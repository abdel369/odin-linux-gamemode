#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../lib/common.sh
source "$REPO_DIR/lib/common.sh"

require_debian_like
# shellcheck source=/dev/null
source /etc/os-release

if have_cmd FEX && have_cmd FEXBash; then
  log "FEX already installed."
  FEX --version || true
else
  warn "FEX is not installed."
  warn "This module intentionally does not force-install FEX on every distro yet."
  warn "Set ODIN_INSTALL_FEX_OFFICIAL=1 to try the upstream Ubuntu installer."

  if [[ "${ODIN_INSTALL_FEX_OFFICIAL:-0}" == "1" ]]; then
    if [[ "${ID:-}" != "ubuntu" && "${ID_LIKE:-}" != *ubuntu* ]]; then
      die "Upstream FEX auto-install path is currently limited here to Ubuntu-like images."
    fi
    tmp="$(mktemp -d)"
    trap 'rm -rf "$tmp"' EXIT
    log "Downloading upstream FEX installer..."
    curl -fsSL https://raw.githubusercontent.com/FEX-Emu/FEX/main/Scripts/InstallFEX.py -o "$tmp/InstallFEX.py"
    python3 "$tmp/InstallFEX.py"
  else
    exit 0
  fi
fi

if have_cmd FEXBash; then
  log "Testing FEX uname..."
  FEXBash -c 'uname -m' || true
fi

if have_cmd FEXRootFSFetcher; then
  if [[ ! -d "$HOME/.fex-emu/RootFS" ]]; then
    warn "No FEX rootfs found at ~/.fex-emu/RootFS. Run FEXRootFSFetcher interactively."
  fi
fi
