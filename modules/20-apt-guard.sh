#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=lib/common.sh
source "$REPO_DIR/lib/common.sh"

require_debian_like

PROTECTED_REGEX='^(linux-image|linux-dtb|linux-headers|linux-u-boot|armbian-bsp|armbian-firmware)'
mapfile -t protected < <(dpkg-query -W -f='${binary:Package}\n' 2>/dev/null | grep -E "$PROTECTED_REGEX" || true)

if [[ ${#protected[@]} -gt 0 ]]; then
  log "Holding boot/kernel-sensitive packages: ${protected[*]}"
  sudo_cmd apt-mark hold "${protected[@]}"
else
  warn "No boot/kernel-sensitive packages found to hold."
fi

copy_executable "$(repo_path scripts/odin-safe-upgrade)" "/usr/local/bin/odin-safe-upgrade"

sudo_cmd install -Dm644 /dev/stdin /etc/apt/preferences.d/99-odin-linux-gamemode-protect-kernel <<'PIN'
# odin-linux-gamemode: prevent accidental installation of new boot/kernel packages.
# Remove this file only when intentionally testing a new Armbian kernel/DTB/boot stack.
Package: linux-image-* linux-dtb-* linux-headers-* linux-u-boot-* armbian-bsp-*
Pin: release *
Pin-Priority: -1
PIN

log "Installed odin-safe-upgrade and conservative apt pinning."
warn "Use odin-safe-upgrade for routine userland updates. Do not use plain apt upgrade until you know your recovery path."
