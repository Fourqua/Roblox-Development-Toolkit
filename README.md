# Roblox Developer Toolkit

> The Roblox Developer Toolkit is free scripting documentation repo for passionate roblox _developers_.

---

## Structure - **Ex**

```
roblox-dev-toolkit/
│
├── README.md
│
├── DataStore/
│   ├── README.md
│   └── DataStore.lua
│
├── PlayerManager/
│   ├── README.md
│   └── PlayerManager.lua
│
├── CombatSystem/
│   ├── README.md
│   └── CombatSystem.lua
│
└── ...more modules added over time
```

Every folder is self-contained. You do not need to understand the full toolkit to use one module.

---

## Modules

| Module | Description |
|---|---|
| `DataStore` | Wrapper for Roblox DataStoreService with auto-retry and session locking |
| `PlayerManager` | Handles player join/leave lifecycle, data loading, and cleanup |
| `CombatSystem` | Modular melee and ranged combat framework with hitbox and damage handling |

More systems are added regularly. Check back or watch the repo for updates.

---

## How to Use

1. Browse the folders and find the system you need.
2. Read its `README.md` — each one covers setup, the full API, and examples.
3. Copy the `.luau` file into the correct Roblox Studio service (specified in each README).
4. Adapt the code to fit your game.

---

## Contributing

Contributions are insisted. Heres how to add a new module or improve an existing one:

1. Fork the repository
2. Create a new folder named in `PascalCase`
3. Add your `.luau` source file
4. Add a `README.md` file inside the folder using the format below
5. Create a pull request with a short description of what the module does

Please make sure your code is clean and your documentation is complete before submitting.

### Module README Format

Each module's `README.md` should follow this structure:

```
# Module Name

---

## Overview
What this module does and when to use it.

## Setup
Where to place the script and any configuration required.

## API Reference
All public functions with parameters and return values.

## Examples
At least one working code example.

## Notes
Edge cases, limitations, or anything else worth knowing.
```

---

*Open to contributions*
