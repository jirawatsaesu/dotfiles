# Jirawat's CLAUDE.md

Personal preferences for Claude Code across all projects.

## Response Style

- Respond in Thai when I write in Thai, English when I write in English
- Be concise — no trailing summaries, no restating what you just did
- Default to no comments in code unless the WHY is non-obvious

## MCP Servers

- **ClickUp** — task and time tracking
- **Figma** — design tool (token in `~/.claude/settings.json`)
- **Chrome DevTools** — browser automation

## Custom Skills

**Engineering** (`/eng:*`)
- `/eng:create-pr` — create a Bitbucket pull request from current branch
- `/eng:create-ticket` — create a ClickUp task in the current AutoGov sprint
- `/eng:daily-report` — daily meeting report from ClickUp time entries
- `/eng:weekly-report` — weekly engineer-to-engineer report from ClickUp time entries
- `/eng:monthly-report` — monthly C-level report from ClickUp time entries

**Content Creator** (`/creator:*`)
- `/creator:create-ref-sheet` — design concept sheet prompt for AI video preproduction (Stage 1)
- `/creator:create-story-board` — storyboard prompts for AI video production (Stage 2)

## Preferences

- Never commit without being asked explicitly
- Never push to remote without confirmation
- When working on frontend, start the dev server and verify in browser before reporting done
