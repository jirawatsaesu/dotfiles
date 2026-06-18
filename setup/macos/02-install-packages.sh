#!/bin/bash
set -e

echo "🟣 installing packages from Brewfile."
cd "$(dirname "${BASH_SOURCE[0]}")"
brew bundle install
echo "✅ packages installed!"
