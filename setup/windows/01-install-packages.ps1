Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host "🔵 installing packages via winget."
winget install --id Schniz.fnm -e --accept-package-agreements --accept-source-agreements
Write-Host "✅ packages installed!"
