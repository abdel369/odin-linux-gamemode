# Contributing

This project should stay boring, reversible, and easy to debug.

## Rules for contributions

1. No internal-storage writes in v0.1.
2. No ABL flashing in v0.1.
3. No destructive partitioning commands.
4. No copied scripts from projects with unclear licensing.
5. Every installer module must be idempotent.
6. Every game report should include an `odin-doctor` log or equivalent version data.
7. Prefer one small pull request per change.

## Commit style

Examples:

```text
doctor: add Mesa package version collection
apt-guard: block linux-dtb upgrades by default
gamescope: add nested launch wrapper
steam: add x86-through-FEX notes
compat: add Stardew Valley Armbian baseline
```

## Testing before PR

```bash
bash -n install.sh lib/*.sh modules/*.sh scripts/*
./install.sh --doctor
```

If available:

```bash
shellcheck install.sh lib/*.sh modules/*.sh scripts/*
```
