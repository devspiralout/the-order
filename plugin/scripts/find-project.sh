#!/usr/bin/env bash
# Locates the target project and its .order.yml config.
#
# Project configs are stored in ~/.config/the-order/projects/, NOT in the
# project repo itself — this keeps target repos clean.
#
# Priority: $ORDER_PROJECT_PATH > match CWD against stored configs > cached path
#
# Outputs the absolute path to the PROJECT ROOT to stdout.
# The config file path can be derived: ~/.config/the-order/projects/<name>.order.yml

set -euo pipefail

CONFIG_DIR="${HOME}/.config/the-order/projects"
CACHE_FILE="${HOME}/.cache/the-order/project-path"

# Helper: output a discovered path (and cache it)
found() {
  local dir="$1"
  mkdir -p "$(dirname "$CACHE_FILE")"
  echo "$dir" > "$CACHE_FILE"
  echo "$dir"
  exit 0
}

# 1. Explicit env var always wins
if [[ -n "${ORDER_PROJECT_PATH:-}" ]] && [[ -d "$ORDER_PROJECT_PATH" ]]; then
  echo "$ORDER_PROJECT_PATH"
  exit 0
fi

# 2. Match CWD against stored project configs
if [[ -d "$CONFIG_DIR" ]]; then
  cwd="$(pwd)"
  for config in "$CONFIG_DIR"/*.order.yml; do
    [[ -f "$config" ]] || continue

    # Extract the root path from the config file
    # Looks for "  root: /some/path" or "  root: \"/some/path\""
    root=$(grep -E '^\s+root:\s+' "$config" 2>/dev/null | head -1 | sed 's/.*root:\s*//; s/^"//; s/"$//' | sed 's/^ *//')

    if [[ -n "$root" ]] && [[ -d "$root" ]]; then
      # Check if CWD is inside this project root
      case "$cwd" in
        "$root"|"$root"/*)
          found "$root"
          ;;
      esac
    fi
  done
fi

# 3. Check cached path as fallback
if [[ -f "$CACHE_FILE" ]]; then
  cached=$(cat "$CACHE_FILE")
  if [[ -d "$cached" ]]; then
    # Verify a config still exists for this path
    if [[ -d "$CONFIG_DIR" ]]; then
      for config in "$CONFIG_DIR"/*.order.yml; do
        [[ -f "$config" ]] || continue
        root=$(grep -E '^\s+root:\s+' "$config" 2>/dev/null | head -1 | sed 's/.*root:\s*//; s/^"//; s/"$//' | sed 's/^ *//')
        if [[ "$root" == "$cached" ]]; then
          echo "$cached"
          exit 0
        fi
      done
    fi
  fi
  # Cache is stale, remove it
  rm -f "$CACHE_FILE"
fi

echo "ERROR: No project config found for the current directory." >&2
echo "Run /init to scan your project and create a config." >&2
echo "Configs are stored in: $CONFIG_DIR" >&2
exit 1
