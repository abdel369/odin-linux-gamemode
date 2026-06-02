# Steam modes

This project tracks Steam paths separately because "native Linux" can mean different things on ARM.

## Mode A: Steam x86 through FEX

The Steam client and Linux x86_64 game binaries run through FEX. This can be surprisingly useful for older Linux games.

## Mode B: Steam ARM64 client

The Steam client itself runs as ARM64, while x86/Windows games rely on FEX/Proton or future ARM64-native builds. This is the future-facing path, but may be more brittle outside official appliance images.

## Mode C: No Steam, pure launchers

Use Heroic, Lutris-like wrappers, native ports, emulators, Moonlight, or direct binaries.

## Reporting rule

Do not just write "native Linux works." Write one of:

- Linux ARM64 native
- Linux x86_64 via FEX
- Windows x86_64 via Proton + FEX
- Android via separate wrapper
