-- ============================================================
-- GhostlyPilotUI - YC API Wrapper
-- Author: 茉莉璐 With Deepseek
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

-- ============================================================
-- 预设主题
-- ============================================================
Library.Presets = {
    ["樱花粉"] = {
        Accent   = Color3.fromRGB(255, 120, 220),
        Active   = Color3.fromRGB(120, 170, 255),
        Slider   = Color3.fromRGB(120, 140, 255),
        CardBg   = Color3.fromRGB(252, 252, 255),
        PanelBg  = Color3.fromRGB(248, 248, 252),
        Stroke   = Color3.fromRGB(235, 235, 240),
        TextDark = Color3.fromRGB(40, 40, 45),
        TextGray = Color3.fromRGB(130, 130, 145),
        Off      = Color3.fromRGB(200, 200, 205),
        OffText  = Color3.fromRGB(100, 100, 110),
    },
    ["深海蓝"] = {
        Accent   = Color3.fromRGB(80, 180, 255),
        Active   = Color3.fromRGB(100, 150, 255),
        Slider   = Color3.fromRGB(60, 120, 220),
        CardBg   = Color3.fromRGB(245, 250, 255),
        PanelBg  = Color3.fromRGB(240, 248, 255),
        Stroke   = Color3.fromRGB(215, 230, 245),
        TextDark = Color3.fromRGB(30, 50, 80),
        TextGray = Color3.fromRGB(100, 130, 170),
        Off      = Color3.fromRGB(190, 210, 230),
        OffText  = Color3.fromRGB(80, 110, 150),
    },
    ["薄荷绿"] = {
        Accent   = Color3.fromRGB(80, 220, 160),
        Active   = Color3.fromRGB(60, 200, 180),
        Slider   = Color3.fromRGB(50, 180, 140),
        CardBg   = Color3.fromRGB(248, 255, 252),
        PanelBg  = Color3.fromRGB(240, 255, 248),
        Stroke   = Color3.fromRGB(210, 240, 225),
        TextDark = Color3.fromRGB(30, 70, 55),
        TextGray = Color3.fromRGB(90, 140, 120),
        Off      = Color3.fromRGB(200, 230, 215),
        OffText  = Color3.fromRGB(80, 120, 105),
    },
    ["暗夜黑"] = {
        Accent   = Color3.fromRGB(180, 180, 200),
        Active   = Color3.fromRGB(100, 130, 200),
        Slider   = Color3.fromRGB(120, 150, 220),
        CardBg   = Color3.fromRGB(40, 42, 50),
        PanelBg  = Color3.fromRGB(32, 34, 42),
        Stroke   = Color3.fromRGB(70, 72, 85),
        TextDark = Color3.fromRGB(230, 230, 240),
        TextGray = Color3.fromRGB(150, 150, 165),
        Off      = Color3.fromRGB(80, 82, 95),
        OffText  = Color3.fromRGB(180, 180, 195),
    },
    ["烈焰红"] = {
        Accent   = Color3.fromRGB(255, 90, 90),
        Active   = Color3.fromRGB(255, 130, 80),
        Slider   = Color3.fromRGB(230, 70, 70),
        CardBg   = Color3.fromRGB(255, 250, 250),
        PanelBg  = Color3.fromRGB(255, 245, 245),
        Stroke   = Color3.fromRGB(245, 220, 220),
        TextDark = Color3.fromRGB(60, 25, 25),
        TextGray = Color3.fromRGB(150, 100, 100),
        Off      = Color3.fromRGB(230, 200, 200),
        OffText  = Color3.fromRGB(140, 90, 90),
    },
}

-- ============================================================
-- 当前主题
-- ============================================================
Library.Theme = {
    Accent   = Color3.fromRGB(255, 150, 200),
    Active   = Color3.fromRGB(255, 180, 220), 
    Slider   = Color3.fromRGB(255, 120, 180),
    CardBg   = Color3.fromRGB(255, 245, 248),
    PanelBg  = Color3.fromRGB(255, 240, 245),
    Stroke   = Color3.fromRGB(255, 200, 220),
    TextDark = Color3.fromRGB(100, 50, 70),
    TextGray = Color3.fromRGB(180, 130, 150),
    Off      = Color3.fromRGB(240, 210, 220),
    OffText  = Color3.fromRGB(150, 100, 120),
}

Library.COLOR_ON  = Library.Theme.Accent
Library.COLOR_OFF = Color3.fromRGB(230, 70, 70)

Library.ThemeBindings = {}
Library.TextBindings = {}

-- 通用工具
local function IsDarkTheme()
    return Library.Theme.TextDark.R > 0.5
end

local function LighterColor(c, amount)
    return Color3.new(
        math.min(c.R + (amount or 0.04), 1),
        math.min(c.G + (amount or 0.04), 1),
        math.min(c.B + (amount or 0.04), 1)
    )
end

local function DarkerColor(c, amount)
    return Color3.new(
        math.max(c.R - (amount or 0.04), 0),
        math.max(c.G - (amount or 0.04), 0),
        math.max(c.B - (amount or 0.04), 0)
    )
end

function Library:_BindTheme(obj, colorFunc)
    table.insert(self.ThemeBindings, {obj = obj, func = colorFunc})
    if obj:IsA("GuiObject") then
        obj.BackgroundColor3 = colorFunc()
    end
end

function Library:_BindText(obj, colorFunc)
    table.insert(self.TextBindings, {obj = obj, func = colorFunc})
    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
        obj.TextColor3 = colorFunc()
    end
end

function Library:_BindStroke(obj, colorFunc)
    table.insert(self.ThemeBindings, {
        obj = obj,
        func = function()
            obj.Color = colorFunc()
        end,
        isStroke = true,
    })
    obj.Color = colorFunc()
end

function Library:_RefreshTheme()
    for _, item in ipairs(self.ThemeBindings) do
        if item.obj and item.obj.Parent then
            pcall(function()
                if item.isStroke then
                    item.obj.Color = item.func()
                elseif item.obj:IsA("GuiObject") then
                    item.obj.BackgroundColor3 = item.func()
                end
            end)
        end
    end
    for _, item in ipairs(self.TextBindings) do
        if item.obj and item.obj.Parent then
            pcall(function()
                item.obj.TextColor3 = item.func()
            end)
        end
    end
    self.COLOR_ON = self.Theme.Accent
end

-- ============================================================
-- 主题切换
-- ============================================================
function Library:ApplyTheme(name)
    local preset = self.Presets[name]
    if not preset then
        self:Notify("主题不存在", false)
        return
    end
    for k, v in pairs(preset) do
        self.Theme[k] = v
    end
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
                    if grad then
                        grad.Color = ColorSequence.new{
                            ColorSequenceKeypoint.new(0, self.Theme.Accent),
                            ColorSequenceKeypoint.new(1, self.Theme.Active)
                        }
                    end
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
    local tint = Color3.new(
        card.R * 0.92 + accent.R * 0.08,
        card.G * 0.92 + accent.G * 0.08,
        card.B * 0.92 + accent.B * 0.08
    )
    grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, card),
        ColorSequenceKeypoint.new(1, tint)
    }
end

-- ============================================================
-- 内存配置（不持久化）
-- ============================================================
Library.ConfigCache = {}

function Library:SetConfig(key, value)
    if not key then return end
    self.ConfigCache[key] = value
end

function Library:GetConfig(key, default)
    if not key then return default end
    local v = self.ConfigCache[key]
    if v == nil then return default end
    return v
end

-- ============================================================
-- 主题持久化（仅主题名自动保存）
-- ============================================================
Library.ThemeFile = "GhostlyPilot_theme.txt"

function Library:_SaveThemeName(name)
    if not (writefile and name) then return end
    pcall(function() writefile(self.ThemeFile, name) end)
end

function Library:_LoadThemeName()
    if not (isfile and readfile) then return nil end
    if not isfile(self.ThemeFile) then return nil end
    local ok, content = pcall(function() return readfile(self.ThemeFile) end)
    if not ok or not content or content == "" then return nil end
    return content
end

-- ============================================================
-- Globals
-- ============================================================
Library.Globals = {
    GuiRoot      = nil, MainCard     = nil, LeftPanel    = nil, RightPanel   = nil,
    HUDFrame     = nil, NotifHolder  = nil, DragHolder   = nil, Bar          = nil,
    TitleLabel   = nil, IconClickButton = nil, CloseButton  = nil,
    SubPanels    = {}, SubPanelButtons = {}, AllButtons   = {},
    ActiveNotifs = {}, FloatWidgets = {}, OpenSound    = nil, CloseSound   = nil,
    MainCardOpen = false, Initialized  = false,
    LeftScroll   = nil, LHTimeLabel = nil, MainGradient = nil,
}

local function initSounds()
    Library.Globals.OpenSound = Instance.new("Sound")
    Library.Globals.OpenSound.SoundId = "rbxassetid://9118823101"
    Library.Globals.OpenSound.Volume = 0.5
    Library.Globals.OpenSound.PlaybackSpeed = 1.2
    Library.Globals.OpenSound.Parent = SoundService

    Library.Globals.CloseSound = Instance.new("Sound")
    Library.Globals.CloseSound.SoundId = "rbxassetid://9118823101"
    Library.Globals.CloseSound.Volume = 0.4
    Library.Globals.CloseSound.PlaybackSpeed = 0.85
    Library.Globals.CloseSound.Parent = SoundService
end

function Library:PlaySound(sound)
    if not sound then return end
    local clone = sound:Clone()
    clone.Parent = SoundService
    clone:Play()
    clone.Ended:Connect(function() clone:Destroy() end)
end
function Library:PlayOpen()  self:PlaySound(self.Globals.OpenSound)  end
function Library:PlayClose() self:PlaySound(self.Globals.CloseSound) end

