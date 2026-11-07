const express = require('express');
const fetch = require('node-fetch');
const app = express();

// ⚠️ 在这里填你的 Turso 数据库信息
const TURSO_URL = "libsql://gpdata-m0li1u.aws-ap-northeast-1.turso.io"; 
const TURSO_TOKEN = "eyJhbGciOiJFZERTQSIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJncGRhdGEtbTBsZzF1In0..."; 
const ADMIN_PASS = "hhh_XYJ";

const turso = async (sql, args = []) => {
    const res = await fetch(TURSO_URL.replace("libsql://", "https://") + "/v2/pipeline", {
        method: "POST",
        headers: { "Authorization": `Bearer ${TURSO_TOKEN}`, "Content-Type": "application/json" },
        body: JSON.stringify({
            requests: [
                { type: "execute", stmt: { sql, args: args.map(a => ({ type: typeof a === "number" ? "integer" : "text", value: String(a) })) } },
                { type: "close" }
            ]
        })
    });
    return res.json();
};

const esc = s => String(s).replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));

app.get('/', (req, res) => res.send("BKU Server is Running!"));

app.get('/track_exec', async (req, res) => {
    const today = new Date(new Date().getTime() + 8 * 60 * 60 * 1000).toISOString().split('T')[0];
    try {
        await turso("CREATE TABLE IF NOT EXISTS bku_daily_stats (date TEXT PRIMARY KEY, exec_count INTEGER DEFAULT 0)");
        await turso("CREATE TABLE IF NOT EXISTS bku_users (id TEXT PRIMARY KEY, name TEXT, place_id TEXT, last_time INTEGER, count INTEGER DEFAULT 0, banned INTEGER DEFAULT 0)");
        await turso("CREATE TABLE IF NOT EXISTS bku_commands (id INTEGER PRIMARY KEY AUTOINCREMENT, target TEXT, type TEXT, msg TEXT, created INTEGER)");
        await turso("CREATE TABLE IF NOT EXISTS bku_chat_logs (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id TEXT, name TEXT, msg TEXT, created INTEGER)");
        
        await turso("INSERT INTO bku_daily_stats (date, exec_count) VALUES (?, 1) ON CONFLICT(date) DO UPDATE SET exec_count = exec_count + 1", [today]);
        res.send("ok");
    } catch (e) { res.status(500).send(e.message); }
});

app.get('/check', async (req, res) => {
    const id = req.query.userId;
    const name = req.query.name || "";
    const placeId = req.query.placeId || "未知";
    const isHeartbeat = req.query.hb === "1";
    if (!id) return res.status(400).send("bad");
    const today = new Date(new Date().getTime() + 8 * 60 * 60 * 1000).toISOString().split('T')[0];
    try {
        const userRes = await turso("SELECT * FROM bku_users WHERE id = ?", [id]);
        const rows = userRes.results[0].response.result.rows;
        let isNewExec = false;
        if (rows.length > 0) {
            if (rows[0][5].value == "1") return res.send("banned");
            const lastTime = parseInt(rows[0][3].value || 0);
            let count = parseInt(rows[0][4].value || 0);
            if (isHeartbeat) {
                await turso("UPDATE bku_users SET name = ?, place_id = ?, last_time = ? WHERE id = ?", [name, placeId, Date.now(), id]);
            } else {
                const vParam = req.query.v || "";
                if (vParam !== "" && vParam !== "1") { isNewExec = true; count++; }
                else if (Date.now() - lastTime > 30000) { isNewExec = true; count++; }
                await turso("UPDATE bku_users SET name = ?, place_id = ?, last_time = ?, count = ? WHERE id = ?", [name, placeId, Date.now(), count, id]);
            }
        } else {
            await turso("INSERT INTO bku_users (id, name, place_id, last_time, count, banned) VALUES (?, ?, ?, ?, 1, 0)", [id, name, placeId, Date.now()]);
            isNewExec = true;
        }
        if (isNewExec) {
            await turso("INSERT INTO bku_daily_stats (date, exec_count) VALUES (?, 1) ON CONFLICT(date) DO UPDATE SET exec_count = exec_count + 1", [today]);
        }
        const cmdRes = await turso("SELECT id, type, msg FROM bku_commands WHERE target = ? OR target = 'all' ORDER BY id ASC", [id]);
        const cmdRows = cmdRes.results[0].response.result.rows;
        if (cmdRows.length > 0) {
            let cmds = cmdRows.map(r => ({ id: r[0].value, type: r[1].value, msg: r[2].value }));
            for (let c of cmds) await turso("DELETE FROM bku_commands WHERE id = ?", [c.id]);
            return res.json(cmds);
        }
        res.send("ok");
    } catch (e) { res.status(500).send(e.message); }
});

