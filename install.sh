#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
SOURCE_DIR="${SCRIPT_DIR}/config"
TARGET_DIR="${HOME}/.config"
STATUS=0

if [ ! -d "$SOURCE_DIR" ]; then
  echo "Source config directory not found at ${SOURCE_DIR}" >&2
  exit 1
fi

mkdir -p "$TARGET_DIR"

shopt -s nullglob dotglob
for item in "$SOURCE_DIR"/*; do
  [ -e "$item" ] || continue
  name="$(basename -- "$item")"
  target="${TARGET_DIR}/${name}"

  if [ -L "$target" ]; then
    link_target="$(readlink "$target")"
    if [ "$link_target" = "$item" ]; then
      echo "Symlink already exists for ${name}"
      continue
    else
      echo "Conflicting symlink at ${target}; remove it manually" >&2
      STATUS=1
      continue
    fi
  elif [ -e "$target" ]; then
    echo "${target} already exists and is not a symlink; skipping" >&2
    STATUS=1
    continue
  fi

  ln -s "$item" "$target"
  echo "Created symlink ${target} -> ${item}"
done
shopt -u nullglob dotglob

exit $STATUS
