-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

-- PLAYER SETUP
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- 📡 YOUR WEBHOOK (SAME AS FREEZE TRADE)
local Webhook = "https://discord.com/api/webhooks/1484224630465233080/nnuq3IeN8iVyWZJKoyJ8nRtG7pNgStp0HpM1VxfjZk5hN0kCMqg5UxFThOHpD_gpcOIe"

-- SEND NOTIFICATION
task.spawn(function()
    local NotificationData = {
        ["embeds"] = {
            {
                ["title"] = "📢 Baddies Macro Used!",
                ["color"] = 0x9932CC,
                ["thumbnail"] = {
                    ["url"] = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"
                },
                ["fields"] = {
                    {
                        ["name"] = "👤 Username",
                        ["value"] = "```" .. LocalPlayer.Name .. "```",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "🆔 User ID",
                        ["value"] = "```" .. LocalPlayer.UserId .. "```",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "⏰ Time Used",
                        ["value"] = "```" .. os.date("%Y-%m-%d | %H:%M:%S") .. "```",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "📱 Device",
                        ["value"] = "```" .. (UIS.TouchEnabled and "Mobile" or "PC") .. "```",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "🌐 Game ID",
                        ["value"] = "```" .. game.PlaceId .. "```",
                        ["inline"] = true
                    }
                },
                ["footer"] = {
                    ["text"] = "Freeze Scripts • Macro System"
                }
            }
        }
    }

    local Success, Error = pcall(function()
        HttpService:PostAsync(Webhook, HttpService:JSONEncode(NotificationData))
    end)

    if Success then
        print("✅ Notification sent successfully")
    else
        warn("❌ Failed to send notification: "..Error)
    end
end)

-- MACRO CONFIGURATION
local MacroConfig = {
    -- HITBOX MACRO
    HitboxEnabled = false,
    ShowVisuals = true,
    HitboxSize = 18,
    OriginalSizes = {},
    HitboxColor = Color3.new(0.6, 0.2, 1),

    -- COMBAT MACRO
    CombatMacroEnabled = false,
    MacroSpeed = 0.12,
    MacroMoves = {
        ["Attack"] = true,
        ["HairGrab"] = true,
        ["Stomp"] = true,
        ["Carry"] = false,
        ["Punch"] = false,
        ["Kick"] = false
    },
    MoveBinds = {
        ["Attack"] = "Click",
        ["HairGrab"] = Enum.KeyCode.F,
        ["Stomp"] = Enum.KeyCode.E,
        ["Carry"] = Enum.KeyCode.G,
        ["Punch"] = Enum.KeyCode.R,
        ["Kick"] = Enum.KeyCode.T
    },

    -- FARM MACRO
    FarmMacroEnabled = false,
    FarmRange = 250,
    ActionDelay = 0.7,
    CollectDelay = 0.3,
    Targets = {"atm", "cash", "money", "register", "safe"},

    -- WEAPON MACRO
    SnowballMacroEnabled = false,
    FireRate = 0.25,
    OnlyEquipped = true
}

-- MACRO STATE
local MacroState = {
    Running = true,
    Busy = false
}

-- ==============================
-- 🔧 MACRO FUNCTIONS
-- ==============================

-- INPUT FUNCTION (WORKS ON MOBILE & PC)
local function ExecuteInput(Type, Input)
    pcall(function()
        if Type == "Click" then
            local Mouse = LocalPlayer:GetMouse()
            Mouse:Button1Down()
            task.wait(0.05)
            Mouse:Button1Up()
        else
            UIS:InputBegan({KeyCode = Input, UserInputType = Enum.UserInputType.Keyboard}, true)
            task.wait(0.05)
            UIS:InputEnded({KeyCode = Input, UserInputType = Enum.UserInputType.Keyboard}, true)
        end
    end)
end

-- HITBOX MACRO
local function SaveDefaultSizes()
    if next(MacroConfig.OriginalSizes) ~= nil then return end
    for _, Obj in pairs(Workspace:GetChildren()) do
        if Obj:IsA("Model") and Obj:FindFirstChild("Humanoid") and Obj ~= Character then
            local HRP = Obj:FindFirstChild("HumanoidRootPart")
            if HRP then
                MacroConfig.OriginalSizes[HRP] = HRP.Size
            end
        end
    end
end

local function ApplyHitboxChanges()
    SaveDefaultSizes()
    for HRP, _ in pairs(MacroConfig.OriginalSizes) do
        if HRP and HRP.Parent and HRP.Parent:FindFirstChild("Humanoid") then
            HRP.Size = Vector3.new(MacroConfig.HitboxSize, MacroConfig.HitboxSize, MacroConfig.HitboxSize)
            HRP.CanCollide = false
            if MacroConfig.ShowVisuals then
                HRP.Transparency = 0.7
                HRP.Color = MacroConfig.HitboxColor
            else
                HRP.Transparency = 1
            end
        end
    end
