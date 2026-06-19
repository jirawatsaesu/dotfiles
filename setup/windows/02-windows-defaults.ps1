Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host "[*] applying Windows defaults..."

# Windows Terminal: default to PowerShell 7 instead of legacy Windows PowerShell 5.1 -
# the dotfiles profile (Documents/PowerShell/...) and ~/.claude/cpm.ps1 it dot-sources
# are only deployed to the PowerShell 7 profile path.
# GUID is Windows Terminal's deterministic id for the built-in "Windows.Terminal.PowershellCore" dynamic profile.
$wtSettingsPath = Get-ChildItem "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState\settings.json" -ErrorAction SilentlyContinue |
    Select-Object -First 1 -ExpandProperty FullName
if ($wtSettingsPath) {
    $pwshGuid = '{574e775e-4f2a-5b96-ac1e-a2962a402336}'
    $pattern = '"defaultProfile":\s*"\{[0-9a-fA-F-]+\}"'
    $replacement = '"defaultProfile": "' + $pwshGuid + '"'
    $content = Get-Content $wtSettingsPath -Raw
    if ($content -notmatch [regex]::Escape($replacement)) {
        Set-Content $wtSettingsPath ($content -replace $pattern, $replacement) -NoNewline
        Write-Host "[ok] Windows Terminal default profile set to PowerShell 7."
    } else {
        Write-Host "[ok] Windows Terminal default profile already PowerShell 7."
    }
} else {
    Write-Host "[--] Windows Terminal settings.json not found, skipping."
}

Write-Host "[ok] Windows defaults applied!"
