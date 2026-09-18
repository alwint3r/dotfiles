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

install_file() {
  local source_file="$1"
  local target="$2"

  if [ ! -f "$source_file" ]; then
    echo "Source file not found at ${source_file}" >&2
    STATUS=1
    return
  fi

  mkdir -p "$(dirname -- "$target")"

  if [ -L "$target" ]; then
    local link_target
    link_target="$(readlink "$target")"
    if [ "$link_target" = "$source_file" ]; then
      echo "Symlink already exists for $(basename -- "$target")"
      return
    else
      echo "Conflicting symlink at ${target}; remove it manually" >&2
      STATUS=1
      return
    fi
  elif [ -e "$target" ]; then
    echo "${target} already exists and is not a symlink; skipping" >&2
    STATUS=1
    return
  fi

  ln -s "$source_file" "$target"
  echo "Created symlink ${target} -> ${source_file}"
}

install_dir "${SCRIPT_DIR}/config" "${HOME}/.config"
install_dir "${SCRIPT_DIR}/.agents" "${HOME}/.agents"
install_file "${SCRIPT_DIR}/pi/agent/AGENTS.md" "${HOME}/.pi/agent/AGENTS.md"
install_dir "${SCRIPT_DIR}/pi/agent/extensions" "${HOME}/.pi/agent/extensions"

exit $STATUS
