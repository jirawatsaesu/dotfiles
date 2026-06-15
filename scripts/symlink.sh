#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"

symlink() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -L "$dest" ]; then
    rm "$dest"
  elif [ -e "$dest" ]; then
    mv "$dest" "${dest}.bak"
    echo "Backed up: $dest → ${dest}.bak"
  fi
  ln -s "$src" "$dest"
  echo "Linked: $dest → $src"
}

# Claude
symlink "$DOTFILES/claude/commands"              "$HOME/.claude/commands"
symlink "$DOTFILES/claude/settings.json"         "$HOME/.claude/settings.json"
symlink "$DOTFILES/claude/statusline-command.sh" "$HOME/.claude/statusline-command.sh"

# Link each personal skill individually into ~/.claude/skills/
mkdir -p "$HOME/.claude/skills"
for skill_dir in "$DOTFILES/claude/skills"/*/; do
  skill_name=$(basename "$skill_dir")
  symlink "$skill_dir" "$HOME/.claude/skills/$skill_name"
done

# Link shippable 9arm-skills
if [ ! -f "$DOTFILES/claude/third-party/9arm-skills/skills/engineering/debug-mantra/SKILL.md" ]; then
  echo "Warning: 9arm-skills submodule not initialized. Run: git submodule update --init"
else
  for skill_dir in "$DOTFILES/claude/third-party/9arm-skills/skills"/*/*/; do
    [ -f "${skill_dir}SKILL.md" ] || continue
    skill_name=$(basename "$skill_dir")
    symlink "$skill_dir" "$HOME/.claude/skills/$skill_name"
  done
fi

# Git
symlink "$DOTFILES/git/.gitconfig"          "$HOME/.gitconfig"
symlink "$DOTFILES/git/.gitconfig-personal" "$HOME/.gitconfig-personal"
symlink "$DOTFILES/git/.gitconfig-coraline" "$HOME/.gitconfig-coraline"

# Zsh
symlink "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"

# Update statusLine in settings.json for macOS
# (settings.local.json is not honored for statusLine by Claude Code)
settings_file="$DOTFILES/claude/settings.json"
tmp=$(mktemp)
jq '.statusLine = {"type": "command", "command": "bash ~/.claude/statusline-command.sh"}' \
  "$settings_file" > "$tmp" && mv "$tmp" "$settings_file"
echo "Updated: statusLine in settings.json (macOS)"
