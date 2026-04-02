# The Order — Agent Team Knowledge Base

> "We are part of the Order of the Phoenix — an organisation dedicated to
> fighting Voldemort and his Death Eaters."
> — Remus Lupin

## Purpose

This is a Claude Code plugin that spawns an agent team to learn and
enforce your engineering ways of working. Agents read documentation from
your project, then apply that knowledge when reviewing code, generating
new features, or auditing standards.

---

## Project Configuration

Every project that uses The Order needs an `.order.yml` file in its root.
This file tells the agents what tech stack you use, where your standards
live, and what each agent owns.

The path to the project is configured via the `ORDER_PROJECT_PATH` environment
variable, or auto-discovered by walking up from the current working directory.

### Reading the manifest

Before doing any work, agents MUST read `.order.yml` to understand:
- The project's name and standards locations
- Which technical agents exist and what they own
- The tech stack, testing tools, and project-specific notes for each agent

### Discovering Documentation

Use the `mcp__project-docs__*` tools to browse and read files from the project.

Common locations to check (as defined in `.order.yml`):
- Standards directories
- Documentation directories
- Architecture decision records
- Contributing guides

### Reading Documentation

When given a task, always:
1. First read `.order.yml` to find the standards paths
2. Search the project for relevant documentation
3. Read the relevant files to understand the project's practices
4. Apply those practices to your work
5. If you find conflicting or missing documentation, flag it to the Orchestrator

---

## Agent Team

The team has a core set of roles that collaborate on every piece of work.
Each role is defined in `agents/<role>/AGENT.md`.

### Default roles

| Role | Focus | Key interactions |
|------|-------|-----------------|
| **Orchestrator** | Task breakdown, sequencing, coordination | Assigns work, routes decisions, synthesises outputs |
| **PM** | Requirements, scope, acceptance criteria | Scopes work before assignment, defines "done" with QE |
| **QE** | Test strategy, coverage, quality validation | Reviews all code, validates against acceptance criteria |

### Technical agents

Technical agents are defined in `.order.yml` and typically include:

| Role | Focus | Key interactions |
|------|-------|-----------------|
| **FE Engineer** | Frontend codebase | Coordinates with BE on API contracts, notifies QE when ready |
| **BE Engineer** | Backend codebase | Notifies FE of endpoint changes, loops in QE for test review |

Projects may define different technical agents (e.g., a single "Engineer" for
a monolith, or add an "Infra Engineer" for platform work). Check `.order.yml`
for the project's specific team configuration.

### Collaboration Rules

1. **No solo work.** Every agent actively involves teammates whose area is affected.
2. **Contracts first.** Technical agents align on API contracts before implementing.
3. **Shift-left testing.** QE defines test scenarios before implementation starts.
4. **PM scopes first.** PM clarifies requirements and acceptance criteria before the Orchestrator assigns work.
5. **QE signs off last.** Nothing is considered done until QE validates it.
6. **Share findings constantly.** Use the shared task list to communicate progress, blockers, and decisions.

---

## Skills

Use these slash commands to spawn the team:

| Command | Purpose |
|---------|---------|
| `/team-setup <task>` | Full squad for feature delivery |
| `/code-review <PR>` | Five-angle PR review |
| `/bug-investigation <bug>` | Investigate, reproduce, fix, regression-test |
| `/dream` | Consolidate session learnings into durable knowledge |
| `/init` | First-time setup — configure dream mode, scaffold .order.yml |

---

## Dream — Learning Across Sessions

Agents accumulate context during a session — decisions, gotchas, standards
applied, edge cases discovered. The dream process consolidates these into
durable knowledge files in `knowledge/` that future sessions can load.

### How it works

1. At session end (or manually), `/dream` reviews what happened
2. Non-obvious, reusable learnings are distilled into `knowledge/` files
3. Task-specific details are discarded; only generalisable insights are kept
4. Future sessions load these files alongside project standards

### Modes

- **Auto** (`ORDER_AUTO_DREAM=true`): Dream runs automatically before each
  session ends. A hook blocks the stop until dreaming is complete.
- **Manual** (`ORDER_AUTO_DREAM=false`): Run `/dream` yourself when you want
  to consolidate. This is the default.

Configure your preference with `/init` or by setting `ORDER_AUTO_DREAM` in
`.claude/settings.local.json`.

### Knowledge vs project docs

- **Project docs** = team-maintained standards (the manual)
- **Knowledge files** = agent-learned context (field experience)

Knowledge files should contain things that can't be derived from reading project
docs alone. If a learning keeps recurring, promote it to a proper project standard.

---

## MCP Servers

The `project-docs` MCP server provides filesystem read access to the target
project repository. It automatically discovers the project by walking up from
the current directory looking for `.order.yml`, and caches the result. To
override, set the `ORDER_PROJECT_PATH` environment variable.
