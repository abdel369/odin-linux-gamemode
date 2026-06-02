#!/usr/bin/env bash

log()  { printf '\033[1;32m[odin]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[odin:warn]\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31m[odin:error]\033[0m %s\n' "$*" >&2; exit 1; }

have_cmd() { command -v "$1" >/dev/null 2>&1; }

require_debian_like() {
  [[ -r /etc/os-release ]] || die "/etc/os-release not found"
  # shellcheck source=/dev/null
  source /etc/os-release
  case "${ID:-}" in
    debian|ubuntu|armbian) return 0 ;;
  esac
  case "${ID_LIKE:-}" in
    *debian*|*ubuntu*) return 0 ;;
  esac
  die "This installer currently expects Debian/Ubuntu/Armbian-style apt systems. Detected ID=${ID:-unknown}."
}

sudo_cmd() {
  if [[ ${EUID:-$(id -u)} -eq 0 ]]; then
    "$@"
  else
    sudo "$@"
  fi
}

repo_path() {
  printf '%s/%s\n' "$REPO_DIR" "$1"
}

run_module() {
  local mod="$1"
  local path
  path="$(repo_path "modules/$mod")"
  [[ -x "$path" ]] || die "Module not executable or missing: $path"
  log "Running module: $mod"
  "$path"
}

copy_executable() {
  local src="$1"
  local dst="$2"
  [[ -f "$src" ]] || die "Missing source file: $src"
  sudo_cmd install -Dm755 "$src" "$dst"
}

copy_file() {
  local src="$1"
  local dst="$2"
  [[ -f "$src" ]] || die "Missing source file: $src"
  sudo_cmd install -Dm644 "$src" "$dst"
}

install_available_packages() {
  require_debian_like
  local available=()
  local missing=()
  for pkg in "$@"; do
    if apt-cache show "$pkg" >/dev/null 2>&1; then
      available+=("$pkg")
    else
      missing+=("$pkg")
    fi
  done
  if [[ ${#missing[@]} -gt 0 ]]; then
    warn "Skipping unavailable packages: ${missing[*]}"
  fi
  if [[ ${#available[@]} -gt 0 ]]; then
    sudo_cmd apt-get install --no-install-recommends -y "${available[@]}"
  else
    warn "No requested packages were available."
  fi
}