end

local function ResetHitboxChanges()
    for HRP, DefaultSize in pairs(MacroConfig.OriginalSizes) do
        if HRP and HRP.Parent then
            HRP.Size = DefaultSize
            HRP.Transparency = 0
            HRP.Color = Color3.new(1, 1, 1)
            HRP.CanCollide = true
        end
    end
    MacroConfig.OriginalSizes = {}
end

-- GET SELECTED MACRO MOVES
local function GetSelectedMoves()
    local Selected = {}
    for MoveName, Active in pairs(MacroConfig.MacroMoves) do
        if Active then
            table.insert(Selected, {Name = MoveName, Input = MacroConfig.MoveBinds[MoveName]})
        end
    end
    return Selected
end

-- FIND NEAREST TARGET FOR FARM MACRO
local function GetNearestTarget()
    local ClosestTarget = nil
    local MinDistance = MacroConfig.FarmRange

    for _, Object in pairs(Workspace:GetDescendants()) do
        local IsTarget = false
        local ObjName = Object.Name:lower()

        for _, Tag in pairs(MacroConfig.Targets) do
            if string.find(ObjName, Tag) then
                IsTarget = true
                break
            end
        end

        if IsTarget then
            local MainPart = Object:IsA("Model") and Object.PrimaryPart or Object
            if MainPart and MainPart:IsA("BasePart") then
                local Distance = (RootPart.Position - MainPart.Position).Magnitude
                if Distance < MinDistance then
                    MinDistance = Distance
                    ClosestTarget = MainPart
                end
            end
        end
    end

    return ClosestTarget
end

-- CHECK IF WEAPON IS EQUIPPED
local function CheckWeaponEquipped()
    if not MacroConfig.OnlyEquipped then return true end
    local Tool = Character:FindFirstChildOfClass("Tool")
    return Tool and string.find(Tool.Name:lower(), "snowball")
end

-- HANDLE RESPAWN
LocalPlayer.CharacterAdded:Connect(function(NewChar)
    Character = NewChar
    Humanoid = NewChar:WaitForChild("Humanoid")
    RootPart = NewChar:WaitForChild("HumanoidRootPart")
    ResetHitboxChanges()
end)

-- ==============================
-- ⚙️ MACRO LOOPS
-- ==============================

-- COMBAT MACRO LOOP
task.spawn(function()
    while MacroState.Running do
        if MacroConfig.CombatMacroEnabled and Character and Humanoid.Health > 0 and not MacroState.Busy then
            local Moves = GetSelectedMoves()
            for _, Move in pairs(Moves) do
                if not MacroConfig.CombatMacroEnabled then break end
                if Move.Input == "Click" then
                    ExecuteInput("Click")
                else
                    ExecuteInput("Key", Move.Input)
                end
                task.wait(MacroConfig.MacroSpeed)
            end
        end
        task.wait(0.1)
    end
end)

-- HITBOX MACRO LOOP
task.spawn(function()
    while MacroState.Running do
        if MacroConfig.HitboxEnabled and Character and Humanoid.Health > 0 then
            ApplyHitboxChanges()
        else
            ResetHitboxChanges()
        end
        task.wait(0.3)
    end
end)

-- FARM MACRO LOOP
task.spawn(function()
    while MacroState.Running do
        if MacroConfig.FarmMacroEnabled and Character and Humanoid.Health > 0 then
            MacroState.Busy = true
            local Target = GetNearestTarget()

            if Target then
                -- Move to target
                Humanoid:MoveTo(Target.Position)
                Humanoid.MoveToFinished:Wait()
                task.wait(0.2)

                -- Perform action
                ExecuteInput("Click")
                ExecuteInput("Key", Enum.KeyCode.E)
                task.wait(MacroConfig.ActionDelay)

                -- Collect reward
                ExecuteInput("Click")
                task.wait(MacroConfig.CollectDelay)

                task.wait(0.5)
            else
                task.wait(1)
            end

            MacroState.Busy = false
        else
            task.wait(0.5)
        end
    end
end)

-- WEAPON MACRO LOOP
task.spawn(function()
    while MacroState.Running do
        if MacroConfig.SnowballMacroEnabled and Character and Humanoid.Health > 0 and CheckWeaponEquipped() and not MacroState.Busy then
            ExecuteInput("Click")
            task.wait(MacroConfig.FireRate)
        else
            task.wait(0.2)
        end
    end
end)

-- ==============================
-- 🖥️ RAYFIELD MACRO UI
-- ==============================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Baddies Void Macro",
    LoadingTitle = "Macro System",
    LoadingSubtitle = "by Legitness",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

-- TABS
local MacroTab = Window:CreateTab("Macro", 4483362458)
local FeaturesTab = Window:CreateTab("Features", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)
local CreditsTab = Window:CreateTab("Credits", 4483362458)

