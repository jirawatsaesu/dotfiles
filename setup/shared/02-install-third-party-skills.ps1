Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

fnm env --shell powershell | Out-String | Invoke-Expression
fnm use --install-if-missing lts-latest

# npx skills add installs relative to cwd, and the orchestrator's cwd is setup/, not $HOME
Set-Location $HOME

Write-Host "[*] installing 9arm-skills."
npx --yes skills add thananon/9arm-skills -s debug-mantra scrutinize post-mortem -a claude-code -g -y
Write-Host "[ok] 9arm-skills installed!"

Write-Host "[*] installing mattpocock-skills."
npx --yes skills add mattpocock/skills -s grill-me -a claude-code -g -y
Write-Host "[ok] mattpocock-skills installed!"
