local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- CONFIG table. Change the values to your liking
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

local stamina = CONFIG.MaxStamina
local isSprinting = false
local regenTimer = 0

-- hook up a UI bar if you have one
-- local staminaBar = player.PlayerGui.ScreenGui.StaminaBar.Fill

local function updateStaminaUI()
	-- staminaBar.Size = UDim2.new(stamina / CONFIG.MaxStamina, 0, 1, 0)
end

RunService.Heartbeat:Connect(function(dt)
	local shiftHeld = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or
		UserInputService:IsKeyDown(Enum.KeyCode.RightShift)

	local isMoving = humanoid.MoveDirection.Magnitude > 0

	if shiftHeld and isMoving and stamina > 0 then
		isSprinting = true
		regenTimer = 0
		humanoid.WalkSpeed = CONFIG.SprintSpeed
		stamina = math.max(0, stamina - CONFIG.DrainRate * dt)
	else
		isSprinting = false
		humanoid.WalkSpeed = CONFIG.WalkSpeed

		if regenTimer < CONFIG.RegenDelay then
			regenTimer = regenTimer + dt
		else
			stamina = math.min(CONFIG.MaxStamina, stamina + CONFIG.RegenRate * dt)
		end
	end

	updateStaminaUI()
end)