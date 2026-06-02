#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=lib/common.sh
source "$REPO_DIR/lib/common.sh"

require_debian_like

if have_cmd gamescope; then
  log "gamescope already installed: $(gamescope --version 2>/dev/null || true)"
  exit 0
fi

sudo_cmd apt-get update
if apt-cache show gamescope >/dev/null 2>&1; then
  install_available_packages gamescope
  exit 0
fi

warn "gamescope package not found in apt repositories."
warn "Set ODIN_BUILD_GAMESCOPE=1 to build Gamescope from source."

if [[ "${ODIN_BUILD_GAMESCOPE:-0}" != "1" ]]; then
  exit 0
fi

install_available_packages \
  git build-essential meson ninja-build cmake pkg-config python3-mako \
  libwayland-dev wayland-protocols libxkbcommon-dev libdrm-dev libgbm-dev \
  libvulkan-dev libcap-dev libsdl2-dev libpipewire-0.3-dev libinput-dev \
  libseat-dev libsystemd-dev

WORKDIR="${ODIN_BUILD_DIR:-$HOME/src}"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

if [[ ! -d gamescope ]]; then
  git clone https://github.com/ValveSoftware/gamescope.git
fi
cd gamescope
git pull --ff-only || true
git submodule update --init --recursive
meson setup build --prefix=/usr --buildtype=release --wipe
ninja -C build
sudo_cmd ninja -C build install

log "Gamescope build/install complete. Test with: gamescope -- vkcube"
