#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=lib/common.sh
source "$REPO_DIR/lib/common.sh"

if ! have_cmd libinput; then
  warn "libinput command missing. Install base packages first."
  exit 1
fi

echo "Detected libinput devices:"
libinput list-devices || true
cat <<'MSG'

Enter the exact touchscreen device name to ignore.
Leave blank to cancel.
MSG
read -r -p "Touchscreen name: " TOUCH_NAME

if [[ -z "$TOUCH_NAME" ]]; then
  warn "Cancelled."
  exit 0
fi

RULE_FILE="/etc/udev/rules.d/99-odin-disable-touch.rules"
sudo_cmd tee "$RULE_FILE" >/dev/null <<EOF_RULE
# Created by odin-linux-gamemode
ACTION=="add|change", SUBSYSTEM=="input", ATTRS{name}=="$TOUCH_NAME", ENV{LIBINPUT_IGNORE_DEVICE}="1"
EOF_RULE

sudo_cmd udevadm control --reload-rules
sudo_cmd udevadm trigger
log "Installed touchscreen ignore rule: $RULE_FILE"
warn "Reboot or re-login if the touchscreen is still active."
