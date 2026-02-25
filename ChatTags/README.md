# ChatTags

Displays colored role tags in chat for Owners, Admins, and Mods. Tags appear before the player's name whenever they send a message.

---

## Overview

Uses Roblox's `TextChatService` and `OnIncomingMessage` to prepend a colored tag to matching players' chat messages. Runs on the client since `OnIncomingMessage` is client-side only. Role checks are done by `UserId` so tags can't be faked by username changes.

---

## Setup

1. Place `ChatTags.lua` in `StarterPlayerScripts` as a `LocalScript`
2. Add player UserIds to the correct role in the `ROLES` table:

```lua
local ROLES = {
	Owners = { 123456789 },  -- your UserId here
	Admins = { 987654321 },
	Mods   = { 111222333, 444555666 },
}
```

To find a UserId, go to `roblox.com/users/USERNAME/profile` — the number in the URL is the UserId.

---

## Examples

```lua
-- Multiple admins
Admins = { 111111111, 222222222, 333333333 },

-- Custom tag text and color
Owner = { Text = "[👑 Owner]", Color = Color3.fromRGB(255, 215, 0)   },
Mod   = { Text = "[🛡 Mod]",   Color = Color3.fromRGB(100, 180, 255) },
```

---

## Troubleshooting

**Tags aren't showing**
Make sure the script is a `LocalScript` inside `StarterPlayerScripts`. It will not work as a regular `Script`.

**Error about OnIncomingMessage being client only**
You placed it in `ServerScriptService` — move it to `StarterPlayerScripts`.

**Tag shows for the wrong player**
Double check the UserId. You can verify it by printing `player.UserId` in the output when that player joins.

---

## Notes

- Since this runs client-side, the `ROLES` table is visible to exploiters — tags are visual only and should not be used for permission checks. Do permission logic server-side separately
- A player can only have one tag — Owner is checked first, then Admin, then Mod
- Emoji in tag text is supported on most platforms