#!/bin/bash
set -e

eval "$(fnm env)"
fnm use --install-if-missing lts-latest

# npx skills add installs relative to cwd, and the orchestrator's cwd is setup/, not $HOME
cd "$HOME"

# `skills add` always re-clones and overwrites, even if already installed, so check first
installed_skills="$(npx --yes skills list -g 2>/dev/null)"

skills_installed() {
  for skill in "$@"; do
    grep -q "$skill" <<<"$installed_skills" || return 1
  done
}

if skills_installed debug-mantra scrutinize post-mortem; then
  echo "[i] 9arm-skills already installed, skipping."
else
  echo "[*] installing 9arm-skills."
  npx --yes skills add thananon/9arm-skills -s debug-mantra scrutinize post-mortem -a claude-code -g -y
  echo "[ok] 9arm-skills installed!"
fi

if skills_installed grilling; then
  echo "[i] mattpocock-skills already installed, skipping."
else
  echo "[*] installing mattpocock-skills."
  npx --yes skills add mattpocock/skills -s grilling -a claude-code -g -y
  echo "[ok] mattpocock-skills installed!"
fi
