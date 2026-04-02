#!/usr/bin/env bash
# SessionStart hook: clears dream flag and shows onboarding on first run.

set -euo pipefail

DREAM_FLAG="/tmp/the-order-dream-done"
INIT_FLAG="${HOME}/.config/the-order/initialized"

# Clear dream flag from any previous session
rm -f "$DREAM_FLAG"

# First-run onboarding
if [[ ! -f "$INIT_FLAG" ]]; then
  cat <<'WELCOME'
Welcome to **The Order of the Phoenix** — your agent team plugin.

This plugin spawns a team of specialist agents (Orchestrator, FE Engineer,
BE Engineer, PM, QE) that read your project's coding standards and collaborate
on feature delivery, code reviews, and bug investigations.

## Getting Started

The Order needs an `.order.yml` file in your project root to understand your
tech stack and standards. Run `/init` to generate one automatically.

## Dream Mode

The Order has a **dream** feature — after each session, agents can consolidate
what they learned into durable knowledge that makes future sessions smarter.

You have two options:

- **Auto** (`ORDER_AUTO_DREAM=true`): The team will automatically dream before
  ending each session. Recommended for most users.
- **Manual** (`ORDER_AUTO_DREAM=false`): You run `/dream` yourself when you
  want to consolidate learnings. Good if you prefer full control.

**Run `/init` to configure your preferences and get started.**

## Quick Start

Once configured, use these commands:
- `/team-setup <task>` — spawn the full team for a feature
- `/code-review <PR>` — five-angle PR review
- `/bug-investigation <bug>` — investigate and fix a bug
- `/dream` — manually trigger dream consolidation
WELCOME

  mkdir -p "$(dirname "$INIT_FLAG")"
  touch "$INIT_FLAG"
fi

exit 0
