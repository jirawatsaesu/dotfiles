Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

fnm env --shell powershell | Out-String | Invoke-Expression
fnm use --install-if-missing lts-latest

# npx skills add installs relative to cwd, and the orchestrator's cwd is setup/, not $HOME
Set-Location $HOME

# `skills add` always re-clones and overwrites, even if already installed, so check first
$installedSkills = npx --yes skills list -g 2>$null | Out-String

function Test-SkillsInstalled {
  param([string[]]$Skills)
  foreach ($skill in $Skills) {
    if ($installedSkills -notmatch [regex]::Escape($skill)) {
      return $false
    }
  }
  return $true
}

if (Test-SkillsInstalled -Skills @("debug-mantra", "scrutinize", "post-mortem")) {
  Write-Host "[i] 9arm-skills already installed, skipping."
} else {
  Write-Host "[*] installing 9arm-skills."
  npx --yes skills add thananon/9arm-skills -s debug-mantra scrutinize post-mortem -a claude-code -g -y
  Write-Host "[ok] 9arm-skills installed!"
}

if (Test-SkillsInstalled -Skills @("grilling")) {
  Write-Host "[i] mattpocock-skills already installed, skipping."
} else {
  Write-Host "[*] installing mattpocock-skills."
  npx --yes skills add mattpocock/skills -s grilling -a claude-code -g -y
  Write-Host "[ok] mattpocock-skills installed!"
}
