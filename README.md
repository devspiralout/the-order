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

The team also **learns over time** — a dream process consolidates session
learnings into durable knowledge that makes future sessions smarter.

## Prerequisites

- Claude Code v2.1.32 or later
- The Fawkes repo cloned locally
- Node.js (for the MCP filesystem server)
- tmux (optional — for split-pane view of agents working simultaneously)

## Setup

1. Install the plugin:
   ```
   /plugin install devspiralout/the-order
   ```

2. On first launch, the plugin will greet you and ask whether you want
   **auto** or **manual** dream mode (see below). You can also run `/init`
   at any time to reconfigure.

3. That's it. The plugin automatically finds your local Fawkes clone by
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

## Dream — Learning Across Sessions

After each session, agents can consolidate what they learned — decisions made,
gotchas discovered, standards applied, edge cases found — into durable
knowledge files that future sessions can load. Think of it like REM sleep
for your agent team.

### Modes

| Mode | How it works | Best for |
|------|-------------|----------|
| **Auto** | Dream runs automatically before each session ends | Teams that want continuous improvement without thinking about it |
| **Manual** | Run `/dream` yourself when you want to consolidate | Users who prefer full control or only dream after substantial sessions |

Configure your preference:
- On first launch, the plugin asks you to choose
- Run `/init` to change it later
- Or set `ORDER_AUTO_DREAM` to `true` or `false` in `.claude/settings.local.json`

### What gets captured

Knowledge files live in `knowledge/` and contain things that **can't be derived
from reading Fawkes docs alone** — the kind of thing a teammate would tell you
over coffee:

- Which standards actually apply where (and where they conflict)
- Codebase-specific gotchas and landmines
- Patterns that work well vs ones that caused problems
- Common review feedback that keeps recurring
- Gaps in the Fawkes documentation

### Knowledge vs Fawkes docs

- **Fawkes docs** = team-maintained standards (the manual)
- **Knowledge files** = agent-learned context (field experience)

If a learning keeps recurring, that's a signal to promote it to a proper
Fawkes standard.

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
│   └── marketplace.json             # Marketplace definition
├── plugin/                          # The actual plugin
│   ├── .claude-plugin/
│   │   └── plugin.json              # Plugin metadata
│   ├── .claude/
│   │   └── settings.json            # Permissions, hooks, and env config
│   ├── .mcp.json                    # Fawkes docs MCP server (auto-discovers repo)
│   ├── scripts/
│   │   ├── find-fawkes.sh           # Auto-discovers Fawkes repo location
│   │   ├── start-fawkes-mcp.sh      # Wrapper that finds repo and starts MCP server
│   │   ├── session-init.sh          # SessionStart hook (onboarding + flag reset)
│   │   └── auto-dream-check.sh     # Stop hook (blocks if auto-dream not done)
│   ├── agents/
│   │   ├── orchestrator/            # Coordination, task breakdown
│   │   ├── fe-engineer/             # React/TypeScript frontend
│   │   ├── be-engineer/             # C#/.NET backend
│   │   ├── pm/                      # Requirements and acceptance criteria
│   │   └── qe/                      # Test strategy and validation
│   ├── skills/
│   │   ├── team-setup/              # /team-setup — full squad for feature work
│   │   ├── code-review/             # /code-review — five-angle PR review
│   │   ├── bug-investigation/       # /bug-investigation — investigate and fix bugs
│   │   ├── dream/                   # /dream — consolidate session learnings
│   │   └── init/                    # /init — first-time setup and config
│   ├── knowledge/                   # Accumulated learnings (grows over time)
│   └── CLAUDE.md                    # Team-wide instructions
└── README.md                        # You are here
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
