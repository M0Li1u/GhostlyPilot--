local _0xCAA0 = game:GetService(string.char(80,108,97,121,101,114,115))
local _0xEF8F = game:GetService(string.char(82,117,110,83,101,114,118,105,99,101))
local _0x16AC = game:GetService(string.char(85,115,101,114,73,110,112,117,116,83,101,114,118,105,99,101))
local _0xA94B = _0xCAA0.LocalPlayer
local _0xD4CB = _0xA94B:WaitForChild(string.char(80,108,97,121,101,114,71,117,105))
local _0x438B = 60
local _0xEE09 = 30
local _0x2F1A = 500
local _0xE26B = false
local _0xF11A = false
local _0x2562 = nil
local _0xB7A4 = nil
local _0x4D6E = {}
local _0xBF14 = nil
local _0xB1D0 = nil
local _0x675E = _0xD4CB:FindFirstChild(string.char(70,108,121,67,111,110,116,114,111,108,71,117,105))
if _0x675E then _0x675E:Destroy() end
local _0x01D0 = Instance.new(string.char(83,99,114,101,101,110,71,117,105))
_0x01D0.Name =string.char(70,108,121,67,111,110,116,114,111,108,71,117,105)_0x01D0.ResetOnSpawn = false
_0x01D0.IgnoreGuiInset = true
_0x01D0.Parent = _0xD4CB
local _0x2261 = Instance.new(string.char(70,114,97,109,101))
_0x2261.Name =string.char(77,97,105,110,70,114,97,109,101)_0x2261.Size = UDim2.new(0, 200, 0, 190)
_0x2261.Position = UDim2.new(0.5, -100, 0.5, -95)
_0x2261.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
_0x2261.BorderSizePixel = 0
_0x2261.Active = true
_0x2261.ClipsDescendants = true
_0x2261.Parent = _0x01D0
local _0xDFA5 = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xDFA5.CornerRadius = UDim.new(0, 8)
_0xDFA5.Parent = _0x2261
local _0x5301 = Instance.new(string.char(85,73,68,114,97,103,68,101,116,101,99,116,111,114))
local _0xB142 = pcall(function()
_0x5301.Parent = _0x2261
end)
if not _0xB142 then
_0x5301:Destroy()
end
local _0x360C = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0x360C.Name =string.char(84,105,116,108,101)_0x360C.Size = UDim2.new(1, 0, 0, 30)
_0x360C.Position = UDim2.new(0, 0, 0, 0)
_0x360C.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
_0x360C.BorderSizePixel = 0
_0x360C.Text =string.char(233,163,158,232,161,140,85,105,45,45,231,148,177,66,97,108,111,107,115,120,105,110,230,177,137,229,140,150)_0x360C.TextColor3 = Color3.fromRGB(200, 200, 200)
_0x360C.Font = Enum.Font.Gotham
_0x360C.TextSize = 14
_0x360C.Parent = _0x2261
local _0xC589 = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xC589.CornerRadius = UDim.new(0, 8)
_0xC589.Parent = _0x360C
if not _0xB142 then
local _0x60AE, _0xB2D7, _0x54D8 = false, nil, nil
_0x360C.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1
or input.UserInputType == Enum.UserInputType.Touch then
_0x60AE = true
_0xB2D7 = input.Position
_0x54D8 = _0x2261.Position
end
end)
_0x16AC.InputChanged:Connect(function(input)
if _0x60AE and _0xB2D7 and _0x54D8 then
if input.UserInputType == Enum.UserInputType.MouseMovement
or input.UserInputType == Enum.UserInputType.Touch then
local _0x8964 = input.Position - _0xB2D7
_0x2261.Position = UDim2.new(
_0x54D8.X.Scale, _0x54D8.X.Offset + _0x8964.X,
_0x54D8.Y.Scale, _0x54D8.Y.Offset + _0x8964.Y
)
end
end
end)
_0x16AC.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1
or input.UserInputType == Enum.UserInputType.Touch then
_0x60AE = false
end
end)
end
local _0xCD19 = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0xCD19.Name =string.char(84,111,103,103,108,101,66,117,116,116,111,110)_0xCD19.Size = UDim2.new(0.9, 0, 0, 30)
_0xCD19.Position = UDim2.new(0.05, 0, 0, 40)
_0xCD19.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
_0xCD19.BorderSizePixel = 0
_0xCD19.Text =string.char(229,188,128,229,144,175,233,163,158,232,161,140)_0xCD19.TextColor3 = Color3.fromRGB(200, 200, 200)
_0xCD19.Font = Enum.Font.Gotham
_0xCD19.TextSize = 12
_0xCD19.AutoButtonColor = false
_0xCD19.Parent = _0x2261
local _0xB796 = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xB796.CornerRadius = UDim.new(0, 6)
_0xB796.Parent = _0xCD19
local _0x6512 = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0x6512.Name =string.char(78,111,99,108,105,112,66,117,116,116,111,110)_0x6512.Size = UDim2.new(0.9, 0, 0, 30)
_0x6512.Position = UDim2.new(0.05, 0, 0, 80)
_0x6512.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
_0x6512.BorderSizePixel = 0
_0x6512.Text =string.char(231,169,191,229,162,153,58,32,229,133,179,233,151,173)_0x6512.TextColor3 = Color3.fromRGB(200, 200, 200)
_0x6512.Font = Enum.Font.Gotham
_0x6512.TextSize = 12
_0x6512.AutoButtonColor = false
_0x6512.Parent = _0x2261
local _0xB15F = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xB15F.CornerRadius = UDim.new(0, 6)
_0xB15F.Parent = _0x6512
local _0x1A1C = Instance.new(string.char(70,114,97,109,101))
_0x1A1C.Name =string.char(83,112,101,101,100,83,108,105,100,101,114)_0x1A1C.Size = UDim2.new(0.9, 0, 0, 50)
_0x1A1C.Position = UDim2.new(0.05, 0, 0, 120)
_0x1A1C.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
_0x1A1C.BorderSizePixel = 0
_0x1A1C.Parent = _0x2261
local _0x028E = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0x028E.CornerRadius = UDim.new(0, 6)
_0x028E.Parent = _0x1A1C
local _0xF8FE = Instance.new(string.char(84,101,120,116,76,97,98,101,108))
_0xF8FE.Name =string.char(83,112,101,101,100,84,101,120,116)_0xF8FE.Size = UDim2.new(1, 0, 0, 20)
_0xF8FE.Position = UDim2.new(0, 0, 0, 0)
_0xF8FE.BackgroundTransparency = 1
_0xF8FE.Text =string.char(233,128,159,229,186,166,58,32).. _0x438B
_0xF8FE.TextColor3 = Color3.fromRGB(200, 200, 200)
_0xF8FE.Font = Enum.Font.Gotham
_0xF8FE.TextSize = 12
_0xF8FE.Parent = _0x1A1C
local _0xA21D = Instance.new(string.char(70,114,97,109,101))
_0xA21D.Name =string.char(83,108,105,100,101,114,66,97,114)_0xA21D.Size = UDim2.new(0.9, 0, 0, 6)
_0xA21D.Position = UDim2.new(0.05, 0, 0, 25)
_0xA21D.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
_0xA21D.BorderSizePixel = 0
_0xA21D.Parent = _0x1A1C
local _0x987A = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0x987A.CornerRadius = UDim.new(0, 3)
_0x987A.Parent = _0xA21D
local _0x054B = Instance.new(string.char(70,114,97,109,101))
_0x054B.Name =string.char(83,108,105,100,101,114,70,105,108,108)_0x054B.Size = UDim2.new((_0x438B - _0xEE09) / (_0x2F1A - _0xEE09), 0, 1, 0)
_0x054B.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
_0x054B.BorderSizePixel = 0
_0x054B.Parent = _0xA21D
local _0xE65D = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xE65D.CornerRadius = UDim.new(0, 3)
_0xE65D.Parent = _0x054B
local _0xA38E = Instance.new(string.char(84,101,120,116,66,117,116,116,111,110))
_0xA38E.Name =string.char(83,108,105,100,101,114,66,117,116,116,111,110)_0xA38E.Size = UDim2.new(0, 20, 0, 20)
_0xA38E.Position = UDim2.new((_0x438B - _0xEE09) / (_0x2F1A - _0xEE09), -10, 0.5, -10)
_0xA38E.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
_0xA38E.BorderSizePixel = 0
_0xA38E.Text =""_0xA38E.Parent = _0xA21D
local _0xD91D = Instance.new(string.char(85,73,67,111,114,110,101,114))
_0xD91D.CornerRadius = UDim.new(0, 10)
_0xD91D.Parent = _0xA38E
local function _0xAC7B()
if _0xB1D0 then return _0xB1D0 end
local _0xD231 = _0xA94B:FindFirstChild(string.char(80,108,97,121,101,114,83,99,114,105,112,116,115))
if not _0xD231 then return nil end
local _0x412C = _0xD231:FindFirstChild(string.char(80,108,97,121,101,114,77,111,100,117,108,101))
if not _0x412C then return nil end
local _0xBECF, _0xA8D3 = pcall(function()
return require(_0x412C:WaitForChild(string.char(67,111,110,116,114,111,108,77,111,100,117,108,101)))
end)
if _0xBECF then
_0xB1D0 = _0xA8D3
return _0xA8D3
end
return nil
end
local function _0xE47D()
for part in pairs(_0x4D6E) do
_0x4D6E[part] = nil
end
end
local function _0x90B3()
if not _0xF11A or not _0xBF14 then return end
for _, part in ipairs(_0xBF14:GetDescendants()) do
if part:IsA(string.char(66,97,115,101,80,97,114,116)) then
if _0x4D6E[part] == nil then
_0x4D6E[part] = part.CanCollide
end
part.CanCollide = false
end
end
end
local function _0xC202(_0xC0DC)
_0xBF14 = _0xC0DC
_0xE47D()
if _0xF11A then
_0x90B3()
end
end
_0xA94B.CharacterAdded:Connect(function(_0xC0DC)
task.wait(0.2)
if _0xE26B then
_0xE26B = false
_0xCD19.Text =string.char(229,188,128,229,144,175,233,163,158,232,161,140)_0xCD19.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
if _0x2562 then
_0x2562:Disconnect()
_0x2562 = nil
end
end
_0xC202(_0xC0DC)
end)
if _0xA94B.Character then
_0xC202(_0xA94B.Character)
end
local function _0xA931()
for part, state in pairs(_0x4D6E) do
if part and part.Parent then
part.CanCollide = state
end
end
_0xE47D()
end
_0x6512.MouseButton1Click:Connect(function()
_0xF11A = not _0xF11A
if _0xF11A then
_0x6512.Text =string.char(231,169,191,229,162,153,58,32,229,188,128,229,144,175)_0x6512.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
_0x90B3()
if not _0xB7A4 then
_0xB7A4 = task.spawn(function()
while _0xF11A do
_0x90B3()
task.wait(0.5)
end
_0xB7A4 = nil
end)
end
else
_0x6512.Text =string.char(231,169,191,229,162,153,58,32,229,133,179,233,151,173)_0x6512.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
_0xA931()
end
end)
local function _0x9F67()
if not _0xE26B then return end
_0xE26B = false
_0xCD19.Text =string.char(229,188,128,229,144,175,233,163,158,232,161,140)_0xCD19.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
local _0xC0DC = _0xBF14
if _0xC0DC then
local _0xFB11 = _0xC0DC:FindFirstChildOfClass(string.char(72,117,109,97,110,111,105,100))
if _0xFB11 then
_0xFB11.PlatformStand = false
end
local _0x02D5 = _0xC0DC:FindFirstChild(string.char(72,117,109,97,110,111,105,100,82,111,111,116,80,97,114,116))
if _0x02D5 then
for _, name in ipairs({string.char(86,101,108,111,99,105,116,121,72,97,110,100,108,101,114),string.char(71,121,114,111,72,97,110,100,108,101,114),string.char(70,108,121,65,116,116,97,99,104,109,101,110,116)}) do
local _0x0AF8 = _0x02D5:FindFirstChild(name)
if _0x0AF8 then _0x0AF8:Destroy() end
end
end
end
if _0x2562 then
_0x2562:Disconnect()
_0x2562 = nil
end
end
local function _0x2519()
if _0xE26B then return end
local _0xC0DC = _0xBF14
local _0x02D5 = _0xC0DC and _0xC0DC:FindFirstChild(string.char(72,117,109,97,110,111,105,100,82,111,111,116,80,97,114,116))
local _0xFB11 = _0xC0DC and _0xC0DC:FindFirstChildOfClass(string.char(72,117,109,97,110,111,105,100))
if not (_0xC0DC and _0x02D5 and _0xFB11) then
warn(string.char(91,70,108,121,93,32,232,167,146,232,137,178,230,136,150,32,72,117,109,97,110,111,105,100,82,111,111,116,80,97,114,116,32,230,156,170,229,176,177,231,187,170))
return
end
local _0x6312 = _0xAC7B()
if not _0x6312 then
warn(string.char(91,70,108,121,93,32,230,151,160,230,179,149,232,142,183,229,143,150,32,67,111,110,116,114,111,108,77,111,100,117,108,101))
return
end
_0xE26B = true
_0xCD19.Text =string.char(229,133,179,233,151,173,233,163,158,232,161,140)_0xCD19.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
local _0xABEA = _0x02D5:FindFirstChild(string.char(70,108,121,65,116,116,97,99,104,109,101,110,116))
if not _0xABEA then
_0xABEA = Instance.new(string.char(65,116,116,97,99,104,109,101,110,116))
_0xABEA.Name =string.char(70,108,121,65,116,116,97,99,104,109,101,110,116)_0xABEA.Parent = _0x02D5
end
local _0x2BE5 = Instance.new(string.char(76,105,110,101,97,114,86,101,108,111,99,105,116,121))
_0x2BE5.Name =string.char(86,101,108,111,99,105,116,121,72,97,110,100,108,101,114)_0x2BE5.Attachment0 = _0xABEA
_0x2BE5.MaxForce = math.huge
_0x2BE5.VectorVelocity = Vector3.zero
_0x2BE5.RelativeTo = Enum.ActuatorRelativeTo.World
_0x2BE5.Parent = _0x02D5
local _0x1187 = Instance.new(string.char(65,108,105,103,110,79,114,105,101,110,116,97,116,105,111,110))
_0x1187.Name =string.char(71,121,114,111,72,97,110,100,108,101,114)_0x1187.Attachment0 = _0xABEA
_0x1187.Mode = Enum.OrientationAlignmentMode.OneAttachment
_0x1187.MaxTorque = math.huge
_0x1187.Responsiveness = 200
_0x1187.Parent = _0x02D5
_0xFB11.PlatformStand = true
_0x2562 = _0xEF8F.RenderStepped:Connect(function()
if not _0xE26B or not _0xBF14 or _0xBF14 ~= _0xC0DC
or not _0xFB11.Parent or _0xFB11.Health <= 0 then
_0x9F67()
return
end
local _0xFB4A = workspace.CurrentCamera.CFrame
_0x1187.CFrame = _0xFB4A
local _0xC63B = _0x6312:GetMoveVector()
local _0xF9AF = Vector3.zero
if _0xC63B.Magnitude > 0 then
local _0x48F2 = _0xFB4A.LookVector
local _0xDA72 = _0xFB4A.RightVector
_0xF9AF = (_0xDA72 * _0xC63B.X - _0x48F2 * _0xC63B.Z)
if _0xF9AF.Magnitude > 0 then
_0xF9AF = _0xF9AF.Unit * _0x438B
end
end
local _0x4D53 = 0
if _0x16AC:IsKeyDown(Enum.KeyCode.Space) then _0x4D53 += 1 end
if _0x16AC:IsKeyDown(Enum.KeyCode.LeftShift)
or _0x16AC:IsKeyDown(Enum.KeyCode.RightShift) then
_0x4D53 -= 1
end
if _0x4D53 ~= 0 then
_0xF9AF += Vector3.new(0, _0x4D53 * _0x438B, 0)
if _0xF9AF.Magnitude > _0x438B then
_0xF9AF = _0xF9AF.Unit * _0x438B
end
end
_0x2BE5.VectorVelocity = _0xF9AF
end)
end
_0xCD19.MouseButton1Click:Connect(function()
if _0xE26B then
_0x9F67()
else
_0x2519()
end
end)
local _0x2D8D = false
local function _0x444B(inputPosX)
local _0xBE97 = _0xA21D.AbsolutePosition
local _0x49EA = _0xA21D.AbsoluteSize
if _0x49EA.X <= 0 then return end
local _0x88B8 = math.clamp((inputPosX - _0xBE97.X) / _0x49EA.X, 0, 1)
_0xA38E.Position = UDim2.new(_0x88B8, -10, 0.5, -10)
_0x054B.Size = UDim2.new(_0x88B8, 0, 1, 0)
_0x438B = math.floor(_0xEE09 + (_0x2F1A - _0xEE09) * _0x88B8)
_0xF8FE.Text =string.char(233,128,159,229,186,166,58,32).. _0x438B
end
local function _0x8225(input)
if input.UserInputType == Enum.UserInputType.Touch then
return input.Position.X
end
return _0x16AC:GetMouseLocation().X
end
_0xA38E.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1
or input.UserInputType == Enum.UserInputType.Touch then
_0x2D8D = true
_0x444B(_0x8225(input))
end
end)
_0xA21D.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1
or input.UserInputType == Enum.UserInputType.Touch then
_0x2D8D = true
_0x444B(_0x8225(input))
end
end)
_0x16AC.InputChanged:Connect(function(input)
if not _0x2D8D then return end
if input.UserInputType == Enum.UserInputType.MouseMovement
or input.UserInputType == Enum.UserInputType.Touch then
_0x444B(_0x8225(input))
end
end)
_0x16AC.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1
or input.UserInputType == Enum.UserInputType.Touch then
_0x2D8D = false
end
end)
