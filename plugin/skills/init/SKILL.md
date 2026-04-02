---
name: init
description: First-time setup for The Order plugin. Scans the project to scaffold .order.yml, configures dream mode and Office UI preferences.
---

Help the user configure The Order plugin for first use.

## Step 1 — Scaffold .order.yml

Project configs are stored in `~/.config/the-order/projects/`, NOT in the
project repo — this keeps target repos completely clean.

Check if a config already exists for the current project:
```bash
ls ~/.config/the-order/projects/*.order.yml 2>/dev/null
```

If a matching config exists (check the `root` field matches the current project),
skip to Step 2.

If not, scan the project to generate a draft. Use the standard Claude Code tools
(Glob, Read, Grep) — the MCP server won't be available yet on first run.

### Scanning strategy

Discover the project in this order — each layer adds detail:

**1. Read existing documentation first (most valuable):**
- `CLAUDE.md`, `AGENTS.md` — often describe the full architecture, standards locations, and conventions
- `CONTRIBUTING.md`, `README.md` — may describe tech stack and project structure
- `docs/`, `standards/`, `guides/` — look for directories that contain engineering standards

**2. Detect tech stack from project files:**
- `*.csproj`, `*.sln` → .NET (check for version in `global.json`)
- `package.json` → Node.js/TypeScript/React (read it for framework dependencies)
- `pyproject.toml`, `setup.py`, `requirements.txt` → Python
- `go.mod` → Go
- `Cargo.toml` → Rust
- `Gemfile` → Ruby
- `build.gradle`, `pom.xml` → Java/Kotlin

**3. Detect project shape:**
- Look for frontend/backend split (separate directories, `ClientApp/`, `src/web/`, `frontend/`, etc.)
- Look for monorepo signals (`packages/`, `apps/`, workspace configs)
- Check for infrastructure (`terraform/`, `k8s/`, `deploy/`, `.github/workflows/`)
- Check testing setup (test directories, test config files)

**4. Find standards and documentation paths:**
- Search for directories containing markdown files about conventions, standards, or architecture
- Look for ADR (Architecture Decision Record) directories
- Note any paths referenced in CLAUDE.md or CONTRIBUTING.md

### Generate the draft

Using what you found, generate a complete `.order.yml` with:
- `project.name` — from the repo directory name or package.json name
- `project.root` — **absolute path to the project root** (e.g., `/Users/you/Fawkes`)
- `project.standards_paths` — every documentation/standards directory you found
- `team.agents` — one agent per distinct tech area (FE/BE, or a single Engineer for monoliths)
  - `owns` — the directory each agent is responsible for
  - `stack` — specific technologies and versions you detected
  - `testing` — testing frameworks found in config or dependencies
  - `notes` — any project-specific conventions from CLAUDE.md or CONTRIBUTING.md

**Show the draft to the user and ask them to review before writing it.** They may
want to adjust ownership areas, add notes, or correct detected versions.

### Write the config

Write the reviewed config to `~/.config/the-order/projects/<project-name>.order.yml`:

```bash
mkdir -p ~/.config/the-order/projects
```

For example, a project named "Fawkes" would be written to:
`~/.config/the-order/projects/fawkes.order.yml`

Use a lowercase, hyphenated version of the project name for the filename.

### After writing

Tell the user:
> The `project-docs` MCP server discovers your project via the config file.
> It couldn't start this session because the config didn't exist yet.
> **Start a new session** and the MCP server will pick it up automatically —
> agents will then be able to browse your standards directly.

## Step 2 — Configure dream mode

Explain the two dream modes:

- **Auto** (`ORDER_AUTO_DREAM=true`): The team automatically consolidates
  learnings before each session ends. Good for teams that want continuous
  improvement without thinking about it.
- **Manual** (`ORDER_AUTO_DREAM=false`): The user runs `/dream` when they
  want to consolidate. Good for users who want full control or only dream
  after substantial sessions.

Ask the user which mode they prefer.

Based on their choice, update `.claude/settings.local.json` to set the
`ORDER_AUTO_DREAM` environment variable:

```json
{
  "env": {
    "ORDER_AUTO_DREAM": "true"
  }
}
```

Merge with any existing content in `.claude/settings.local.json` — don't
overwrite other settings.

## Step 3 — Configure Office UI

Ask if they want the visual Office UI — an isometric pixel-art view of agents
working in real-time (Severance MDR × Habbo Hotel aesthetic).

- **Enabled** (`ORDER_UI=true`): The Office UI server starts automatically each
  session. Run `/office` to open the browser, or it opens automatically.
- **Disabled** (`ORDER_UI=false`): No UI server, no overhead. This is the default.

Based on their choice, also set `ORDER_UI` in `.claude/settings.local.json`
alongside the dream mode setting.

## Step 4 — Confirm setup

Confirm the setup is complete and remind them of the available commands:
- `/team-setup <task>` — full squad for feature work
- `/code-review <PR>` — five-angle PR review
- `/bug-investigation <bug>` — investigate and fix bugs
- `/dream` — manually trigger dream consolidation
- `/office` — launch the visual Office UI

Create the initialisation flag:
```bash
mkdir -p ~/.config/the-order && touch ~/.config/the-order/initialized
```
