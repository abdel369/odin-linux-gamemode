# odin-linux-gamemode

Experimental SD-first setup layer for running a flexible Linux gaming environment on AYN Odin 2 / Odin 2 Portal class SM8550 handhelds.

This is not SteamOS, ROCKNIX, Batocera, or an internal installer. The goal is to turn a normal Armbian install into a reproducible handheld gaming lab with diagnostics, guarded updates, FEX helpers, Gamescope helpers, Steam launch wrappers, and compatibility logging.

## Current v0.1 scope

- SD-card-first only.
- No partition resizing.
- No ABL flashing.
- No internal install.
- No kernel patching.
- No power-management promises.
- Make Armbian experiments reproducible and debuggable.

## Target devices

Test target:

- AYN Odin 2 / Odin 2 Pro / Odin 2 Max
- AYN Odin 2 Portal

Broader target later:

- Related SM8550 / Snapdragon 8 Gen 2 Android handhelds with working mainline Linux support.

## Why this exists

Armbian gives flexibility, but handheld Linux updates and gaming stacks are fragile. ROCKNIX and Batocera are excellent appliance-style systems, but they are intentionally less flexible than a normal Linux distro. This project aims to sit between those worlds.

## First-run flow

Clone the repo on a fresh Armbian install:

```bash
git clone https://github.com/abdel369/odin-linux-gamemode.git
cd odin-linux-gamemode
./install.sh --doctor
./install.sh --apt-guard
./install.sh --base
```

Optional modules:

```bash
./install.sh --fex
./install.sh --gamescope
./install.sh --sessions
```

Run the safer upgrade wrapper instead of plain `apt upgrade`:

```bash
odin-safe-upgrade
```

## Important safety rule

Do not run random internal-install, ABL, `dd`, `parted`, or `sgdisk` experiments from this repository. Internal install support belongs in a separate, later, explicitly dangerous branch after recovery is documented and tested.

## Project status

Early scaffold. Expect rough edges. Contributions should focus on logs, reproducibility, and small verified improvements.
