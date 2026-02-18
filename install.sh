#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
STATUS=0

install_dir() {
  local source_dir="$1"
  local target_dir="$2"

  if [ ! -d "$source_dir" ]; then
    echo "Source directory not found at ${source_dir}" >&2
    STATUS=1
    return
  fi

  mkdir -p "$target_dir"

  shopt -s nullglob dotglob
  for item in "$source_dir"/*; do
    [ -e "$item" ] || continue
    local name
    name="$(basename -- "$item")"
    local target="${target_dir}/${name}"

    if [ -L "$target" ]; then
      local link_target
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
}

install_dir "${SCRIPT_DIR}/config" "${HOME}/.config"
install_dir "${SCRIPT_DIR}/.agent" "${HOME}/.agent"

exit $STATUS
