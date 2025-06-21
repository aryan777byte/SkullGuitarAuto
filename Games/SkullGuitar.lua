-- Skull Guitar Auto Script with GUI, Auto TP, Quest Accept

local player = game.Players.LocalPlayer
local root = player.Character:WaitForChild("HumanoidRootPart")
local tween = game:GetService("TweenService")

-- SETTINGS
local TARGET_NPC_NAME = "Reborn Skeleton"
local QUEST_NPC = "Gravestone"
local QUEST_NAME = "Reborn Skeleton"
local TARGET_AREA = "Haunted Castle"

-- UI SETUP
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "SkullGuitarGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 150, 0, 50)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.new(1, 1, 1)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.new(0, 0, 0)

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(1, 0, 1, 0)
button.Text = "OFF"
button.TextColor3 = Color3.new(1, 1, 1)
button.BackgroundColor3 = Color3.new(1, 0, 0)

local enabled = false
button.MouseButton1Click:Connect(function()
	enabled = not enabled
	button.Text = enabled and "ON" or "OFF"
	button.BackgroundColor3 = enabled and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
end)

-- Auto teleport to Haunted Castle
pcall(function()
	if not game.Workspace.Map:FindFirstChild("Haunted Castle") then
		local portals = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Portals")
		if portals then
			for _, v in pairs(portals:GetDescendants()) do
				if v:IsA("TouchTransmitter") and v.Parent.Name == "Haunted Castle" then
					firetouchinterest(root, v.Parent, 0)
					firetouchinterest(root, v.Parent, 1)
					break
				end
			end
		end
	end
end)

-- Quest accept
local function acceptQuest()
	local args = {
		[1] = "StartQuest",
		[2] = QUEST_NPC,
		[3] = QUEST_NAME
	}
	game:GetService("ReplicatedStorage").Remotes.CommQuest:InvokeServer(unpack(args))
end

-- Get nearest enemy
local function getEnemy()
	for _, mob in pairs(workspace.Enemies:GetChildren()) do
		if mob.Name == TARGET_NPC_NAME and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
			return mob
		end
	end
end

-- Auto attack
task.spawn(function()
	while true do
		if enabled then
			local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
			if tool then tool:Activate() end
		end
		task.wait(0.3)
	end
end)

-- Main loop
while task.wait(0.2) do
	if enabled then
		acceptQuest()
		local mob = getEnemy()
		if mob then
			pcall(function()
				root.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
			end)
		end
	end
end
