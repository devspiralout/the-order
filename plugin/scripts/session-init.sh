#!/usr/bin/env bash
# SessionStart hook: clears flags, starts Office UI if enabled, shows onboarding.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DREAM_FLAG="/tmp/the-order-dream-done"
EVENT_DIR="/tmp/the-order-events"
INIT_FLAG="${HOME}/.config/the-order/initialized"

# Clear dream flag from any previous session
rm -f "$DREAM_FLAG"

# Clear stale events from previous session
rm -rf "$EVENT_DIR"
mkdir -p "$EVENT_DIR"

# Auto-start Office UI if enabled
if [[ "${ORDER_UI:-false}" == "true" ]]; then
  "$SCRIPT_DIR/office-server.sh" start
fi

# First-run onboarding
if [[ ! -f "$INIT_FLAG" ]]; then
  cat <<'WELCOME'
Welcome to **The Order of the Phoenix** — your agent team plugin.

This plugin spawns a team of specialist agents (Orchestrator, PM, QE, plus
technical agents from your project config) that read your project's coding
standards and collaborate on feature delivery, code reviews, and bug investigations.

## Getting Started

Run `/init` to scan your project and create a config. Configs are stored in
`~/.config/the-order/projects/` — your project repo stays untouched.

## Features

- **Dream Mode**: Agents consolidate learnings into durable knowledge across sessions
- **Office UI**: A visual isometric office showing agents working in real-time

**Run `/init` to configure your preferences and get started.**

## Quick Start

Once configured, use these commands:
- `/team-setup <task>` — spawn the full team for a feature
- `/code-review <PR>` — five-angle PR review
- `/bug-investigation <bug>` — investigate and fix a bug
- `/dream` — manually trigger dream consolidation
- `/office` — launch the visual Office UI
WELCOME

  mkdir -p "$(dirname "$INIT_FLAG")"
  touch "$INIT_FLAG"
fi

exit 0
