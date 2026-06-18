#!/bin/bash
set -e

echo "[*] installing packages from Brewfile."
cd "$(dirname "${BASH_SOURCE[0]}")"
brew bundle install
echo "[ok] packages installed!"

# Remove temporary chezmoi binary installed by one-liner (now replaced by brew)
if [ -f "$HOME/.local/bin/chezmoi" ]; then
  rm "$HOME/.local/bin/chezmoi"
  echo "[ok] removed temporary chezmoi from ~/.local/bin/"
fi
