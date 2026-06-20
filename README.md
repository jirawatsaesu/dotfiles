# Jirawat's dotfiles

Personal dotfiles and dev environment setup, managed with [Chezmoi](https://www.chezmoi.io).

## Setup

**macOS**

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply jirawatsaesu/dotfiles
```

**Windows**

```powershell
winget install twpayne.chezmoi
chezmoi init --apply jirawatsaesu/dotfiles
```

After setup, replace `YOUR_FIGMA_TOKEN_HERE` in `~/.claude/settings.json` with your actual token.

## Testing in isolation

A `Dockerfile` lets you test chezmoi's file deployment (templating, `.chezmoiignore` rules, naming conventions) without touching a real machine:

```bash
docker build -t dotfiles-test .
docker run --rm -it dotfiles-test
```

This runs `chezmoi apply` inside a throwaway Linux container and drops you into a shell to inspect the result (`cat ~/.gitconfig`, `ls ~/.claude`, etc).

**Scope**: since this repo only targets macOS and Windows, Linux falls into neither platform branch — `.zshrc` and `statusline-command.sh`/`.ps1` won't deploy, and the bootstrap scripts under `setup/` won't run. This only verifies the platform-agnostic pieces (git config, Claude commands, `CLAUDE.md`, the rendered `settings.json`) actually template and land correctly — it's not a substitute for testing on a real macOS or Windows machine.

## Tools

**Shell**

- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) — zsh prompt (macOS)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) — fish-style suggestions (macOS)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) — command coloring (macOS)
- [PowerShell 7](https://github.com/PowerShell/PowerShell) — default shell, set as Windows Terminal's default profile (Windows)

**Version managers**

- [Chezmoi](https://www.chezmoi.io) — dotfiles manager
- [fnm](https://github.com/Schniz/fnm) — Node.js version manager
- [uv](https://github.com/astral-sh/uv) — Python version & package manager

**Git**

- [Git](https://git-scm.com)
- [gh](https://cli.github.com) — GitHub CLI
- [Fork](https://git-fork.com) — Git GUI

**AI**

- [Claude Code](https://claude.ai/code) — AI coding assistant. See [`configs/dot_claude/CLAUDE.md`](configs/dot_claude/CLAUDE.md) for custom skills, plugins, and MCP servers.

**Dev tools**

- [VS Code](https://code.visualstudio.com)
- [Docker](https://www.docker.com)
- [Postman](https://www.postman.com)
- [TablePlus](https://tableplus.com)
- [DBeaver](https://dbeaver.io)
