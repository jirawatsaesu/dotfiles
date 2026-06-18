# Jirawat's dotfiles

Personal config for shell, git, and Claude Code — managed with [Chezmoi](https://www.chezmoi.io).

## Setup

**macOS**

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/jirawatsaesu/dotfiles/main/setup/macos.sh)
```

**Windows**

```powershell
irm https://raw.githubusercontent.com/jirawatsaesu/dotfiles/main/setup/windows.ps1 | iex
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
| `dot_claude/executable_statusline-command.sh` | `~/.claude/statusline-command.sh` | macOS |
| `dot_claude/statusline-command.ps1` | `~/.claude/statusline-command.ps1` | Windows |
| `dot_claude/exact_commands/` | `~/.claude/commands/` | both |
| `dot_claude/CLAUDE.md` | `~/.claude/CLAUDE.md` | both |

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
- `/creator:create-story-board` — storyboard prompts for AI video production

**Plugins** (installed via Claude Code marketplace)
- [andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) — coding principles
- [9arm-skills](https://github.com/thananon/9arm-skills) — debug-mantra, scrutinize, post-mortem, management-talk
