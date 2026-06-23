---
name: daily-report
description: Generate a daily meeting report for Product Owner from ClickUp time entries. Fetches tracked tasks for a given date, formats them using the standard template, saves as a .txt file, and opens it.
allowed-tools: [mcp__clickup__clickup_get_time_entries, mcp__clickup__clickup_find_member_by_name, Bash, Write]
---

# /daily-report

Generate a daily report to share with the Product Owner.

## Arguments

- **date** — the date to report on (optional; prompt if not provided)
- **project** — project name shown in the header (optional; infer from working directory)

## Steps

### 1. Resolve arguments and user

**Project name:**
Infer from the current working directory name (e.g. `/Users/coraline/coraline/auto-gov` → `auto-gov`). Only ask if the name is ambiguous or generic (e.g. `src`, `code`, `project`).

**Date:**
If `date` was not provided, ask:

> What date to report on?
> 1. Today
> 2. Yesterday
> 3. Last Friday
> 4. Custom (YYYY-MM-DD)

Resolve to `YYYY-MM-DD` using `currentDate` from context:
- **Today** → today
- **Yesterday** → today − 1 day
- **Last Friday** → the most recent Friday before today
- **Custom** → wait for the user to type a `YYYY-MM-DD` date

Also derive a **section label** for the "work done" section based on the chosen option:
- Today → `Today's Work`
- Yesterday → `Yesterday's Work`
- Last Friday → `Last Friday's Work`
- Custom → `Work on {report_date}`

Resolve the current user via `mcp__clickup__clickup_find_member_by_name` using the user's email from context.

- **report_date** = the date work was done (`YYYY-MM-DD`).
- **meeting_date** = today from context (`YYYY-MM-DD`).

### 2. Gather work context (two sources)

**Source A — ClickUp time entries:**
Call `mcp__clickup__clickup_get_time_entries` with:
- `start_date`: report_date
- `end_date`: report_date + ` 23:59`
- `assignee_id`: user ID from step 1

Group entries by task. **Exclude** any task that:
- Has status `backlog`
- Is a meeting/ceremony (task name contains: `meeting`, `daily`, `standup`, `planning`, `retro`, `review`, `sharing` — case-insensitive)

**Source B — conversation history:**
Scan the current conversation context for any messages where the user described what they actually worked on, fixed, or investigated. This captures work described in the developer's own words rather than the ticket title.

**Merge:** For each ClickUp task, prefer the conversation history description if available — it reflects what was actually done. Otherwise infer from the ticket name.

### 3. Format the report

Sort tasks by status in this order: `Done` → `In Review` → `In Progress`.

Use this template — all dates in `YYYY-MM-DD` format:

```
================================================
{project} | Daily Report | {full_name} | {meeting_date}
================================================

{section_label} ({report_date})
----------------------------------------

- {task name}
  {description of what was actually done, in Thai}
  Status: {status label}

Today's Plan ({meeting_date})
----------------------------------------
- Continue working on: {task name short}
```

**Description language:** write the description in **Thai** (technical terms/names can stay in English inline, as naturally written). Everything else in the report (header, section labels, status labels, plan section) stays in English.

**Status label mapping:**
- `in progress` → `In Progress`
- `review` / `in review` → `In Review`
- `complete` / `done` → `Done`

**Plan section:** only tasks with status `in progress`. Format: `- Continue working on: {task name short}`.

**Tone:** short and informative for the Product Owner. Outcome-focused, no internal jargon.

### 4. Save the file

- Output directory: `reports/daily/` relative to the current working directory. Create it if needed (`mkdir -p`).
- Filename: `{project_lowercase}_daily-report_{report_date}.txt`
  - `project_lowercase` = project name lowercased, spaces → `-`

### 5. Open the file

Run `open {filepath}` via Bash.

### 6. Confirm

Reply with only the filepath.
