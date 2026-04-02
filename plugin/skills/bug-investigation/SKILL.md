---
name: bug-investigation
description: Spawn the Order agent team to investigate, reproduce, fix, and regression-test a bug.
---

Spawn the Order of the Phoenix agent team to investigate and fix the given bug.

## Team to spawn

First, read the project's `.order.yml` to discover which technical agents are configured.

Always create these three core agents with investigation-focused roles:

1. **PM** — Clarify expected vs actual behaviour, define fix criteria
2. **QE** — Write a reproduction test case and define regression tests
3. **Orchestrator** — Coordinate the investigation and synthesise findings

Then create one agent for **each technical agent** defined in the `team.agents` section
of `.order.yml`. Each investigates the code in their ownership area.

## Investigation workflow

1. **PM** clarifies the expected behaviour vs what's actually happening
2. **Orchestrator** assigns investigation areas to technical agents based on where the bug likely lives
3. Technical agents investigate their respective areas in parallel
4. **QE** writes a reproduction test that demonstrates the bug
5. Engineers propose fixes, coordinating if the fix spans multiple areas
6. **QE** validates the fix and defines regression tests
7. **PM** confirms the fix matches expected behaviour
8. **Orchestrator** synthesises the root cause analysis and fix summary

## Output

The Orchestrator should produce:

- **Root cause** — What went wrong and why
- **Fix** — What was changed to resolve it
- **Regression tests** — What tests were added to prevent recurrence
- **Impact assessment** — What else might be affected

## The bug

$ARGUMENTS
