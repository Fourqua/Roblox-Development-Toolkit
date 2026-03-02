
local Players          = game:GetService("Players")
local ServerStorage    = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AUTHORIZED = {
	123828372, -- replace with your UserId
}

-- RemoteEvents
local GiveCommandEvent  = ReplicatedStorage:WaitForChild("GiveCommandEvent")
local GiveResponseEvent = ReplicatedStorage:WaitForChild("GiveResponseEvent")

local function isAuthorized(player)
	for _, id in ipairs(AUTHORIZED) do
		if id == player.UserId then return true end
	end
	return false
end

-- case insensitive partial player name search
local function findPlayer(name)
	local lower = name:lower()
	for _, p in ipairs(Players:GetPlayers()) do
		if p.Name:lower():find(lower, 1, true) then
			return p
		end
	end
	return nil
end

-- Find a tool in ServerStorage by name
local function findItem(name)
	local lower = name:lower()
	for _, obj in ipairs(ServerStorage:GetChildren()) do
		if obj:IsA("Tool") and obj.Name:lower() == lower then
			return obj
		end
	end
	return nil
end

GiveCommandEvent.OnServerEvent:Connect(function(sender, targetName, itemName)
	if not isAuthorized(sender) then
		GiveResponseEvent:FireClient(sender, "You are not authorized to use /give.")
		return
	end

	if not targetName or not itemName then
		GiveResponseEvent:FireClient(sender, "Usage: /give <player> <item>")
		return
	end

	local target = findPlayer(targetName)
	if not target then
		GiveResponseEvent:FireClient(sender, "Player not found: " .. targetName)
		return
	end

	local item = findItem(itemName)
	if not item then
		GiveResponseEvent:FireClient(sender, "Item not found in ServerStorage: " .. itemName)
		return
	end

	-- Clone the tool into the player's backpack
	local clone = item:Clone()
	clone.Parent = target.Backpack

	GiveResponseEvent:FireClient(sender, "Gave " .. item.Name .. " to " .. target.Name)
end)