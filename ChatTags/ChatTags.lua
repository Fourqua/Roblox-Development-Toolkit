-- LOCAL SCRIPT!
-- Doesn't use Legacy Chat because Roblox got rid of it
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")

-- roblox.com/users/USERNAME/profile
local ROLES = {
	Owners = {
		8599316688, -- replace with your UserId (this is mine for an example)
	},
	Admins = {
		-- UserIds here
	},
	Mods = {
		-- UserIds here
	}, -- Can add more ranks if you want
}

-- Tag appearance per role
-- Change or add to your liking.
local TAG_CONFIG = {
	Owner = { Text = "[Owner]", Color = Color3.fromRGB(255, 50,  50)  },
	Admin = { Text = "[Admin]", Color = Color3.fromRGB(255, 165, 0)   },
	Mod   = { Text = "[Mod]",   Color = Color3.fromRGB(50,  200, 100) },
}

-- Returns the role name for a given user
local function getRole(userId)
	for _, id in ipairs(ROLES.Owners) do
		if id == userId then return "Owner" end
	end
	for _, id in ipairs(ROLES.Admins) do
		if id == userId then return "Admin" end
	end
	for _, id in ipairs(ROLES.Mods) do
		if id == userId then return "Mod" end
	end -- Make sure for every new rank you add this exact line.
	return nil
end

-- Convert a Color3 to a hex string for rich text
local function toHex(color)
	return string.format("%02x%02x%02x",
		math.round(color.R * 255),
		math.round(color.G * 255),
		math.round(color.B * 255)
	)
end

-- Apply tag by formatting the chat message prefix using OnIncomingMessage function
TextChatService.OnIncomingMessage = function(message)
	local properties = Instance.new("TextChatMessageProperties")

	-- Get the player who sent the message
	local textSource = message.TextSource
	if not textSource then return properties end

	local player = Players:GetPlayerByUserId(textSource.UserId)
	if not player then return properties end

	local role = getRole(player.UserId)
	if not role then return properties end

	local config = TAG_CONFIG[role]
	local hex = toHex(config.Color)

	-- Prepend the colored tag to the players chat message prefix
	properties.PrefixText = string.format(
		'<font color="#%s"><b>%s</b></font> %s',
		hex, config.Text, message.PrefixText
	)

	return properties
end

-- :)