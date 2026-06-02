# Testing checklist

Run this before and after major changes:

```bash
./install.sh --doctor
vulkaninfo --summary
glxinfo -B
id
ls -lah /dev/dri
```

If FEX is installed:

```bash
FEX --version
FEXBash -c 'uname -m'
```

If Gamescope is installed:

```bash
gamescope -- vkcube
```

When reporting a game:

- Device model
- Armbian image/date
- Kernel
- Mesa version
- FEX version
- Steam mode
- Runtime/Proton version
- Gamescope on/off
- Result
- Logs