-- ============================================================
-- 通知
-- ============================================================
function Library:Notify(title, status)
    local NotifHolder = self.Globals.NotifHolder
    if not NotifHolder then return end
    local NOTIF_W, NOTIF_H, GAP = 240, 56, 10

    local Frame = Instance.new("Frame")
    Frame.Parent = NotifHolder
    Frame.BackgroundColor3 = self.Theme.CardBg
    Frame.BackgroundTransparency = 0.05
    Frame.Size = UDim2.new(0, NOTIF_W, 0, NOTIF_H)
    Frame.AnchorPoint = Vector2.new(1, 1)
    Frame.ZIndex = 101
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 14)
    local stroke = Instance.new("UIStroke")
    stroke.Color = self.Theme.Stroke
    stroke.Thickness = 1
    stroke.Parent = Frame

    local TL = Instance.new("TextLabel")
    TL.Parent = Frame
    TL.Text = title
    TL.Font = Enum.Font.GothamBold
    TL.TextSize = 16
    TL.TextColor3 = self.Theme.TextDark
    TL.BackgroundTransparency = 1
    TL.Size = UDim2.new(1, -24, 0, 22)
    TL.Position = UDim2.new(0, 14, 0, 8)
    TL.TextXAlignment = Enum.TextXAlignment.Left

    local SL = Instance.new("TextLabel")
    SL.Parent = Frame
    SL.Text = status and "已开启" or "已关闭"
    SL.Font = Enum.Font.GothamMedium
    SL.TextSize = 13
    SL.TextColor3 = status and self.COLOR_ON or self.COLOR_OFF
    SL.BackgroundTransparency = 1
    SL.Size = UDim2.new(1, -24, 0, 18)
    SL.Position = UDim2.new(0, 14, 0, 30)
    SL.TextXAlignment = Enum.TextXAlignment.Left

    local TF = Instance.new("Frame")
    TF.Parent = Frame
    TF.Size = UDim2.new(1, -28, 0, 3)
    TF.Position = UDim2.new(0.5, 0, 1, -8)
    TF.AnchorPoint = Vector2.new(0.5, 1)
    TF.BackgroundColor3 = self.Theme.Stroke
    Instance.new("UICorner", TF).CornerRadius = UDim.new(1, 0)

    local TFi = Instance.new("Frame")
    TFi.Parent = TF
    TFi.Size = UDim2.new(1, 0, 1, 0)
    TFi.BackgroundColor3 = status and self.COLOR_ON or self.COLOR_OFF
    Instance.new("UICorner", TFi).CornerRadius = UDim.new(1, 0)

    local yOffset = 0
    for i = #self.Globals.ActiveNotifs, 1, -1 do
        local n = self.Globals.ActiveNotifs[i]
        if n.Parent then
            TweenService:Create(n, TweenInfo.new(0.3), {Position = UDim2.new(1, 0, 1, -yOffset)}):Play()
            yOffset = yOffset + NOTIF_H + GAP
        end
    end
    Frame.Position = UDim2.new(1, 300, 1, -yOffset)
    table.insert(self.Globals.ActiveNotifs, Frame)

    TweenService:Create(Frame, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, 0, 1, -yOffset)
    }):Play()

    local tw = TweenService:Create(TFi, TweenInfo.new(3, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)})
    tw:Play()
    tw.Completed:Connect(function()
        for i, v in ipairs(self.Globals.ActiveNotifs) do
            if v == Frame then table.remove(self.Globals.ActiveNotifs, i); break end
        end
        local out = TweenService:Create(Frame, TweenInfo.new(0.28), {
            Position = Frame.Position + UDim2.new(0, 300, 0, 0)
        })
        out:Play()
        out.Completed:Connect(function() Frame:Destroy() end)
        task.wait(0.05)
        local y = 0
        for i = #self.Globals.ActiveNotifs, 1, -1 do
            local n = self.Globals.ActiveNotifs[i]
            if n.Parent then
                TweenService:Create(n, TweenInfo.new(0.3), {Position = UDim2.new(1, 0, 1, -y)}):Play()
                y = y + NOTIF_H + GAP
            end
        end
    end)
end

-- ============================================================
-- HUD
-- ============================================================
function Library:AddStatus(name)
    local HUDFrame = self.Globals.HUDFrame
    if not HUDFrame then return end
    if HUDFrame:FindFirstChild(name) then return end

    local font = Enum.Font.GothamBold
    local textSize = 18
    local w = TextService:GetTextSize(name, textSize, font, Vector2.new(1000, 1000)).X

    local Wrap = Instance.new("Frame")
    Wrap.Name = name
    Wrap.Parent = HUDFrame
    Wrap.BackgroundTransparency = 1
    Wrap.Size = UDim2.new(0, w + 14, 0, 22)
    Wrap.LayoutOrder = -math.floor(w)

    local Cont = Instance.new("Frame")
    Cont.Name = "Container"
    Cont.Parent = Wrap
    Cont.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Cont.BackgroundTransparency = 0.35
    Cont.Size = UDim2.new(1, 0, 1, 0)
    Cont.Position = UDim2.new(1, 50, 0, 0)
    Cont.ClipsDescendants = true

    local Bar = Instance.new("Frame")
    Bar.Parent = Cont
    Bar.Size = UDim2.new(0, 4, 1, 0)
    Bar.Position = UDim2.new(1, -4, 0, 0)
    Bar.BackgroundColor3 = Color3.new(1, 1, 1)
    Bar.ZIndex = 2
    local Grad = Instance.new("UIGradient")
    Grad.Parent = Bar
    Grad.Rotation = -90
    Grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, self.Theme.Accent),
        ColorSequenceKeypoint.new(1, self.Theme.Active)
    }

    local Lab = Instance.new("TextLabel")
    Lab.Parent = Cont
    Lab.Text = name
    Lab.Font = font
    Lab.TextSize = textSize
    Lab.TextColor3 = Color3.new(1, 1, 1)
    Lab.BackgroundTransparency = 1
    Lab.Size = UDim2.new(1, -14, 1, 0)
    Lab.TextXAlignment = Enum.TextXAlignment.Right
    Lab.ZIndex = 1

    TweenService:Create(Cont, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {
        Position = UDim2.new(0, 0, 0, 0)
    }):Play()
end

function Library:RemoveStatus(name)
    local HUDFrame = self.Globals.HUDFrame
    if not HUDFrame then return end
    local old = HUDFrame:FindFirstChild(name)
    if not old then return end
    local cont = old:FindFirstChild("Container")
    if cont then
        local out = TweenService:Create(cont, TweenInfo.new(0.3), {Position = UDim2.new(1, 50, 0, 0)})
        out:Play()
        out.Completed:Connect(function()
            if old and old.Parent then old:Destroy() end
        end)
        task.delay(0.2, function()
            if old and old.Parent then old:Destroy() end
        end)
    else
        old:Destroy()
    end
end

-- ============================================================
-- 构建基础 UI
-- ============================================================
local function buildBaseUI()
    local GuiRoot = Instance.new("ScreenGui")
    GuiRoot.Name = "GhostlyPilotUI"
    GuiRoot.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    GuiRoot.ResetOnSpawn = false
    GuiRoot.IgnoreGuiInset = true
    GuiRoot.Enabled = false
    GuiRoot.DisplayOrder = 9999
    GuiRoot.Parent = parentGui
    Library.Globals.GuiRoot = GuiRoot
    _G.GhostlyPilotUI_Loaded = GuiRoot

    task.wait()

    local function calcScale()
        local cam = workspace.CurrentCamera
        if not cam then return 0.8 end
        local vp = cam.ViewportSize
        local sW = (vp.X * 0.85) / 620
        local sH = (vp.Y * 0.85) / 380
        return math.clamp(math.min(sW, sH), 0.45, 1.4)
    end
    local scale = calcScale()

    -- 悬浮条（固定白色，不跟随主题）
    local DragHolder = Instance.new("Frame")
    DragHolder.Name = "DragHolder"
    DragHolder.Size = UDim2.new(0, 280, 0, 42)
    DragHolder.Position = UDim2.new(0.5, -140, 0.08, 0)
    DragHolder.AnchorPoint = Vector2.new(0.5, 0)
    DragHolder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    DragHolder.BackgroundTransparency = 0.4
    DragHolder.Active = true
    DragHolder.Draggable = true
    DragHolder.ClipsDescendants = true
    DragHolder.Parent = GuiRoot
    Instance.new("UICorner", DragHolder).CornerRadius = UDim.new(0, 22)

    local Bar = Instance.new("Frame")
    Bar.Name = "Bar"
    Bar.Size = UDim2.new(1, 0, 1, 0)
    Bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Bar.ClipsDescendants = true
    Bar.Parent = DragHolder
    Instance.new("UICorner", Bar).CornerRadius = UDim.new(0, 22)

    local IconWrap = Instance.new("Frame")
    IconWrap.Size = UDim2.new(0, 30, 0, 30)
    IconWrap.Position = UDim2.new(0, 6, 0.5, 0)
    IconWrap.AnchorPoint = Vector2.new(0, 0.5)
    IconWrap.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    IconWrap.Parent = Bar
    Instance.new("UICorner", IconWrap).CornerRadius = UDim.new(1, 0)

    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(1.5, -4, 1.5, -4)
    Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
    Icon.AnchorPoint = Vector2.new(0.5, 0.5)
    Icon.BackgroundTransparency = 1
    Icon.ScaleType = Enum.ScaleType.Fit
    Icon.Image = "rbxassetid://127629592269434"
    Icon.Parent = IconWrap

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 220, 1, 0)
    TitleLabel.Position = UDim2.new(0, 44, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "GhostlyPilot"
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    TitleLabel.TextSize = 17
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = DragHolder

    local IconClickButton = Instance.new("TextButton")
    IconClickButton.Size = UDim2.new(1, 0, 1, 0)
    IconClickButton.BackgroundTransparency = 1
    IconClickButton.Text = ""
    IconClickButton.Parent = IconWrap

    local function UpdateBarWidth()
        local totalW = TitleLabel.TextBounds.X + 44 + 10
        DragHolder.Size = UDim2.new(0, totalW, 0, 42)
        Bar.Size = UDim2.new(0, totalW, 1, 0)
    end
    TitleLabel:GetPropertyChangedSignal("Text"):Connect(UpdateBarWidth)
    task.defer(UpdateBarWidth)
    task.delay(0.1, UpdateBarWidth)
    task.delay(0.5, UpdateBarWidth)
    Library.Globals.UpdateBarWidth = UpdateBarWidth

    -- 主卡片
    local MainCard = Instance.new("Frame")
    MainCard.Name = "MainCard"
    MainCard.Size = UDim2.new(0, 0, 0, 0)
    MainCard.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainCard.AnchorPoint = Vector2.new(0.5, 0.5)
    MainCard.BackgroundColor3 = Library.Theme.CardBg
    MainCard.BackgroundTransparency = 1
    MainCard.ClipsDescendants = true
    MainCard.Parent = GuiRoot
    Instance.new("UICorner", MainCard).CornerRadius = UDim.new(0, 16)
    Library.Globals.MainCard = MainCard
    Library:_BindTheme(MainCard, function() return Library.Theme.CardBg end)

    local MainUIScale = Instance.new("UIScale")
    MainUIScale.Parent = MainCard
    MainUIScale.Scale = scale
    Library.Globals.MainUIScale = MainUIScale

    local MainGradient = Instance.new("UIGradient")
    MainGradient.Rotation = 135
    MainGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Library.Theme.CardBg),
        ColorSequenceKeypoint.new(1, Library.Theme.CardBg)
    }
    MainGradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.05),
        NumberSequenceKeypoint.new(1, 0.15)
    }
    MainGradient.Parent = MainCard
    Library.Globals.MainGradient = MainGradient
    
