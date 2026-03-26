#!/usr/bin/env zsh
# Second-phase Node install (run after ~/.config is cloned). Not invoked by .fi.sh automatically unless you confirm.
set -e

NODE_VERSION=24

# Match https://fnm.vercel.app/install default install locations
if [[ -d "${HOME}/.fnm" ]]; then
  FNM_DIR="${HOME}/.fnm"
elif [[ -n "${XDG_DATA_HOME:-}" ]]; then
  FNM_DIR="${XDG_DATA_HOME}/fnm"
else
  FNM_DIR="${HOME}/.local/share/fnm"
fi

export PATH="${FNM_DIR}:${PATH}"
if ! command -v fnm &>/dev/null; then
  echo "fnm not found in PATH (${FNM_DIR}). Install fnm first (e.g. run .fi.sh Developer Tools)." >&2
  exit 1
fi

eval "$(fnm env)"
fnm install --progress never "${NODE_VERSION}"
fnm default "${NODE_VERSION}"

echo "Node $(node -v) — npm $(npm -v)"
