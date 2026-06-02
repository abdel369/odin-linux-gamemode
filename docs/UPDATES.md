# Updates and apt safety

On ARM handheld community images, the kernel, DTB, bootloader, firmware, modules, and root filesystem are often tightly coupled. A normal `apt upgrade` can update part of that stack without the rest of the boot path matching.

Use:

```bash
odin-safe-upgrade
```

The guard installed by `./install.sh --apt-guard` does three things:

1. Holds currently installed boot/kernel-sensitive packages with `apt-mark hold`.
2. Adds conservative apt pinning for new kernel/DTB/U-Boot/BSP packages.
3. Installs a wrapper that simulates the upgrade and aborts if protected packages would change.

For intentional kernel testing, clone your SD card first, remove the pin file, unhold packages, and expect breakage.

```bash
sudo rm /etc/apt/preferences.d/99-odin-linux-gamemode-protect-kernel
sudo apt-mark unhold $(apt-mark showhold | grep -E '^(linux-image|linux-dtb|linux-headers|linux-u-boot|armbian-bsp|armbian-firmware)' || true)
```
