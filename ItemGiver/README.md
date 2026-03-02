# ItemGiver

Give tools from `ServerStorage` to any player's backpack using a chat command. Only authorized players can use it.

---

## Overview

Authorized players type `/give <player> <item>` in chat. The client script detects the command and fires it to the server. The server validates the sender, finds the target player, clones the tool from `ServerStorage`, and drops it into their `Backpack`. Feedback is sent back as a system message visible only to the sender.

---

## Setup

1. In `ReplicatedStorage`, create two `RemoteEvent` objects named exactly:
   - `GiveCommandEvent`
   - `GiveResponseEvent`

2. Place `ItemGiver_Server.lua` in `ServerScriptService` as a `Script`

3. Place `ItemGiver_Client.lua` in `StarterPlayerScripts` as a `LocalScript`

4. Add your UserId to `AUTHORIZED` in the server script:

```lua
local AUTHORIZED = {
	123456789,
}
```

5. Place your tools directly inside `ServerStorage` — the item name in the command must match the tool's name exactly (case-insensitive)

---

## Usage

```
/give PlayerName Sword
/give PlayerName Fireball
/give Fourqua Knife
```

---

## Troubleshooting

**"Item not found in ServerStorage"** - 
Make sure the tool is a direct child of `ServerStorage`, not inside a folder.

**"Player not found"** - 
The script does a partial name match. Make sure you are spelling enough of the name to identify them.

**Command fires but nothing happens** - 
Check that both `RemoteEvent` objects exist in `ReplicatedStorage` named `GiveCommandEvent` and `GiveResponseEvent`.

**Unauthorized message even though it's me** - 
Double check your UserId in the `AUTHORIZED` table. `roblox.com/users/USERNAME/profile`.

---

## Notes

- Tools are cloned from `ServerStorage`. Can be changed to something like the `ReplicatedStorage`.
- Authorization is checked on the server so that clients cannot fake the command.
- Item name matching is case insensitive so `/give Fourqua sword` and `/give Fourqua Sword` both work.