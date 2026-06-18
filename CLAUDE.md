# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository managed by [Chezmoi](https://www.chezmoi.io). Contains configuration for shell, git, and Claude Code across macOS and Windows.

## Directory Structure

Chezmoi source root is `configs/` (set via `.chezmoiroot`).

- `configs/dot_claude/` → `~/.claude/`
  - `CLAUDE.md` — global Claude Code preferences
  - `settings.json.tmpl` — platform-specific settings (statusLine injected via template)
  - `statusline-command.sh` — statusline script (macOS)
  - `statusline-command.ps1` — statusline script (Windows)
  - `commands/` → `~/.claude/commands/`
- `configs/dot_gitconfig` → `~/.gitconfig`
- `configs/dot_gitconfig-personal` → `~/.gitconfig-personal`
- `configs/dot_gitconfig-coraline` → `~/.gitconfig-coraline`
- `configs/dot_zshrc` → `~/.zshrc` (macOS only)
- `configs/Documents/PowerShell/Microsoft.PowerShell_profile.ps1` → `~/Documents/PowerShell/...` (Windows only)

## Chezmoi Conventions

- `dot_` prefix → deployed with `.` prefix (e.g. `dot_zshrc` → `~/.zshrc`)
- `.tmpl` extension → Go template, processed before deployment
- `.chezmoiignore` → files not deployed (README.md, CLAUDE.md, etc.)

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

1. Edit source files in `configs/` directly
2. Run `chezmoi apply` to deploy changes
3. Platform-specific content lives in `settings.json.tmpl` — use `{{ if eq .chezmoi.os "windows" }}` for branching
4. Files not meant to be deployed (README.md, CLAUDE.md, .gitmodules) are listed in `configs/.chezmoiignore`

## Bootstrap

One-line installation scripts live in `setup/`:
- `setup/macos.sh` — installs Homebrew, dependencies, then `chezmoi init --apply`
- `setup/windows.ps1` — installs winget packages, then `chezmoi init --apply`

## Platform Support

- **macOS**: zsh + Powerlevel10k, Claude statusline via bash script
- **Windows**: PowerShell profile, Claude statusline via PS1 script
- Shared: git config, Claude Code settings/commands
