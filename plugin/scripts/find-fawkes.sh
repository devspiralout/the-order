#!/usr/bin/env bash
# Locates the Fawkes repository on the local machine.
# Priority: $FAWKES_REPO_PATH > cached path > common locations > broad search
# Outputs the absolute path to stdout, exits 1 if not found.

set -euo pipefail

CACHE_FILE="${HOME}/.cache/the-order/fawkes-path"

# 1. Explicit env var always wins
if [[ -n "${FAWKES_REPO_PATH:-}" ]] && [[ -d "$FAWKES_REPO_PATH" ]]; then
  echo "$FAWKES_REPO_PATH"
  exit 0
fi

# 2. Check cached path from a previous discovery
if [[ -f "$CACHE_FILE" ]]; then
  cached=$(cat "$CACHE_FILE")
  if [[ -d "$cached" ]]; then
    echo "$cached"
    exit 0
  fi
  # Cache is stale, remove it
  rm -f "$CACHE_FILE"
fi

# Helper: verify a candidate directory is the Fawkes repo.
# The fingerprint is auror-delivery/README.md — the coding standards readme
# that exists in every Fawkes clone.
is_fawkes() {
  local dir="$1"
  [[ -f "$dir/auror-delivery/README.md" ]]
}

# 3. Check common locations
common_paths=(
  "$HOME/Fawkes"
  "$HOME/Desktop/Fawkes"
  "$HOME/repos/Fawkes"
  "$HOME/Projects/Fawkes"
  "$HOME/projects/Fawkes"
  "$HOME/code/Fawkes"
  "$HOME/Code/Fawkes"
  "$HOME/dev/Fawkes"
  "$HOME/Dev/Fawkes"
  "$HOME/src/Fawkes"
  "$HOME/workspace/Fawkes"
  "$HOME/Workspace/Fawkes"
  "$HOME/Documents/Fawkes"
)

for path in "${common_paths[@]}"; do
  if is_fawkes "$path"; then
    mkdir -p "$(dirname "$CACHE_FILE")"
    echo "$path" > "$CACHE_FILE"
    echo "$path"
    exit 0
  fi
done

# 4. Broad search — look for auror-delivery/README.md anywhere under home (max depth 5, timeout 5s)
found=$(timeout 5 find "$HOME" -maxdepth 5 -type f -path "*/auror-delivery/README.md" 2>/dev/null | head -10)

while IFS= read -r match; do
  if [[ -n "$match" ]]; then
    # The repo root is two levels up from auror-delivery/README.md
    candidate="$(cd "$(dirname "$match")/.." && pwd)"
    mkdir -p "$(dirname "$CACHE_FILE")"
    echo "$candidate" > "$CACHE_FILE"
    echo "$candidate"
    exit 0
  fi
done <<< "$found"

echo "ERROR: Could not find the Fawkes repository." >&2
echo "Set FAWKES_REPO_PATH to the path of your local Fawkes clone." >&2
exit 1
