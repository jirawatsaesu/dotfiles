Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host "[*] installing packages via winget."
winget install --id Schniz.fnm -e --accept-package-agreements --accept-source-agreements
winget install --id Microsoft.PowerShell -e --accept-package-agreements --accept-source-agreements
Write-Host "[ok] packages installed!"