-- ============================================================
-- 樱花粉(2.0)
-- ============================================================
MainCard.BackgroundTransparency = 0.15 

local SakuraFrame = Instance.new("Frame")
SakuraFrame.Name = "SakuraWallpaper"
SakuraFrame.Size = UDim2.new(1, 0, 1, 0)
SakuraFrame.BackgroundColor3 = Color3.fromRGB(255, 235, 240)
SakuraFrame.BackgroundTransparency = 0.2
SakuraFrame.ZIndex = 1
SakuraFrame.ClipsDescendants = true
SakuraFrame.Parent = MainCard
Instance.new("UICorner", SakuraFrame).CornerRadius = UDim.new(0, 16)

task.spawn(function()
    while SakuraFrame and SakuraFrame.Parent do
        local petal = Instance.new("ImageLabel")
        petal.Name = "Petal"
        petal.Size = UDim2.fromOffset(math.random(15, 30), math.random(15, 30)) 
        petal.BackgroundTransparency = 1
        petal.Image = "rbxassetid://8131033444" 
        petal.ImageColor3 = Color3.fromRGB(255, 170, 200) 
        petal.ImageTransparency = math.random(30, 60) / 100
        petal.Rotation = math.random(0, 360)
        
        local startX = math.random(0, 600)
        petal.Position = UDim2.new(0, startX, 0, -30)
        petal.ZIndex = 1
        petal.Parent = SakuraFrame

        local fallTime = math.random(3, 8)
        local endX = startX + math.random(-150, 150)
        
        local tween = TweenService:Create(petal, TweenInfo.new(fallTime, Enum.EasingStyle.Linear), {
            Position = UDim2.new(0, endX, 1, 30),
            Rotation = petal.Rotation + math.random(180, 720)
        })
        tween:Play()
        
        tween.Completed:Connect(function()
            petal:Destroy()
        end)

        task.wait(0.3)
    end
end)

    -- 通知容器
    local NotifHolder = Instance.new("Frame")
    NotifHolder.Name = "NotifHolder"
    NotifHolder.Parent = GuiRoot
    NotifHolder.BackgroundTransparency = 1
    NotifHolder.Size = UDim2.new(0, 260, 1, -100)
    NotifHolder.Position = UDim2.new(1, -16, 1, -16)
    NotifHolder.AnchorPoint = Vector2.new(1, 1)
    NotifHolder.ZIndex = 1000
    Library.Globals.NotifHolder = NotifHolder
    local NotifUIScale = Instance.new("UIScale")
    NotifUIScale.Parent = NotifHolder
    NotifUIScale.Scale = scale
    Library.Globals.NotifUIScale = NotifUIScale

    -- HUD
    local HUDFrame = Instance.new("Frame")
    HUDFrame.Name = "HUD"
    HUDFrame.Parent = GuiRoot
    HUDFrame.Position = UDim2.new(1, -10, 0, 50)
    HUDFrame.AnchorPoint = Vector2.new(1, 0)
    HUDFrame.Size = UDim2.new(0, 300, 1, -60)
    HUDFrame.BackgroundTransparency = 1
    HUDFrame.ZIndex = 1000
    Library.Globals.HUDFrame = HUDFrame
    local HUDUIScale = Instance.new("UIScale")
    HUDUIScale.Parent = HUDFrame
    HUDUIScale.Scale = scale
    Library.Globals.HUDUIScale = HUDUIScale
    local HUDLayout = Instance.new("UIListLayout")
    HUDLayout.Parent = HUDFrame
    HUDLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    HUDLayout.Padding = UDim.new(0, 2)
    HUDLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- 顶部标题栏
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 44)
    Header.BackgroundTransparency = 1
    Header.Parent = MainCard

    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 26, 0, 26)
    CloseButton.Position = UDim2.new(1, -32, 0, 9)
    CloseButton.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
    CloseButton.Text = "×"
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextColor3 = Color3.fromRGB(80, 80, 90)
    CloseButton.TextSize = 18
    CloseButton.AutoButtonColor = false
    CloseButton.Parent = Header
    Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(1, 0)
    Library.Globals.CloseButton = CloseButton

    Library:_BindTheme(CloseButton, function()
        if IsDarkTheme() then
            return Color3.fromRGB(70, 72, 82)
        else
            return Color3.fromRGB(240, 240, 245)
        end
    end)
    Library:_BindText(CloseButton, function() return Library.Theme.TextGray end)

    -- 左侧面板
    local LeftPanel = Instance.new("Frame")
    LeftPanel.Name = "LeftPanel"
    LeftPanel.Size = UDim2.new(0, 180, 1, -20)
    LeftPanel.Position = UDim2.new(0, 10, 0, 10)
    LeftPanel.BackgroundColor3 = Library.Theme.PanelBg
    LeftPanel.BackgroundTransparency = 0
    LeftPanel.BorderSizePixel = 0
    LeftPanel.ClipsDescendants = true
    LeftPanel.Parent = MainCard
    Instance.new("UICorner", LeftPanel).CornerRadius = UDim.new(0, 12)
    Library.Globals.LeftPanel = LeftPanel
    Library:_BindTheme(LeftPanel, function() return Library.Theme.PanelBg end)
    LeftPanel.ZIndex = 2
    
    -- 标题区
    local HEADER_H = 150
    local LeftHeader = Instance.new("Frame")
    LeftHeader.Name = "LeftHeader"
    LeftHeader.Size = UDim2.new(1, 0, 0, HEADER_H)
    LeftHeader.Position = UDim2.new(0, 0, 0, 0)
    LeftHeader.BackgroundTransparency = 1
    LeftHeader.ZIndex = 2
    LeftHeader.Parent = LeftPanel

    local LHIcon = Instance.new("ImageLabel")
    LHIcon.Size = UDim2.new(0, 60, 0, 60)
    LHIcon.Position = UDim2.new(0.5, 0, 0, 4)
    LHIcon.AnchorPoint = Vector2.new(0.5, 0)
    LHIcon.BackgroundTransparency = 1
    LHIcon.ScaleType = Enum.ScaleType.Fit
    LHIcon.Image = "rbxassetid://117319089551538"
    LHIcon.ZIndex = 3
    LHIcon.Parent = LeftHeader

    local LHTitle = Instance.new("TextLabel")
    LHTitle.Size = UDim2.new(1, -16, 0, 40)
    LHTitle.Position = UDim2.new(0.5, 0, 0, 68)
    LHTitle.AnchorPoint = Vector2.new(0.5, 0)
    LHTitle.BackgroundTransparency = 1
    LHTitle.Text = "Ghostly\nPilot"
    LHTitle.TextWrapped = true
    LHTitle.Font = Enum.Font.Merriweather
    LHTitle.TextColor3 = Library.Theme.TextDark
    LHTitle.TextSize = 17
    LHTitle.TextXAlignment = Enum.TextXAlignment.Center
    LHTitle.TextYAlignment = Enum.TextYAlignment.Center
    LHTitle.ZIndex = 3
    LHTitle.Parent = LeftHeader
    Library:_BindText(LHTitle, function() return Library.Theme.TextDark end)

    local LHTime = Instance.new("TextLabel")
    LHTime.Name = "LHTime"
    LHTime.Size = UDim2.new(1, -16, 0, 14)
    LHTime.Position = UDim2.new(0.5, 0, 0, 110)
    LHTime.AnchorPoint = Vector2.new(0.5, 0)
    LHTime.BackgroundTransparency = 1
    LHTime.Text = "北京时间：--:--:--"
    LHTime.Font = Enum.Font.Gotham
    LHTime.TextColor3 = Library.Theme.TextGray
    LHTime.TextSize = 11
    LHTime.TextXAlignment = Enum.TextXAlignment.Center
    LHTime.ZIndex = 3
    LHTime.Parent = LeftHeader
    Library:_BindText(LHTime, function() return Library.Theme.TextGray end)

    local LHVer = Instance.new("TextLabel")
    LHVer.Size = UDim2.new(1, -16, 0, 14)
    LHVer.Position = UDim2.new(0.5, 0, 0, 126)
    LHVer.AnchorPoint = Vector2.new(0.5, 0)
    LHVer.BackgroundTransparency = 1
    LHVer.Text = "v" .. VERSION
    LHVer.Font = Enum.Font.Gotham
    LHVer.TextColor3 = Library.Theme.TextGray
    LHVer.TextSize = 11
    LHVer.TextXAlignment = Enum.TextXAlignment.Center
    LHVer.ZIndex = 3
    LHVer.Parent = LeftHeader
    Library:_BindText(LHVer, function() return Library.Theme.TextGray end)

    local LHSep = Instance.new("Frame")
    LHSep.Size = UDim2.new(1, -24, 0, 1)
    LHSep.Position = UDim2.new(0.5, 0, 0, 142)
    LHSep.AnchorPoint = Vector2.new(0.5, 0)
    LHSep.BackgroundColor3 = Library.Theme.Stroke
    LHSep.BorderSizePixel = 0
    LHSep.ZIndex = 3
    LHSep.Parent = LeftHeader
    Library:_BindTheme(LHSep, function() return Library.Theme.Stroke end)

    Library.Globals.LHTimeLabel = LHTime

    -- 分类滚动区
    local LeftScroll = Instance.new("ScrollingFrame")
    LeftScroll.Name = "LeftScroll"
    LeftScroll.Size = UDim2.new(1, 0, 1, -HEADER_H)
    LeftScroll.Position = UDim2.new(0, 0, 0, HEADER_H)
    LeftScroll.BackgroundTransparency = 1
    LeftScroll.BorderSizePixel = 0
    LeftScroll.ScrollBarThickness = 3
    LeftScroll.ScrollBarImageColor3 = Library.Theme.Stroke
    LeftScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    LeftScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    LeftScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    LeftScroll.Parent = LeftPanel
    Library.Globals.LeftScroll = LeftScroll

    local LeftPad = Instance.new("UIPadding")
    LeftPad.PaddingTop = UDim.new(0, 8)
    LeftPad.PaddingBottom = UDim.new(0, 8)
    LeftPad.PaddingLeft = UDim.new(0, 6)
    LeftPad.PaddingRight = UDim.new(0, 6)
    LeftPad.Parent = LeftScroll

    local LeftLayout = Instance.new("UIListLayout")
    LeftLayout.Padding = UDim.new(0, 4)
    LeftLayout.FillDirection = Enum.FillDirection.Vertical
    LeftLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    LeftLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
    LeftLayout.Parent = LeftScroll

    -- 右侧内容区
    local RightPanel = Instance.new("ScrollingFrame")
    RightPanel.Name = "RightPanel"
    RightPanel.Size = UDim2.new(1, -204, 1, -60)
    RightPanel.Position = UDim2.new(0, 194, 0, 50)
    RightPanel.BackgroundColor3 = Library.Theme.CardBg
    RightPanel.BackgroundTransparency = 0
    RightPanel.BorderSizePixel = 0
    RightPanel.ScrollBarThickness = 4
    RightPanel.ScrollBarImageColor3 = Library.Theme.Stroke
    RightPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
    RightPanel.AutomaticCanvasSize = Enum.AutomaticSize.Y
    RightPanel.ScrollingDirection = Enum.ScrollingDirection.Y
    RightPanel.ClipsDescendants = true
    RightPanel.Parent = MainCard
    Instance.new("UICorner", RightPanel).CornerRadius = UDim.new(0, 12)
    Library.Globals.RightPanel = RightPanel
    Library:_BindTheme(RightPanel, function() return Library.Theme.CardBg end)
    RightPanel.ZIndex = 2

    local RightPad = Instance.new("UIPadding")
    RightPad.PaddingTop = UDim.new(0, 12)
    RightPad.PaddingBottom = UDim.new(0, 12)
    RightPad.PaddingLeft = UDim.new(0, 12)
    RightPad.PaddingRight = UDim.new(0, 12)
    RightPad.Parent = RightPanel

    Library.Globals.DragHolder      = DragHolder
    Library.Globals.Bar             = Bar
    Library.Globals.TitleLabel      = TitleLabel
    Library.Globals.IconClickButton = IconClickButton
