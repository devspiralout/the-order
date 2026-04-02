# The Order

> "We are part of the Order of the Phoenix — an organisation dedicated to
> fighting Voldemort and his Death Eaters."

A Claude Code plugin that spawns an agent team to read your engineering
documentation and apply it — like onboarding a squad that already knows
how to learn.

## What Is This?

The Order spawns a team of specialist agents — Orchestrator, FE Engineer,
BE Engineer, PM, and QE — that read documentation from **your project**
to understand your coding practices, business logic, and architectural
decisions, then collaborate to deliver work end-to-end.

It works with **any tech stack** — you describe your project in a config file
and the agents adapt. Configs are stored in `~/.config/the-order/projects/`,
so your project repo stays completely untouched.

The team also **learns over time** — a dream process consolidates session
learnings into durable knowledge that makes future sessions smarter.

## Prerequisites

- Claude Code v2.1.32 or later
- Node.js (for the MCP filesystem server)
- tmux (optional — for split-pane view of agents working simultaneously)

## Setup

1. Add the marketplace and install the plugin:
   ```
   /plugin marketplace add devspiralout/the-order
   /plugin install order-of-the-phoenix@the-order
   ```

2. Run `/init` from your project directory. It will scan your codebase,
   generate a config, and ask your preferences (dream mode, Office UI).
   See [examples/](examples/) for config templates.

3. Start a new session (so the MCP server picks up the config), and you're live.

## Project Configuration

Running `/init` scans your project and creates a config file at:
```
~/.config/the-order/projects/<project-name>.order.yml
```

The config stays **outside your project repo** — no files to commit or gitignore.

Here's what a config looks like:

```yaml
project:
  name: "MyProject"
  root: "/Users/you/MyProject"
  standards_paths:
    - "docs/standards/"

team:
  agents:
    fe-engineer:
      name: "FE Engineer"
      owns: "src/frontend/"
      stack: "React 18, TypeScript, Tailwind CSS"
      testing: "Jest, React Testing Library, Playwright"
      notes: |
        - Use the design system components from src/components/ui/

    be-engineer:
      name: "BE Engineer"
      owns: "src/api/"
      stack: "Python 3.12, FastAPI, SQLAlchemy"
      testing: "pytest, httpx"
      notes: |
        - All endpoints must have OpenAPI docstrings
```

See the [examples/](examples/) directory for complete configurations covering:
- **C#/.NET + React** (full-stack web app)
- **Python FastAPI** (API service)
- **Go monolith** with infrastructure agent

### Auto-discovery

The plugin matches your current directory against the `project.root` field
in stored configs. No env vars needed if you're working inside a configured
project.

To override: `export ORDER_PROJECT_PATH=~/your/project/path`

## Usage

Use the slash commands to spawn the team:

```
/team-setup Implement user profile page with avatar upload
/code-review https://github.com/org/repo/pull/123
/bug-investigation Users see stale data after updating their profile
```

## Office UI — Visual Agent Dashboard

Watch your agent team work in real-time in an isometric pixel-art office
(Severance MDR × Habbo Hotel aesthetic).

```
/office
```

Agents walk through a door when spawned, sit at desks, show speech bubbles
with what they're working on, and file out when done. The UI is powered by
passive `PostToolUse` hooks — **zero extra token cost** to the agents.

### Modes

| Mode | How it works | Best for |
|------|-------------|----------|
| **Auto** | UI server starts every session | Always-on visual feedback |
| **Manual** | Run `/office` to start on demand | Occasional use, no overhead |

Configure with `/init` or set `ORDER_UI` to `true` in `.claude/settings.local.json`.

**Requirements:** Node.js (for the UI server). The browser connects to `http://localhost:3742`.

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
from reading your project docs alone** — the kind of thing a teammate would
tell you over coffee:

- Which standards actually apply where (and where they conflict)
- Codebase-specific gotchas and landmines
- Patterns that work well vs ones that caused problems
- Common review feedback that keeps recurring
- Gaps in the project documentation

### Knowledge vs project docs

- **Project docs** = team-maintained standards (the manual)
- **Knowledge files** = agent-learned context (field experience)

If a learning keeps recurring, that's a signal to promote it to a proper
project standard.

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
├── examples/                        # .order.yml examples for common stacks
│   ├── dotnet-react.order.yml        # C#/.NET + React example
│   ├── python-fastapi.order.yml     # Python FastAPI example
│   └── go-monolith.order.yml        # Go + Terraform example
├── plugin/                          # The actual plugin
│   ├── .claude-plugin/
│   │   └── plugin.json              # Plugin metadata
│   ├── .claude/
│   │   └── settings.json            # Permissions, hooks, and env config
│   ├── .mcp.json                    # Project docs MCP server (auto-discovers repo)
│   ├── scripts/
│   │   ├── find-project.sh          # Auto-discovers project via stored configs
│   │   ├── find-config.sh          # Resolves config file path for current project
│   │   ├── start-project-mcp.sh     # Wrapper that finds project and starts MCP server
│   │   ├── emit-event.sh            # PostToolUse hook (captures agent activity for UI)
│   │   ├── office-server.sh         # Manages Office UI server lifecycle
│   │   ├── session-init.sh          # SessionStart hook (onboarding + UI auto-start)
│   │   └── auto-dream-check.sh      # Stop hook (dream check + UI cleanup)
│   ├── agents/
│   │   ├── orchestrator/            # Coordination, task breakdown
│   │   ├── fe-engineer/             # Frontend specialist
│   │   ├── be-engineer/             # Backend specialist
│   │   ├── pm/                      # Requirements and acceptance criteria
│   │   └── qe/                      # Test strategy and validation
│   ├── skills/
│   │   ├── team-setup/              # /team-setup — full squad for feature work
│   │   ├── code-review/             # /code-review — five-angle PR review
│   │   ├── bug-investigation/       # /bug-investigation — investigate and fix bugs
│   │   ├── dream/                   # /dream — consolidate session learnings
│   │   ├── office/                   # /office — launch visual Office UI
│   │   └── init/                    # /init — first-time setup and config
│   ├── ui/                          # Office UI (Phaser 3 isometric app)
│   │   ├── server.js                # Express + WebSocket event bridge
│   │   └── public/                  # Phaser app (HTML, JS, procedural sprites)
│   ├── knowledge/                   # Accumulated learnings (grows over time)
│   └── CLAUDE.md                    # Team-wide instructions
└── README.md                        # You are here
```

## Team Roles

| Role | Focus |
|------|-------|
| Orchestrator | Task breakdown, sequencing, coordination |
| FE Engineer | Frontend codebase (as defined in project config) |
| BE Engineer | Backend codebase (as defined in project config) |
| PM | Requirements, scope, acceptance criteria |
| QE | Test strategy, coverage, quality validation |

Technical agent roles and their specialisations are configured in the project config —
the FE/BE split is a common default but not required.

See `agents/<role>/AGENT.md` for full role definitions.
