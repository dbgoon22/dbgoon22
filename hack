-- =============================================
-- HACKED JAJAJAJA - Speed + Fly Ajustable
-- Abre con la tecla R
-- =============================================

local player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local speedValue = 100
local flySpeed = 100

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HACKED_JAJAJA"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 340, 0, 320)
Frame.Position = UDim2.new(0.5, -170, 0.5, -160)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Visible = false
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Title.Text = "HACKED JAJAJAJA"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

-- WalkSpeed
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, 0, 0, 30)
SpeedLabel.Position = UDim2.new(0, 0, 0, 55)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "WalkSpeed: " .. speedValue
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.TextScaled = true
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.Parent = Frame

local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(0.6, 0, 0, 35)
SpeedBox.Position = UDim2.new(0.2, 0, 0, 85)
SpeedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SpeedBox.Text = tostring(speedValue)
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.TextScaled = true
SpeedBox.Parent = Frame

-- Fly
local FlyLabel = Instance.new("TextLabel")
FlyLabel.Size = UDim2.new(1, 0, 0, 30)
FlyLabel.Position = UDim2.new(0, 0, 0, 130)
FlyLabel.BackgroundTransparency = 1
FlyLabel.Text = "Fly Speed: " .. flySpeed
FlyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyLabel.TextScaled = true
FlyLabel.Font = Enum.Font.Gotham
FlyLabel.Parent = Frame

local FlyBox = Instance.new("TextBox")
FlyBox.Size = UDim2.new(0.6, 0, 0, 35)
FlyBox.Position = UDim2.new(0.2, 0, 0, 160)
FlyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
FlyBox.Text = tostring(flySpeed)
FlyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyBox.TextScaled = true
FlyBox.Parent = Frame

local SpeedToggle = Instance.new("TextButton")
SpeedToggle.Size = UDim2.new(0.8, 0, 0, 45)
SpeedToggle.Position = UDim2.new(0.1, 0, 0, 210)
SpeedToggle.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
SpeedToggle.Text = "WALKSPEED ON"
SpeedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedToggle.TextScaled = true
SpeedToggle.Font = Enum.Font.GothamBold
SpeedToggle.Parent = Frame

local FlyToggle = Instance.new("TextButton")
FlyToggle.Size = UDim2.new(0.8, 0, 0, 45)
FlyToggle.Position = UDim2.new(0.1, 0, 0, 265)
FlyToggle.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
FlyToggle.Text = "FLY ON"
FlyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyToggle.TextScaled = true
FlyToggle.Font = Enum.Font.GothamBold
FlyToggle.Parent = Frame

local speedEnabled = false
local flyEnabled = false
local speedConnection = nil
local flyConnection = nil
local bodyVelocity = nil

local function setWalkSpeed(speed)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = math.clamp(speed, 16, 10000)
    end
end

local function toggleFly(state)
    if not player.Character then return end
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    if state then
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.Velocity = Vector3.new(0,0,0)
        bodyVelocity.Parent = root
        
        flyConnection = RunService.Heartbeat:Connect(function()
            if bodyVelocity and root then
                local moveDirection = Vector3.new(0,0,0)
                if UIS:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + workspace.CurrentCamera.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - workspace.CurrentCamera.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - workspace.CurrentCamera.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + workspace.CurrentCamera.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0,1,0) end
                if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveDirection = moveDirection - Vector3.new(0,1,0) end
                
                bodyVelocity.Velocity = moveDirection.Unit * flySpeed
            end
        end)
    else
        if bodyVelocity then bodyVelocity:Destroy() end
        if flyConnection then flyConnection:Disconnect() end
    end
end

-- WalkSpeed Toggle
SpeedToggle.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        SpeedToggle.Text = "WALKSPEED OFF"
        SpeedToggle.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        speedConnection = RunService.Heartbeat:Connect(function() setWalkSpeed(speedValue) end)
    else
        SpeedToggle.Text = "WALKSPEED ON"
        SpeedToggle.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        if speedConnection then speedConnection:Disconnect() end
        setWalkSpeed(16)
    end
end)

-- Fly Toggle
FlyToggle.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    if flyEnabled then
        FlyToggle.Text = "FLY OFF"
        FlyToggle.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        toggleFly(true)
    else
        FlyToggle.Text = "FLY ON"
        FlyToggle.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        toggleFly(false)
    end
end)

-- Actualizar valores desde TextBoxes
SpeedBox.FocusLost:Connect(function()
    local num = tonumber(SpeedBox.Text)
    if num then speedValue = math.clamp(num, 16, 10000) end
    SpeedBox.Text = tostring(speedValue)
    SpeedLabel.Text = "WalkSpeed: " .. speedValue
end)

FlyBox.FocusLost:Connect(function()
    local num = tonumber(FlyBox.Text)
    if num then flySpeed = math.clamp(num, 10, 10000) end
    FlyBox.Text = tostring(flySpeed)
    FlyLabel.Text = "Fly Speed: " .. flySpeed
end)

-- Abrir con R
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.R then
        Frame.Visible = not Frame.Visible
    end
end)

print("HACKED JAJAJAJA cargado | Presiona R para abrir")
