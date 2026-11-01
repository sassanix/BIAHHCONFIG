#!/usr/bin/env bash
# HD texture pack helper for Linux (Steam Proton).
# Prepares the game for a TFC Installer texture pack:
#   1. Verifies the game folder and the extracted mod folder.
#   2. Sets the Large Address Aware flag on the game .exe (native, no Wine).
#   3. Applies the HD streaming override (PoolSize=2048) inside the Proton
#      prefix, where the game keeps its SumacEngine.ini.
#   4. Launches TFC Installer inside the same Proton prefix with Wine, so
#      you can finish with the same three steps as on Windows.
#
# Usage:
#   ./install-textures.sh \
#     --game-path "$HOME/.steam/steam/steamapps/common/Brothers in Arms Hells Highway" \
#     --mod-folder "$HOME/Downloads/BIAHH-HD-World" \
#     --tfc-installer "$HOME/Downloads/TFCInstaller.exe"
#
# Steam app id for Hell's Highway is 15390. If your library lives elsewhere,
# pass --compat-path to point at the 15390 compatdata folder directly.

set -euo pipefail

APP_ID=15390
GAME_PATH="" MOD_FOLDER="" TFC_INSTALLER="" COMPAT_PATH=""

while [ $# -gt 0 ]; do
  case "$1" in
    --game-path) GAME_PATH="$2"; shift 2 ;;
    --mod-folder) MOD_FOLDER="$2"; shift 2 ;;
    --tfc-installer) TFC_INSTALLER="$2"; shift 2 ;;
    --compat-path) COMPAT_PATH="$2"; shift 2 ;;
    *) echo "Unknown argument: $1" >&2; exit 2 ;;
  esac
done

[ -n "$GAME_PATH" ] && [ -n "$MOD_FOLDER" ] || {
  echo "Required: --game-path and --mod-folder (see header of this script)" >&2; exit 2; }
[ -d "$GAME_PATH/Binaries" ] || { echo "Binaries folder not found under $GAME_PATH" >&2; exit 1; }
[ -f "$MOD_FOLDER/GameProfile.xml" ] || {
  echo "GameProfile.xml not found in $MOD_FOLDER." >&2
  echo "Extract the pack archive first and point --mod-folder at the extracted folder." >&2; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"

# Largest .exe in Binaries is the game executable
EXE="$(find "$GAME_PATH/Binaries" -maxdepth 1 -iname '*.exe' -printf '%s %p\n' | sort -rn | head -1 | cut -d' ' -f2-)"
[ -n "$EXE" ] || { echo "No .exe found in Binaries" >&2; exit 1; }
echo "Game executable: $EXE"

cp -a "$EXE" "$EXE.backup-$STAMP"
echo "Backed up exe to $EXE.backup-$STAMP"
python3 "$SCRIPT_DIR/patch-laa.py" "$EXE"

# Find the Proton prefix and the game's real config inside it
if [ -z "$COMPAT_PATH" ]; then
  LIBRARY_ROOT="$(dirname "$(dirname "$GAME_PATH")")"   # .../steamapps
  COMPAT_PATH="$LIBRARY_ROOT/compatdata/$APP_ID"
fi
SUMAC_INI="$(find "$COMPAT_PATH/pfx" -name 'SumacEngine.ini' 2>/dev/null | head -1 || true)"
if [ -n "${SUMAC_INI:-}" ]; then
  cp -a "$SUMAC_INI" "$SUMAC_INI.backup-$STAMP"
  if grep -q '^PoolSize=' "$SUMAC_INI"; then
    sed -i 's/^PoolSize=.*/PoolSize=2048/' "$SUMAC_INI"
  elif grep -q '^\[TextureStreaming\]' "$SUMAC_INI"; then
    sed -i 's/^\[TextureStreaming\]/[TextureStreaming]\nPoolSize=2048/' "$SUMAC_INI"
  else
    printf '\n[TextureStreaming]\nPoolSize=2048\n' >> "$SUMAC_INI"
  fi
  echo "Set PoolSize=2048 in $SUMAC_INI (backup saved)."
else
  echo "SumacEngine.ini not found in the Proton prefix yet."
  echo "Run the game once through Steam, quit, then re-run this script."
fi

if [ -n "$TFC_INSTALLER" ]; then
  echo "Launching TFC Installer inside the game prefix."
  echo "In it: 1) game folder = the Z: path of $GAME_PATH"
  echo "       2) mod folder  = the Z: path of $MOD_FOLDER"
  echo "       3) click Update All."
  echo "Note: the installer needs the .NET 6 Windows runtime in the prefix."
  echo "If it fails to start, install it with: protontricks $APP_ID dotnetdesktop6"
  WINEPREFIX="$COMPAT_PATH/pfx" wine "$TFC_INSTALLER" || \
    echo "Wine could not start the installer. See textures/README.md, Linux section, option B."
else
  echo "No --tfc-installer given. Preparation is done; install the pack with"
  echo "TFC Installer as described in textures/README.md."
fi
