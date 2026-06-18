Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

winget install --id Schniz.fnm -e --accept-package-agreements --accept-source-agreements

fnm install --lts
