
local npc = script.Parent
local humanoid = npc:WaitForChild("Humanoid")

local DAMAGE = 25
local COOLDOWN = 2
local RANGE = 12

local Players = game:GetService("Players")

while humanoid.Health > 0 do
    task.wait(COOLDOWN)

    local root = npc:FindFirstChild("HumanoidRootPart")
    if not root then continue end

    for _, player in ipairs(Players:GetPlayers()) do
        local character = player.Character
        local targetHumanoid = character
            and character:FindFirstChildOfClass("Humanoid")
        local targetRoot = character
            and character:FindFirstChild("HumanoidRootPart")

        if targetHumanoid and targetRoot
            and targetHumanoid.Health > 0
            and (targetRoot.Position - root.Position).Magnitude <= RANGE then

            targetHumanoid:TakeDamage(DAMAGE)
        end
    end
end
