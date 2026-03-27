---
name: dream
description: Consolidate session learnings into durable knowledge files. Run manually or triggered automatically at session end when auto-dream is enabled.
---

You are running the dream consolidation process. Your job is to review what
happened this session and distil non-obvious, reusable learnings into the
`knowledge/` directory.

## Step 1 — Review the session

Look back at everything that happened this session:
- What tasks were completed?
- What decisions were made and why?
- What standards were referenced from Fawkes?
- What surprises, gotchas, or edge cases were discovered?
- What review feedback was given?
- Were there any disagreements or trade-offs?
- Did any Fawkes docs turn out to be outdated, incomplete, or conflicting?

## Step 2 — Read existing knowledge

Read all files in the `knowledge/` directory to understand what's already been
captured. You don't want to duplicate or contradict existing learnings.

## Step 3 — Decide what to keep

For each potential learning, apply this filter:

**KEEP** if it is:
- Non-obvious — wouldn't be clear from just reading Fawkes docs
- Reusable — applies beyond this specific task
- Actionable — helps a future agent make a better decision

**UPDATE** if it:
- Refines, corrects, or adds nuance to an existing knowledge entry

**DISCARD** if it:
- Is task-specific with no general applicability
- Is already well-documented in Fawkes
- Is obvious to any experienced engineer

## Step 4 — Write knowledge files

Write or update files in the `knowledge/` directory. Use these categories:

| File | Contents |
|------|----------|
| `standards-map.md` | Which Fawkes standards apply to which areas, and gaps/conflicts found |
| `fe-patterns.md` | Frontend-specific learnings, gotchas, patterns that work |
| `be-patterns.md` | Backend-specific learnings, gotchas, patterns that work |
| `review-lessons.md` | Common review feedback, quality patterns to watch for |
| `gotchas.md` | Codebase-specific landmines and non-obvious behaviours |
| `doc-gaps.md` | Fawkes documentation that is missing, outdated, or conflicting |

Each entry in a knowledge file should follow this format:

```markdown
## Short descriptive title

<what was learned>

**Context:** <when/where this applies>
**Discovered:** <date>
```

## Step 5 — Mark dream as complete

Run this command to set the dream flag so the session can end:

```bash
touch /tmp/the-order-dream-done
```

## Step 6 — Summary

Output a brief summary of what was captured:
- How many new learnings were added
- How many existing entries were updated
- Any doc gaps flagged for the team

If there was nothing meaningful to capture this session, that's fine — say so
and still mark the dream as complete.
