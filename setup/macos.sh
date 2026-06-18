#!/bin/bash
set -e

# Install Homebrew
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install prerequisites
brew install chezmoi fnm powerlevel10k zsh-autosuggestions zsh-syntax-highlighting

# Install Node LTS
fnm install --lts

# Apply dotfiles
chezmoi init --apply jirawatsaesu/dotfiles
