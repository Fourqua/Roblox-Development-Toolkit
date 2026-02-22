local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- CONFIG. Change the values to your liking.
local CONFIG = {
	WalkSpeed    = 16,  -- default movement speed
	SprintSpeed  = 28,  -- speed while sprinting
	MaxStamina   = 100, -- max stamina
	DrainRate    = 20,  -- stamina lost per second while sprinting
	RegenRate    = 10,  -- stamina regained per second while not sprinting
	RegenDelay   = 1,   -- seconds after stopping sprint before regen kicks in
}

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Stamina starts full
local stamina = CONFIG.MaxStamina
local isSprinting = false
local regenTimer = 0 

-- Uncomment if you have a UI bar to work with
-- Local staminaBar = player.PlayerGui.ScreenGui.StaminaBar.Fill

-- Updates the stamina bar on screen
local function updateStaminaUI()
	-- Uncomment if you have UI bar to work with.
	-- StaminaBar.Size = UDim2.new(stamina / CONFIG.MaxStamina, 0, 1, 0)
end

-- This runs every frame
RunService.Heartbeat:Connect(function(dt)
	-- Check if shift is being held down
	local shiftHeld = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or
		UserInputService:IsKeyDown(Enum.KeyCode.RightShift)

	-- Check if the player is actually walking somewhere
	local isMoving = humanoid.MoveDirection.Magnitude > 0

	if shiftHeld and isMoving and stamina > 0 then
		-- Player is sprinting, drain stamina and go fast
		isSprinting = true
		regenTimer = 0 -- Reset the regen delay timer
		humanoid.WalkSpeed = CONFIG.SprintSpeed
		stamina = math.max(0, stamina - CONFIG.DrainRate * dt)
	else
		-- Player is not sprinting, slow them down and regen stamina
		isSprinting = false
		humanoid.WalkSpeed = CONFIG.WalkSpeed

		if regenTimer < CONFIG.RegenDelay then
			-- Still waiting before regen starts
			regenTimer = regenTimer + dt
		else
			-- When enough time passed, start filling stamina back up
			stamina = math.min(CONFIG.MaxStamina, stamina + CONFIG.RegenRate * dt)
		end
	end

	updateStaminaUI()
end)