#!/usr/bin/env bash
# Manages the Office UI server lifecycle.
# Usage: office-server.sh start | stop | status

set -euo pipefail

PID_FILE="/tmp/the-order-office.pid"
EVENT_DIR="/tmp/the-order-events"
UI_DIR="$(cd "$(dirname "$0")/../ui" && pwd)"
PORT="${ORDER_UI_PORT:-3742}"

case "${1:-}" in
  start)
    # Already running?
    if [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
      echo "Office UI already running on http://localhost:$PORT (PID $(cat "$PID_FILE"))"
      exit 0
    fi

    # Ensure event directory exists
    mkdir -p "$EVENT_DIR"

    # Start the server in the background
    cd "$UI_DIR"
    ORDER_UI_PORT="$PORT" EVENT_DIR="$EVENT_DIR" node server.js &
    SERVER_PID=$!
    echo "$SERVER_PID" > "$PID_FILE"
    echo "Office UI started on http://localhost:$PORT (PID $SERVER_PID)"
    ;;

  stop)
    if [[ -f "$PID_FILE" ]]; then
      PID=$(cat "$PID_FILE")
      if kill -0 "$PID" 2>/dev/null; then
        kill "$PID"
        echo "Office UI stopped (PID $PID)"
      fi
      rm -f "$PID_FILE"
    else
      echo "Office UI is not running"
    fi
    ;;

  status)
    if [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
      echo "running"
    else
      echo "stopped"
    fi
    ;;

  *)
    echo "Usage: office-server.sh start|stop|status" >&2
    exit 1
    ;;
esac
