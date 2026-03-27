#!/usr/bin/env bash
# Wrapper that finds the Fawkes repo and starts the MCP filesystem server.
# Used as the MCP server command so no manual env var setup is needed.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FAWKES_PATH=$("$SCRIPT_DIR/find-fawkes.sh")

exec npx -y @anthropic/mcp-server-filesystem "$FAWKES_PATH"
