#!/usr/bin/env bash
# Stop hook: blocks session end if auto-dream is enabled and dream hasn't run.
# Also cleans up the Office UI server if it's running.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DREAM_FLAG="/tmp/the-order-dream-done"

# Stop Office UI server if running
"$SCRIPT_DIR/office-server.sh" stop 2>/dev/null || true

# If auto-dream is off or unset, allow stop
if [[ "${ORDER_AUTO_DREAM:-false}" != "true" ]]; then
  exit 0
fi

# If dream already ran this session, allow stop
if [[ -f "$DREAM_FLAG" ]]; then
  exit 0
fi

# Block stop and ask Claude to dream first
echo "Auto-dream is enabled but hasn't run this session. Please run /dream to consolidate learnings before ending." >&2
exit 2
