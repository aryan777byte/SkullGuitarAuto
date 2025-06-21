-- Games/SkullGuitar.lua
-- Auto-Farm Script for Skull Guitar enemies (Redz Hub style)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local root = player.Character:WaitForChild("HumanoidRootPart")
local enemiesFolder = workspace:WaitForChild("Enemies")
local targetEnemyName = "Reborn Skeleton" -- CHANGE THIS if needed

-- Find closest enemy with matching name
local function getNearestEnemy()
	local closestEnemy, shortestDist = nil, math.huge
	for _, enemy in pairs(enemiesFolder:GetChildren()) do
		if enemy:IsA("Model") and enemy.Name == targetEnemyName and enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") and enemy.Humanoid.Health > 0 then
			local dist = (root.Position - enemy.HumanoidRootPart.Position).Magnitude
			if dist < shortestDist then
				shortestDist = dist
				closestEnemy = enemy
			end
		end
	end
	return closestEnemy
end

-- Auto attack loop (for sword/guitar/melee/etc.)
task.spawn(function()
	while true do
		local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
		if tool then
			tool:Activate()
		end
		task.wait(0.3)
	end
end)

-- Teleport and kill enemies
while true do
	local enemy = getNearestEnemy()
	if enemy and enemy:FindFirstChild("HumanoidRootPart") then
		pcall(function()
			root.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
		end)
	end
	task.wait(0.2)
end
