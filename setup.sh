#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

"$DOTFILES/scripts/symlink.sh"

echo ""
echo "Done. Remember to set your FIGMA_TOKEN in ~/.claude/settings.json"
