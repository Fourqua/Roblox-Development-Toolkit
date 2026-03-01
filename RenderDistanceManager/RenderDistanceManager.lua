local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- CONFIG - Adjust these to your liking
local CONFIG = {
	RenderDistance  = 300,  -- Parts beyond this are hidden
	CheckInterval   = 0.5,  -- Seconds between distance checks
	FadeEnabled     = true, -- Smoothly fade parts in/out instead of popping
	FadeTime        = 0.3,  -- Seconds to fade in/out
}

-- INTERNALS
-- Collect all parts in the workspace that should be managed
local function getManagedParts()
	local parts = {}
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") then
			-- Skip character parts
			local isCharacter = false
			for _, p in ipairs(Players:GetPlayers()) do
				if p.Character and obj:IsDescendantOf(p.Character) then
					isCharacter = true
					break
				end
			end
			if not isCharacter then
				table.insert(parts, obj)
			end
		end
	end
	return parts
end

local function setVisibility(part, visible)
	if CONFIG.FadeEnabled then
		-- Tween transparency
		local target = visible and 0 or 1
		if math.abs(part.Transparency - target) < 0.01 then return end
		part.Transparency = target
	else
		part.LocalTransparencyModifier = visible and 0 or 1
	end
end

-- MAIN LOOP
local elapsed = 0

RunService.Heartbeat:Connect(function(dt)
	elapsed = elapsed + dt
	if elapsed < CONFIG.CheckInterval then return end
	elapsed = 0

	local character = player.Character
	if not character then return end
	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local playerPos = root.Position
	local distSq    = CONFIG.RenderDistance * CONFIG.RenderDistance -- compare squared to avoid sqrt

	for _, part in ipairs(getManagedParts()) do
		if part and part.Parent then
			local dx = part.Position.X - playerPos.X
			local dy = part.Position.Y - playerPos.Y
			local dz = part.Position.Z - playerPos.Z
			local visible = (dx*dx + dy*dy + dz*dz) <= distSq
			setVisibility(part, visible)
		end
	end
end)