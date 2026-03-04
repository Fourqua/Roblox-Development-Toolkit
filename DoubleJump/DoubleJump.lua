local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")

local player    = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid  = character:WaitForChild("Humanoid")

-- CONFIG. Adjust these settings to your ;olomg
local CONFIG = {
	DoubleJumpPower = 50,  -- Upward velocity applied on second jump
}

local canDoubleJump = false
local hasDoubleJumped = false

-- Reset the jump when the player landed
humanoid.StateChanged:Connect(function(_, newState)
	if newState == Enum.HumanoidStateType.Landed or
	   newState == Enum.HumanoidStateType.Running then
		canDoubleJump    = false
		hasDoubleJumped  = false
	end

	-- Allow double jump once the player is in "freefall mode" 
	if newState == Enum.HumanoidStateType.Freefall then
		canDoubleJump = true
	end
end)

-- Listen for the jump input
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode ~= Enum.KeyCode.Space then return end

	if canDoubleJump and not hasDoubleJumped then
		hasDoubleJumped = true
		canDoubleJump   = false

		-- Apply upward force for the second jump
		local rootPart = character:FindFirstChild("HumanoidRootPart")
		if rootPart then
			rootPart.AssemblyLinearVelocity = Vector3.new(
				rootPart.AssemblyLinearVelocity.X,
				CONFIG.DoubleJumpPower,
				rootPart.AssemblyLinearVelocity.Z
			)
		end
	end
end)

-- Reconnect on player respawn
player.CharacterAdded:Connect(function(newCharacter)
	character      = newCharacter
	humanoid       = newCharacter:WaitForChild("Humanoid")
	canDoubleJump  = false
	hasDoubleJumped = false

	humanoid.StateChanged:Connect(function(_, newState)
		if newState == Enum.HumanoidStateType.Landed or
		   newState == Enum.HumanoidStateType.Running then
			canDoubleJump   = false
			hasDoubleJumped = false
		end
		if newState == Enum.HumanoidStateType.Freefall then
			canDoubleJump = true
		end
	end)
end)