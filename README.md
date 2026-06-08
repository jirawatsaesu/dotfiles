# dotfiles

Personal config files for shell, git, and Claude Code — all in one place.

## Setup on a new machine

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
git clone git@github.com:YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x setup.sh
./setup.sh
```

**4. Install fnm and Node** (required before opening a new shell — `.zshrc` uses it)
```bash
brew install fnm
fnm install --lts
```

**5. Set secrets in `~/.claude/settings.json`**
- Replace `YOUR_FIGMA_TOKEN_HERE` with your actual Figma token

## What's included

**Dotfiles**
| File | Symlinked to |
|---|---|
| `zsh/.zshrc` | `~/.zshrc` |
| `git/.gitconfig` | `~/.gitconfig` |

**Claude Code**
| File | Symlinked to |
|---|---|
| `claude/commands/` | `~/.claude/commands/` |
| `claude/settings.json` | `~/.claude/settings.json` |
| `claude/statusline-command.sh` | `~/.claude/statusline-command.sh` |

## Software Engineer

**Commands**
- `create-pr` — create a pull request from current branch

**Skills** (installation required)
- [9arm-skills](https://github.com/thananon/9arm-skills) — skills for engineering, productivity, and development workflows
- [andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) — coding principles

## Content Creator

**Commands**
- `create-ref-sheet` — generate a design concept sheet prompt for AI video preproduction
- `create-story-board` — generate storyboard prompts for AI video production
