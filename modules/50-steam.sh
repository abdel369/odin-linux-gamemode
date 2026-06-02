#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../lib/common.sh
source "$REPO_DIR/lib/common.sh"

mkdir -p "$HOME/.steam/root/compatibilitytools.d" "$HOME/Games/Steam"

copy_executable "$(repo_path scripts/odin-steam-desktop)" "/usr/local/bin/odin-steam-desktop"
copy_executable "$(repo_path scripts/odin-gamemode)" "/usr/local/bin/odin-gamemode"

if have_cmd steam; then
  log "Steam command found. Wrappers installed."
else
  warn "Steam command not found."
  warn "v0.1 installs wrappers and directories only; Steam install automation needs device-tested contribution."
fi
