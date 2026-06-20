Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$failed = @()

function Install-Pkg($id) {
  # skip if already installed so onchange re-runs don't report false failures
  winget list --id $id -e --source winget *> $null
  if ($LASTEXITCODE -eq 0) {
    Write-Host "[i] $id already installed, skipping."
    return
  }
  winget install --id $id -e --source winget --accept-package-agreements --accept-source-agreements
  if ($LASTEXITCODE -ne 0) {
    Write-Warning "[!!] failed to install $id (exit $LASTEXITCODE)"
    $script:failed += $id
  }
}

Write-Host "[*] installing packages via winget."

# Shell
Install-Pkg "Microsoft.PowerShell"

# Version managers
Install-Pkg "Schniz.fnm"
Install-Pkg "astral-sh.uv"

# Git
Install-Pkg "Git.Git"
Install-Pkg "GitHub.cli"

# Dev tools
Install-Pkg "Microsoft.VisualStudioCode"
Install-Pkg "Docker.DockerDesktop"
Install-Pkg "Postman.Postman"
Install-Pkg "Fork.Fork" # Git GUI
Install-Pkg "TablePlus.TablePlus"
Install-Pkg "DBeaver.DBeaver.Community"

# Productivity
Install-Pkg "Google.Chrome"
Install-Pkg "Discord.Discord"

if ($failed.Count -gt 0) {
  Write-Warning "[!!] failed to install: $($failed -join ', ')"
  exit 1
}
Write-Host "[ok] packages installed!"
