local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")

local player    = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid  = character:WaitForChild("Humanoid")
local camera    = workspace.CurrentCamera

-- CONFIG. Adjust these settings to your liking:
local CONFIG = {
	DashPower    = 80,   -- How far/fast the dash launches the player
	Cooldown     = 1,    -- Amount of econds before the player can dash again
	DashKey      = Enum.KeyCode.Q, -- Keybind for dashing
}

local onCooldown = false

local function dash()
	if onCooldown then return end
	if humanoid.Health <= 0 then return end

	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end

	onCooldown = true

	-- Use move direction if moving
	local direction = humanoid.MoveDirection
	if direction.Magnitude < 0.1 then
		direction = camera.CFrame.LookVector
	end
	direction = Vector3.new(direction.X, 0, direction.Z).Unit

	-- Apply the dash
	rootPart.AssemblyLinearVelocity = Vector3.new(
		direction.X * CONFIG.DashPower,
		rootPart.AssemblyLinearVelocity.Y, 
		direction.Z * CONFIG.DashPower
	)

	task.wait(CONFIG.Cooldown)
	onCooldown = false
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == CONFIG.DashKey then
		dash()
	end
end)

-- Reconnect on respawn
player.CharacterAdded:Connect(function(newCharacter)
	character  = newCharacter
	humanoid   = newCharacter:WaitForChild("Humanoid")
	onCooldown = false
end)