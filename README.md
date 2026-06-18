# Jirawat's dotfiles

Personal config for shell, git, and Claude Code — managed with [Chezmoi](https://www.chezmoi.io).

## Setup

**macOS**

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply jirawatsaesu/dotfiles
```

**Windows**

1. Install chezmoi (adds it to PATH automatically):

```powershell
winget install twpayne.chezmoi
```

2. Clone and apply dotfiles:

```powershell
chezmoi init --apply jirawatsaesu/dotfiles
```

After setup, replace `YOUR_FIGMA_TOKEN_HERE` in `~/.claude/settings.json` with your actual token.

## What's included

| Source | Target | Platform |
|---|---|---|
| `dot_zshrc` | `~/.zshrc` | macOS |
| `Documents/PowerShell/Microsoft.PowerShell_profile.ps1` | `~/Documents/PowerShell/...` | Windows |
| `dot_gitconfig` | `~/.gitconfig` | both |
| `dot_gitconfig-personal` | `~/.gitconfig-personal` | both |
| `dot_gitconfig-coraline` | `~/.gitconfig-coraline` | both |
| `dot_claude/settings.json.tmpl` | `~/.claude/settings.json` | both |
| `dot_claude/statusline-command.sh` | `~/.claude/statusline-command.sh` | macOS |
| `dot_claude/statusline-command.ps1` | `~/.claude/statusline-command.ps1` | Windows |
| `dot_claude/commands/` | `~/.claude/commands/` | both |
| `dot_claude/CLAUDE.md` | `~/.claude/CLAUDE.md` | both |

## Testing in isolation

A `Dockerfile` lets you test chezmoi's file deployment (templating, `.chezmoiignore` rules, naming conventions) without touching a real machine:

```bash
docker build -t dotfiles-test .
docker run --rm -it dotfiles-test
```

This runs `chezmoi apply` inside a throwaway Linux container and drops you into a shell to inspect the result (`cat ~/.gitconfig`, `ls ~/.claude`, etc).

**Scope**: since this repo only targets macOS and Windows, Linux falls into neither platform branch — `.zshrc` and `statusline-command.sh`/`.ps1` won't deploy, and the bootstrap scripts under `setup/` won't run. This only verifies the platform-agnostic pieces (git config, Claude commands, `CLAUDE.md`, the rendered `settings.json`) actually template and land correctly — it's not a substitute for testing on a real macOS or Windows machine.

## Tools

- [Chezmoi](https://www.chezmoi.io) — dotfiles manager
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) — zsh prompt
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) — fish-style suggestions
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) — command coloring
- [fnm](https://github.com/Schniz/fnm) — Node.js version manager
- [Claude Code](https://claude.ai/code) — AI coding assistant

## Claude Code Skills

**Engineering**
- `/eng:create-pr` — create a Bitbucket pull request from current branch
- `/eng:create-ticket` — create a ClickUp task in the current sprint
- `/eng:daily-report` — daily meeting report from ClickUp time entries
- `/eng:weekly-report` — weekly engineer report from ClickUp time entries
- `/eng:monthly-report` — monthly C-level report from ClickUp time entries

**Content Creator**
- `/creator:create-ref-sheet` — design concept sheet prompt for AI video preproduction
- `/creator:create-storyboard` — storyboard prompts for AI video production

**Plugins** (installed via Claude Code marketplace)
- [andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) — coding principles

**Third-party skills** (installed via `npx skills add`, see `setup/shared/02-install-9arm-skills.sh`)
- [9arm-skills](https://github.com/thananon/9arm-skills) — debug-mantra, scrutinize, post-mortem (selected subset of the repo's 6 skills)
