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

**3. Clone and apply dotfiles**
```bash
git clone git@github.com:YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x setup.sh
./setup.sh
```

**4. Set secrets in `~/.claude/settings.json`**
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

## zsh plugins

Managed via Homebrew — update with `brew upgrade`:

- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) — prompt theme
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) — fish-style suggestions
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) — command coloring

## Node version manager

Uses [fnm](https://github.com/Schniz/fnm) (fast, Rust-based) instead of nvm.

```bash
brew install fnm
```

## Claude skills

**Software Engineer**

Custom skills in `claude/skills/`:
- `create-pr` — create a pull request from current branch

Install these separately via Claude Code plugins:
- [9arm-skills](https://github.com/thananon/9arm-skills) — skills for engineering, productivity, and development workflows
- [andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) — coding principles

**Content Creator**

Custom skills in `claude/skills/`:
- `create-ref-sheet` — generate a design concept sheet prompt for AI video preproduction
- `create-story-board` — generate storyboard prompts for AI video production
