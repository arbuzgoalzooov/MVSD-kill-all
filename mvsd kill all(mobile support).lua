local FindFirstChild = game.FindFirstChild
local Destroy = game.Destroy

if FindFirstChild(game.AdService, "Advertisement") then
    Destroy(game.AdService.Advertisement)
end

if FindFirstChild(game.ReplicatedStorage, "Remotes") and FindFirstChild(game.ReplicatedStorage.Remotes, "RenderBullet") then
    Destroy(game.ReplicatedStorage.Remotes.RenderBullet)
end

if FindFirstChild(game.ReplicatedStorage, "Remotes") and FindFirstChild(game.ReplicatedStorage.Remotes, "RenderKnifeProjectile") then
    Destroy(game.ReplicatedStorage.Remotes.RenderKnifeProjectile)
end

if FindFirstChild(game.ReplicatedStorage, "Ability") and FindFirstChild(game.ReplicatedStorage.Ability, "RenderShroudProjectile") then
    Destroy(game.ReplicatedStorage.Ability.RenderShroudProjectile)
end

if FindFirstChild(game.ReplicatedStorage, "Ability") and FindFirstChild(game.ReplicatedStorage.Ability, "CreateTrail") then
    Destroy(game.ReplicatedStorage.Ability.CreateTrail)
end

if FindFirstChild(game.ReplicatedStorage, "Remotes") and FindFirstChild(game.ReplicatedStorage.Remotes, "OnRoundEnded") then
else
    return
end

if getgenv().KillAllLocked then
    return
end

local KillAllDelay = 0.01
local KillAllRageness = 15
local HitMSOffset = -300

HitMSOffset = HitMSOffset / 1000

local Phrases = {
    "Work by mit.",
    "You want to be like me.",
    "R.I.P. - Rest In Piss, forever miss.",
    "GG WP = Get Good, Worst Player.",
    '"Cheater!!!" - said an L and got tapped again',
    "Look! Someone wants my attention that hard!",
    "#MitEbet",
    "UD = Ultra Detected.",
    "Hey, MVSD AC creator! Didn't know about cool Advertisement Remote!",
    "Forever Lose 🥀."
}

game = game
workspace = workspace

getgenv().Enabled = true
getgenv().KillAllLocked = true

local FirstTime = true

local Connect = game.ChildAdded.Connect

local TaskWait = task.wait
local TaskSpawn = task.spawn
local VectorCreate = vector.create
local Vector3Zero = Vector3.zero
local CoroutineWrap = coroutine.wrap

local MathRandom = math.random

local Arg1 = Vector3Zero
local Arg2 = VectorCreate(50, 0, 0)
local Arg4 = Vector3Zero

local GetChildren = game.GetChildren
local GetService = game.GetService
local GetAttribute = game.GetAttribute

local UserInputService = game.UserInputService
local TextChatService = game.TextChatService

local RBXGeneral = TextChatService.TextChannels.RBXGeneral
local SendAsync = RBXGeneral.SendAsync

local Players = game.Players
local StarterGui = game.StarterGui

local LocalPlayer = Players.LocalPlayer

local Remote = game.ReplicatedStorage.Remotes.ShootGun
local FireServer = Remote.FireServer

local PingValue = GetService(game, "Stats").Network.ServerStatsItem["Data Ping"]
local GetValue = PingValue.GetValue

local OnRoundEnded = game.ReplicatedStorage.Remotes.OnRoundEnded
local OnMatchFinished = game.ReplicatedStorage.Remotes.OnMatchFinished

local Ping
local Count = 0
local Time = tick()

local function Notify(Title, Text, Duration)
    StarterGui:SetCore("SendNotification", {
        Title = Title,
        Text = Text,
        Duration = Duration
    })
end

local function EquipTools()
    if LocalPlayer.Character then
        local Weapon = FindFirstChild(LocalPlayer.Backpack, "Default")
        if Weapon then
            for _, Tool in pairs(GetChildren(LocalPlayer.Backpack)) do
                if GetAttribute(Tool, "Cooldown") then
                    Tool.Parent = LocalPlayer.Character
                    Notify("EquipTools", "Success", 0.5)
                end
            end
        end
    end
end

local function LegitKillAll()
    EquipTools()
    TaskWait(1.6)
    for _, Victim in pairs(GetChildren(Players)) do
        if Victim.Team ~= LocalPlayer.Team and FindFirstChild(workspace, Victim.Name) and FindFirstChild(workspace[Victim.Name], "Head") then
            FireServer(Remote, Arg1, Arg2, FindFirstChild(Victim.Character.Head, "Part"), Arg4)
        end
    end
