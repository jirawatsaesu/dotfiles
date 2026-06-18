Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Install prerequisites
winget install --id twpayne.chezmoi -e --accept-package-agreements --accept-source-agreements
winget install --id Schniz.fnm -e --accept-package-agreements --accept-source-agreements

# Install Node LTS
fnm install --lts

# Apply dotfiles
chezmoi init --apply jirawatsaesu/dotfiles
