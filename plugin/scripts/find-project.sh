#!/usr/bin/env bash
# Locates the target project repository on the local machine.
# The project is identified by having an .order.yml file in its root.
# Priority: $ORDER_PROJECT_PATH > cached path > walk up from CWD > common locations
# Outputs the absolute path to stdout, exits 1 if not found.

set -euo pipefail

CACHE_FILE="${HOME}/.cache/the-order/project-path"

# 1. Explicit env var always wins
if [[ -n "${ORDER_PROJECT_PATH:-}" ]] && [[ -d "$ORDER_PROJECT_PATH" ]]; then
  echo "$ORDER_PROJECT_PATH"
  exit 0
fi

# 2. Check cached path from a previous discovery
if [[ -f "$CACHE_FILE" ]]; then
  cached=$(cat "$CACHE_FILE")
  if [[ -d "$cached" ]] && [[ -f "$cached/.order.yml" ]]; then
    echo "$cached"
    exit 0
  fi
  # Cache is stale, remove it
  rm -f "$CACHE_FILE"
fi

# Helper: cache and output a discovered path
found() {
  local dir="$1"
  mkdir -p "$(dirname "$CACHE_FILE")"
  echo "$dir" > "$CACHE_FILE"
  echo "$dir"
  exit 0
}

# 3. Walk up from CWD looking for .order.yml
dir="$(pwd)"
while [[ "$dir" != "/" ]]; do
  if [[ -f "$dir/.order.yml" ]]; then
    found "$dir"
  fi
  dir="$(dirname "$dir")"
done

# 4. Broad search — look for .order.yml anywhere under home (max depth 5, timeout 5s)
results=$(timeout 5 find "$HOME" -maxdepth 5 -name ".order.yml" -type f 2>/dev/null | head -5)

while IFS= read -r match; do
  if [[ -n "$match" ]]; then
    candidate="$(cd "$(dirname "$match")" && pwd)"
    found "$candidate"
  fi
done <<< "$results"

echo "ERROR: Could not find a project with .order.yml." >&2
echo "Create an .order.yml in your project root, or set ORDER_PROJECT_PATH." >&2
echo "See: https://github.com/devspiralout/the-order/tree/main/examples" >&2
exit 1
