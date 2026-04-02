#!/usr/bin/env bash
# PostToolUse hook: captures agent tool activity as events for the Office UI.
# Writes JSONL events to /tmp/the-order-events/ (one file per agent).
# The UI server watches this directory via fs.watch and pushes events over WebSocket.
#
# Claude Code provides these environment variables to PostToolUse hooks:
#   CLAUDE_TOOL_NAME    — the tool that was called (Read, Edit, Write, Bash, Agent, etc.)
#   CLAUDE_TOOL_INPUT   — JSON string of the tool's input parameters
#   CLAUDE_TOOL_RESULT  — the tool's output (truncated)
#   CLAUDE_AGENT_NAME   — name of the agent that made the call (from AGENT.md frontmatter)
#   CLAUDE_SESSION_ID   — unique session identifier

set -euo pipefail

EVENT_DIR="/tmp/the-order-events"
mkdir -p "$EVENT_DIR"

# Skip if UI is not enabled
if [[ "${ORDER_UI:-false}" != "true" ]]; then
  exit 0
fi

# Skip if no agent name (top-level calls, not from a spawned agent)
AGENT="${CLAUDE_AGENT_NAME:-}"
if [[ -z "$AGENT" ]]; then
  exit 0
fi

TOOL="${CLAUDE_TOOL_NAME:-unknown}"
INPUT="${CLAUDE_TOOL_INPUT:-{}}"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Infer a human-readable action from the tool call
case "$TOOL" in
  Read)
    # Extract file path from input
    FILE=$(echo "$INPUT" | grep -o '"file_path":"[^"]*"' | head -1 | cut -d'"' -f4 | xargs basename 2>/dev/null || echo "file")
    ACTION="reading"
    DETAIL="$FILE"
    ;;
  Edit)
    FILE=$(echo "$INPUT" | grep -o '"file_path":"[^"]*"' | head -1 | cut -d'"' -f4 | xargs basename 2>/dev/null || echo "file")
    ACTION="editing"
    DETAIL="$FILE"
    ;;
  Write)
    FILE=$(echo "$INPUT" | grep -o '"file_path":"[^"]*"' | head -1 | cut -d'"' -f4 | xargs basename 2>/dev/null || echo "file")
    ACTION="writing"
    DETAIL="$FILE"
    ;;
  Bash)
    CMD=$(echo "$INPUT" | grep -o '"command":"[^"]*"' | head -1 | cut -d'"' -f4 | cut -c1-50)
    ACTION="running"
    DETAIL="$CMD"
    ;;
  Grep)
    PATTERN=$(echo "$INPUT" | grep -o '"pattern":"[^"]*"' | head -1 | cut -d'"' -f4 | cut -c1-30)
    ACTION="searching"
    DETAIL="$PATTERN"
    ;;
  Glob)
    PATTERN=$(echo "$INPUT" | grep -o '"pattern":"[^"]*"' | head -1 | cut -d'"' -f4 | cut -c1-30)
    ACTION="finding"
    DETAIL="$PATTERN"
    ;;
  Agent)
    # Agent spawning or sending message to another agent
    ACTION="collaborating"
    DETAIL=$(echo "$INPUT" | grep -o '"description":"[^"]*"' | head -1 | cut -d'"' -f4 | cut -c1-50)
    ;;
  SendMessage)
    TO=$(echo "$INPUT" | grep -o '"to":"[^"]*"' | head -1 | cut -d'"' -f4)
    ACTION="talking"
    DETAIL="to $TO"
    ;;
  TaskCreate|TaskUpdate)
    ACTION="planning"
    DETAIL=$(echo "$INPUT" | grep -o '"subject":"[^"]*"' | head -1 | cut -d'"' -f4 | cut -c1-50)
    ;;
  *)
    ACTION="working"
    DETAIL="$TOOL"
    ;;
esac

# Write event as a single JSON line to the agent's event file
EVENT="{\"agent\":\"$AGENT\",\"action\":\"$ACTION\",\"detail\":\"$DETAIL\",\"tool\":\"$TOOL\",\"ts\":\"$TIMESTAMP\"}"
echo "$EVENT" >> "$EVENT_DIR/$AGENT.jsonl"

exit 0
