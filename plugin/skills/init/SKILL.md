---
name: init
description: First-time setup for The Order plugin. Explains features and configures dream mode preference (auto or manual).
---

Help the user configure The Order plugin for first use.

## What to do

1. Check if the project has an `.order.yml` file. If not, offer to help create
   one by scanning the project for signals (package.json, *.csproj, pyproject.toml,
   go.mod, Cargo.toml, etc.) and generating a draft. Show it to the user for review
   before writing it.

2. Explain the two dream modes:

   - **Auto** (`ORDER_AUTO_DREAM=true`): The team automatically consolidates
     learnings before each session ends. Good for teams that want continuous
     improvement without thinking about it.
   - **Manual** (`ORDER_AUTO_DREAM=false`): The user runs `/dream` when they
     want to consolidate. Good for users who want full control or only dream
     after substantial sessions.

3. Ask the user which mode they prefer.

4. Based on their choice, update `.claude/settings.local.json` to set the
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

5. Confirm the setup is complete and remind them of the available commands:
   - `/team-setup <task>` — full squad for feature work
   - `/code-review <PR>` — five-angle PR review
   - `/bug-investigation <bug>` — investigate and fix bugs
   - `/dream` — manually trigger dream consolidation

6. Create the initialisation flag:
   ```bash
   mkdir -p ~/.config/the-order && touch ~/.config/the-order/initialized
   ```
