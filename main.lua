
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "GodModePanel"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

local top = Instance.new("TextButton")
top.Size = UDim2.fromOffset(125, 38)
top.Position = UDim2.fromOffset(10, 100)
top.Text = "🛡 GOD MODE"
top.Parent = gui

local panel = Instance.new("Frame")
panel.Size = UDim2.fromOffset(260, 160)
panel.Position = UDim2.new(0.5, -130, 0.5, -80)
panel.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
panel.Visible = false
panel.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "GOD MODE CONTROL"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(45,45,65)
title.Parent = panel

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(35,35)
close.Position = UDim2.new(1,-35,0,0)
close.Text = "X"
close.Parent = panel

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1,0,0,40)
status.Position = UDim2.fromOffset(0,55)
status.BackgroundTransparency = 1
status.Text = "GOD MODE: SERVER ACTIVE"
status.TextColor3 = Color3.fromRGB(80,255,120)
status.Parent = panel

local info = Instance.new("TextLabel")
info.Size = UDim2.new(1,-20,0,45)
info.Position = UDim2.fromOffset(10,100)
info.BackgroundTransparency = 1
info.Text = "Protection enabled for all players"
info.TextColor3 = Color3.new(1,1,1)
info.Parent = panel

top.MouseButton1Click:Connect(function()
    panel.Visible = not panel.Visible
end)

close.MouseButton1Click:Connect(function()
    panel.Visible = false
end)
