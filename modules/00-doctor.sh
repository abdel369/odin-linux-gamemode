#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="${HOME}/odin-linux-gamemode-logs"
mkdir -p "$LOG_DIR"
OUT="$LOG_DIR/doctor-$(date +%Y%m%d-%H%M%S).log"

{
  echo "=== Odin Linux GameMode Doctor ==="
  date
  echo

  echo "=== OS ==="
  cat /etc/os-release 2>/dev/null || true
  echo

  echo "=== Kernel ==="
  uname -a || true
  echo

  echo "=== Page size ==="
  getconf PAGESIZE 2>/dev/null || true
  echo

  echo "=== CPU ==="
  lscpu 2>/dev/null || true
  echo

  echo "=== Memory ==="
  free -h 2>/dev/null || true
  echo

  echo "=== Block devices ==="
  lsblk -o NAME,SIZE,TYPE,FSTYPE,LABEL,PARTLABEL,MOUNTPOINTS 2>/dev/null || true
  echo

  echo "=== Mounts ==="
  findmnt 2>/dev/null || true
  echo

  echo "=== DRM devices ==="
  ls -lah /dev/dri 2>/dev/null || true
  echo

  echo "=== User groups ==="
  id || true
  echo

  echo "=== Protected package candidates ==="
  dpkg-query -W -f='${binary:Package}\t${Version}\n' 2>/dev/null | grep -E '^(linux-image|linux-dtb|linux-headers|linux-u-boot|armbian-bsp|armbian-firmware)' || true
  echo

  echo "=== Held packages ==="
  apt-mark showhold 2>/dev/null || true
  echo

  echo "=== Mesa / Vulkan / DRM packages ==="
  dpkg-query -W -f='${binary:Package}\t${Version}\n' 2>/dev/null | grep -Ei 'mesa|vulkan|libdrm|gbm|freedreno|turnip' || true
  echo

  echo "=== Vulkan summary ==="
  if command -v vulkaninfo >/dev/null 2>&1; then
    vulkaninfo --summary || true
  else
    echo "vulkaninfo not installed"
  fi
  echo

  echo "=== OpenGL renderer ==="
  if command -v glxinfo >/dev/null 2>&1; then
    glxinfo -B || true
  else
    echo "glxinfo not installed"
  fi
  echo

  echo "=== FEX ==="
  if command -v FEX >/dev/null 2>&1; then
    FEX --version || true
  else
    echo "FEX not installed"
  fi
  if command -v FEXBash >/dev/null 2>&1; then
    FEXBash -c 'echo "FEX uname: $(uname -m)"' || true
  fi
  echo

  echo "=== Gamescope ==="
  if command -v gamescope >/dev/null 2>&1; then
    gamescope --version || true
  else
    echo "gamescope not installed"
  fi
  echo

  echo "=== Steam paths ==="
  find "$HOME/.steam" "$HOME/.local/share/Steam" -maxdepth 4 -type d 2>/dev/null | head -200 || true
  echo

  echo "=== Input devices ==="
  ls -lah /dev/input 2>/dev/null || true
  if command -v libinput >/dev/null 2>&1; then
    libinput list-devices || true
  fi
  echo

  echo "=== Recent relevant journal lines ==="
  journalctl -b --no-pager 2>/dev/null | grep -Ei 'adreno|freedreno|turnip|vulkan|drm|msm|gpu|firmware|gamescope|fex|steam|input|suspend|sleep' | tail -400 || true
} | tee "$OUT"

echo
echo "Saved doctor log to: $OUT"
