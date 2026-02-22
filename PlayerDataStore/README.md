# DataStore

Player data system using on Roblox's `DataStoreService`. Loads on join, saves on leave, and on a server shutdown.

---

## Setup

1. Enable **Studio Access to API Services** in `Game Settings`
2. Place `DataStore.lua` in `ServerScriptService` as a `script`
3. Edit `DEFAULT_DATA` at the top to match your game
4. Require it in any server script:

```lua
local DataStore = require(game.ServerScriptService.DataStore)
```

---

## How It Works

When a player joins, `loadData` fires and calls `GetAsync` to fetch their saved data from Roblox's servers. That data gets stored in a local `cache` table (just a Lua table in memory) keyed by `UserId`. Every `Get`, `Set`, and `Increment` call reads and writes to that cache — not the DataStore directly. This keeps things fast and avoids hitting Roblox's rate limits on every change.

When the player leaves, `saveData` fires and calls `SetAsync` to push the cache back to Roblox. `BindToClose` does the same for all players when the server shuts down.

The `DEFAULT_DATA` table acts as a template. When a new player joins, they get a fresh copy of it. If they've already joined and are a returning player, their saved values are layered on top, meaning any new keys you add in the future will automatically appear for existing players too.

---

## Usage

```lua
-- Read a value
local coins = DataStore.Get(player, "Coins")
print(coins) -- 0 for new players

-- Set a value directly
DataStore.Set(player, "Level", 5)

-- Add to a number (Defaults to +1)
DataStore.Increment(player, "Coins", 50)
DataStore.Increment(player, "XP")

-- Force save immediately
DataStore.Save(player)
```

---

## Adding New Data Keys

Just add a new key to `DEFAULT_DATA` at the top of the script:

```lua
local DEFAULT_DATA = {
	Coins    = 0,
	Level    = 1,
	XP       = 0,
	Gems     = 0,       -- added
	Crowns     = 0,       -- added
	Settings = {        -- tables work aswell
		Music = true,
		Sounds   = true,
	},
}
```

Existing players will automatically receive the new keys with their default values on their next load, since saved data is merged into `DEFAULT_DATA` rather than replacing it.

---

## Troubleshooting

**Data isn't saving in Studio**
Make sure **Enable Studio Access to API Services** is turned on in `Game Settings → Security`. Without it, all DataStore calls silently fail.

**Player data loads as all defaults every time**
The DataStore name may have changed, or the `GetAsync` call is failing silently. Check the output for any `[DataStore] Failed` warnings.

**A new key I added isn't showing up for existing players**
Make sure the key exists in `DEFAULT_DATA`. The merge loop only fills in keys that are defined there — if it's missing from defaults, it won't be added to returning players' data.

**`Increment` isn't working**
The key you're incrementing must be a number in `DEFAULT_DATA`. Calling `Increment` on a string or table key will silently do nothing.

---

## Notes

- Change `"PlayerData_v1"` to `"PlayerData_v2"` to wipe all data on a new release
- `Set` and `Increment` do not auto-save — call `Save()` after anything important