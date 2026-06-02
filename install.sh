#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$REPO_DIR/lib/common.sh"

usage() {
  cat <<'USAGE'
odin-linux-gamemode installer

Usage:
  ./install.sh --doctor
  ./install.sh --base
  ./install.sh --apt-guard
  ./install.sh --fex
  ./install.sh --gamescope
  ./install.sh --sessions
  ./install.sh --disable-touch
  ./install.sh --all-safe

Safe default order:
  ./install.sh --doctor --apt-guard --base --sessions

Notes:
  --all-safe does not install to internal storage, does not flash ABL,
  and does not modify partitions.
USAGE
}

if [[ $# -eq 0 ]]; then
  usage
  exit 0
fi

for arg in "$@"; do
  case "$arg" in
    --doctor)
      run_module "00-doctor.sh"
      ;;
    --base)
      run_module "10-base-packages.sh"
      ;;
    --apt-guard)
      run_module "20-apt-guard.sh"
      ;;
    --fex)
      run_module "30-fex.sh"
      ;;
    --gamescope)
      run_module "40-gamescope.sh"
      ;;
    --steam)
      run_module "50-steam.sh"
      ;;
    --sessions)
      run_module "60-sessions.sh"
      ;;
    --disable-touch)
      run_module "70-disable-touch.sh"
      ;;
    --all-safe)
      run_module "00-doctor.sh"
      run_module "20-apt-guard.sh"
      run_module "10-base-packages.sh"
      run_module "60-sessions.sh"
      ;;
    -h|--help)
      usage
      ;;
    *)
      die "Unknown option: $arg"
      ;;
  esac
done
