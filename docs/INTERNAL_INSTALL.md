# Internal install status

v0.1 intentionally does not support internal installation.

Internal installation on Android handhelds is not just copying files to faster storage. It usually involves device-specific bootloader behavior, partition layout assumptions, Android userdata resizing, recovery planning, and a way back to stock Android.

For this project, internal install requires a separate design document and test plan before code exists.

## Requirements before any internal-install branch

- Confirmed stock ABL backup/restore flow.
- Confirmed fastboot/recovery access.
- Confirmed partition map before/after.
- Confirmed Android restore path.
- Confirmed Linux restore path.
- At least two testers with sacrificial devices.
- No copy-pasted scripts from other projects unless license-compatible and credited.

## v0.1 rule

No `dd`, `sgdisk`, `parted`, `resize2fs`, `e2fsck`, `mkfs`, or bootloader flashing in installer modules.
