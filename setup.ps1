$ErrorActionPreference = "Stop"
$DOTFILES = $PSScriptRoot

& "$DOTFILES\scripts\symlink.ps1"

Write-Host ""
Write-Host "Done. Remember to set your FIGMA_TOKEN in ~/.claude/settings.json"
