
local Players = game:GetService("Players")

local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")

    humanoid:SetAttribute("GodMode", true)

    local ff = Instance.new("ForceField")
    ff.Visible = false
    ff.Parent = character

    task.spawn(function()
        while character.Parent and humanoid.Health > 0 do
            humanoid.Health = humanoid.MaxHealth
            task.wait(0.2)
        end
    end)
end

local function setupPlayer(player)
    player.CharacterAdded:Connect(setupCharacter)

    if player.Character then
        setupCharacter(player.Character)
    end
end

Players.PlayerAdded:Connect(setupPlayer)

for _, player in ipairs(Players:GetPlayers()) do
    setupPlayer(player)
end
