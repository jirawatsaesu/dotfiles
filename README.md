# dotfiles

Personal config files for shell, git, and Claude Code — all in one place.

## Setup on macOS

**1. Install Homebrew**
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/homebrew/install/HEAD/install.sh)"
```

**2. Install zsh and plugins**
```bash
brew install zsh powerlevel10k zsh-autosuggestions zsh-syntax-highlighting
```

Plugins:
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) — prompt theme
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) — fish-style suggestions
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) — command coloring

**3. Clone and apply dotfiles**
```bash
git clone git@github.com:YOUR_USERNAME/dotfiles.git ~/personal/dotfiles
cd ~/personal/dotfiles
git submodule update --init
chmod +x setup.sh
bash setup.sh
```

**4. Install fnm and Node** (required before opening a new shell — `.zshrc` uses it)

[fnm](https://github.com/Schniz/fnm) is a fast Node.js version manager (like nvm, but faster).
```bash
brew install fnm
fnm install --lts
```

**5. Set secrets in `~/.claude/settings.json`**
- Replace `YOUR_FIGMA_TOKEN_HERE` with your actual Figma token

## Setup on Windows

**Prerequisites**
- [Git for Windows](https://git-scm.com/download/win) — includes Git Bash, required for the Claude statusline (`bash` must be on PATH)
- Developer Mode enabled (`Settings → System → For developers`) — required for symlinks without admin rights

**1. Install fnm and Node**
```powershell
winget install Schniz.fnm
fnm install --lts
```

**2. Clone and apply dotfiles**
```powershell
git clone git@github.com:YOUR_USERNAME/dotfiles.git ~/personal/dotfiles
cd ~/personal/dotfiles
git submodule update --init
.\setup.ps1
```

**3. Set secrets in `~/.claude/settings.json`**
- Replace `YOUR_FIGMA_TOKEN_HERE` with your actual Figma token

**No Git Bash / bash not in PATH?** The statusline falls back gracefully (blank). To use the PowerShell statusline instead, create `~/.claude/settings.local.json`:
```json
{
  "statusLine": {
    "type": "command",
    "command": "powershell -File $env:USERPROFILE\\.claude\\statusline-command.ps1"
  }
}
```

## What's included

**Dotfiles**
| File | Symlinked to | Platform |
|---|---|---|
| `zsh/.zshrc` | `~/.zshrc` | macOS |
| `windows/Microsoft.PowerShell_profile.ps1` | `$PROFILE` | Windows |
| `git/.gitconfig` | `~/.gitconfig` | both |
| `git/.gitconfig-personal` | `~/.gitconfig-personal` | both |
| `git/.gitconfig-coraline` | `~/.gitconfig-coraline` | both |

**Claude Code**
| File | Symlinked to | Platform |
|---|---|---|
| `claude/commands/` | `~/.claude/commands/` | both |
| `claude/settings.json` | `~/.claude/settings.json` | both |
| `claude/statusline-command.sh` | `~/.claude/statusline-command.sh` | both |
| `claude/statusline-command.ps1` | `~/.claude/statusline-command.ps1` | Windows |
| `claude/skills/*/` | `~/.claude/skills/*/` (individual symlinks) | both |
| `claude/third-party/9arm-skills/skills/*/*/` | `~/.claude/skills/*/` (individual symlinks) | both |

## Software Engineer

**Commands** (`claude/commands/eng/`)
- `eng:create-pr` — create a pull request from current branch
- `eng:create-ticket` — create a ClickUp task in the current sprint
- `eng:daily-report` — generate a daily meeting report from ClickUp time entries
- `eng:weekly-report` — generate a weekly engineer report from ClickUp time entries
- `eng:monthly-report` — generate a monthly C-level report from ClickUp time entries

**Skills** (third-party, via [9arm-skills](https://github.com/thananon/9arm-skills) submodule)

Personal skills live in `claude/skills/`. Third-party skills are managed as git submodules in `claude/third-party/` — no separate installation needed, `setup.sh` (macOS) or `setup.ps1` (Windows) links everything automatically.

| Skill | Source |
|---|---|
| `debug-mantra` | [9arm-skills](https://github.com/thananon/9arm-skills) (submodule) |
| `post-mortem` | [9arm-skills](https://github.com/thananon/9arm-skills) (submodule) |
| `scrutinize` | [9arm-skills](https://github.com/thananon/9arm-skills) (submodule) |
| `management-talk` | [9arm-skills](https://github.com/thananon/9arm-skills) (submodule) |
| `create-pr` | personal |
| `create-ref-sheet` | personal |
| `create-story-board` | personal |

**Plugins** (installed via Claude Code's plugin system, not managed here)
- [andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) — coding principles

## Content Creator

**Commands** (`claude/commands/creator/`)
- `creator:create-ref-sheet` — generate a design concept sheet prompt for AI video preproduction
- `creator:create-story-board` — generate storyboard prompts for AI video production
