# fnm (Node version manager)
if (Get-Command fnm -ErrorAction SilentlyContinue) {
  fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression
}

# uv: always use uv-managed pythons, never a stray system/store python
$env:UV_PYTHON_PREFERENCE = "only-managed"

# PATH additions
$env:PATH = "$env:USERPROFILE\.local\bin;$env:PATH"

# History
Set-PSReadLineOption -MaximumHistoryCount 10000
Set-PSReadLineOption -HistoryNoDuplicates:$true

. "$HOME\.claude\cpm.ps1"
