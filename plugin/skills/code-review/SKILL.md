---
name: code-review
description: Spawn the Order agent team to review a PR or set of changes from multiple angles — standards, domain logic, and test coverage.
---

Spawn the Order of the Phoenix agent team to review the given PR or code changes.

## Team to spawn

First, read the project's `.order.yml` to discover which technical agents are configured.

Always create these three core agents with review-focused roles:

1. **PM** — Check changes match the ticket intent and acceptance criteria
2. **QE** — Check test coverage, identify missing edge cases, validate error handling
3. **Orchestrator** — Synthesise all feedback into a structured review

Then create one agent for **each technical agent** defined in the `team.agents` section
of `.order.yml`. Each reviews the code in their ownership area against project standards.

## Review workflow

1. All agents read the project's `.order.yml` and relevant standards for their area first
2. **PM** reviews the changes against the ticket/intent — are we building the right thing?
3. Each technical agent reviews code in their ownership area for standards compliance, patterns, and conventions
4. **QE** reviews test coverage, edge cases, error paths, and test identifiers
5. **Orchestrator** collects all feedback and produces a single structured review

## Review output format

The Orchestrator should produce a review with these sections:

- **Summary** — One-paragraph overview of the changes
- **Standards compliance** — Any deviations from project standards (with file/line references)
- **Logic concerns** — Potential bugs, edge cases, or incorrect behaviour
- **Test gaps** — Missing test coverage or untested paths
- **Suggestions** — Non-blocking improvements
- **Verdict** — Approve, request changes, or needs discussion

## The PR or changes to review

$ARGUMENTS
