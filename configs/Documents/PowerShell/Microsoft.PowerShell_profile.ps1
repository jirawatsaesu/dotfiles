# fnm (Node version manager)
if (Get-Command fnm -ErrorAction SilentlyContinue) {
  fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression
}

# PATH additions
$env:PATH = "$env:USERPROFILE\.local\bin;$env:PATH"

# History
Set-PSReadLineOption -MaximumHistoryCount 10000
Set-PSReadLineOption -HistoryNoDuplicates:$true

. "$HOME\.claude\cpm.ps1"
