#!/usr/bin/env bash
set -euo pipefail

makepkg -C

REPO_DIR="$(cd "$(dirname "$0")" && pwd)/repo/any"
REPO_NAME="zkl-repo"

cd "$REPO_DIR"

rm -f "${REPO_NAME}.db.tar.gz" "${REPO_NAME}.files.tar.gz"

cp -f ../../*.pkg.tar.zst .

# keep only the newest version of each package name
# (prevents repo-add weirdness and saves space)
ls *.pkg.tar.zst | awk -F'-[0-9]' '{print $1}' | sort -u | while read -r pkg; do
  # keep latest by version-sort
  keep="$(ls -1 "${pkg}"-*.pkg.tar.zst | sort -V | tail -n1)"
  ls -1 "${pkg}"-*.pkg.tar.zst | grep -vFx "$keep" | xargs -r rm -f
done

# Rebuild repo DB from scratch (most reliable)
repo-add -n -R "${REPO_NAME}.db.tar.gz" ./*.pkg.tar.zst

# Move all packages under "all-packages" folder
cd ../..
ALL_PACKAGES_FOLDER="all-packages"
if [ ! -d "$ALL_PACKAGES_FOLDER" ]; then
    echo "[INFO] '$ALL_PACKAGES_FOLDER' does not exist. Creating new one."
    mkdir -p "$ALL_PACKAGES_FOLDER"
fi
mv ./*.pkg.tar.zst $ALL_PACKAGES_FOLDER

