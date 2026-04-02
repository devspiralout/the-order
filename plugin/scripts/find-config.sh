#!/usr/bin/env bash
# Finds the .order.yml config file for the current project.
# Outputs the absolute path to the config file to stdout.
# Uses find-project.sh to determine which project we're in,
# then locates the matching config in ~/.config/the-order/projects/.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="${HOME}/.config/the-order/projects"

# Get the project root
PROJECT_ROOT=$("$SCRIPT_DIR/find-project.sh" 2>/dev/null) || {
  echo "ERROR: No project found. Run /init first." >&2
  exit 1
}

# Find the config file that matches this root
if [[ -d "$CONFIG_DIR" ]]; then
  for config in "$CONFIG_DIR"/*.order.yml; do
    [[ -f "$config" ]] || continue
    root=$(grep -E '^\s+root:\s+' "$config" 2>/dev/null | head -1 | sed 's/.*root:\s*//; s/^"//; s/"$//' | sed 's/^ *//')
    if [[ "$root" == "$PROJECT_ROOT" ]]; then
      echo "$config"
      exit 0
    fi
  done
fi

echo "ERROR: No config file found for project at $PROJECT_ROOT" >&2
echo "Run /init to create one." >&2
exit 1
