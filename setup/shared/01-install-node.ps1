Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host "🟡 installing node lts via fnm."
fnm install --lts
# fnm install alone does not put node/npx on PATH for this process — activate explicitly
fnm env --shell powershell | Out-String | Invoke-Expression
fnm use --install-if-missing lts-latest
Write-Host "✅ node installed!"
