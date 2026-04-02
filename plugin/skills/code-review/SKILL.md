---
name: code-review
description: Spawn the Order agent team to review a PR or set of changes from five angles — standards, domain logic, frontend, backend, and test coverage.
---

Spawn the Order of the Phoenix agent team to review the given PR or code changes.

## Team to spawn

Create all five agents with review-focused roles:

1. **PM** — Check changes match the ticket intent and acceptance criteria
2. **FE Engineer** — Review frontend code against project frontend standards
3. **BE Engineer** — Review backend code against project backend standards
4. **QE** — Check test coverage, identify missing edge cases, validate error handling
5. **Orchestrator** — Synthesise all feedback into a structured review

## Review workflow

1. All agents read the project's `.order.yml` and relevant standards for their area first
2. **PM** reviews the changes against the ticket/intent — are we building the right thing?
3. **FE Engineer** reviews frontend code for standards compliance, patterns, and conventions
4. **BE Engineer** reviews backend code for standards compliance, patterns, and data access
5. **QE** reviews test coverage, edge cases, error paths, and test identifiers
6. **Orchestrator** collects all feedback and produces a single structured review

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
