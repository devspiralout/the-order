# The Order

> "We are part of the Order of the Phoenix — an organisation dedicated to
> fighting Voldemort and his Death Eaters."

A Claude Code plugin that spawns an agent team to read your engineering
documentation and apply it — like onboarding a squad that already knows
how to learn.

## What Is This?

The Order spawns a team of five specialist agents — Orchestrator, FE Engineer,
BE Engineer, PM, and QE — that read documentation from your **Fawkes** repo
to understand your coding practices, business logic, and architectural
decisions, then collaborate to deliver work end-to-end.

## Prerequisites

- Claude Code v2.1.32 or later
- The Fawkes repo cloned locally
- Node.js (for the MCP filesystem server)
- tmux (optional — for split-pane view of agents working simultaneously)

## Setup

1. Install the plugin:
   ```
   /plugin install <repo-url>
   ```

2. That's it. The plugin automatically finds your local Fawkes clone by
   checking common locations (`~/Fawkes`, `~/repos/Fawkes`, `~/Desktop/Fawkes`,
   etc.) and caches the result.

   If your Fawkes repo is somewhere unusual, set the override:
   ```bash
   export FAWKES_REPO_PATH=~/your/custom/path/Fawkes
   ```

## Usage

Use the slash commands to spawn the team:

```
/team-setup Implement user profile page with avatar upload
/code-review https://github.com/org/repo/pull/123
/bug-investigation Users see stale data after updating their profile
```

## Viewing Agents at Work

When agents are spawned, you have two ways to watch them:

### In-process mode (default)

All agents run in a single terminal window. Navigate between them:

| Shortcut | Action |
|----------|--------|
| **Shift+Down** | Cycle through teammates |
| **Enter** | View a teammate's full session |
| **Esc** | Interrupt a teammate |
| **Ctrl+T** | Toggle the shared task list |

### Split-pane mode (optional)

See all agents working simultaneously in separate terminal panes. Requires
[tmux](https://github.com/tmux/tmux):

```bash
brew install tmux
```

Then add to your Claude Code settings:
```json
{
  "teammateMode": "tmux"
}
```

Each agent gets its own pane — click into any pane to interact with that
agent directly.

## Repo Structure

```
the-order/
├── .claude-plugin/
│   └── plugin.json          # Plugin metadata
├── .mcp.json                # Fawkes docs MCP server (auto-discovers repo)
├── scripts/
│   ├── find-fawkes.sh       # Auto-discovers Fawkes repo location
│   └── start-fawkes-mcp.sh  # Wrapper that finds repo and starts MCP server
├── .claude/
│   └── settings.json        # Permissions and env config
├── agents/
│   ├── orchestrator/        # Coordination, task breakdown
│   ├── fe-engineer/         # React/TypeScript frontend
│   ├── be-engineer/         # C#/.NET backend
│   ├── pm/                  # Requirements and acceptance criteria
│   └── qe/                  # Test strategy and validation
├── skills/
│   ├── team-setup/          # /team-setup — full squad for feature work
│   ├── code-review/         # /code-review — five-angle PR review
│   └── bug-investigation/   # /bug-investigation — investigate and fix bugs
├── CLAUDE.md                # Team-wide instructions
└── README.md                # You are here
```

## Team Roles

| Role | Focus |
|------|-------|
| Orchestrator | Task breakdown, sequencing, coordination |
| FE Engineer | React/TypeScript frontend in ClientApp |
| BE Engineer | C#/.NET backend, EF Core, APIs |
| PM | Requirements, scope, acceptance criteria |
| QE | Test strategy, coverage, quality validation |

See `agents/<role>/AGENT.md` for full role definitions.