end

-- ============================================================
-- 屏幕尺寸变化时重新适配
-- ============================================================
local function bindViewportRescale()
    local cam = workspace.CurrentCamera
    if not cam then return end
    cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        local vp = cam.ViewportSize
        local sW = (vp.X * 0.85) / 620
        local sH = (vp.Y * 0.85) / 380
        local s = math.clamp(math.min(sW, sH), 0.45, 1.4)
        if Library.Globals.UpdateBarWidth then Library.Globals.UpdateBarWidth() end
        if Library.Globals.MainUIScale then Library.Globals.MainUIScale.Scale = s end
        if Library.Globals.HUDUIScale then Library.Globals.HUDUIScale.Scale = s end
        if Library.Globals.NotifUIScale then Library.Globals.NotifUIScale.Scale = s end
    end)
end

-- ============================================================
-- 打开/关闭主卡片
-- ============================================================
local function bindOpenClose()
    local G = Library.Globals
    local function collapse()
        G.TitleLabel.Visible = false
        TweenService:Create(G.DragHolder, TweenInfo.new(0.22), {Size = UDim2.new(0, 42, 0, 42)}):Play()
        TweenService:Create(G.Bar, TweenInfo.new(0.22), {Size = UDim2.new(0, 42, 1, 0)}):Play()
    end
    local function restore()
        G.TitleLabel.Visible = true
        task.wait()
        local totalW = G.TitleLabel.TextBounds.X + 44 + 10
        TweenService:Create(G.DragHolder, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, totalW, 0, 42)}):Play()
        TweenService:Create(G.Bar, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, totalW, 1, 0)}):Play()
    end
    local function openCard()
        if G.MainCardOpen then return end
        G.MainCardOpen = true
        collapse()
        G.MainCard.BackgroundTransparency = 1
        G.MainCard.Size = UDim2.new(0, 0, 0, 0)
        G.MainCard.Visible = true
        task.wait(0.1)
        TweenService:Create(G.MainCard, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 620, 0, 380), BackgroundTransparency = 0
        }):Play()
    end
    local function closeCard()
        if not G.MainCardOpen then return end
        G.MainCardOpen = false
        local tw = TweenService:Create(G.MainCard, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1
        })
        tw:Play()
        tw.Completed:Once(function()
            G.MainCard.Visible = false
            restore()
        end)
    end
    G.IconClickButton.MouseButton1Click:Connect(function()
        if G.MainCardOpen then closeCard() else openCard() end
    end)
    G.CloseButton.MouseButton1Click:Connect(closeCard)
end

-- ============================================================
-- 北京时间
-- ============================================================
local function startClock()
    local function update()
        local utcNow = os.time()
        local bj = os.date("!*t", utcNow + 8 * 60 * 60)
        local timeStr = string.format("北京时间：%02d:%02d:%02d", bj.hour, bj.min, bj.sec)
        if Library.Globals.LHTimeLabel then
            Library.Globals.LHTimeLabel.Text = timeStr
        end
    end
    update()
    task.spawn(function()
        while task.wait(1) do
            if Library.Globals.LHTimeLabel and Library.Globals.LHTimeLabel:IsDescendantOf(game) then
                update()
            else
                break
            end
        end
    end)
end

-- ============================================================
-- Window 对象
-- ============================================================
local function CreateWindowObj(name)
    local Win = {}
    local panel = Library.Globals.SubPanels[name]
    function Win:CreateButton(title, callback)
        Library:AddExpandButton(panel, title, nil, function(state)
            if state and callback then pcall(callback) end
        end)
    end
    function Win:CreateModule(title, callback)
        local Btn, MoreBtn, Content = Library:AddExpandButton(panel, title, nil, callback)
        return Library:WrapModule(Btn, MoreBtn, Content, title)
    end
    function Win:CreateActionButton(title, callback)
        return Library:AddActionButton(panel, title, callback)
    end
    return Win
end

function Library:WrapModule(btn, moreBtn, content, title)
    local Mod = {}
    Mod._btn = btn
    Mod._content = content

    function Mod:CreateSlider(txt, min, max, def, cb, suffix, cfgKey)
        Library:AddSlider(content, txt, min, max, def, cb, suffix, cfgKey)
    end
    function Mod:CreateSwitch(txt, cb, def, cfgKey)
        Library:AddSwitch(content, txt, cb, def, cfgKey)
    end
    function Mod:CreateDropdown(txt, opts, cb, multiple, cfgKey)
        Library:AddDropdown(content, txt, opts, cb, multiple, cfgKey)
    end
    function Mod:CreateInput(txt, placeholder, cb, cfgKey)
        Library:AddInput(content, txt, placeholder, cb, cfgKey)
    end
    function Mod:CreateColorPicker(txt, defaultColor, cb, cfgKey)
        Library:AddColorPicker(content, txt, defaultColor, cb, cfgKey)
    end
    return Mod
end

