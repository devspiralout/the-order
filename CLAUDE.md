# The Order — Agent Team Knowledge Base

> "We are part of the Order of the Phoenix — an organisation dedicated to
> fighting Voldemort and his Death Eaters."
> — Remus Lupin

## Purpose

This repo is a Claude Code plugin that spawns an agent team to learn and
enforce our engineering ways of working. Agents read documentation from
the **Fawkes** repo, then apply that knowledge when reviewing code,
generating new features, or auditing our standards.

---

## The Fawkes Repository

Our source of truth for coding practices and business logic lives in the
Fawkes repo. The path is configured via the `FAWKES_REPO_PATH` environment
variable. Before doing any work, agents MUST familiarise themselves with
the relevant documentation.

### Discovering Documentation

Use the `mcp__fawkes-docs__*` tools to browse and read files from Fawkes.

Common locations to check:
- `docs/` — general documentation
- `guides/` — how-to guides and onboarding
- `standards/` — coding standards and conventions
- `auror-delivery/standards/` — comprehensive coding standards
- `architecture/` — architectural decision records (ADRs)

### Reading Documentation

When given a task, always:
1. First search Fawkes for relevant markdown files
2. Read the relevant files to understand our practices
3. Apply those practices to your work
4. If you find conflicting or missing documentation, flag it to the Orchestrator

---

## Agent Team

The team has five roles that collaborate on every piece of work. Each role
is defined in `agents/<role>/AGENT.md`.

| Role | Focus | Key interactions |
|------|-------|-----------------|
| **Orchestrator** | Task breakdown, sequencing, coordination | Assigns work, routes decisions, synthesises outputs |
| **FE Engineer** | React/TypeScript frontend in ClientApp | Coordinates with BE on API contracts, notifies QE when ready |
| **BE Engineer** | C#/.NET backend, EF Core, APIs | Notifies FE of endpoint changes, loops in QE for test review |
| **PM** | Requirements, scope, acceptance criteria | Scopes work before assignment, defines "done" with QE |
| **QE** | Test strategy, coverage, quality validation | Reviews all code, validates against acceptance criteria |

### Collaboration Rules

1. **No solo work.** Every agent actively involves teammates whose area is affected.
2. **Contracts first.** FE and BE align on API contracts before implementing.
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

---

## MCP Servers

The `fawkes-docs` MCP server provides filesystem read access to the Fawkes
repository. It automatically discovers the Fawkes repo on your machine by
checking common locations (`~/Fawkes`, `~/repos/Fawkes`, `~/Desktop/Fawkes`,
etc.) and caches the result. To override, set the `FAWKES_REPO_PATH`
environment variable.
