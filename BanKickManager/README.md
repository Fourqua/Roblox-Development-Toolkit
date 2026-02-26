# BanKickManager

Chat based ban and kick system. Authorized players can type `/ban`, `/kick`, or `/unban` in chat to moderate others.

---

## Overview

There are two scripts: a server script that handles all the logic. A client script that listens for commands typed in chat. Commands are detected client side and fired to the server with a `RemoteEvent`. The server validates the sender is authorized before doing anything.

---

## Setup

1. In the `ReplicatedStorage`, create two `RemoteEvent` objects named:
   - `CommandEvent`
   - `ResponseEvent`

2. Place `BanKickServer.lua` in `ServerScriptService` as a `Script`.

3. Place `BanKickClient.lua` in `StarterPlayerScripts` as a `LocalScript`.

4. Add authorized UserIds to the `AUTHORIZED` table in the server script:

```lua
local AUTHORIZED = {
	8599316688, -- your UserId
}
```

---

## Commands

| Command | Usage | Example |
|---|---|---|
| Kick | `/kick <user> <reason>` | `/kick Fourqua griefing` |
| Ban | `/ban <user> <time> <reason>` | `/ban Fourqua 1d cheating` |
| Unban | `/unban <userId>` | `/unban 8599316688` |

**Time formats for the `/ban` command:**
- `30m` — 30 minutes
- `2h` — 2 hours
- `7d` — 7 days
- `perm` — permanent

---

## Examples

```
/kick Fourqua Being rude in chat
/ban Fourqua 7d Exploiting
/ban Fourqua perm Repeated offenses
/unban 8599316688
```

---

## Troubleshooting

**Commands aren't doing anything** - 
Make sure two `RemoteEvent` objects exist in `ReplicatedStorage` exactly named `CommandEvent` and `ResponseEvent`.

**"You are not authorized" message** - 
Your UserId isn't in the `AUTHORIZED` table in the `BanKickServerlua`. Make sure to add it there.

**Banned player can still join** - 
Make sure `BanKickServer.lua` is a `Script` in `ServerScriptService`. The ban check on join only runs server side.

**Unban requires UserId not username** - 
Use their UserId directly with `/unban`.

---

## Notes

- Authorization is checked server side meaning clients cannot fake commands.
- Change `"BanList_v1"` to `"BanList_v2"` to wipe all bans.
- `/unban` takes a UserId, not a username.