-- ============================================================
-- 左侧标签按钮
-- ============================================================
function Library:_CreateLeftButton(name)
    local LeftScroll = self.Globals.LeftScroll
    if not LeftScroll then return nil end

    local Btn = Instance.new("TextButton")
    Btn.Name = "Btn_" .. name
    Btn.Size = UDim2.new(1, 0, 0, 34)
    Btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Btn.BackgroundTransparency = 1
    Btn.Text = name
    Btn.Font = Enum.Font.GothamBold
    Btn.TextColor3 = self.Theme.TextGray
    Btn.TextSize = 13
    Btn.AutoButtonColor = false
    Btn.LayoutOrder = #self.Globals.AllButtons + 1
    Btn.Parent = LeftScroll
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

    Btn:SetAttribute("IsActive", false)

    local function setActive(active)
        Btn:SetAttribute("IsActive", active)
        if active then
            TweenService:Create(Btn, TweenInfo.new(0.2), {
                BackgroundColor3 = self.Theme.Active,
                BackgroundTransparency = 0,
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        else
            TweenService:Create(Btn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                TextColor3 = self.Theme.TextGray
            }):Play()
        end
    end

    table.insert(self.TextBindings, {
        obj = Btn,
        func = function()
            if Btn:GetAttribute("IsActive") then
                return Color3.fromRGB(255, 255, 255)
            else
                return Library.Theme.TextGray
            end
        end
    })

    Btn.MouseButton1Click:Connect(function()
        Library:ShowSubPanel(name, setActive)
    end)

    table.insert(self.Globals.AllButtons, {button = Btn, setActive = setActive})
    return Btn, setActive
end

-- ============================================================
-- 创建子面板
-- ============================================================
function Library:CreateChildWindow(title)
    local panel = Instance.new("Frame")
    panel.Name = "Panel_" .. title
    panel.Size = UDim2.new(1, 0, 0, 0)
    panel.AutomaticSize = Enum.AutomaticSize.Y
    panel.BackgroundTransparency = 1
    panel.Visible = false
    panel.Parent = self.Globals.RightPanel
    local lay = Instance.new("UIListLayout")
    lay.Padding = UDim.new(0, 8)
    lay.FillDirection = Enum.FillDirection.Vertical
    lay.HorizontalAlignment = Enum.HorizontalAlignment.Center
    lay.VerticalAlignment = Enum.VerticalAlignment.Top
    lay.Parent = panel
    self.Globals.SubPanels[title] = panel

    local Btn, setActive = self:_CreateLeftButton(title)
    self.Globals.SubPanelButtons[title] = {button = Btn, activateFn = setActive}
    return CreateWindowObj(title)
end

function Library:ShowSubPanel(name, activateFn)
    for _, p in pairs(self.Globals.SubPanels) do p.Visible = false end
    local target = self.Globals.SubPanels[name]
    if target then target.Visible = true end
    for _, item in ipairs(self.Globals.AllButtons) do item.setActive(false) end
    if activateFn then activateFn(true) end
end

-- ============================================================
-- 可展开功能按钮
-- ============================================================
function Library:AddExpandButton(parent, title, statusName, onToggle, icon)
    local ROW_H = 40
    local PAD = 8

    local Row = Instance.new("Frame")
    Row.Name = title
    Row.BackgroundColor3 = self.Theme.CardBg
    Row.BackgroundTransparency = 0
    Row.Size = UDim2.new(1, 0, 0, ROW_H)
    Row.ClipsDescendants = true
    Row.Parent = parent
    Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 10)
    self:_BindTheme(Row, function() return Library.Theme.CardBg end)

    local RowStroke = Instance.new("UIStroke", Row)
    RowStroke.Color = self.Theme.Stroke
    RowStroke.Thickness = 1
    RowStroke.Transparency = 1

    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, ROW_H)
    Header.BackgroundTransparency = 1
    Header.Parent = Row

    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 24, 0, 24)
    Icon.Position = UDim2.new(0, 8, 0.5, 0)
    Icon.AnchorPoint = Vector2.new(0, 0.5)
    Icon.BackgroundTransparency = 1
    Icon.ScaleType = Enum.ScaleType.Fit
    Icon.Image = icon or "rbxassetid://127629592269434"
    Icon.Parent = Header

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -130, 1, 0)
    TitleLabel.Position = UDim2.new(0, 40, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.Font = Enum.Font.GothamMedium
    TitleLabel.TextColor3 = self.Theme.TextDark
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header
    self:_BindText(TitleLabel, function() return Library.Theme.TextDark end)

    local SwitchBtn = Instance.new("TextButton")
    SwitchBtn.Size = UDim2.new(0, 30, 0, 16)
    SwitchBtn.Position = UDim2.new(1, -50, 0.5, 0)
    SwitchBtn.AnchorPoint = Vector2.new(1, 0.5)
    SwitchBtn.BackgroundColor3 = self.Theme.Off
    SwitchBtn.Text = ""
    SwitchBtn.AutoButtonColor = false
    SwitchBtn.Parent = Header
    Instance.new("UICorner", SwitchBtn).CornerRadius = UDim.new(1, 0)

    SwitchBtn:SetAttribute("IsOn", false)
    self:_BindTheme(SwitchBtn, function()
        if SwitchBtn:GetAttribute("IsOn") then
            return Library.Theme.Accent
        else
            return Library.Theme.Off
        end
    end)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 12, 0, 12)
    Knob.Position = UDim2.new(0, 2, 0.5, 0)
    Knob.AnchorPoint = Vector2.new(0, 0.5)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.Parent = SwitchBtn
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)
    self:_BindTheme(Knob, function()
        if IsDarkTheme() then
            return Color3.fromRGB(230, 230, 240)
        else
            return Color3.fromRGB(255, 255, 255)
        end
    end)

    local MoreBtn = Instance.new("TextButton")
    MoreBtn.Size = UDim2.new(0, 22, 0, 22)
    MoreBtn.Position = UDim2.new(1, -14, 0.5, 0)
    MoreBtn.AnchorPoint = Vector2.new(1, 0.5)
    MoreBtn.BackgroundColor3 = Color3.fromRGB(245, 245, 248)
    MoreBtn.Text = "+"
    MoreBtn.Font = Enum.Font.GothamBold
    MoreBtn.TextColor3 = self.Theme.OffText
    MoreBtn.TextSize = 16
    MoreBtn.AutoButtonColor = false
    MoreBtn.Parent = Header
    Instance.new("UICorner", MoreBtn).CornerRadius = UDim.new(0, 6)

    MoreBtn:SetAttribute("IsOpen", false)
    self:_BindTheme(MoreBtn, function()
        if MoreBtn:GetAttribute("IsOpen") then
            return Library.Theme.Accent
        else
            return LighterColor(Library.Theme.CardBg, 0.04)
        end
    end)
    self:_BindText(MoreBtn, function()
        if MoreBtn:GetAttribute("IsOpen") then
            return Color3.fromRGB(255, 255, 255)
        else
            return Library.Theme.OffText
        end
    end)

    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.BackgroundTransparency = 1
    Content.Position = UDim2.new(0, 0, 0, ROW_H)
    Content.Size = UDim2.new(1, 0, 0, 0)
    Content.AutomaticSize = Enum.AutomaticSize.Y
    Content.ClipsDescendants = false
    Content.Visible = false
    Content.Parent = Row
    self:_BindTheme(Content, function() return Library.Theme.CardBg end)

    local CPad = Instance.new("UIPadding")
    CPad.PaddingTop = UDim.new(0, PAD)
    CPad.PaddingBottom = UDim.new(0, PAD)
    CPad.PaddingLeft = UDim.new(0, 10)
    CPad.PaddingRight = UDim.new(0, 10)
    CPad.Parent = Content

    local CLayout = Instance.new("UIListLayout")
    CLayout.Padding = UDim.new(0, 6)
    CLayout.FillDirection = Enum.FillDirection.Vertical
    CLayout.SortOrder = Enum.SortOrder.LayoutOrder
    CLayout.Parent = Content

local open = false
local currentHeight = ROW_H

local function refreshHeight()
    task.defer(function()
        if not Content.Parent then return end
        local layout = Content:FindFirstChildOfClass("UIListLayout")
        local pad = Content:FindFirstChildOfClass("UIPadding")
        local padTop = pad and pad.PaddingTop.Offset or 0
        local padBottom = pad and pad.PaddingBottom.Offset or 0
        
        local contentH = 0
        if layout then 
            contentH = layout.AbsoluteContentSize.Y + padTop + padBottom + 15 
        else 
            contentH = Content.AbsoluteSize.Y 
        end
        
        local targetHeight = open and (ROW_H + contentH) or ROW_H
           
        if currentHeight ~= targetHeight then
            currentHeight = targetHeight
            TweenService:Create(Row, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, targetHeight) }):Play()
        end
    end)
end

Content:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() task.defer(refreshHeight) end)
local layoutObj = Content:FindFirstChildOfClass("UIListLayout")
if layoutObj then 
    layoutObj:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() task.defer(refreshHeight) end) 
end
Content.ChildAdded:Connect(function(child) 
    if child:IsA("GuiObject") then 
        task.defer(function() task.wait(0.05); refreshHeight() end) 
    end 
end)

    local function toggle()
        isToggled = not isToggled
        SwitchBtn:SetAttribute("IsOn", isToggled)
        updateSwitchVisual()
        Library:Notify(title, isToggled)
        if isToggled then
            Library:AddStatus(title)
        else
            Library:RemoveStatus(title)
        end
        if onToggle then pcall(onToggle, isToggled) end
    end

    SwitchBtn.MouseButton1Click:Connect(toggle)

    local titleClick = Instance.new("TextButton")
    titleClick.Size = UDim2.new(1, -130, 1, 0)
    titleClick.Position = UDim2.new(0, 40, 0, 0)
    titleClick.BackgroundTransparency = 1
    titleClick.Text = ""
    titleClick.Parent = Header
    titleClick.MouseButton1Click:Connect(toggle)

    MoreBtn.MouseButton1Click:Connect(function()
        open = not open
        MoreBtn:SetAttribute("IsOpen", open)
        MoreBtn.Text = open and "−" or "+"
        if open then
            Content.Visible = true
            task.wait()
            refreshHeight()
            TweenService:Create(MoreBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = Library.Theme.Accent,
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        else
            TweenService:Create(Row, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, ROW_H)}):Play()
            task.delay(0.25, function()
                if not open then Content.Visible = false end
            end)
            TweenService:Create(MoreBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = LighterColor(Library.Theme.CardBg, 0.04),
                TextColor3 = Library.Theme.OffText
            }):Play()
        end
    end)

    return Row, MoreBtn, Content
end

-- ============================================================
-- 控件：Slider
-- ============================================================
function Library:AddSlider(parent, txt, min, max, def, callback, suffix, cfgKey)
    local v = self:GetConfig(cfgKey, def)
    if v == nil then v = def end
    local suffix = suffix or ""
    local F = Instance.new("Frame")
    F.Parent = parent
    F.BackgroundTransparency = 1
    F.Size = UDim2.new(1, 0, 0, 34)

    local L = Instance.new("TextLabel")
    L.Parent = F
    L.Text = txt .. ": " .. v .. suffix
    L.Font = Enum.Font.Gotham
    L.TextSize = 12
    L.TextColor3 = self.Theme.TextDark
    L.BackgroundTransparency = 1
    L.Size = UDim2.new(1, -16, 0, 16)
    L.Position = UDim2.new(0, 8, 0, 0)
    L.TextXAlignment = Enum.TextXAlignment.Left
    self:_BindText(L, function() return Library.Theme.TextDark end)

    local B = Instance.new("Frame")
    B.Parent = F
    B.BackgroundColor3 = self.Theme.Off
    B.Position = UDim2.new(0, 8, 0, 22)
    B.Size = UDim2.new(1, -16, 0, 6)
    Instance.new("UICorner", B).CornerRadius = UDim.new(1, 0)
    self:_BindTheme(B, function() return Library.Theme.Off end)

    local Fil = Instance.new("Frame")
    Fil.Parent = B
    Fil.BackgroundColor3 = self.Theme.Slider
    Fil.Size = UDim2.new((v - min) / (max - min), 0, 1, 0)
    Instance.new("UICorner", Fil).CornerRadius = UDim.new(1, 0)
    self:_BindTheme(Fil, function() return Library.Theme.Slider end)

    local T = Instance.new("TextButton")
    T.Parent = F
    T.BackgroundTransparency = 1
    T.Text = ""
    T.Size = UDim2.new(1, 0, 1, 0)
    T.ZIndex = 10

    local dragging = false
    local connChanged, connEnded
    local function stopDrag()
        dragging = false
        if connChanged then connChanged:Disconnect(); connChanged = nil end
        if connEnded then connEnded:Disconnect(); connEnded = nil end
    end

    T.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            connChanged = UserInputService.InputChanged:Connect(function(inp)
                if not dragging then return end
                if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                    local p = math.clamp((inp.Position.X - B.AbsolutePosition.X) / B.AbsoluteSize.X, 0, 1)
                    v = math.floor(min + (max - min) * p)
                    L.Text = txt .. ": " .. v .. suffix
                    Fil.Size = UDim2.new(p, 0, 1, 0)
                    if cfgKey then Library:SetConfig(cfgKey, v) end
                    pcall(callback, v)
                end
            end)
            connEnded = UserInputService.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    stopDrag()
                end
            end)
        end
    end)
