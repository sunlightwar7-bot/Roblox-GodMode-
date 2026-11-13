
--[[
    ROBLOX GODMODE CONTROL V2
    Client UI for your own Roblox game
    Place as LocalScript in StarterPlayerScripts
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remove old UI
local old = playerGui:FindFirstChild("GodModePanel")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "GodModePanel"
gui.ResetOnSpawn = false
gui.DisplayOrder = 100
gui.Parent = playerGui

local function make(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function round(obj, radius)
    make("UICorner", {
        CornerRadius = UDim.new(0, radius)
    }, obj)
end

local function stroke(obj)
    make("UIStroke", {
        Color = Color3.fromRGB(65, 75, 100),
        Thickness = 1
    }, obj)
end

-- TOPBAR
local top = make("TextButton", {
    Name = "TopbarButton",
    Size = UDim2.fromOffset(125, 38),
    Position = UDim2.new(0, 12, 0, 90),
    BackgroundColor3 = Color3.fromRGB(25, 30, 45),
    Text = "🛡 GOD MODE",
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = true
}, gui)

round(top, 10)
stroke(top)

-- MAIN PANEL
local panel = make("Frame", {
    Name = "MainPanel",
    Size = UDim2.fromOffset(290, 300),
    Position = UDim2.new(0.5, -145, 0.5, -150),
    BackgroundColor3 = Color3.fromRGB(19, 23, 34),
    BorderSizePixel = 0,
    Visible = false
}, gui)

round(panel, 14)
stroke(panel)

-- HEADER
local header = make("Frame", {
    Size = UDim2.new(1, 0, 0, 48),
    BackgroundColor3 = Color3.fromRGB(31, 39, 57),
    BorderSizePixel = 0
}, panel)

round(header, 14)

local title = make("TextLabel", {
    Size = UDim2.new(1, -100, 1, 0),
    Position = UDim2.fromOffset(12, 0),
    BackgroundTransparency = 1,
    Text = "GOD MODE CONTROL",
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, header)

local minimize = make("TextButton", {
    Size = UDim2.fromOffset(32, 30),
    Position = UDim2.new(1, -73, 0, 9),
    BackgroundColor3 = Color3.fromRGB(65, 75, 100),
    Text = "—",
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 18,
    Font = Enum.Font.GothamBold
}, header)

round(minimize, 7)

local close = make("TextButton", {
    Size = UDim2.fromOffset(32, 30),
    Position = UDim2.new(1, -36, 0, 9),
    BackgroundColor3 = Color3.fromRGB(180, 55, 65),
    Text = "X",
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 13,
    Font = Enum.Font.GothamBold
}, header)

round(close, 7)

-- STATUS
local status = make("TextLabel", {
    Size = UDim2.new(1, -24, 0, 35),
    Position = UDim2.fromOffset(12, 58),
    BackgroundColor3 = Color3.fromRGB(30, 75, 55),
    Text = "● SERVER STATUS: CHECKING",
    TextColor3 = Color3.fromRGB(110, 255, 160),
    TextSize = 11,
    Font = Enum.Font.GothamBold
}, panel)

round(status, 8)

-- BUTTON CREATOR
local function createButton(name, y, color)
    local btn = make("TextButton", {
        Size = UDim2.new(1, -24, 0, 42),
        Position = UDim2.fromOffset(12, y),
        BackgroundColor3 = color,
        Text = name,
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = true
    }, panel)

    round(btn, 8)
    return btn
end

local godButton = createButton(
    "🛡 GOD MODE: SERVER CONTROLLED", 105,
    Color3.fromRGB(35, 105, 75)
)

local healButton = createButton(
    "❤️ AUTO HEAL: SERVER CONTROLLED", 155,
    Color3.fromRGB(45, 75, 125)
)

local burstButton = createButton(
    "⚡ BURST DAMAGE: NPC SERVER CONTROL", 205,
    Color3.fromRGB(125, 75, 35)
)

local footer = make("TextLabel", {
    Size = UDim2.new(1, -24, 0, 28),
    Position = UDim2.fromOffset(12, 260),
    BackgroundTransparency = 1,
    Text = "GODMODE CONTROL V2 | PRIVATE GAME",
    TextColor3 = Color3.fromRGB(145, 150, 170),
    TextSize = 9,
    Font = Enum.Font.Gotham
}, panel)

-- OPEN / CLOSE
top.Activated:Connect(function()
    panel.Visible = not panel.Visible
end)

close.Activated:Connect(function()
    panel.Visible = false
end)

-- MINIMIZE / EXPAND
local minimized = false

minimize.Activated:Connect(function()
    minimized = not minimized

    TweenService:Create(panel, TweenInfo.new(0.2), {
        Size = minimized
            and UDim2.fromOffset(290, 48)
            or UDim2.fromOffset(290, 300)
    }):Play()

    minimize.Text = minimized and "+" or "—"

    status.Visible = not minimized
    godButton.Visible = not minimized
    healButton.Visible = not minimized
    burstButton.Visible = not minimized
    footer.Visible = not minimized
end)

-- DRAG PANEL
local dragging = false
local dragStart
local startPos

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = panel.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then

        local delta = input.Position - dragStart

        panel.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- SERVER STATUS
local function updateStatus()
    local active = player:GetAttribute("GodMode")

    if active == true then
        status.Text = "● GOD MODE: ACTIVE"
        status.TextColor3 = Color3.fromRGB(110, 255, 160)
    elseif active == false then
        status.Text = "● GOD MODE: INACTIVE"
        status.TextColor3 = Color3.fromRGB(255, 120, 120)
    else
        status.Text = "● WAITING FOR SERVER"
        status.TextColor3 = Color3.fromRGB(255, 210, 100)
    end
end

player:GetAttributeChangedSignal("GodMode"):Connect(updateStatus)
updateStatus()

print("GodMode Control V2 Loaded")
