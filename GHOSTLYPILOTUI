-- ============================================================
-- GhostlyPilotUI - YC GUI API Wrapper(b站BeiHaiLY)
-- Author: 茉莉璐 with Deepseek
-- Version: 2.2.1
-- ============================================================

if _G.GhostlyPilotUI_Loaded then
    pcall(function()
        if _G.GhostlyPilotUI_Loaded.Parent then
            _G.GhostlyPilotUI_Loaded:Destroy()
        end
    end)
end

local Library = {}
local VERSION = "2.2.1"
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local parentGui = (gethui and gethui()) or CoreGui

Library.Presets = {
    ["默认粉蓝"] = { Accent = Color3.fromRGB(255, 120, 220), Active = Color3.fromRGB(120, 170, 255), Slider = Color3.fromRGB(120, 140, 255), CardBg = Color3.fromRGB(252, 252, 255), PanelBg = Color3.fromRGB(248, 248, 252), Stroke = Color3.fromRGB(235, 235, 240), TextDark = Color3.fromRGB(40, 40, 45), TextGray = Color3.fromRGB(130, 130, 145), Off = Color3.fromRGB(200, 200, 205), OffText = Color3.fromRGB(100, 100, 110) },
    ["深海蓝"] = { Accent = Color3.fromRGB(80, 180, 255), Active = Color3.fromRGB(100, 150, 255), Slider = Color3.fromRGB(60, 120, 220), CardBg = Color3.fromRGB(245, 250, 255), PanelBg = Color3.fromRGB(240, 248, 255), Stroke = Color3.fromRGB(215, 230, 245), TextDark = Color3.fromRGB(30, 50, 80), TextGray = Color3.fromRGB(100, 130, 170), Off = Color3.fromRGB(190, 210, 230), OffText = Color3.fromRGB(80, 110, 150) },
    ["薄荷绿"] = { Accent = Color3.fromRGB(80, 220, 160), Active = Color3.fromRGB(60, 200, 180), Slider = Color3.fromRGB(50, 180, 140), CardBg = Color3.fromRGB(248, 255, 252), PanelBg = Color3.fromRGB(240, 255, 248), Stroke = Color3.fromRGB(210, 240, 225), TextDark = Color3.fromRGB(30, 70, 55), TextGray = Color3.fromRGB(90, 140, 120), Off = Color3.fromRGB(200, 230, 215), OffText = Color3.fromRGB(80, 120, 105) },
    ["暗夜黑"] = { Accent = Color3.fromRGB(180, 180, 200), Active = Color3.fromRGB(100, 130, 200), Slider = Color3.fromRGB(120, 150, 220), CardBg = Color3.fromRGB(40, 42, 50), PanelBg = Color3.fromRGB(32, 34, 42), Stroke = Color3.fromRGB(70, 72, 85), TextDark = Color3.fromRGB(230, 230, 240), TextGray = Color3.fromRGB(150, 150, 165), Off = Color3.fromRGB(80, 82, 95), OffText = Color3.fromRGB(180, 180, 195) },
    ["烈焰红"] = { Accent = Color3.fromRGB(255, 90, 90), Active = Color3.fromRGB(255, 130, 80), Slider = Color3.fromRGB(230, 70, 70), CardBg = Color3.fromRGB(255, 250, 250), PanelBg = Color3.fromRGB(255, 245, 245), Stroke = Color3.fromRGB(245, 220, 220), TextDark = Color3.fromRGB(60, 25, 25), TextGray = Color3.fromRGB(150, 100, 100), Off = Color3.fromRGB(230, 200, 200), OffText = Color3.fromRGB(140, 90, 90) },
}