end

-- ============================================================
-- 控件：Switch
-- ============================================================
function Library:AddSwitch(parent, txt, callback, defaultState, cfgKey)
    local on = self:GetConfig(cfgKey, defaultState)
    if on == nil then on = false end
    local B = Instance.new("TextButton")
    B.Parent = parent
    B.BackgroundColor3 = self.Theme.CardBg
    B.BackgroundTransparency = 0
    B.Size = UDim2.new(1, 0, 0, 34)
    B.Text = ""
    B.AutoButtonColor = false
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 10)
    self:_BindTheme(B, function() return Library.Theme.CardBg end)

    local L = Instance.new("TextLabel")
    L.Parent = B
    L.Text = txt
    L.Font = Enum.Font.Gotham
    L.TextSize = 14
    L.TextColor3 = self.Theme.TextDark
    L.BackgroundTransparency = 1
    L.Size = UDim2.new(1, -60, 1, 0)
    L.Position = UDim2.new(0, 14, 0, 0)
    L.TextXAlignment = Enum.TextXAlignment.Left
    self:_BindText(L, function() return Library.Theme.TextDark end)

    local Box = Instance.new("Frame")
    Box.Parent = B
    Box.Size = UDim2.new(0, 30, 0, 16)
    Box.Position = UDim2.new(1, -42, 0.5, 0)
    Box.AnchorPoint = Vector2.new(1, 0.5)
    Box.BackgroundColor3 = on and self.Theme.Accent or self.Theme.Off
    Instance.new("UICorner", Box).CornerRadius = UDim.new(1, 0)

    Box:SetAttribute("IsOn", on)
    self:_BindTheme(Box, function()
        if Box:GetAttribute("IsOn") then
            return Library.Theme.Accent
        else
            return Library.Theme.Off
        end
    end)

    local Knob = Instance.new("Frame")
    Knob.Parent = Box
    Knob.Size = UDim2.new(0, 12, 0, 12)
    Knob.Position = on and UDim2.new(1, -14, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
    Knob.AnchorPoint = Vector2.new(0, 0.5)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)
    self:_BindTheme(Knob, function()
        if IsDarkTheme() then
            return Color3.fromRGB(230, 230, 240)
        else
            return Color3.fromRGB(255, 255, 255)
        end
    end)

    B.MouseButton1Click:Connect(function()
        on = not on
        Box:SetAttribute("IsOn", on)
        TweenService:Create(Box, TweenInfo.new(0.2), {
            BackgroundColor3 = on and Library.Theme.Accent or Library.Theme.Off
        }):Play()
        TweenService:Create(Knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Position = on and UDim2.new(1, -14, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
        }):Play()
        if cfgKey then Library:SetConfig(cfgKey, on) end
        pcall(callback, on)
    end)
end

