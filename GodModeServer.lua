
-- GOD MODE GLOBAL SERVER
-- Place in ServerScriptService

local Players = game:GetService("Players")

local function activateGodMode(player, character)
    local humanoid = character:WaitForChild("Humanoid")

    player:SetAttribute("GodMode", true)
    character:SetAttribute("GodMode", true)

    -- ForceField protection
    local forceField = character:FindFirstChild("GodModeForceField")

    if not forceField then
        forceField = Instance.new("ForceField")
        forceField.Name = "GodModeForceField"
        forceField.Visible = false
        forceField.Parent = character
    end

    -- Preserve normal MaxHealth
    local restoring = false

    humanoid.HealthChanged:Connect(function(health)
        if restoring or not character.Parent then
            return
        end

        if health < humanoid.MaxHealth then
            restoring = true
            humanoid.Health = humanoid.MaxHealth
            restoring = false
        end
    end)

    -- Initial full health
    humanoid.Health = humanoid.MaxHealth

    print("[GodMode] Activated for:", player.Name)
end

local function setupPlayer(player)
    player:SetAttribute("GodMode", true)

    player.CharacterAdded:Connect(function(character)
        activateGodMode(player, character)
    end)

    if player.Character then
        task.spawn(activateGodMode, player, player.Character)
    end
end

Players.PlayerAdded:Connect(setupPlayer)

for _, player in ipairs(Players:GetPlayers()) do
    setupPlayer(player)
end

print("[GodMode] Global server protection loaded")
