local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local plr = Players.LocalPlayer
local playerGui = plr:WaitForChild("PlayerGui")

local flySpeed = 60
local minSpeed = 30
local maxSpeed = 500

local flying = false
local noclipEnabled = false
local flyConnection = nil
local noclipThread = nil
local originalCollisions = {}
local activeCharacter = nil
local controlModule = nil

local oldGui = playerGui:FindFirstChild("FlyControlGui")
if oldGui then oldGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyControlGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = playerGui

local Frame = Instance.new("Frame")
Frame.Name = "MainFrame"
Frame.Size = UDim2.new(0, 200, 0, 190)
Frame.Position = UDim2.new(0.5, -100, 0.5, -95)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.ClipsDescendants = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame

local dragDetector = Instance.new("UIDragDetector")
local hasDragDetector = pcall(function()
    dragDetector.Parent = Frame
end)
if not hasDragDetector then
    dragDetector:Destroy()
end

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.BorderSizePixel = 0
Title.Text = "飞行Ui--由Baloksxin汉化"
Title.TextColor3 = Color3.fromRGB(200, 200, 200)
Title.Font = Enum.Font.Gotham
Title.TextSize = 14
Title.Parent = Frame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

if not hasDragDetector then
    local dragging, dragStart, startPos = false, nil, nil
    Title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and dragStart and startPos then
            if input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                Frame.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0.9, 0, 0, 30)
ToggleButton.Position = UDim2.new(0.05, 0, 0, 40)
ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "开启飞行"
ToggleButton.TextColor3 = Color3.fromRGB(200, 200, 200)
ToggleButton.Font = Enum.Font.Gotham
ToggleButton.TextSize = 12
ToggleButton.AutoButtonColor = false
ToggleButton.Parent = Frame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = ToggleButton

local NoclipButton = Instance.new("TextButton")
NoclipButton.Name = "NoclipButton"
NoclipButton.Size = UDim2.new(0.9, 0, 0, 30)
NoclipButton.Position = UDim2.new(0.05, 0, 0, 80)
NoclipButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
NoclipButton.BorderSizePixel = 0
NoclipButton.Text = "穿墙: 关闭"
NoclipButton.TextColor3 = Color3.fromRGB(200, 200, 200)
NoclipButton.Font = Enum.Font.Gotham
NoclipButton.TextSize = 12
NoclipButton.AutoButtonColor = false
NoclipButton.Parent = Frame

local NoclipCorner = Instance.new("UICorner")
NoclipCorner.CornerRadius = UDim.new(0, 6)
NoclipCorner.Parent = NoclipButton

local SpeedSlider = Instance.new("Frame")
SpeedSlider.Name = "SpeedSlider"
SpeedSlider.Size = UDim2.new(0.9, 0, 0, 50)
SpeedSlider.Position = UDim2.new(0.05, 0, 0, 120)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedSlider.BorderSizePixel = 0
SpeedSlider.Parent = Frame

local SliderCorner = Instance.new("UICorner")
SliderCorner.CornerRadius = UDim.new(0, 6)
SliderCorner.Parent = SpeedSlider

local SpeedText = Instance.new("TextLabel")
SpeedText.Name = "SpeedText"
SpeedText.Size = UDim2.new(1, 0, 0, 20)
SpeedText.Position = UDim2.new(0, 0, 0, 0)
SpeedText.BackgroundTransparency = 1
SpeedText.Text = "速度: " .. flySpeed
SpeedText.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedText.Font = Enum.Font.Gotham
SpeedText.TextSize = 12
SpeedText.Parent = SpeedSlider

local SliderBar = Instance.new("Frame")
SliderBar.Name = "SliderBar"
SliderBar.Size = UDim2.new(0.9, 0, 0, 6)
SliderBar.Position = UDim2.new(0.05, 0, 0, 25)
SliderBar.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
SliderBar.BorderSizePixel = 0
SliderBar.Parent = SpeedSlider

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(0, 3)
BarCorner.Parent = SliderBar