-- ============================================================
-- 控件：Dropdown
-- ============================================================
function Library:AddDropdown(parent, txt, opts, callback, multiple, cfgKey)
    local open = false
    local multiple = multiple or false
    local selected = {}
    local H = 34
    local optH = 26

    local Base = Instance.new("Frame")
    Base.Parent = parent
    Base.BackgroundColor3 = self.Theme.CardBg
    Base.BackgroundTransparency = 0
    Base.Size = UDim2.new(1, 0, 0, H)
    Base.ClipsDescendants = true
    Instance.new("UICorner", Base).CornerRadius = UDim.new(0, 10)
    self:_BindTheme(Base, function() return Library.Theme.CardBg end)

    local Main = Instance.new("TextButton")
    Main.Parent = Base
    Main.BackgroundTransparency = 1
    Main.Size = UDim2.new(1, 0, 0, H)
    Main.Text = ""
    Main.AutoButtonColor = false

    local L = Instance.new("TextLabel")
    L.Parent = Main
    L.Text = txt .. " ▼"
    L.Font = Enum.Font.Gotham
    L.TextSize = 14
    L.TextColor3 = self.Theme.TextDark
    L.BackgroundTransparency = 1
    L.Size = UDim2.new(1, -20, 1, 0)
    L.Position = UDim2.new(0, 14, 0, 0)
    L.TextXAlignment = Enum.TextXAlignment.Left
    self:_BindText(L, function() return Library.Theme.TextDark end)

    local saved = self:GetConfig(cfgKey, nil)
    if saved then
        if multiple and type(saved) == "table" then
            selected = {}
            for _, v in ipairs(saved) do table.insert(selected, v) end
        elseif not multiple and type(saved) == "string" then
            L.Text = txt .. ": " .. saved .. " ▼"
        end
    end

    local Opts = Instance.new("Frame")
    Opts.Parent = Base
    Opts.Position = UDim2.new(0, 0, 0, H)
    Opts.Size = UDim2.new(1, 0, 0, #opts * optH)
    Opts.BackgroundTransparency = 1

    local OList = Instance.new("UIListLayout")
    OList.Parent = Opts

    local function UpdateDisplay()
        if multiple then
            local names = {}
            for _, v in ipairs(selected) do table.insert(names, v) end
            L.Text = txt .. ": " .. (#names > 0 and table.concat(names, ", ") or "无") .. " ▼"
        end
    end

    for _, o in ipairs(opts) do
        local isSel = false
        for _, v in ipairs(selected) do
            if v == o then isSel = true; break end        end
        local Ob = Instance.new("TextButton")
        Ob.Parent = Opts
        Ob.Size = UDim2.new(1, 0, 0, optH)
        Ob.BackgroundTransparency = 1
        Ob.Text = multiple and (isSel and "☑ " or "☐ ") .. o or o
        Ob.Font = Enum.Font.Gotham
        Ob.TextSize = 14
        Ob.TextColor3 = self.Theme.TextDark
        Ob.AutoButtonColor = false
        Ob.TextXAlignment = Enum.TextXAlignment.Left
        self:_BindText(Ob, function() return Library.Theme.TextDark end)

        Ob.MouseButton1Click:Connect(function()
            if multiple then
                local found = false
                for i, v in ipairs(selected) do
                    if v == o then
                        table.remove(selected, i)
                        Ob.Text = "☐ " .. o
                        found = true
                        break
                    end
                end
                if not found then
                    table.insert(selected, o)
                    Ob.Text = "☑ " .. o
                end
                UpdateDisplay()
                if cfgKey then Library:SetConfig(cfgKey, selected) end
                pcall(callback, selected)
            else
                L.Text = txt .. ": " .. o .. " ▼"
                open = false
                TweenService:Create(Base, TweenInfo.new(0.25), {Size = UDim2.new(1, 0, 0, H)}):Play()
                if cfgKey then Library:SetConfig(cfgKey, o) end
                pcall(callback, o)
            end
        end)
    end

    if multiple then UpdateDisplay() end

    Main.MouseButton1Click:Connect(function()
        open = not open
        local nh = open and (H + #opts * optH) or H
        TweenService:Create(Base, TweenInfo.new(0.25), {Size = UDim2.new(1, 0, 0, nh)}):Play()
    end)

    return Base
end

-- ============================================================
-- 控件：Input
-- ============================================================
function Library:AddInput(parent, text, placeholder, callback, cfgKey)
    local BoxH = 34
    local Container = Instance.new("Frame")
    Container.Parent = parent
    Container.BackgroundColor3 = self.Theme.CardBg
    Container.BackgroundTransparency = 0
    Container.Size = UDim2.new(1, 0, 0, BoxH)
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 10)
    self:_BindTheme(Container, function() return Library.Theme.CardBg end)

    local Label = Instance.new("TextLabel")
    Label.Parent = Container
    Label.Text = text .. ":"
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextColor3 = self.Theme.TextDark
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(0, 70, 1, 0)
    Label.Position = UDim2.new(0, 14, 0, 0)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    self:_BindText(Label, function() return Library.Theme.TextDark end)

    local TextBox = Instance.new("TextBox")
    TextBox.Parent = Container
    TextBox.BackgroundTransparency = 1
    TextBox.Size = UDim2.new(1, -90, 1, 0)
    TextBox.Position = UDim2.new(0, 84, 0, 0)
    TextBox.Font = Enum.Font.Gotham
    TextBox.Text = tostring(Library:GetConfig(cfgKey, "") or "")
    TextBox.PlaceholderText = placeholder or "输入..."
    TextBox.TextSize = 14
    TextBox.TextColor3 = self.Theme.TextDark
    TextBox.PlaceholderColor3 = self.Theme.TextGray
    TextBox.TextXAlignment = Enum.TextXAlignment.Left
    TextBox.ClearTextOnFocus = false
    TextBox.BorderSizePixel = 0
    self:_BindText(TextBox, function() return Library.Theme.TextDark end)

    TextBox.FocusLost:Connect(function(enterPressed)
        if cfgKey then Library:SetConfig(cfgKey, TextBox.Text) end
        pcall(callback, TextBox.Text)
    end)
end

-- ============================================================
-- 控件：ColorPicker
-- ============================================================
function Library:AddColorPicker(parent, txt, defaultColor, callback, cfgKey)
    local saved = self:GetConfig(cfgKey, nil)
    local selectedColor = saved or defaultColor or Color3.fromRGB(255, 255, 255)
    local hue, sat, val = selectedColor:ToHSV()

    local Container = Instance.new("Frame")
    Container.Parent = parent
    Container.BackgroundColor3 = self.Theme.CardBg
    Container.BackgroundTransparency = 0
    Container.Size = UDim2.new(1, 0, 0, 36)
    Container.ClipsDescendants = true
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 10)
    self:_BindTheme(Container, function() return Library.Theme.CardBg end)

    local Label = Instance.new("TextLabel")
    Label.Parent = Container
    Label.Text = txt
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextColor3 = self.Theme.TextDark
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 14, 0, 0)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    self:_BindText(Label, function() return Library.Theme.TextDark end)

    local Preview = Instance.new("Frame")
    Preview.Parent = Container
    Preview.Size = UDim2.new(0, 22, 0, 22)
    Preview.Position = UDim2.new(1, -30, 0.5, 0)
    Preview.AnchorPoint = Vector2.new(1, 0.5)
    Preview.BackgroundColor3 = selectedColor
    Preview.BorderSizePixel = 0
    Instance.new("UICorner", Preview).CornerRadius = UDim.new(0, 4)

    local ClickBtn = Instance.new("TextButton")
    ClickBtn.Parent = Container
    ClickBtn.BackgroundTransparency = 1
    ClickBtn.Text = ""
    ClickBtn.Size = UDim2.new(1, 0, 1, 0)
    ClickBtn.ZIndex = 10

    local Picker = Instance.new("Frame")
    Picker.Parent = Container
    Picker.BackgroundColor3 = Color3.fromRGB(250, 250, 255)
    Picker.BorderSizePixel = 0
    Picker.Size = UDim2.new(1, 0, 0, 0)
    Picker.ClipsDescendants = true
    Picker.Visible = false
    Picker.ZIndex = 100
    Instance.new("UICorner", Picker).CornerRadius = UDim.new(0, 8)

    local SVBoard = Instance.new("ImageLabel")
    SVBoard.Parent = Picker
    SVBoard.Position = UDim2.new(0, 10, 0, 10)
    SVBoard.Size = UDim2.new(1, -50, 0, 110)
    SVBoard.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
    SVBoard.BorderSizePixel = 0
    SVBoard.Image = "rbxassetid://4155801252"
    SVBoard.ScaleType = Enum.ScaleType.Stretch
    Instance.new("UICorner", SVBoard).CornerRadius = UDim.new(0, 6)

    local SVCursor = Instance.new("Frame")
    SVCursor.Parent = SVBoard
    SVCursor.Size = UDim2.new(0, 10, 0, 10)
    SVCursor.AnchorPoint = Vector2.new(0.5, 0.5)
    SVCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SVCursor.BorderSizePixel = 0
    SVCursor.ZIndex = 5
    Instance.new("UICorner", SVCursor).CornerRadius = UDim.new(1, 0)
    local SVCursorStroke = Instance.new("UIStroke")
    SVCursorStroke.Color = Color3.fromRGB(0, 0, 0)
    SVCursorStroke.Thickness = 1.5
    SVCursorStroke.Parent = SVCursor

    local HueBar = Instance.new("Frame")
    HueBar.Parent = Picker
    HueBar.Position = UDim2.new(1, -35, 0, 10)
    HueBar.Size = UDim2.new(0, 22, 0, 110)
    HueBar.BorderSizePixel = 0
    Instance.new("UICorner", HueBar).CornerRadius = UDim.new(0, 6)

    local HueGradient = Instance.new("UIGradient")
    HueGradient.Rotation = 90
    HueGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
    })
    HueGradient.Parent = HueBar

    local HueCursor = Instance.new("Frame")
    HueCursor.Parent = HueBar
    HueCursor.Size = UDim2.new(1, 6, 0, 6)
    HueCursor.AnchorPoint = Vector2.new(0.5, 0.5)
    HueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HueCursor.BorderSizePixel = 0
    HueCursor.ZIndex = 5
    Instance.new("UICorner", HueCursor).CornerRadius = UDim.new(1, 0)
    local HueCursorStroke = Instance.new("UIStroke")
    HueCursorStroke.Color = Color3.fromRGB(0, 0, 0)
    HueCursorStroke.Thickness = 1.5
    HueCursorStroke.Parent = HueCursor

    local function makeInput(xPos, labelText, defaultText, width)
        local Box = Instance.new("Frame")
        Box.Parent = Picker
        Box.Position = UDim2.new(0, xPos, 0, 130)
        Box.Size = UDim2.new(0, width, 0, 26)
        Box.BackgroundColor3 = Color3.fromRGB(235, 235, 245)
        Box.BorderSizePixel = 0
        Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 6)

        local BoxLabel = Instance.new("TextLabel")
        BoxLabel.Parent = Box
        BoxLabel.Text = labelText
        BoxLabel.Font = Enum.Font.GothamBold
        BoxLabel.TextSize = 11
        BoxLabel.TextColor3 = Color3.fromRGB(120, 120, 130)
        BoxLabel.BackgroundTransparency = 1
        BoxLabel.Size = UDim2.new(0, 16, 1, 0)
        BoxLabel.Position = UDim2.new(0, 4, 0, 0)

        local BoxInput = Instance.new("TextBox")
        BoxInput.Parent = Box
        BoxInput.BackgroundTransparency = 1
        BoxInput.Text = defaultText
        BoxInput.Font = Enum.Font.Gotham
        BoxInput.TextSize = 12
        BoxInput.TextColor3 = Color3.fromRGB(40, 40, 40)
        BoxInput.Size = UDim2.new(1, -22, 1, 0)
        BoxInput.Position = UDim2.new(0, 20, 0, 0)
        BoxInput.TextXAlignment = Enum.TextXAlignment.Left
        BoxInput.ClearTextOnFocus = false

        return Box, BoxInput
    end

    local RBox, RInput = makeInput(10, "R", "255", 60)
    local GBox, GInput = makeInput(75, "G", "255", 60)
    local BBox, BInput = makeInput(140, "B", "255", 60)
    local HexBox, HexInput = makeInput(205, "#", "#FFFFFF", 100)

    local function updateCursor()
        SVCursor.Position = UDim2.new(sat, 0, 1 - val, 0)
        HueCursor.Position = UDim2.new(0.5, 0, hue, 0)
    end

    local function updateDisplays()
        local c = Color3.fromHSV(hue, sat, val)
        Preview.BackgroundColor3 = c
        SVBoard.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
        RInput.Text = tostring(math.floor(c.R * 255))
        GInput.Text = tostring(math.floor(c.G * 255))
        BInput.Text = tostring(math.floor(c.B * 255))
        HexInput.Text = string.format("#%02X%02X%02X", math.floor(c.R * 255), math.floor(c.G * 255), math.floor(c.B * 255))
    end

    local function applyAndSave(c)
        if cfgKey then Library:SetConfig(cfgKey, c) end
        pcall(callback, c)
    end

    local svDragging = false
    local svConnChanged, svConnEnded
    local function stopSV()
        svDragging = false
        if svConnChanged then svConnChanged:Disconnect(); svConnChanged = nil end
        if svConnEnded then svConnEnded:Disconnect(); svConnEnded = nil end
    end
    SVBoard.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            svDragging = true
            svConnChanged = UserInputService.InputChanged:Connect(function(inp)
                if not svDragging then return end
                if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                    local p = inp.Position
                    local x = math.clamp((p.X - SVBoard.AbsolutePosition.X) / SVBoard.AbsoluteSize.X, 0, 1)
                    local y = math.clamp((p.Y - SVBoard.AbsolutePosition.Y) / SVBoard.AbsoluteSize.Y, 0, 1)
                    sat, val = x, 1 - y
                    updateCursor()
                    updateDisplays()
                    applyAndSave(Color3.fromHSV(hue, sat, val))
                end
            end)
            svConnEnded = UserInputService.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    stopSV()
                end
            end)
        end
    end)

    local hueDragging = false
    local hueConnChanged, hueConnEnded
    local function stopHue()
        hueDragging = false
        if hueConnChanged then hueConnChanged:Disconnect(); hueConnChanged = nil end
        if hueConnEnded then hueConnEnded:Disconnect(); hueConnEnded = nil end
    end
    HueBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            hueDragging = true
            hueConnChanged = UserInputService.InputChanged:Connect(function(inp)
                if not hueDragging then return end
                if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                    local p = inp.Position
                    local y = math.clamp((p.Y - HueBar.AbsolutePosition.Y) / HueBar.AbsoluteSize.Y, 0, 1)
                    hue = y
                    updateCursor()
                    updateDisplays()
                    applyAndSave(Color3.fromHSV(hue, sat, val))
                end
            end)
            hueConnEnded = UserInputService.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    stopHue()
                end
            end)
        end
    end)

    local function onRGBInput()
        local r = math.clamp(tonumber(RInput.Text) or 0, 0, 255)
        local g = math.clamp(tonumber(GInput.Text) or 0, 0, 255)
        local b = math.clamp(tonumber(BInput.Text) or 0, 0, 255)
        local c = Color3.fromRGB(r, g, b)
        hue, sat, val = c:ToHSV()
        updateCursor()
        updateDisplays()
        applyAndSave(c)
    end
    RInput.FocusLost:Connect(onRGBInput)
    GInput.FocusLost:Connect(onRGBInput)
    BInput.FocusLost:Connect(onRGBInput)

    HexInput.FocusLost:Connect(function()
        local text = HexInput.Text
        local r, g, b = string.match(text, "^#?([%x][%x])([%x][%x])([%x][%x])$")
        if r and g and b then
            local cr, cg, cb = tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)
            if cr and cg and cb then
                local c = Color3.fromRGB(cr, cg, cb)
                hue, sat, val = c:ToHSV()
                updateCursor()
                updateDisplays()
                applyAndSave(c)
                return
            end
        end
        updateDisplays()
    end)

    updateCursor()
    updateDisplays()

    local open = false
    ClickBtn.MouseButton1Click:Connect(function()
        open = not open
        if open then
            Picker.Visible = true
            TweenService:Create(Container, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {
                Size = UDim2.new(1, 0, 0, 36 + 170)
            }):Play()
            TweenService:Create(Picker, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {
                Size = UDim2.new(1, 0, 0, 170)
            }):Play()
        else
            TweenService:Create(Container, TweenInfo.new(0.25, Enum.EasingStyle.Exponential), {
                Size = UDim2.new(1, 0, 0, 36)
            }):Play()
            TweenService:Create(Picker, TweenInfo.new(0.25, Enum.EasingStyle.Exponential), {
                Size = UDim2.new(1, 0, 0, 0)
            }):Play()
            task.delay(0.3, function()
                if not open then Picker.Visible = false end
            end)
        end
    end)

    local settings = {}
    function settings:Set(color)
        selectedColor = color
        hue, sat, val = color:ToHSV()
        updateCursor()
        updateDisplays()
    end
    return settings
end

