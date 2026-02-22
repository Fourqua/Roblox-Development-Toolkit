local Players = game:GetService("Players")

local CONFIG = {
	MinHeight    = 15,   -- Studs fallen before damage kicks in
	DamagePerStud = 2,   -- Damage applied per stud fallen above MinHeight
	MaxDamage    = 100,  -- Cap so a single fall can't exceed this damage
}

local function onCharacterAdded(character)
	local humanoid = character:WaitForChild("Humanoid")
	local rootPart = character:WaitForChild("HumanoidRootPart")

	local peakY = rootPart.Position.Y
	local isFalling = false

	rootPart:GetPropertyChangedSignal("Position"):Connect(function()
		local currentY = rootPart.Position.Y

		if currentY > peakY then
			peakY = currentY
		end

		local verticalVelocity = rootPart.AssemblyLinearVelocity.Y

		if verticalVelocity < -1 then
			isFalling = true
		end

		if isFalling and humanoid.FloorMaterial ~= Enum.Material.Air then
			local fallen = peakY - currentY

			if fallen > CONFIG.MinHeight then
				local damage = (fallen - CONFIG.MinHeight) * CONFIG.DamagePerStud
				damage = math.min(damage, CONFIG.MaxDamage)
				humanoid:TakeDamage(damage)
			end

			isFalling = false
			peakY = currentY
		end
	end)

	humanoid.StateChanged:Connect(function(_, newState)
		if newState == Enum.HumanoidStateType.Jumping or
		   newState == Enum.HumanoidStateType.Freefall then
			peakY = rootPart.Position.Y
		end
	end)
end

local function onPlayerAdded(player)
	player.CharacterAdded:Connect(onCharacterAdded)
end

Players.PlayerAdded:Connect(onPlayerAdded)

for _, player in ipairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end