local SliderFill = Instance.new("Frame")
SliderFill.Name = "SliderFill"
SliderFill.Size = UDim2.new((flySpeed - minSpeed) / (maxSpeed - minSpeed), 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBar

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(0, 3)
FillCorner.Parent = SliderFill

local SliderButton = Instance.new("TextButton")
SliderButton.Name = "SliderButton"
SliderButton.Size = UDim2.new(0, 20, 0, 20)
SliderButton.Position = UDim2.new((flySpeed - minSpeed) / (maxSpeed - minSpeed), -10, 0.5, -10)
SliderButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
SliderButton.BorderSizePixel = 0
SliderButton.Text = ""
SliderButton.Parent = SliderBar

local SliderButtonCorner = Instance.new("UICorner")
SliderButtonCorner.CornerRadius = UDim.new(0, 10)
SliderButtonCorner.Parent = SliderButton

local function getControlModule()
    if controlModule then return controlModule end
    local playerScripts = plr:FindFirstChild("PlayerScripts")
    if not playerScripts then return nil end
    local playerModule = playerScripts:FindFirstChild("PlayerModule")
    if not playerModule then return nil end
    local ok, mod = pcall(function()
        return require(playerModule:WaitForChild("ControlModule"))
    end)
    if ok then
        controlModule = mod
        return mod
    end
    return nil
end

local function clearOriginalCollisions()
    for part in pairs(originalCollisions) do
        originalCollisions[part] = nil
    end
end

local function applyNoclipStep()
    if not noclipEnabled or not activeCharacter then return end
    for _, part in ipairs(activeCharacter:GetDescendants()) do
        if part:IsA("BasePart") then
            if originalCollisions[part] == nil then
                originalCollisions[part] = part.CanCollide
            end
            part.CanCollide = false
        end
    end
end

local function bindCharacter(char)
    activeCharacter = char
    clearOriginalCollisions()
    if noclipEnabled then
        applyNoclipStep()
    end
end

plr.CharacterAdded:Connect(function(char)
    task.wait(0.2)
    if flying then
        flying = false
        ToggleButton.Text = "开启飞行"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
    end
    bindCharacter(char)
end)

if plr.Character then
    bindCharacter(plr.Character)
end

local function restoreCollisions()
    for part, state in pairs(originalCollisions) do
        if part and part.Parent then
            part.CanCollide = state
        end
    end
    clearOriginalCollisions()
end

NoclipButton.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        NoclipButton.Text = "穿墙: 开启"
        NoclipButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        applyNoclipStep()
        if not noclipThread then
            noclipThread = task.spawn(function()
                while noclipEnabled do
                    applyNoclipStep()
                    task.wait(0.5)
                end
                noclipThread = nil
            end)
        end
    else
        NoclipButton.Text = "穿墙: 关闭"
        NoclipButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        restoreCollisions()
    end
end)

local function disableFlight()
    if not flying then return end
    flying = false
    ToggleButton.Text = "开启飞行"
    ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

    local char = activeCharacter
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.PlatformStand = false
        end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            for _, name in ipairs({"VelocityHandler", "GyroHandler", "FlyAttachment"}) do
                local inst = root:FindFirstChild(name)
                if inst then inst:Destroy() end
            end
        end
    end

    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
end

local function enableFlight()
    if flying then return end
    local char = activeCharacter
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not (char and root and hum) then
        warn("[Fly] 角色或 HumanoidRootPart 未就绪")
        return
    end

    local ctrl = getControlModule()
    if not ctrl then
        warn("[Fly] 无法获取 ControlModule")
        return
    end

    flying = true
    ToggleButton.Text = "关闭飞行"
    ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)

    local attach = root:FindFirstChild("FlyAttachment")
    if not attach then
        attach = Instance.new("Attachment")
        attach.Name = "FlyAttachment"
        attach.Parent = root
    end

    local lv = Instance.new("LinearVelocity")
    lv.Name = "VelocityHandler"
    lv.Attachment0 = attach
    lv.MaxForce = math.huge
    lv.VectorVelocity = Vector3.zero
    lv.RelativeTo = Enum.ActuatorRelativeTo.World
    lv.Parent = root

    local ao = Instance.new("AlignOrientation")
    ao.Name = "GyroHandler"
    ao.Attachment0 = attach
    ao.Mode = Enum.OrientationAlignmentMode.OneAttachment
    ao.MaxTorque = math.huge
    ao.Responsiveness = 200
    ao.Parent = root

    hum.PlatformStand = true

    flyConnection = RunService.RenderStepped:Connect(function()
        if not flying or not activeCharacter or activeCharacter ~= char
            or not hum.Parent or hum.Health <= 0 then
            disableFlight()
            return
        end

        local camCF = workspace.CurrentCamera.CFrame
        ao.CFrame = camCF

        local move = ctrl:GetMoveVector()

        local velocity = Vector3.zero
        if move.Magnitude > 0 then
            local forward = camCF.LookVector
            local right = camCF.RightVector
            velocity = (right * move.X - forward * move.Z)
            if velocity.Magnitude > 0 then
                velocity = velocity.Unit * flySpeed
            end
        end

        local up = 0
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then up += 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
            or UserInputService:IsKeyDown(Enum.KeyCode.RightShift) then
            up -= 1
        end
        if up ~= 0 then
            velocity += Vector3.new(0, up * flySpeed, 0)
            if velocity.Magnitude > flySpeed then
                velocity = velocity.Unit * flySpeed
            end
        end

        lv.VectorVelocity = velocity
    end)
end

ToggleButton.MouseButton1Click:Connect(function()
    if flying then
        disableFlight()
    else
        enableFlight()
    end
end)

local sliding = false

local function updateSlider(inputPosX)
    local absPos = SliderBar.AbsolutePosition
    local absSize = SliderBar.AbsoluteSize
    if absSize.X <= 0 then return end
    local rel = math.clamp((inputPosX - absPos.X) / absSize.X, 0, 1)
    SliderButton.Position = UDim2.new(rel, -10, 0.5, -10)
    SliderFill.Size = UDim2.new(rel, 0, 1, 0)
    flySpeed = math.floor(minSpeed + (maxSpeed - minSpeed) * rel)
    SpeedText.Text = "速度: " .. flySpeed
end

local function inputX(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        return input.Position.X
    end
    return UserInputService:GetMouseLocation().X
end

SliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        sliding = true
        updateSlider(inputX(input))
    end
end)

SliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        sliding = true
        updateSlider(inputX(input))
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not sliding then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        updateSlider(inputX(input))
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        sliding = false
    end
end)
