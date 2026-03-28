#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CODEX_DIR="${HOME}/.codex"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

backup_path() {
  local target="$1"
  if [[ -L "$target" ]]; then
    rm -f "$target"
    return
  fi

  if [[ -e "$target" ]]; then
    local backup="${target}.backup-${TIMESTAMP}"
    mv "$target" "$backup"
    printf 'Backed up %s -> %s\n' "$target" "$backup" >&2
  fi
}

link_file() {
  local source="$1"
  local target="$2"

  backup_path "$target"
  ln -s "$source" "$target"
  printf 'Linked %s -> %s\n' "$target" "$source" >&2
}

link_dir() {
  local source="$1"
  local target="$2"

  backup_path "$target"
  ln -s "$source" "$target"
  printf 'Linked %s -> %s\n' "$target" "$source" >&2
}

mkdir -p "$CODEX_DIR"

link_file "${SCRIPT_DIR}/config.toml" "${CODEX_DIR}/config.toml"
link_file "${SCRIPT_DIR}/AGENTS.md" "${CODEX_DIR}/AGENTS.md"

if [[ -d "${SCRIPT_DIR}/skills" ]]; then
  link_dir "${SCRIPT_DIR}/skills" "${CODEX_DIR}/skills"
fi

printf 'Setup completed.\n' >&2