app.get('/chat', async (req, res) => {
    const userId = req.query.userId || "";
    const name = (req.query.name || "").slice(0, 50);
    const msg = (req.query.msg || "").slice(0, 500);
    if (!userId || !msg) return res.status(400).send("bad");
    try {
        await turso("INSERT INTO bku_chat_logs (user_id, name, msg, created) VALUES (?, ?, ?, ?)", [userId, name, msg, Date.now()]);
        res.send("ok");
    } catch (e) { res.status(500).send(e.message); }
});

app.get('/panel_data', async (req, res) => {
    const pass = req.query.admin_pass;
    if (pass !== ADMIN_PASS) return res.status(403).json({error:"Denied"});
    const today = new Date(new Date().getTime() + 8 * 60 * 60 * 1000).toISOString().split('T')[0];
    const thisMonth = today.slice(0, 7);
    try {
        const statRes = await turso("SELECT exec_count FROM bku_daily_stats WHERE date = ?", [today]);
        const todayExec = statRes.results[0].response.result.rows.length > 0 ? statRes.results[0].response.result.rows[0][0].value : "0";
        const monthRes = await turso("SELECT SUM(exec_count) FROM bku_daily_stats WHERE date LIKE ?", [thisMonth + "%"]);
        const monthExec = (monthRes.results[0].response.result.rows.length > 0 && monthRes.results[0].response.result.rows[0][0].value !== null) ? monthRes.results[0].response.result.rows[0][0].value : "0";
        
        const result = await turso("SELECT * FROM bku_users ORDER BY last_time DESC");
        const rows = result.results[0].response.result.rows;
        let onlineUsers = []; let tableData = []; let onlineCount = 0;
        for (let row of rows) {
            const id = row[0].value; const name = row[1].value || "未知";
            let placeId = row[2].value || "未知"; if (placeId === "" || placeId === "未知") placeId = "无/单机";
            const lastTime = parseInt(row[3].value || 0); const countData = row[4].value || "0";
            const isBanned = row[5].value == "1"; const isOnline = lastTime && (Date.now() - lastTime < 60000);
            if (isOnline) { onlineCount++; onlineUsers.push({id, name: esc(name)}); }
            let timeStr = "从未上线";
            if (lastTime) { if (isOnline) timeStr = "<span class='status-online'>在线</span>"; else timeStr = `<span class='status-offline'>离线 (${Math.floor((Date.now() - lastTime) / 60000)}分钟前)</span>`; }
            const btn = isBanned ? `<button onclick="fetch('/unban?id=${id}&admin_pass=${pass}').then(()=>loadData())">解封</button>` : `<button onclick="fetch('/ban?id=${id}&admin_pass=${pass}').then(()=>loadData())">封禁</button>`;
            tableData.push({id, name: esc(name), placeId: esc(placeId), statusStr: timeStr, count: esc(countData), btn, isOnline: !!isOnline});
        }
        
        const chatRes = await turso("SELECT id, name, msg, created FROM bku_chat_logs ORDER BY id DESC LIMIT 50");
        const chats = chatRes.results[0].response.result.rows.map(r => ({ id: parseInt(r[0].value || 0), name: esc(r[1].value || "未知"), msg: esc(r[2].value || ""), created: parseInt(r[3].value || 0) }));
        
        res.json({ total: rows.length, online: onlineCount, todayExec, monthExec, onlineUsers, rows: tableData, chats });
    } catch (e) { res.status(500).json({error: e.message}); }
});

app.get('/cmd', async (req, res) => {
    if (req.query.admin_pass !== ADMIN_PASS) return res.status(403).send("Denied");
    try {
        await turso("INSERT INTO bku_commands (target, type, msg, created) VALUES (?, ?, ?, ?)", [req.query.target || "all", req.query.type, req.query.msg || "", Date.now()]);
        res.send("指令已发送");
    } catch (e) { res.status(500).send(e.message); }
});