end

local function KillAll()
    for _ = 1, KillAllRageness do
        for _, Victim in pairs(GetChildren(Players)) do
            if Victim.Team ~= LocalPlayer.Team and FindFirstChild(workspace, Victim.Name) and FindFirstChild(workspace[Victim.Name], "Head") then
                FireServer(Remote, Arg1, Arg2, FindFirstChild(Victim.Character.Head, "Part"), Arg4)
                Count = Count + 1
            end
        end
    end
end

CoroutineWrap(function()
    while true do
        if getgenv().KillAll and getgenv().Enabled then
            EquipTools()
            for Index = 1, 10 do
                KillAll()
                TaskWait(0.001)
            end
        end

        TaskWait(KillAllDelay)
    end
end)()

Connect(LocalPlayer.AttributeChanged, function(Attribute)
    if Attribute == "MatchStartTime" and GetAttribute(LocalPlayer, Attribute) then
        Ping = GetValue(PingValue) / 1000 + HitMSOffset

        TaskWait(4.5 - (Ping * 2))

        if FirstTime then
            FirstTime = false
            LegitKillAll()
        else
            Count = 0
            Time = tick()
            getgenv().KillAll = true
        end
    end
end)

Connect(OnRoundEnded.OnClientEvent, function()
    if Count ~= 0 then
        print("Sent " .. Count .. " packets for " .. tostring(tick() - Time) .. " seconds.")
    end

    getgenv().KillAll = false

    Ping = GetValue(PingValue) / 1000 + HitMSOffset

    TaskWait(7 - (Ping * 2))

    if FirstTime then
        FirstTime = false
        LegitKillAll()
    else
        Count = 0
        Time = tick()
        getgenv().KillAll = true
    end
end)

Connect(OnMatchFinished.OnClientEvent, function(Arg1)
    if Count ~= 0 then
        print("Sent " .. Count .. " packets for " .. tostring(tick() - Time) .. " seconds.")
    end

    getgenv().KillAll = false

    if Arg1 == "Won" and getgenv().Enabled then
        Notify("Best Kill All", "Work by mit", 0.5)

        SendAsync(RBXGeneral, Phrases[MathRandom(1, #Phrases)])

        TaskWait(0.2)

        SendAsync(RBXGeneral, Phrases[MathRandom(1, #Phrases)])
    end
end)

if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
    repeat task.wait() until workspace.CurrentCamera.ViewportSize.X ~= 0 and workspace.CurrentCamera.ViewportSize.Y ~= 0
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KA"
    ScreenGui.Parent = GetService(game, "CoreGui")

    local TextButton = Instance.new("TextButton")
    TextButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Italic)
    TextButton.Text = "Kill Aura"
    TextButton.Size = UDim2.new(0, workspace.CurrentCamera.ViewportSize.X / 5, 0, workspace.CurrentCamera.ViewportSize.Y / 5 * (workspace.CurrentCamera.ViewportSize.X / workspace.CurrentCamera.ViewportSize.Y))
    TextButton.BackgroundTransparency = 0.5
    TextButton.Position = UDim2.new(0.696, 0, 0.522, 0)
    TextButton.TextWrapped = true
    TextButton.TextSize = 53
    TextButton.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
    TextButton.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1488, 1161)
    UICorner.Parent = TextButton

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.164, Color3.fromRGB(125, 125, 125)),
        ColorSequenceKeypoint.new(0.858, Color3.fromRGB(197, 197, 197)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    }

    UIGradient.Parent = TextButton
    
    Connect(TextButton.MouseButton1Down, function() 
        getgenv().Enabled = not getgenv().Enabled

        if getgenv().Enabled then
            EquipTools()
        end

        Notify("Best Kill All", tostring(getgenv().Enabled), 0.25)
    end)
else
    local Typing = false

    Connect(UserInputService.TextBoxFocused, function(TextBox)
        Typing = true
    end)

    Connect(UserInputService.TextBoxFocusReleased, function(TextBox)
        Typing = false
    end)

    Connect(UserInputService.InputBegan, function(Input)
        if Input.KeyCode == Enum.KeyCode.Z and Typing == false then
            getgenv().Enabled = not getgenv().Enabled

            if getgenv().Enabled then
                EquipTools()
            end

            Notify("Best Kill All", tostring(getgenv().Enabled), 0.25)
        end
    end)
end

Notify("Best Kill All", "Executed", 0.5)