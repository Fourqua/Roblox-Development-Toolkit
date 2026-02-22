local Players = game:GetService("Players")

-- Config. Change these values to your liking
local CONFIG = {
	MaxFallDistance = 100, -- Velocity at which the player dies instantly
	MinFallDistance = 40,  -- Minimum velocity before any damage is dealt
}

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid")
		local rootPart = character:WaitForChild("HumanoidRootPart")

		humanoid.StateChanged:Connect(function(_, newState)
			-- Flip velocity to a positive number (makes it easy to work with)
			local velocity = rootPart.Velocity.Y * -1

			if newState == Enum.HumanoidStateType.Landed then
				if velocity > CONFIG.MaxFallDistance then
					-- Instantly kills the player if velocity is over the max
					humanoid.Health = 0
				elseif velocity > CONFIG.MinFallDistance then
					-- Deals partial damage if somewhere in between
					humanoid.Health -= velocity / 4
				end
			end
		end)
	end)
end)