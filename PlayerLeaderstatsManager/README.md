# PlayerLeaderstatsManager

Creates and manages player leaderstats with complete datastore.

---

## Overview

When a player joins, the script loads their saved stats from the DataStore and creates a `leaderstats` folder under their `Player` object. Roblox picks this up and displays it on Roblox's built in leaderboard. Any change to a leaderstat is synced back to the cache instantly, and saved to the DataStore on leave or server shutdown.

---

## Setup

1. Enable **Studio Access to API Services** under the `Security` tab in `Game Settings`
2. Place `PlayerLeaderstatsManager.lua` in `ServerScriptService` as a `Module Script`
3. Edit the `STATS` table at the top to define your leaderboard stats:

```lua
local STATS = {
	Coins  = 0,
	Kills  = 0,
	Deaths = 0,
}
```

---

## Examples

```lua
local LeaderstatsManager = require(game.ServerScriptService.PlayerLeaderstatsManager)

-- Add a kill
LeaderstatsManager.Increment(player, "Kills")

-- Add coins
LeaderstatsManager.Increment(player, "Coins", 50)

-- Read a stat
local coins = LeaderstatsManager.Get(player, "Coins")
print(coins)

-- Set directly
LeaderstatsManager.Set(player, "Deaths", 0)

-- Force save
LeaderstatsManager.Save(player)
```

---

## Troubleshooting

**Leaderstats aren't showing on the leaderboard** - 
Make sure the folder is named exactly `leaderstats`. Roblox is case sensitive about this.

**Stats aren't saving between sessions** - 
Enable **Studio Access to API Services** in `Game Settings → Security`.

**A new stat I added isn't showing for existing players** - 
Add it to the `STATS` table with a default value. The merge logic will fill it in for returning players automatically on their next join.

**Stats reset to 0 every time** - 
The DataStore name may have changed. Make sure `"LeaderstatsData_v1"` hasn't been edited unintentionally.

---

## Notes

- The stats update on the leaderboard when using `Set` or `Increment`
- Change `"LeaderstatsData_v1"` to `"LeaderstatsData_v2"` to wipe all stat data and create a new set.
- Only `IntValue` is used. stats must be whole numbers (Integers)
- Saves automatically on player leave and server shutdown
- System can be integrated with UI, sounds, etc.