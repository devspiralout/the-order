#!/usr/bin/env bash
# Wrapper that finds the target project and starts the MCP filesystem server.
# Used as the MCP server command so no manual env var setup is needed.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_PATH=$("$SCRIPT_DIR/find-project.sh")

exec npx -y @anthropic/mcp-server-filesystem "$PROJECT_PATH"
