---
name: weekly-report
description: Generate a weekly engineer-to-engineer report from ClickUp time entries. Fetches tracked tasks for a given week, formats them with technical detail, saves as a .txt file, and opens it.
allowed-tools: [mcp__clickup__clickup_get_time_entries, mcp__clickup__clickup_find_member_by_name, Bash, Write]
---

# /weekly-report

Generate a Weekly Report for engineer-to-engineer review.

## Arguments

- **week** — the week to report on (optional; prompt if not provided)
- **project** — project name shown in the header (optional; infer from working directory)

## Steps

### 1. Resolve arguments and user

**Project name:**
Infer from the current working directory name (e.g. `/Users/coraline/coraline/auto-gov` → `auto-gov`). Only ask if the name is ambiguous or generic (e.g. `src`, `code`, `project`).

**Week:**
If `week` was not provided, ask:

> Which week to report on?
> 1. This week (Mon–today)
> 2. Last week (Mon–Fri)
> 3. Custom (YYYY-MM-DD to YYYY-MM-DD)

Resolve to a date range using `currentDate` from context:
- **This week** → Monday of the current week to today
- **Last week** → Monday to Friday of the previous week
- **Custom** → wait for the user to type a start and end date

Derive a **section label** based on the chosen option:
- This week → `This Week's Work`
- Last week → `Last Week's Work`
- Custom → `Work from {start_date} to {end_date}`

Resolve the current user via `mcp__clickup__clickup_find_member_by_name` using the user's email from context.

- **start_date** / **end_date** = the resolved week range (`YYYY-MM-DD`).
- **report_date** = today from context (`YYYY-MM-DD`).

### 2. Gather work context (two sources)

**Source A — ClickUp time entries:**
Call `mcp__clickup__clickup_get_time_entries` with:
- `start_date`: start_date
- `end_date`: end_date + ` 23:59`
- `assignee_id`: user ID from step 1

Group entries by task. **Exclude** any task that:
- Has status `backlog`
- Is a meeting/ceremony (task name contains: `meeting`, `daily`, `standup`, `planning`, `retro`, `review`, `sharing` — case-insensitive)

**Source B — conversation history:**
Scan the current conversation context for messages where the user described what they worked on, fixed, or investigated. Prefer these descriptions over ticket names where available.

**Merge:** For each ClickUp task, prefer the conversation history description if available. Otherwise infer from the ticket name.

### 3. Format the report

Group tasks by status in this order: `Done` → `In Review` → `In Progress`.

Use this template — all dates in `YYYY-MM-DD` format:

```
================================================
{project} | Weekly Report | {full_name} | {report_date}
================================================

{section_label} ({start_date} – {end_date})
----------------------------------------

[Done]
- {task name}
  {technical description of what was done and how}

[In Review]
- {task name}
  {technical description of what was done and what's pending review}

[In Progress]
- {task name}
  {technical description of current state and what remains}

Next Week's Plan
----------------------------------------
- {task name short} — {one-line intent}
```

**Tone:** engineer-to-engineer. Technical descriptions are encouraged — include what approach was taken, what was fixed, what remains. Keep each description to 1–2 lines max.

**Next Week's Plan:** include only `In Progress` tasks. Add a brief intent line per task (e.g. `finish implementation`, `open PR for review`, `investigate root cause`).

**Skip empty sections** — if there are no `In Review` tasks, omit the `[In Review]` block entirely.

### 4. Save the file

- Output directory: `reports/weekly/` relative to the current working directory. Create it if needed (`mkdir -p`).
- Filename: `{project_lowercase}_weekly-report_{start_date}-{end_date}.txt`
  - `project_lowercase` = project name lowercased, spaces → `-`

### 5. Open the file

Run `open {filepath}` via Bash.

### 6. Confirm

Reply with only the filepath.
