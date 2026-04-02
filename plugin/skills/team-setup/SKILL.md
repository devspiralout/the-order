---
name: team-setup
description: Spawn the full Order agent team (Orchestrator, PM, FE, BE, QE) for a feature ticket, piece of work, or any task that needs the full squad.
---

Spawn the full Order of the Phoenix agent team to handle the given task.

## Team to spawn

Create all five agents with these roles:

1. **Orchestrator** — Break down the task, coordinate the team, sequence dependencies
2. **PM** — Define acceptance criteria, scope, and trade-offs
3. **FE Engineer** — Implement frontend changes
4. **BE Engineer** — Implement backend changes
5. **QE** — Define test plan, review coverage, validate the implementation

## Workflow

Follow this sequence:

1. **Orchestrator** shares the task context with **PM**
2. **PM** defines scope, acceptance criteria, and any trade-offs
3. **Orchestrator** breaks the task into work items and assigns to **FE** and **BE**
4. **QE** defines test plan based on PM's acceptance criteria (shift-left)
5. **FE** and **BE** align on API contracts, then implement in parallel
6. Engineers share progress and pull each other in as needed
7. **QE** reviews test coverage, identifies gaps and edge cases
8. **PM** reviews against acceptance criteria
9. **Orchestrator** synthesises everything into the final deliverable

## Before starting

All agents MUST read the project's `.order.yml` to understand the tech stack, ownership areas, and project-specific conventions. Then use the `mcp__project-docs__*` tools to read the relevant standards for your role.

## The task

$ARGUMENTS
