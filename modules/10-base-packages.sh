#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=lib/common.sh
source "$REPO_DIR/lib/common.sh"

require_debian_like
sudo_cmd apt-get update

PACKAGES=(
  ca-certificates curl wget git jq unzip p7zip-full
  build-essential cmake meson ninja-build pkg-config python3 python3-pip
  vulkan-tools mesa-utils libdrm-tests
  libgl1-mesa-dri mesa-vulkan-drivers libdrm2 libgbm1
  sway cage xwayland wayland-protocols seatd dbus-user-session
  pipewire wireplumber pipewire-pulse
  mangohud gamemode
  evtest joystick jstest-gtk libinput-tools
  htop btop foot tmux
)

install_available_packages "${PACKAGES[@]}"

if id -nG "$USER" | grep -Eq '(^| )(video|render|input)( |$)'; then
  log "User already belongs to at least one device-access group."
fi

for group in video render input; do
  if getent group "$group" >/dev/null 2>&1; then
    sudo_cmd usermod -aG "$group" "$USER"
  fi
done

warn "Log out and back in after group changes before testing Vulkan/input access."
