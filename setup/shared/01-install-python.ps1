Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host "[*] installing python (latest stable) via uv."
# pre-installs latest CPython so the first `uv run` is fast; use `uv run` / `uv venv` per project
uv python install
Write-Host "[ok] python installed!"
