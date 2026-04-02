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

# Don't use pipefail — grep returning no match (exit 1) is expected and not an error
set -eu

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

# Safe JSON field extraction — returns empty string on failure
json_field() {
  local field="$1"
  local max_len="${2:-50}"
  # Try jq first (proper JSON parsing), fall back to grep
  if command -v jq &>/dev/null; then
    echo "$INPUT" | jq -r ".$field // \"\"" 2>/dev/null | cut -c1-"$max_len" || echo ""
  else
    echo "$INPUT" | grep -o "\"$field\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" | head -1 | sed 's/.*:[[:space:]]*"//; s/"$//' | cut -c1-"$max_len" || echo ""
  fi
}

# Infer a human-readable action from the tool call
case "$TOOL" in
  Read)
    FILE=$(json_field "file_path" 200)
    ACTION="reading"
    DETAIL=$(basename "$FILE" 2>/dev/null || echo "file")
    ;;
  Edit)
    FILE=$(json_field "file_path" 200)
    ACTION="editing"
    DETAIL=$(basename "$FILE" 2>/dev/null || echo "file")
    ;;
  Write)
    FILE=$(json_field "file_path" 200)
    ACTION="writing"
    DETAIL=$(basename "$FILE" 2>/dev/null || echo "file")
    ;;
  Bash)
    ACTION="running"
    DETAIL=$(json_field "command" 50)
    ;;
  Grep)
    ACTION="searching"
    DETAIL=$(json_field "pattern" 30)
    ;;
  Glob)
    ACTION="finding"
    DETAIL=$(json_field "pattern" 30)
    ;;
  Agent)
    ACTION="collaborating"
    DETAIL=$(json_field "description" 50)
    ;;
  SendMessage)
    ACTION="talking"
    TO=$(json_field "to" 30)
    DETAIL="to $TO"
    ;;
  TaskCreate|TaskUpdate)
    ACTION="planning"
    DETAIL=$(json_field "subject" 50)
    ;;
  *)
    ACTION="working"
    DETAIL="$TOOL"
    ;;
esac

# Write event as properly escaped JSON using jq, or safe fallback
if command -v jq &>/dev/null; then
  jq -cn \
    --arg agent "$AGENT" \
    --arg action "$ACTION" \
    --arg detail "$DETAIL" \
    --arg tool "$TOOL" \
    --arg ts "$TIMESTAMP" \
    '{agent: $agent, action: $action, detail: $detail, tool: $tool, ts: $ts}' \
    >> "$EVENT_DIR/$AGENT.jsonl"
else
  # Fallback: strip characters that would break JSON
  SAFE_DETAIL=$(echo "$DETAIL" | tr -d '"\\\n\r' | cut -c1-50)
  echo "{\"agent\":\"$AGENT\",\"action\":\"$ACTION\",\"detail\":\"$SAFE_DETAIL\",\"tool\":\"$TOOL\",\"ts\":\"$TIMESTAMP\"}" \
    >> "$EVENT_DIR/$AGENT.jsonl"
fi

exit 0
