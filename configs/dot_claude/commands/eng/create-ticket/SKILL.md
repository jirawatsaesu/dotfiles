---
name: create-ticket
description: Create a ClickUp task in Internal Product > AutoGov Sprint. Always fetches the latest sprint from folder 90162961868. Accepts task name, description, priority, sprint number, assignee, and tags as arguments. Defaults to the latest sprint, assigned to me, with no tag.
allowed-tools: [mcp__clickup__clickup_get_folder, mcp__clickup__clickup_create_task, mcp__clickup__clickup_resolve_assignees]
---

# /create-ticket

Create a ClickUp task in **Internal Product → AutoGov Sprint** (folder ID: `90162961868`).

## Steps

### 1. Parse arguments

Extract from the user's message:
- **name** — task title (required; ask if not provided)
- **description** — task body (optional; use context to write a sensible one)
- **sprint** — sprint number (optional; omit to use the latest)
- **priority** — `urgent` / `high` / `normal` / `low` (optional; default `normal`)
- **assignee** — name, email, or `me` (optional; default `me`)
- **tags** — comma-separated tag names (optional)

### 2. Fetch the target sprint + resolve assignee (run in parallel)

**2a.** Call `mcp__clickup__clickup_get_folder` with `folder_id: "90162961868"` to get the folder's lists.

Pick the target list from the result:

```python
import re

lists = <folder_result>.get('lists', [])

def sprint_num(s):
    m = re.search(r'Sprint (\d+)', s.get('name', ''))
    return int(m.group(1)) if m else 0

sprint_arg = None  # replace with parsed sprint number if provided

if sprint_arg:
    target = next((l for l in lists if sprint_num(l) == sprint_arg), None)
else:
    target = max(lists, key=sprint_num)

print(target['name'], target['id'])
```

**2b.** Call `mcp__clickup__clickup_resolve_assignees` with `["me"]` (or the specified name/email).

### 3. Create the task

Call `mcp__clickup__clickup_create_task` with:
- `list_id` from step 2a
- `name`, `priority`, `markdown_description`
- `assignees` from step 2b
- `tags` (if any)

### 4. Confirm

Reply with the task name, sprint name, and the ClickUp URL.
