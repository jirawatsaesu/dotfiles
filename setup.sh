#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

symlink() {
  local src="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    mv "$dest" "${dest}.bak"
    echo "Backed up: $dest → ${dest}.bak"
  fi
  ln -sf "$src" "$dest"
  echo "Linked: $dest → $src"
}

# Claude
symlink "$DOTFILES/claude/commands"              "$HOME/.claude/commands"
symlink "$DOTFILES/claude/settings.json"         "$HOME/.claude/settings.json"
symlink "$DOTFILES/claude/statusline-command.sh" "$HOME/.claude/statusline-command.sh"

# Git
symlink "$DOTFILES/git/.gitconfig"           "$HOME/.gitconfig"
symlink "$DOTFILES/git/.gitconfig-personal"  "$HOME/.gitconfig-personal"
symlink "$DOTFILES/git/.gitconfig-coraline"  "$HOME/.gitconfig-coraline"

# Zsh
symlink "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"

echo ""
echo "Done. Remember to set your FIGMA_TOKEN in ~/.claude/settings.json"
