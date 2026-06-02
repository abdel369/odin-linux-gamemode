#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=lib/common.sh
source "$REPO_DIR/lib/common.sh"

copy_executable "$(repo_path scripts/odin-gamemode)" "/usr/local/bin/odin-gamemode"
copy_executable "$(repo_path scripts/odin-steam-desktop)" "/usr/local/bin/odin-steam-desktop"
copy_file "$(repo_path sessions/odin-gamemode.desktop)" "/usr/share/wayland-sessions/odin-gamemode.desktop"

log "Installed Odin Game Mode Wayland session. Select it from your display manager/login screen."