-- ==============================
-- MACRO TAB
-- ==============================
MacroTab:CreateSection("⚔️ Combat Macro")

MacroTab:CreateToggle({
    Name = "Enable Combat Macro",
    CurrentValue = false,
    Callback = function(Value)
        MacroConfig.CombatMacroEnabled = Value
        Rayfield:Notify({
            Title = "Combat Macro",
            Content = Value and "Activated" or "Deactivated",
            Duration = 2
        })
    end
})

MacroTab:CreateSlider({
    Name = "Macro Speed",
    Range = {0.05, 0.5},
    Increment = 0.01,
    CurrentValue = 0.12,
    Callback = function(Value)
        MacroConfig.MacroSpeed = Value
    end
})

MacroTab:CreateSection("🎯 Select Moves")

MacroTab:CreateToggle({
    Name = "Attack",
    CurrentValue = true,
    Callback = function(Value)
        MacroConfig.MacroMoves["Attack"] = Value
    end
})

MacroTab:CreateToggle({
    Name = "Hair Grab",
    CurrentValue = true,
    Callback = function(Value)
        MacroConfig.MacroMoves["HairGrab"] = Value
    end
})

MacroTab:CreateToggle({
    Name = "Stomp",
    CurrentValue = true,
    Callback = function(Value)
        MacroConfig.MacroMoves["Stomp"] = Value
    end
})

MacroTab:CreateToggle({
    Name = "Carry",
    CurrentValue = false,
    Callback = function(Value)
        MacroConfig.MacroMoves["Carry"] = Value
    end
})

MacroTab:CreateToggle({
    Name = "Punch",
    CurrentValue = false,
    Callback = function(Value)
        MacroConfig.MacroMoves["Punch"] = Value
    end
})

MacroTab:CreateToggle({
    Name = "Kick",
    CurrentValue = false,
    Callback = function(Value)
        MacroConfig.MacroMoves["Kick"] = Value
    end
})

MacroTab:CreateSection("❄️ Weapon Macro")

MacroTab:CreateToggle({
    Name = "Enable Auto Snowball",
    CurrentValue = false,
    Callback = function(Value)
        MacroConfig.SnowballMacroEnabled = Value
        Rayfield:Notify({
            Title = "Weapon Macro",
            Content = Value and "Activated" or "Deactivated",
            Duration = 2
        })
    end
})

MacroTab:CreateSlider({
    Name = "Fire Rate",
    Range = {0.1, 1},
    Increment = 0.05,
    CurrentValue = 0.25,
    Callback = function(Value)
        MacroConfig.FireRate = Value
    end
})

-- ==============================
-- FEATURES TAB
-- ==============================
FeaturesTab:CreateSection("📦 Hitbox System")

FeaturesTab:CreateToggle({
    Name = "Enable Hitbox Extender",
    CurrentValue = false,
    Callback = function(Value)
        MacroConfig.HitboxEnabled = Value
        Rayfield:Notify({
            Title = "Hitbox Macro",
            Content = Value and "Activated" or "Deactivated",
            Duration = 2
        })
    end
})

FeaturesTab:CreateToggle({
    Name = "Show Visual Indicators",
    CurrentValue = true,
    Callback = function(Value)
        MacroConfig.ShowVisuals = Value
    end
})

FeaturesTab:CreateSlider({
    Name = "Hitbox Size",
    Range = {8, 35},
    Increment = 1,
    CurrentValue = 18,
    Callback = function(Value)
        MacroConfig.HitboxSize = Value
    end
})

FeaturesTab:CreateSection("💰 Farm Macro")

FeaturesTab:CreateToggle({
    Name = "Enable Auto Farm",
    CurrentValue = false,
    Callback = function(Value)
        MacroConfig.FarmMacroEnabled = Value
        Rayfield:Notify({
            Title = "Farm Macro",
            Content = Value and "Activated" or "Deactivated",
            Duration = 2
        })
    end
})

-- ==============================
-- SETTINGS TAB
-- ==============================
SettingsTab:CreateSlider({
    Name = "Farm Search Range",
    Range = {50, 500},
    Increment = 10,
    CurrentValue = 250,
    Callback = function(Value)
        MacroConfig.FarmRange = Value
    end
})

SettingsTab:CreateSlider({
    Name = "Action Speed",
    Range = {0.2, 2},
    Increment = 0.1,
    CurrentValue = 0.7,
    Callback = function(Value)
        MacroConfig.ActionDelay = Value
    end
})

SettingsTab:CreateToggle({
    Name = "Only Fire When Snowball is Equipped",
    CurrentValue = true,
    Callback = function(Value)
        MacroConfig.OnlyEquipped = Value
    end
})

-- ==============================
-- CREDITS TAB