Library.Theme = {
    Accent = Color3.fromRGB(255, 120, 220), Active = Color3.fromRGB(120, 170, 255), Slider = Color3.fromRGB(120, 140, 255), CardBg = Color3.fromRGB(252, 252, 255), PanelBg = Color3.fromRGB(248, 248, 252), Stroke = Color3.fromRGB(235, 235, 240), TextDark = Color3.fromRGB(40, 40, 45), TextGray = Color3.fromRGB(130, 130, 145), Off = Color3.fromRGB(200, 200, 205), OffText = Color3.fromRGB(100, 100, 110),
}
Library.COLOR_ON = Library.Theme.Accent
Library.COLOR_OFF = Color3.fromRGB(230, 70, 70)
Library.ThemeBindings = {}
Library.TextBindings = {}

local function IsDarkTheme() return Library.Theme.TextDark.R > 0.5 end
local function LighterColor(c, amount) return Color3.new( math.min(c.R + (amount or 0.04), 1), math.min(c.G + (amount or 0.04), 1), math.min(c.B + (amount or 0.04), 1) ) end
local function DarkerColor(c, amount) return Color3.new( math.max(c.R - (amount or 0.04), 0), math.max(c.G - (amount or 0.04), 0), math.max(c.B - (amount or 0.04), 0) ) end

function Library:_BindTheme(obj, colorFunc) table.insert(self.ThemeBindings, {obj = obj, func = colorFunc}) if obj:IsA("GuiObject") then obj.BackgroundColor3 = colorFunc() end end
function Library:_BindText(obj, colorFunc) table.insert(self.TextBindings, {obj = obj, func = colorFunc}) if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then obj.TextColor3 = colorFunc() end end
function Library:_BindStroke(obj, colorFunc) table.insert(self.ThemeBindings, { obj = obj, func = function() obj.Color = colorFunc() end, isStroke = true, }) obj.Color = colorFunc() end

function Library:_RefreshTheme()
    for _, item in ipairs(self.ThemeBindings) do if item.obj and item.obj.Parent then pcall(function() if item.isStroke then item.obj.Color = item.func() elseif item.obj:IsA("GuiObject") then item.obj.BackgroundColor3 = item.func() end end) end end
    for _, item in ipairs(self.TextBindings) do if item.obj and item.obj.Parent then pcall(function() item.obj.TextColor3 = item.func() end) end end
    self.COLOR_ON = self.Theme.Accent
end

function Library:ApplyTheme(name)
    local preset = self.Presets[name]
    if not preset then self:Notify("主题不存在", false) return end
    for k, v in pairs(preset) do self.Theme[k] = v end
    self.COLOR_ON = self.Theme.Accent
    self:_RefreshTheme()
    self:_RefreshHUDGradient()
    self:_RefreshCardGradient()
    self:_SaveThemeName(name)
end

function Library:_RefreshHUDGradient()
    local HUD = self.Globals.HUDFrame
    if not HUD then return end
    for _, wrap in ipairs(HUD:GetChildren()) do
        if wrap:IsA("Frame") then
            local cont = wrap:FindFirstChild("Container")
            if cont then
                for _, child in ipairs(cont:GetChildren()) do
                    local grad = child:FindFirstChildOfClass("UIGradient")
                    if grad then grad.Color = ColorSequence.new{ ColorSequenceKeypoint.new(0, self.Theme.Accent), ColorSequenceKeypoint.new(1, self.Theme.Active) } end
                end
            end
        end
    end
end

function Library:_RefreshCardGradient()
    local grad = self.Globals.MainGradient
    if not grad then return end
    local card = self.Theme.CardBg
    local accent = self.Theme.Accent
    local tint = Color3.new( card.R * 0.92 + accent.R * 0.08, card.G * 0.92 + accent.G * 0.08, card.B * 0.92 + accent.B * 0.08 )
    grad.Color = ColorSequence.new{ ColorSequenceKeypoint.new(0, card), ColorSequenceKeypoint.new(1, tint) }
end

Library.ConfigCache = {}
function Library:SetConfig(key, value) if not key then return end self.ConfigCache[key] = value end
function Library:GetConfig(key, default) if not key then return default end local v = self.ConfigCache[key] if v == nil then return default end return v end

