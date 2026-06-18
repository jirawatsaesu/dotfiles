#!/bin/bash
set -e

if ! command -v brew &>/dev/null; then
  echo "[*] installing homebrew."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "[ok] homebrew installed!"
else
  echo "[i] homebrew is installed."
fi
