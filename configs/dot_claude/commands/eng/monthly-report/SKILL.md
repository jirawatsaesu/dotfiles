---
name: monthly-report
description: Generate a monthly report for C-level from ClickUp time entries. Summarizes delivered work by theme, highlights outcomes and progress, saves as a .txt file, and opens it.
allowed-tools: [mcp__clickup__clickup_get_time_entries, mcp__clickup__clickup_find_member_by_name, Bash, Write]
---

# /monthly-report

Generate a Monthly Report for C-level audience.

## Arguments

- **month** — the month to report on (optional; prompt if not provided)
- **project** — project name shown in the header (optional; infer from working directory)

## Steps

### 1. Resolve arguments and user

**Project name:**
Infer from the current working directory name (e.g. `/Users/coraline/coraline/auto-gov` → `auto-gov`). Only ask if the name is ambiguous or generic (e.g. `src`, `code`, `project`).

**Month:**
If `month` was not provided, ask:

> Which month to report on?
> 1. This month (up to today)
> 2. Last month
> 3. Custom (YYYY-MM)

Resolve to a date range using `currentDate` from context:
- **This month** → first day of current month to today
- **Last month** → first to last day of the previous month
- **Custom** → derive first and last day from the given `YYYY-MM`

- **start_date** / **end_date** = resolved date range (`YYYY-MM-DD`).
- **report_month** = `YYYY-MM` of the reported month.
- **report_date** = today from context (`YYYY-MM-DD`).

Resolve the current user via `mcp__clickup__clickup_find_member_by_name` using the user's email from context.

### 2. Fetch time entries

Call `mcp__clickup__clickup_get_time_entries` with:
- `start_date`: start_date
- `end_date`: end_date + ` 23:59`
- `assignee_id`: user ID from step 1

Group entries by task. **Exclude** any task that:
- Has status `backlog`
- Is a meeting/ceremony (task name contains: `meeting`, `daily`, `standup`, `planning`, `retro`, `review`, `sharing` — case-insensitive)

Also check conversation history for context on what was actually delivered.

### 3. Format the report

Group tasks into **themes** — infer themes from task names (e.g. Authentication, User Management, Performance, Bug Fixes, Infrastructure). Each theme summarises related tasks into a single outcome statement — do not list individual tickets.

Sort themes by impact: delivered features first, then bug fixes, then improvements.

Use this template — dates in `YYYY-MM-DD` format:

```
================================================
{project} | Monthly Report | {full_name} | {report_date}
================================================

Summary — {report_month}
----------------------------------------
{2–3 sentence high-level summary of the month: what was shipped, overall progress, any notable outcomes}

Delivered
----------------------------------------
- {Theme}: {outcome statement — what was built/fixed and why it matters}

In Progress
----------------------------------------
- {Theme}: {current state and expected completion}

Next Month
----------------------------------------
- {Theme}: {planned focus or goal}
```

**Tone:** C-level audience — no technical jargon, no ticket names, no code identifiers. Focus on business outcomes, user impact, and delivery velocity. Each line should answer "so what?" not "what was done technically."

**In Progress:** tasks with status `in progress` or `in review`, grouped by theme.

**Next Month:** infer from `in progress` themes that won't finish this month.

**Skip empty sections** entirely.

### 4. Save the file

- Output directory: `reports/monthly/` relative to the current working directory. Create it if needed (`mkdir -p`).
- Filename: `{project_lowercase}_monthly-report_{report_month}.txt`
  - `project_lowercase` = project name lowercased, spaces → `-`

### 5. Open the file

Run `open {filepath}` via Bash.

### 6. Confirm

Reply with only the filepath.