Library.ThemeFile = "GhostlyPilot_theme.txt"
function Library:_SaveThemeName(name) if not (writefile and name) then return end pcall(function() writefile(self.ThemeFile, name) end) end
function Library:_LoadThemeName() if not (isfile and readfile) then return nil end if not isfile(self.ThemeFile) then return nil end local ok, content = pcall(function() return readfile(self.ThemeFile) end) if not ok or not content or content == "" then return nil end return content end

Library.Globals = {
    GuiRoot = nil, MainCard = nil, LeftPanel = nil, RightPanel = nil, HUDFrame = nil, NotifHolder = nil, DragHolder = nil, Bar = nil, TitleLabel = nil, IconClickButton = nil, CloseButton = nil, SubPanels = {}, SubPanelButtons = {}, AllButtons = {}, ActiveNotifs = {}, FloatWidgets = {}, OpenSound = nil, CloseSound = nil, MainCardOpen = false, Initialized = false, LeftScroll = nil, LHTimeLabel = nil, MainGradient = nil,
}

local function initSounds()
    Library.Globals.OpenSound = Instance.new("Sound") Library.Globals.OpenSound.SoundId = "rbxassetid://9118823101" Library.Globals.OpenSound.Volume = 0.5 Library.Globals.OpenSound.PlaybackSpeed = 1.2 Library.Globals.OpenSound.Parent = SoundService
    Library.Globals.CloseSound = Instance.new("Sound") Library.Globals.CloseSound.SoundId = "rbxassetid://9118823101" Library.Globals.CloseSound.Volume = 0.4 Library.Globals.CloseSound.PlaybackSpeed = 0.85 Library.Globals.CloseSound.Parent = SoundService
end
function Library:PlaySound(sound) if not sound then return end local clone = sound:Clone() clone.Parent = SoundService clone:Play() clone.Ended:Connect(function() clone:Destroy() end) end
function Library:PlayOpen() self:PlaySound(self.Globals.OpenSound) end
function Library:PlayClose() self:PlaySound(self.Globals.CloseSound) end

function Library:Notify(title, status)
    local NotifHolder = self.Globals.NotifHolder
    if not NotifHolder then return end
    local NOTIF_W, NOTIF_H, GAP = 240, 56, 10
    local Frame = Instance.new("Frame") Frame.Parent = NotifHolder Frame.BackgroundColor3 = self.Theme.CardBg Frame.BackgroundTransparency = 0.05 Frame.Size = UDim2.new(0, NOTIF_W, 0, NOTIF_H) Frame.AnchorPoint = Vector2.new(1, 1) Frame.ZIndex = 101
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 14)
    local stroke = Instance.new("UIStroke") stroke.Color = self.Theme.Stroke stroke.Thickness = 1 stroke.Parent = Frame
    local TL = Instance.new("TextLabel") TL.Parent = Frame TL.Text = title TL.Font = Enum.Font.GothamBold TL.TextSize = 16 TL.TextColor3 = self.Theme.TextDark TL.BackgroundTransparency = 1 TL.Size = UDim2.new(1, -24, 0, 22) TL.Position = UDim2.new(0, 14, 0, 8) TL.TextXAlignment = Enum.TextXAlignment.Left
    local SL = Instance.new("TextLabel") SL.Parent = Frame SL.Text = status and "已开启" or "已关闭" SL.Font = Enum.Font.GothamMedium SL.TextSize = 13 SL.TextColor3 = status and self.COLOR_ON or self.COLOR_OFF SL.BackgroundTransparency = 1 SL.Size = UDim2.new(1, -24, 0, 18) SL.Position = UDim2.new(0, 14, 0, 30) SL.TextXAlignment = Enum.TextXAlignment.Left
    local TF = Instance.new("Frame") TF.Parent = Frame TF.Size = UDim2.new(1, -28, 0, 3) TF.Position = UDim2.new(0.5, 0, 1, -8) TF.AnchorPoint = Vector2.new(0.5, 1) TF.BackgroundColor3 = self.Theme.Stroke
    Instance.new("UICorner", TF).CornerRadius = UDim.new(1, 0)
    local TFi = Instance.new("Frame") TFi.Parent = TF TFi.Si
