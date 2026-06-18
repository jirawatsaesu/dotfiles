#!/bin/bash
set -e

if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew install fnm powerlevel10k zsh-autosuggestions zsh-syntax-highlighting

fnm install --lts