app.get('/ban', async (req, res) => {
    if (req.query.admin_pass !== ADMIN_PASS) return res.status(403).send("Denied");
    try { await turso("UPDATE bku_users SET banned = 1 WHERE id = ?", [req.query.id]); res.send("ok"); } catch (e) { res.status(500).send(e.message); }
});

app.get('/unban', async (req, res) => {
    if (req.query.admin_pass !== ADMIN_PASS) return res.status(403).send("Denied");
    try { await turso("UPDATE bku_users SET banned = 0 WHERE id = ?", [req.query.id]); res.send("ok"); } catch (e) { res.status(500).send(e.message); }
});

app.get('/panel', async (req, res) => {
    if (req.query.admin_pass !== ADMIN_PASS) return res.status(403).send("Access Denied");
    const today = new Date(new Date().getTime() + 8 * 60 * 60 * 1000).toISOString().split('T')[0];
    const thisMonth = today.slice(0, 7);
    try {
        const statRes = await turso("SELECT exec_count FROM bku_daily_stats WHERE date = ?", [today]);
        const todayExec = statRes.results[0].response.result.rows.length > 0 ? statRes.results[0].response.result.rows[0][0].value : "0";
        const monthRes = await turso("SELECT SUM(exec_count) FROM bku_daily_stats WHERE date LIKE ?", [thisMonth + "%"]);
        const monthExec = (monthRes.results[0].response.result.rows.length > 0 && monthRes.results[0].response.result.rows[0][0].value !== null) ? monthRes.results[0].response.result.rows[0][0].value : "0";
        
        let html = `<html><head><meta name='viewport' content='width=device-width, initial-scale=1.0'><style>body{background:#1e1e1e;color:#fff;font-family:sans-serif;padding:10px;}h1{text-align:center;font-size:22px;background:linear-gradient(90deg,#ffb6c1,#87ceeb,#ffb6c1);background-size:200% auto;-webkit-background-clip:text;background-clip:text;color:transparent;-webkit-text-fill-color:transparent;animation:flow 3s linear infinite;}@keyframes flow{0%{background-position:0% center}100%{background-position:200% center}}table{width:100%;border-collapse:collapse;margin-top:10px;}th,td{border:1px solid #444;padding:6px;text-align:left;font-size:12px;}th{background:linear-gradient(90deg,#ffb6c1,#87ceeb,#ffb6c1);background-size:200% auto;-webkit-background-clip:text;background-clip:text;color:transparent;animation:flow 3s linear infinite;font-weight:bold;}button{background:#ffffff !important;color:#000000 !important;border:none;padding:6px 10px;border-radius:4px;cursor:pointer;margin:2px;font-size:12px;font-weight:bold;}.btn-warn{width:100%;margin-top:10px;}.btn-kick{width:100%;margin-top:5px;}.status-online{color:#00ff00;font-weight:bold;}.status-offline{color:#ffaa00;font-weight:bold;}.action-box{background:#2a2a2a;padding:15px;border-radius:8px;margin-bottom:15px;border:1px solid #444;}.action-box input,.action-box select{width:100%;padding:8px;margin:5px 0;background:#1e1e1e;border:1px solid #555;color:#fff;border-radius:4px;box-sizing:border-box;font-size:14px;}.stats{text-align:center;color:#aaa;font-size:13px;margin-bottom:15px;}.stats span{font-weight:bold;}.today-stat{text-align:center;color:#ffb6c1;font-size:14px;font-weight:bold;margin-bottom:10px;}.today-stat span{margin:0 8px;}tr{transition:all 0.3s ease;}.chat-box{background:#2a2a2a;padding:15px;border-radius:8px;margin-bottom:15px;border:1px solid #444;height:250px;overflow-y:auto;}.chat-line{padding:6px 0;border-bottom:1px solid #333;font-size:12px;transition:all 0.3s;}.chat-name{color:#87ceeb;font-weight:bold;}.chat-time{color:#666;font-size:10px;margin-left:8px;}.unread{color:#888 !important;opacity:0.7;}.unread .chat-name{color:#4a7a9a !important;}</style></head><body><h1>BKU Script 控制台</h1><div class='today-stat'><span>今日执行: <span id="todayExec">${todayExec}</span></span> | <span>本月执行: <span id="monthExec">${monthExec}</span></span></div><div class='stats'>总使用人数: <span id="totalCount" style="color:#fff;">0</span> | 当前在线: <span id="onlineCount" class="status-online">0</span></div><div class='action-box'><p style='margin:0 0 10px 0;font-size:15px;font-weight:bold;background:linear-gradient(90deg,#ffb6c1,#87ceeb,#ffb6c1);background-size:200% auto;-webkit-background-clip:text;background-clip:text;color:transparent;animation:flow 3s linear infinite;'>警告与踢出</p><select id='targetId'><option value='all'>-- 全体玩家 --</option></select><input type='text' id='msgText' placeholder='输入文字内容 / 踢出理由'><button class='btn-warn' onclick='sendCmd("warn")'>发送黑屏警告</button><button class='btn-kick' onclick='sendCmd("kick")'>强制踢出服务器</button></div><div class='chat-box' id='chatBox' onscroll='markAsRead()' onclick='markAsRead()'><div id="chatBody"></div></div><table><tr><th>玩家信息</th><th>状态</th><th>操作</th></tr><tbody id="tableBody"></tbody></table><script>let lastChatId = 0; function markAsRead() { document.querySelectorAll('.unread').forEach(el => el.classList.remove('unread')); const body = document.getElementById('chatBody'); if (body.firstElementChild) { lastChatId = body.firstElementChild.getAttribute('data-id') || lastChatId; } } function sendCmd(type){let t=document.getElementById('targetId').value;let m=document.getElementById('msgText').value;if(!m){alert('请输入文字内容');return;}fetch('/cmd?type='+type+'&target='+t+'&msg='+encodeURIComponent(m)+'&admin_pass=hhh_XYJ').then(r=>r.text()).then(res=>alert(res));}function loadData(){fetch('/panel_data?admin_pass=hhh_XYJ').then(r=>r.json()).then(data=>{document.getElementById('todayExec').innerText=data.todayExec;document.getElementById('monthExec').innerText=data.monthExec;document.getElementById('totalCount').innerText=data.total;document.getElementById('onlineCount').innerText=data.online;let sel=document.getElementById('targetId');let curVal=sel.value;sel.innerHTML="<option value='all'>-- 全体玩家 --</option>"+data.onlineUsers.map(u=>"<option value='"+u.id+"'>"+u.name+" (在线)</option>").join("");if(Array.from(sel.options).some(o=>o.value===curVal)){sel.value=curVal;}let sortedRows=data.rows.sort((a,b)=>{if(a.isOnline!==b.isOnline){return a.isOnline?-1:1;}return a.name.localeCompare(b.name);});document.getElementById('tableBody').innerHTML=sortedRows.map(r=>"<tr><td>"+r.name+"<br><span style='color:#666;font-size:10px;'>ID:"+r.id+" | JobId:"+r.placeId+"</span></td><td>"+r.statusStr+"<br><span style='color:#8892b0;font-size:10px;'>使用次数: "+r.count+"</span></td><td>"+r.btn+"</td></tr>").join("");const chatBox = document.getElementById('chatBox');const isAtTop = chatBox.scrollTop < 30; if(data.chats && data.chats.length > 0){document.getElementById('chatBody').innerHTML = data.chats.map(c=>{let t = new Date(c.created).toLocaleString('zh-CN', {hour12:false});let isUnread = c.id > lastChatId;let unreadClass = isUnread ? "unread" : "";return "<div class='chat-line "+unreadClass+"' data-id='"+c.id+"'><span class='chat-name'>"+c.name+"</span>："+c.msg+"<span class='chat-time'>"+t+"</span></div>";}).join("");if (isAtTop) { chatBox.scrollTop = 0; }} else {document.getElementById('chatBody').innerHTML = "<span style='color:#666;'>暂无聊天记录</span>";}});}loadData();setInterval(loadData, 3000);</script></body></html>`;
        res.send(html);
    } catch(e) { res.status(500).send(e.message); }
});

const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`Server running on port ${port}`));
