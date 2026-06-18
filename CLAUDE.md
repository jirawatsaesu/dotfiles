# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository managed by [Chezmoi](https://www.chezmoi.io). Contains configuration for shell, git, and Claude Code across macOS and Windows.

## Directory Structure

- `dot_claude/` — Claude Code config, deployed to `~/.claude/`
  - `CLAUDE.md` — global Claude Code preferences (deployed to `~/.claude/CLAUDE.md`)
  - `settings.json.tmpl` — Claude Code settings with platform-specific statusLine
  - `executable_statusline-command.sh` — statusline script (macOS)
  - `statusline-command.ps1` — statusline script (Windows)
  - `exact_commands/` — custom skills, deployed to `~/.claude/commands/`
- `dot_gitconfig` → `~/.gitconfig`
- `dot_gitconfig-personal` → `~/.gitconfig-personal`
- `dot_gitconfig-coraline` → `~/.gitconfig-coraline`
- `dot_zshrc` → `~/.zshrc` (macOS only)
- `Documents/PowerShell/Microsoft.PowerShell_profile.ps1` → `~/Documents/PowerShell/...` (Windows only)
- `.chezmoiignore` — platform-specific file exclusions

## Chezmoi Conventions

- `dot_` prefix → files/dirs starting with `.` (e.g. `dot_zshrc` → `~/.zshrc`)
- `executable_` prefix → file is deployed with execute permission
- `exact_` prefix → target directory is managed exactly (extra files are removed)
- `.tmpl` extension → file is a Go template, processed before deployment

## Common Commands

```bash
# Apply all dotfiles
chezmoi apply

# Preview what would change
chezmoi diff

# Check what's out of sync
chezmoi status

# Re-apply after editing a source file
chezmoi apply
```

## Development Workflow

1. Edit source files in this repo directly
2. Run `chezmoi apply` to deploy changes
3. Platform-specific content lives in `settings.json.tmpl` — use `{{ if eq .chezmoi.os "windows" }}` for branching
4. Files not meant to be deployed (README.md, CLAUDE.md, .gitmodules) are listed in `.chezmoiignore`

## Platform Support

- **macOS**: zsh + Powerlevel10k, Claude statusline via bash script
- **Windows**: PowerShell profile, Claude statusline via PS1 script
- Shared: git config, Claude Code settings/commands
