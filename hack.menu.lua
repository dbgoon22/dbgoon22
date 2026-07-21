--//=================================\\--
--||      ROBLOX HACK MENU          ||--
--||  Speed | TriggerBot | Hitbox   ||--
--\\=================================//--

-- Servicios
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Variables locales
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Estados de los hacks
local SpeedEnabled = false
local SpeedValue = 100
local TriggerBotEnabled = false
local HitboxEnabled = false
local HitboxSize = 10
local ShowHitboxesEnabled = false

-- ESP Storage
local ESPBoxes = {}

--//====================================\\--
--||           CREAR GUI              ||--
--\\====================================//--

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HackMenu"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 220, 0, 280)
MainFrame.Position = UDim2.new(0.1, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false  -- Oculto por defecto
MainFrame.Parent = ScreenGui

-- Esquinas redondeadas
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

-- Título
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Text = "HACK MENU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

--//====================================\\--
--||        FUNCIONES DE BOTONES      ||--
--\\====================================//--

local function CreateButton(text, yPos)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.9, 0, 0, 40)
    Button.Position = UDim2.new(0.05, 0, 0, yPos)
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.Font = Enum.Font.Gotham
    Button.Parent = MainFrame
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Button
    
    return Button
end

--//====================================\\--
--||           BOTÓN SPEED            ||--
--\\====================================//--

local SpeedButton = CreateButton("Speed: OFF", 45)

SpeedButton.MouseButton1Click:Connect(function()
    SpeedEnabled = not SpeedEnabled
    if SpeedEnabled then
        SpeedButton.Text = "Speed: ON (" .. SpeedValue .. ")"
        SpeedButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    else
        SpeedButton.Text = "Speed: OFF"
        SpeedButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)

--//====================================\\--
--||        BOTÓN TRIGGERBOT          ||--
--\\====================================//--

local TriggerButton = CreateButton("TriggerBot: OFF", 95)

TriggerButton.MouseButton1Click:Connect(function()
    TriggerBotEnabled = not TriggerBotEnabled
    if TriggerBotEnabled then
        TriggerButton.Text = "TriggerBot: ON"
        TriggerButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    else
        TriggerButton.Text = "TriggerBot: OFF"
        TriggerButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)

--//====================================\\--
--||      BOTÓN HITBOX EXPANDER       ||--
--\\====================================//--

local HitboxButton = CreateButton("Hitbox: OFF", 145)

HitboxButton.MouseButton1Click:Connect(function()
    HitboxEnabled = not HitboxEnabled
    if HitboxEnabled then
        HitboxButton.Text = "Hitbox: ON (" .. HitboxSize .. ")"
        HitboxButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        ExpandHitboxes()
    else
        HitboxButton.Text = "Hitbox: OFF"
        HitboxButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        ResetHitboxes()
    end
end)

--//====================================\\--
--||       BOTÓN SHOW HITBOXES        ||--
--\\====================================//--

local ESPButton = CreateButton("Show Hitboxes: OFF", 195)

ESPButton.MouseButton1Click:Connect(function()
    ShowHitboxesEnabled = not ShowHitboxesEnabled
    if ShowHitboxesEnabled then
        ESPButton.Text = "Show Hitboxes: ON"
        ESPButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    else
        ESPButton.Text = "Show Hitboxes: OFF"
        ESPButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)

--//====================================\\--
--||      BOTÓN TAMAÑO HITBOX         ||--
--\\====================================//--

local SizeButton = CreateButton("Hitbox Size: " .. HitboxSize, 245)

SizeButton.MouseButton1Click:Connect(function()
    HitboxSize = HitboxSize + 2
    if HitboxSize > 20 then HitboxSize = 4 end
    SizeButton.Text = "Hitbox Size: " .. HitboxSize
    
    if HitboxEnabled then
        ExpandHitboxes()
    end
end)

--//====================================\\--
--||         FUNCIONES HACKS          ||--
--\\====================================//--

-- SPEED HACK
RunService.RenderStepped:Connect(function()
    if SpeedEnabled and LocalPlayer.Character then
        local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if Humanoid then
            Humanoid.WalkSpeed = SpeedValue
        end
    end
end)

-- TRIGGERBOT
local function IsPlayerVisible(target)
    if not target.Character then return false end
    local head = target.Character:FindFirstChild("Head")
    if not head then return false end
    
    local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
    if not onScreen then return false end
    
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
    
    if dist < 60 then
        local rayOrigin = Camera.CFrame.Position
        local rayDir = (head.Position - rayOrigin).Unit * 500
        
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
        
        local result = Workspace:Raycast(rayOrigin, rayDir, rayParams)
        if result then
            local model = result.Instance:FindFirstAncestorOfClass("Model")
            if model == target.Character then
                return true
            end
        end
    end
    return false
end

RunService.RenderStepped:Connect(function()
    if TriggerBotEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and IsPlayerVisible(player) then
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                wait(0.05)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                break
            end
        end
    end
end)

-- HITBOX EXPANDER
function ExpandHitboxes()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local head = player.Character:FindFirstChild("Head")
            
            if hrp then
                hrp.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                hrp.Transparency = 0.7
                hrp.CanCollide = false
            end
            if head then
                head.Size = Vector3.new(HitboxSize/2, HitboxSize/2, HitboxSize/2)
                head.Transparency = 0.7
