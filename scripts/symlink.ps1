$ErrorActionPreference = "Stop"
$DOTFILES = (Resolve-Path "$PSScriptRoot\..").Path

function Symlink($src, $dest) {
  $parent = Split-Path $dest
  if ($parent) { New-Item -ItemType Directory -Force $parent | Out-Null }

  if (Test-Path $dest) {
    $item = Get-Item $dest -Force
    if ($item.LinkType -eq "SymbolicLink") {
      if ($item.PSIsContainer) {
        [System.IO.Directory]::Delete($dest)
      } else {
        Remove-Item $dest -Force
      }
    } else {
      $bak = "${dest}.bak"
      Move-Item $dest $bak
      Write-Host "Backed up: $dest -> $bak"
    }
  }

  New-Item -ItemType SymbolicLink -Path $dest -Target $src | Out-Null
  Write-Host "Linked: $dest -> $src"
}

# Claude
Symlink "$DOTFILES\claude\commands"               "$env:USERPROFILE\.claude\commands"
Symlink "$DOTFILES\claude\settings.json"          "$env:USERPROFILE\.claude\settings.json"
Symlink "$DOTFILES\claude\statusline-command.sh"  "$env:USERPROFILE\.claude\statusline-command.sh"
Symlink "$DOTFILES\claude\statusline-command.ps1" "$env:USERPROFILE\.claude\statusline-command.ps1"

# Personal skills
New-Item -ItemType Directory -Force "$env:USERPROFILE\.claude\skills" | Out-Null
foreach ($skillDir in Get-ChildItem "$DOTFILES\claude\skills" -Directory -ErrorAction SilentlyContinue) {
  Symlink $skillDir.FullName "$env:USERPROFILE\.claude\skills\$($skillDir.Name)"
}

# 9arm-skills submodule
$sentinel = "$DOTFILES\claude\third-party\9arm-skills\skills\engineering\debug-mantra\SKILL.md"
if (-not (Test-Path $sentinel)) {
  Write-Host "Warning: 9arm-skills submodule not initialized. Run: git submodule update --init"
} else {
  foreach ($skillDir in Get-ChildItem "$DOTFILES\claude\third-party\9arm-skills\skills" -Recurse -Directory) {
    if (Test-Path "$($skillDir.FullName)\SKILL.md") {
      Symlink $skillDir.FullName "$env:USERPROFILE\.claude\skills\$($skillDir.Name)"
    }
  }
}

# Git
Symlink "$DOTFILES\git\.gitconfig"          "$env:USERPROFILE\.gitconfig"
Symlink "$DOTFILES\git\.gitconfig-personal" "$env:USERPROFILE\.gitconfig-personal"
Symlink "$DOTFILES\git\.gitconfig-coraline" "$env:USERPROFILE\.gitconfig-coraline"

# PowerShell profile (Windows shell config)
Symlink "$DOTFILES\windows\Microsoft.PowerShell_profile.ps1" $PROFILE

# Write statusLine to settings.local.json (machine-specific, not tracked)
$localSettings = "$env:USERPROFILE\.claude\settings.local.json"
$cmd = "powershell -NoProfile -File $env:USERPROFILE\.claude\statusline-command.ps1" -replace '\\', '/'
$statusLine = [PSCustomObject]@{ type = "command"; command = $cmd }
if (Test-Path $localSettings) {
  $obj = Get-Content $localSettings -Raw | ConvertFrom-Json
  $obj | Add-Member -NotePropertyName statusLine -NotePropertyValue $statusLine -Force
} else {
  $obj = [PSCustomObject]@{ statusLine = $statusLine }
}
[System.IO.File]::WriteAllText($localSettings, ($obj | ConvertTo-Json -Depth 10), [System.Text.UTF8Encoding]::new($false))
Write-Host "Updated: statusLine in settings.local.json (Windows)"
