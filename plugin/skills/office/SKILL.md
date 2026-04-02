---
name: office
description: Launch the visual Office UI — an isometric pixel-art view of the agent team working, collaborating, and completing tasks in real-time.
---

Launch The Order's visual Office UI.

## What to do

1. Check if the UI server is already running:
   ```bash
   ./scripts/office-server.sh status
   ```

2. If not running, start it:
   ```bash
   ./scripts/office-server.sh start
   ```

3. Open the browser to the UI:
   ```bash
   open "http://localhost:${ORDER_UI_PORT:-3742}"
   ```

4. Enable the event emission hook by setting the environment variable:
   ```bash
   export ORDER_UI=true
   ```

   If `ORDER_UI` is not already set in the user's `.claude/settings.local.json`,
   offer to persist it:

   ```json
   {
     "env": {
       "ORDER_UI": "true"
     }
   }
   ```

5. Confirm the Office is running and explain:
   - The Office UI shows an isometric pixel-art office (Severance MDR × Habbo Hotel)
   - When you run `/team-setup`, `/code-review`, or `/bug-investigation`, agents
     appear as characters who walk through the door and sit at desks
   - Speech bubbles show what each agent is working on in real-time
   - When agents finish, they file out through the door
   - The UI stays open across multiple skill invocations in the same session
   - Run `/office` again any time to reopen the browser if you closed it

6. To stop the Office UI:
   ```bash
   ./scripts/office-server.sh stop
   ```
