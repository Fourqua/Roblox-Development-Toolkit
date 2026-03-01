# Roblox Development Toolkit

> The Roblox Development Toolkit is free scripting documentation repo for passionate roblox _developers_.

---

## Structure - **Ex**

```
roblox-development-toolkit/
│
├── README.md
|
│── BanKickManager/
│   ├── README.md
│   |── BanKickManager.lua
|   └── BanKickClient.lua
|
├── ChatTags/
│   ├── README.md
│   └── ChatTags.lua
│
├── DayNightCycle/
│   ├── README.md
│   └── DayNightCycle.lua
|
├── FallDamageManager/
│   ├── README.md
│   └── FallDamageManager.lua
|
│── HealthBar/
│   ├── README.md
│   └── HealthBar.lua
|
|── ItemGiver/
│   ├── README.md
│   └── ItemGiver.lua
|
│── PlayerDataStore/
│   ├── README.md
│   └── PlayerDataStore.lua
|
│── PlayerLeaderstatsManager/
│   ├── README.md
│   └── PlayerLeaderstatsManager.lua
|
|── ProceduralWorldGen/
│   ├── README.md
│   └── ProceduralWorldGen.lua
|
|── RenderDistanceManager/
│   ├── README.md
│   └── RenderDistanceManager.lua
|
│── StaminaManager/
│   ├── README.md
│   └── StaminaManager.lua
|
└── ...more modules will be added overtime
```

- Every folder is self-contained. You do not need to understand the full toolkit to use one module.
- Some folders may contain multiple **files** and/or **folders**
- More systems are added regularly. Check back or watch the repo for updates.

---

## How to Use

1. Browse the folders and find the system you need.
2. Read its `README.md` — each one covers setup, the full API, and examples.
3. Copy the `.lua` file into the correct Roblox Studio service (specified in each README).
4. Adapt the code to fit your game.

---

## Contributing

Contributions are insisted. Heres how to add a new module or improve an existing one:

1. Fork this repository
2. Create a new folder named in `PascalCase`
3. Add your `.lua` file
4. Add a `README.md` file inside the folder using the format below
5. Create a pull request with a short description of what the script does

Please make sure your code is clean and your documentation is complete before submitting your pr.

### Module README Format

Each module's `README.md` should follow this structure:

```
# Module Name

---

## Overview
What this module does and when to use it.

## Setup
Where to place the script and any configuration required.

## Examples
At least one working code example.

## Troubleshooting
At least one fix to a certain problem.

## Notes
Edge cases, limitations, or anything else worth knowing.
```

---

*Open to contributions*
