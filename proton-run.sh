#!/usr/bin/env bash
set -euo pipefail

PATH_TO_BIN="${1:?Usage: proton-run <path_to_exe>}"

if [ -e /usr/share/steam/compatibilitytools.d/proton-cachyos/proton ]; then
    echo "Proton executable exists"
else
    echo "Proton executable does not exist"
    exit 1;
fi

echo "Execute for path: $PATH_TO_BIN"

COMPAT_ROOT="/var/lib/proton-prefix/default"    # compatdata root
PFX_DIR="$COMPAT_ROOT/pfx"                      # actual wine prefix lives here

# Create compatdata structure Proton expects
if [ ! -d "$PFX_DIR" ]; then
    echo "$PFX_DIR does not exist. Creating new."
    mkdir -p "$PFX_DIR"
fi

export STEAM_COMPAT_DATA_PATH="$COMPAT_ROOT"
export STEAM_COMPAT_CLIENT_INSTALL_PATH="${STEAM_COMPAT_CLIENT_INSTALL_PATH:-$HOME/.local/share/Steam}"

# isolate wine "user" home away from your real ~
export HOME="$COMPAT_ROOT/home"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
if [ -e "$HOME" ]; then
    echo "Isolated home exists: $HOME"
else
    echo "Create isolated home dir: $HOME"
    mkdir -p "$HOME"
fi

PROTON="/usr/share/steam/compatibilitytools.d/proton-cachyos/proton"

echo "cmd: $PROTON run $PATH_TO_BIN"

exec "$PROTON" run "$PATH_TO_BIN"

