#!/bin/bash
set -e

eval "$(fnm env)"
fnm use --install-if-missing lts-latest

echo "[*] installing 9arm-skills."
# npx skills add installs relative to cwd, and the orchestrator's cwd is setup/, not $HOME
cd "$HOME"
npx --yes skills add thananon/9arm-skills -s debug-mantra scrutinize post-mortem -a claude-code -g -y
echo "[ok] 9arm-skills installed!"
