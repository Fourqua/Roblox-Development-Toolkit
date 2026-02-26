local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local banStore = DataStoreService:GetDataStore("BanList_v1")

-- Add authorized UserIds here
local AUTHORIZED = {
	8599316688, -- replace with your UserId
}

-- RemoteEvents (create these in ReplicatedStorage)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommandEvent  = ReplicatedStorage:WaitForChild("CommandEvent")
local ResponseEvent = ReplicatedStorage:WaitForChild("ResponseEvent")

-- Check if a player is authorized
local function isAuthorized(player)
	for _, id in ipairs(AUTHORIZED) do
		if id == player.UserId then return true end
	end
	return false
end

-- Find a player in the server by name 
local function findPlayer(name)
	local lower = name:lower()
	for _, player in ipairs(Players:GetPlayers()) do
		if player.Name:lower():find(lower, 1, true) then
			return player
		end
	end
	return nil
end

-- Check if a player is banned on join
local function checkBan(player)
	local success, data = pcall(function()
		return banStore:GetAsync(tostring(player.UserId))
	end)

	if not success or not data then return end

	-- Check if ban has expired
	if data.Expiry and os.time() >= data.Expiry then
		pcall(function() banStore:RemoveAsync(tostring(player.UserId)) end)
		return
	end

	-- Still banned - kick them
	local timeLeft = data.Expiry
		and "Expires: " .. os.date("%Y-%m-%d %H:%M", data.Expiry)
		or "Permanent"

	player:Kick(string.format(
		"\nYou are banned.\nReason: %s\n%s",
		data.Reason or "No reason given",
		timeLeft
	))
end

-- /kick <user> <message>
local function kickPlayer(sender, args)
	local targetName = args[1]
	local reason = table.concat(args, " ", 2) or "No reason given"

	if not targetName then
		ResponseEvent:FireClient(sender, "Usage: /kick <user> <reason>")
		return
	end

	local target = findPlayer(targetName)
	if not target then
		ResponseEvent:FireClient(sender, "Player not found: " .. targetName)
		return
	end

	if target == sender then
		ResponseEvent:FireClient(sender, "You cannot kick yourself.")
		return
	end

	target:Kick("\n👟 You were kicked.\nReason: " .. reason)
	ResponseEvent:FireClient(sender, "Kicked " .. target.Name .. " — " .. reason)
end

-- /ban <user> <time> <message>
-- Time format: 1d, 2h, 30m, "perm" 
local function banPlayer(sender, args)
	local targetName = args[1]
	local timeArg    = args[2]
	local reason     = table.concat(args, " ", 3) or "No reason given"

	if not targetName or not timeArg then
		ResponseEvent:FireClient(sender, "Usage: /ban <user> <time> <reason>  |  Time: 1d / 2h / 30m / perm")
		return
	end

	local target = findPlayer(targetName)
	if not target then
		ResponseEvent:FireClient(sender, "Player not found: " .. targetName)
		return
	end

	if target == sender then
		ResponseEvent:FireClient(sender, "You cannot ban yourself.")
		return
	end

	-- Parse duration
	local expiry = nil
	if timeArg:lower() ~= "perm" then
		local amount, unit = timeArg:match("^(%d+)([dhm])$")
		if not amount then
			ResponseEvent:FireClient(sender, "Invalid time format. Use: 1d / 2h / 30m / perm")
			return
		end
		local seconds = tonumber(amount) * ({ d = 86400, h = 3600, m = 60 })[unit]
		expiry = os.time() + seconds
	end

	-- Save ban to the datastore
	local banData = { Reason = reason, Expiry = expiry, BannedBy = sender.Name }
	local success, err = pcall(function()
		banStore:SetAsync(tostring(target.UserId), banData)
	end)

	if not success then
		ResponseEvent:FireClient(sender, "Failed to save ban: " .. tostring(err))
		return
	end

	-- Kick them
	local expiryText = expiry and os.date("%Y-%m-%d %H:%M", expiry) or "Permanent"
	target:Kick(string.format(
		"\nYou have been banned.\nReason: %s\nExpires: %s",
		reason, expiryText
	))

	ResponseEvent:FireClient(sender, "Banned " .. target.Name .. " — " .. reason .. " (" .. expiryText .. ")")
end

-- /unban <userId>
local function unbanPlayer(sender, args)
	local userId = args[1]
	if not userId then
		ResponseEvent:FireClient(sender, "Usage: /unban <userId>")
		return
	end

	local success, err = pcall(function()
		banStore:RemoveAsync(userId)
	end)

	if success then
		ResponseEvent:FireClient(sender, "Unbanned UserId: " .. userId)
	else
		ResponseEvent:FireClient(sender, "Failed to unban: " .. tostring(err))
	end
end

-- Listen for commands fired from the client
CommandEvent.OnServerEvent:Connect(function(sender, command, args)
	if not isAuthorized(sender) then
		ResponseEvent:FireClient(sender, "You are not authorized to use this command.")
		return
	end

	if command == "kick" then
		kickPlayer(sender, args)
	elseif command == "ban" then
		banPlayer(sender, args)
	elseif command == "unban" then
		unbanPlayer(sender, args)
	end
end)

Players.PlayerAdded:Connect(checkBan)