-- ============================================================
-- 控件：ActionButton
-- ============================================================
function Library:AddActionButton(parent, title, callback, icon)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 40)
    Btn.BackgroundColor3 = Library.Theme.CardBg
    Btn.BackgroundTransparency = 0
    Btn.Text = ""
    Btn.AutoButtonColor = false
    Btn.Parent = parent
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 10)
    self:_BindTheme(Btn, function() return Library.Theme.CardBg end)

    local stroke = Instance.new("UIStroke", Btn)
    stroke.Color = Library.Theme.Stroke
    stroke.Thickness = 1
    self:_BindStroke(stroke, function() return Library.Theme.Stroke end)

    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 24, 0, 24)
    Icon.Position = UDim2.new(0, 8, 0.5, 0)
    Icon.AnchorPoint = Vector2.new(0, 0.5)
    Icon.BackgroundTransparency = 1
    Icon.ScaleType = Enum.ScaleType.Fit
    Icon.Image = icon or "rbxassetid://127629592269434"
    Icon.Parent = Btn

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Position = UDim2.new(0, 40, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = title
    Label.Font = Enum.Font.GothamMedium
    Label.TextColor3 = Library.Theme.TextDark
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Btn
    self:_BindText(Label, function() return Library.Theme.TextDark end)

    Btn.MouseButton1Click:Connect(function()
        Btn.BackgroundColor3 = Library.Theme.Accent
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        if callback then pcall(callback) end
        task.wait(0.15)
        TweenService:Create(Btn, TweenInfo.new(0.25), {
            BackgroundColor3 = Library.Theme.CardBg
        }):Play()
        TweenService:Create(Label, TweenInfo.new(0.25), {
            TextColor3 = Library.Theme.TextDark
        }):Play()
    end)

    return Btn
end

-- ============================================================
-- 开场加载动画
-- ============================================================
local function playLoader(onFinish)
    task.spawn(function()
        local ok, err = pcall(function()
            local MAIN_TEXT = "GhostlyPilotUI"
            local SUB_TEXT = "UI作者：茉莉璐"
            local HOLD_TIME = 3
            local LETTER_FLY_TIME = 0.25
            local LETTER_STAGGER = 0.05
            local TEXT_COLOR = Color3.fromRGB(40, 40, 40)

            local Loader = Instance.new("ScreenGui")
            Loader.Name = "GhostlyPilot_Loader"
            Loader.IgnoreGuiInset = true
            Loader.DisplayOrder = 10000
            Loader.ResetOnSpawn = false
            Loader.Parent = parentGui

            local Bg = Instance.new("Frame")
            Bg.Size = UDim2.new(1, 0, 1, 0)
            Bg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Bg.BorderSizePixel = 0
            Bg.Parent = Loader

            local Center = Instance.new("Frame")
            Center.Size = UDim2.new(0, 600, 0, 200)
            Center.AnchorPoint = Vector2.new(0.5, 0.5)
            Center.Position = UDim2.new(0.5, 0, 0.5, 0)
            Center.BackgroundTransparency = 1
            Center.ZIndex = 2
            Center.Parent = Bg

            local function SplitChars(text)
                local chars = {}
                local i = 1
                while i <= #text do
                    local b = text:byte(i)
                    local len = 1
                    if b >= 240 then len = 4
                    elseif b >= 224 then len = 3
                    elseif b >= 192 then len = 2 end
                    table.insert(chars, text:sub(i, i + len - 1))
                    i = i + len
                end
                return chars
            end

            local function CreateLettersRow(parent, text, fontSize, yPosition)
                local row = Instance.new("Frame")
                row.AnchorPoint = Vector2.new(0.5, 0)
                row.Position = UDim2.new(0.5, 0, 0, yPosition)
                row.Size = UDim2.new(0, 0, 0, fontSize + 10)
                row.BackgroundTransparency = 1
                row.Parent = parent

                local letters = {}
                local totalW = 0
                local gap = 2
                local chars = SplitChars(text)

                for i, char in ipairs(chars) do
                    local charW
                    if char == " " then
                        charW = math.floor(fontSize * 0.35)
                    else
                        local tmp = Instance.new("TextLabel")
                        tmp.Font = Enum.Font.GothamBold
                        tmp.TextSize = fontSize
                        tmp.Text = char
                        tmp.Parent = parent
                        charW = tmp.TextBounds.X
                        tmp:Destroy()
                    end

                    local lbl = Instance.new("TextLabel")
                    lbl.BackgroundTransparency = 1
                    lbl.Text = char
                    lbl.Font = Enum.Font.GothamBold
                    lbl.TextSize = fontSize
                    lbl.TextColor3 = TEXT_COLOR
                    lbl.TextXAlignment = Enum.TextXAlignment.Center
                    lbl.Size = UDim2.new(0, charW + 4, 1, 0)
                    lbl.Position = UDim2.new(0, 0, 0, 0)
                    lbl.Parent = row
                    table.insert(letters, {label = lbl, width = charW + 4})
                    totalW = totalW + charW + 4 + gap
                end

                totalW = totalW - gap
                row.Size = UDim2.new(0, totalW, 0, fontSize + 10)

                for _, item in ipairs(letters) do
                    item.label.Position = UDim2.new(0, 800, 0, 0)
                    item.label.TextTransparency = 1
                end
                return row, letters
            end

            local mainRow, mainLetters = CreateLettersRow(Center, MAIN_TEXT, 42, 40)
            local subRow, subLetters = CreateLettersRow(Center, SUB_TEXT, 20, 110)

            local function PlayLetterFlyIn(letters)
                for i, item in ipairs(letters) do
                    local targetX = 0
                    for j = 1, i - 1 do
                        targetX = targetX + letters[j].width + 2
                    end
                    TweenService:Create(item.label, TweenInfo.new(LETTER_FLY_TIME, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Position = UDim2.new(0, targetX, 0, 0),
                        TextTransparency = 0,
                    }):Play()
                    task.wait(LETTER_STAGGER)
                end
            end

            PlayLetterFlyIn(mainLetters)
            task.wait(0.15)
            PlayLetterFlyIn(subLetters)
            task.wait(HOLD_TIME)

            local fadeTime = 0.8
            TweenService:Create(Bg, TweenInfo.new(fadeTime), {BackgroundTransparency = 1}):Play()
            for _, item in ipairs(mainLetters) do
                TweenService:Create(item.label, TweenInfo.new(fadeTime), {TextTransparency = 1}):Play()
            end
            for _, item in ipairs(subLetters) do
                TweenService:Create(item.label, TweenInfo.new(fadeTime), {TextTransparency = 1}):Play()
            end

            task.wait(fadeTime + 0.1)
            Loader:Destroy()
        end)
        if not ok then warn("[加载动画] 出错：", err) end
        if onFinish then onFinish() end
    end)
end

-- ============================================================
-- DestroyUI
-- ============================================================
function Library:DestroyUI()
    pcall(function() self:Notify("UI 已删除", false) end)
    task.wait(0.3)
    if self.Globals.GuiRoot then
        pcall(function() self.Globals.GuiRoot:Destroy() end)
    end
    _G.GhostlyPilotUI_Loaded = nil
    for _, snd in ipairs({self.Globals.OpenSound, self.Globals.CloseSound}) do
        if snd then pcall(function() snd:Destroy() end) end
    end
    self.Globals.Initialized = false
    self.Globals.MainCardOpen = false
    self.Globals.ActiveNotifs = {}
    self.Globals.FloatWidgets = {}
    self.Globals.SubPanels = {}
    self.Globals.SubPanelButtons = {}
    self.Globals.AllButtons = {}
    self.ThemeBindings = {}
    self.TextBindings = {}
    self.Globals.GuiRoot = nil
    self.Globals.MainCard = nil
    self.Globals.LeftPanel = nil
    self.Globals.LeftScroll = nil
    self.Globals.RightPanel = nil
    self.Globals.HUDFrame = nil
    self.Globals.NotifHolder = nil
    self.Globals.DragHolder = nil
    self.Globals.Bar = nil
    self.Globals.TitleLabel = nil
    self.Globals.IconClickButton = nil
    self.Globals.CloseButton = nil
    self.Globals.LHTimeLabel = nil
    self.Globals.MainGradient = nil
end

-- ============================================================
-- 内置分类（设置）
-- ============================================================
function Library:_BuildBuiltinWindows()
    local SettingsWin = self:CreateChildWindow("设置")

    local themeMod = SettingsWin:CreateModule("主题", function() end)

    local themeOrder = {"樱花粉", "深海蓝", "薄荷绿", "暗夜黑", "烈焰红"}
    local themeNames = {}
    for _, name in ipairs(themeOrder) do
        if self.Presets[name] then
            table.insert(themeNames, name)
        end
    end
    for name in pairs(self.Presets) do
        local found = false
        for _, n in ipairs(themeNames) do
            if n == name then found = true; break end
        end
        if not found then table.insert(themeNames, name) end
    end

    themeMod:CreateDropdown("选择主题", themeNames, function(selected)
        self:ApplyTheme(selected)
        self:Notify("主题已切换：" .. selected, true)
    end, false, nil)

    SettingsWin:CreateActionButton("退出", function()
        self:DestroyUI()
    end)

    local first = nil
    for name in pairs(self.Globals.SubPanels) do
        first = name
        break
    end
    if first and self.Globals.SubPanelButtons[first] then
        self:ShowSubPanel(first, self.Globals.SubPanelButtons[first].activateFn)
    end
end

-- ============================================================
-- Init
-- ============================================================
function Library:Init()
    if self.Globals.Initialized then
        warn("[GhostlyPilotUI] 已初始化")
        return self
    end
    self.Globals.Initialized = true

    local savedThemeName = self:_LoadThemeName()
    if savedThemeName and self.Presets[savedThemeName] then
        for k, v in pairs(self.Presets[savedThemeName]) do
            self.Theme[k] = v
        end
        self.COLOR_ON = self.Theme.Accent
    end

    initSounds()
    buildBaseUI()
    bindViewportRescale()
    bindOpenClose()
    startClock()

    self:_RefreshHUDGradient()
    self:_RefreshCardGradient()

    playLoader(function()
        self.Globals.GuiRoot.Enabled = true
        task.wait(0.1)
        self:_BuildBuiltinWindows()
    end)

    return self
end

return Library
