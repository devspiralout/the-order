---
name: team-setup
description: Spawn the full Order agent team (Orchestrator, PM, QE, plus technical agents from .order.yml) for a feature ticket, piece of work, or any task that needs the full squad.
---

Spawn the full Order of the Phoenix agent team to handle the given task.

## Team to spawn

First, read the project's `.order.yml` to discover which technical agents are configured.

Always create these three core agents:

1. **Orchestrator** — Break down the task, coordinate the team, sequence dependencies
2. **PM** — Define acceptance criteria, scope, and trade-offs
3. **QE** — Define test plan, review coverage, validate the implementation

Then create one agent for **each technical agent** defined in the `team.agents` section
of `.order.yml`. For example:
- A project with `fe-engineer` and `be-engineer` gets two technical agents
- A project with a single `engineer` gets one technical agent
- A project with `engineer` and `infra-engineer` gets two technical agents

Use the `name`, `owns`, `stack`, `testing`, and `notes` fields from `.order.yml` to
brief each technical agent on their role.

## Workflow

Follow this sequence:

1. **Orchestrator** shares the task context with **PM**
2. **PM** defines scope, acceptance criteria, and any trade-offs
3. **Orchestrator** breaks the task into work items and assigns to technical agents
4. **QE** defines test plan based on PM's acceptance criteria (shift-left)
5. If multiple technical agents exist, they align on contracts/interfaces, then implement in parallel
6. Engineers share progress and pull each other in as needed
7. **QE** reviews test coverage, identifies gaps and edge cases
8. **PM** reviews against acceptance criteria
9. **Orchestrator** synthesises everything into the final deliverable

## Before starting

All agents MUST read the project's `.order.yml` to understand the tech stack, ownership areas, and project-specific conventions. Then use the `mcp__project-docs__*` tools to read the relevant standards for your role.

## The task

$ARGUMENTS
