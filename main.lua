
-- UNIVERSAL CHARACTER MONITOR V3
-- LocalScript for Roblox Studio

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("GodModePanel")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "GodModePanel"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.Parent = playerGui

local function create(class, props, parent)
    local obj = Instance.new(class)
    for k,v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function corner(obj, radius)
    create("UICorner", {
        CornerRadius = UDim.new(0, radius)
    }, obj)
end

-- TOPBAR
local top = create("TextButton", {
    Size = UDim2.fromOffset(135, 40),
    Position = UDim2.fromOffset(15, 100),
    BackgroundColor3 = Color3.fromRGB(25,30,45),
    Text = "🛡 UNIVERSAL UI",
    TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.GothamBold,
    TextSize = 12
}, gui)
corner(top, 10)

-- PANEL
local panel = create("Frame", {
    Size = UDim2.fromOffset(290, 285),
    Position = UDim2.new(0.5,-145,0.5,-142),
    BackgroundColor3 = Color3.fromRGB(20,24,36),
    Visible = false,
    BorderSizePixel = 0
}, gui)
corner(panel, 14)

-- HEADER
local header = create("TextLabel", {
    Size = UDim2.new(1,-90,0,45),
    Position = UDim2.fromOffset(12,0),
    BackgroundTransparency = 1,
    Text = "UNIVERSAL CONTROL",
    TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left
}, panel)

local mini = create("TextButton", {
    Size = UDim2.fromOffset(32,30),
    Position = UDim2.new(1,-73,0,7),
    Text = "—",
    BackgroundColor3 = Color3.fromRGB(65,75,100),
    TextColor3 = Color3.new(1,1,1)
}, panel)
corner(mini,7)

local close = create("TextButton", {
    Size = UDim2.fromOffset(32,30),
    Position = UDim2.new(1,-36,0,7),
    Text = "X",
    BackgroundColor3 = Color3.fromRGB(180,50,60),
    TextColor3 = Color3.new(1,1,1)
}, panel)
corner(close,7)

local function label(text, y, height)
    return create("TextLabel", {
        Size = UDim2.new(1,-24,0,height or 36),
        Position = UDim2.fromOffset(12,y),
        BackgroundColor3 = Color3.fromRGB(34,42,60),
        Text = text,
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.GothamBold,
        TextSize = 12
    },panel)
end

local characterStatus = label("CHARACTER: CHECKING",55)
local healthStatus = label("HEALTH: CHECKING",100)
local forceStatus = label("FORCEFIELD: CHECKING",145)
local protectionStatus = label("PROTECTION: NOT VERIFIED",190)

local footer = create("TextLabel", {
    Size = UDim2.new(1,-20,0,25),
    Position = UDim2.fromOffset(10,245),
    BackgroundTransparency = 1,
    Text = "UNIVERSAL MONITOR V3",
    TextColor3 = Color3.fromRGB(145,155,175),
    Font = Enum.Font.Gotham,
    TextSize = 10
},panel)

-- OPEN / CLOSE
top.Activated:Connect(function()
    panel.Visible = not panel.Visible
end)

close.Activated:Connect(function()
    panel.Visible = false
end)

-- MINIMIZE
local minimized = false

mini.Activated:Connect(function()
    minimized = not minimized

    characterStatus.Visible = not minimized
    healthStatus.Visible = not minimized
    forceStatus.Visible = not minimized
    protectionStatus.Visible = not minimized
    footer.Visible = not minimized

    panel.Size = minimized
        and UDim2.fromOffset(290,45)
        or UDim2.fromOffset(290,285)

    mini.Text = minimized and "+" or "—"
end)

-- CHARACTER MONITOR
local function monitorCharacter(character)
    characterStatus.Text = "CHARACTER: FOUND"

    local humanoid = character:WaitForChild("Humanoid",10)

    if not humanoid then
        characterStatus.Text = "CHARACTER: HUMANOID MISSING"
        return
    end

    local function update()
        if not character.Parent then return end

        characterStatus.Text = "CHARACTER: ACTIVE"

        healthStatus.Text = string.format(
            "HEALTH: %.0f / %.0f",
            humanoid.Health,
            humanoid.MaxHealth
        )

        local force = character:FindFirstChildOfClass("ForceField")

        forceStatus.Text = force
            and "FORCEFIELD: DETECTED"
            or "FORCEFIELD: NOT DETECTED"

        protectionStatus.Text =
            "PROTECTION: NOT VERIFIED"
    end

    update()

    humanoid.HealthChanged:Connect(update)

    character.ChildAdded:Connect(function(child)
        if child:IsA("ForceField") then
            update()
        end
    end)

    character.ChildRemoved:Connect(function(child)
        if child:IsA("ForceField") then
            update()
        end
    end)
end

player.CharacterAdded:Connect(monitorCharacter)

if player.Character then
    task.spawn(monitorCharacter,player.Character)
else
    characterStatus.Text = "CHARACTER: WAITING"
end

-- DRAG PANEL
local dragging = false
local dragStart
local startPosition

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = panel.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart

        panel.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

print("[Universal Monitor] Loaded")
