-- services
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

-- CONFIG: Change these to your liking.
local CONFIG = {
	DayLength = 240, -- length of a full day/night cycle in seconds
	StartTime = 8,   -- hour the server starts at (0-24 hours)
}

-- A full day is 24 hours. 1440 minutes
local SECONDS_IN_DAY = 24 * 60

-- Convert the starting hour into minutes. All tracking will be done in minutes
local timeOfDay = CONFIG.StartTime * 60

-- Run every frame on the server allowing all players to see the same time.
RunService.Heartbeat:Connect(function(dt)

	-- Advance time based on how much real time passed scaled to day length
	timeOfDay = timeOfDay + (SECONDS_IN_DAY / CONFIG.DayLength) * dt

	-- Loop back to midnight once we pass the end of the day
	if timeOfDay >= SECONDS_IN_DAY then
		timeOfDay = timeOfDay - SECONDS_IN_DAY
	end

	-- Split total minutes into hours and leftover minutes for clock
	local hours = math.floor(timeOfDay / 60)
	local minutes = math.floor(timeOfDay % 60)

	-- Push the new time to lighting
	Lighting:SetMinutesAfterMidnight(hours * 60 + minutes)
end)