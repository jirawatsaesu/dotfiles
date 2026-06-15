[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$input_text = $input | Out-String
if (-not $input_text.Trim()) { exit 0 }
$data = $input_text | ConvertFrom-Json

function Make-Bar($pct) {
  $width = 10
  $filled = [int][Math]::Round($pct / 100 * $width)
  $empty  = $width - $filled
  ("$([string]::new([char]0x2588, $filled))$([string]::new([char]0x2591, $empty))")
}

function Format-ResetAt($epoch) {
  if (-not $epoch -or $epoch -eq "null") { return "" }
  $diff = $epoch - [int][DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
  if ($diff -le 0) { return "now" }
  $days  = [int]($diff / 86400)
  $hours = [int](($diff % 86400) / 3600)
  $mins  = [int](($diff % 3600) / 60)
  if ($days -gt 0) { "{0}d:{1:D2}h" -f $days, $hours }
  else             { "{0}h:{1:D2}m" -f $hours, $mins }
}

$fivePct   = $data.rate_limits.five_hour.used_percentage
$fiveReset = $data.rate_limits.five_hour.resets_at
$weekPct   = $data.rate_limits.seven_day.used_percentage
$weekReset = $data.rate_limits.seven_day.resets_at
$modelName = $data.model.display_name
$effort    = $data.effort.level
$rawCwd    = if ($data.workspace.current_dir) { $data.workspace.current_dir } elseif ($data.cwd) { $data.cwd } else { $PWD }
$cwdDisplay = Split-Path $rawCwd -Leaf
$ctxUsed   = $data.context_window.used_percentage

$accountCache = "$env:USERPROFILE\.claude\.account-cache"
$accountEmail = if (Test-Path $accountCache) { Get-Content $accountCache -Raw | ForEach-Object { $_.Trim() } } else { "" }

# Line 1: account | model | effort | cwd
$parts1 = @()
if ($accountEmail) { $parts1 += $accountEmail }
if ($modelName)    { $parts1 += $modelName }
if ($effort)       { $parts1 += $effort }
if ($cwdDisplay)   { $parts1 += $cwdDisplay }
if ($parts1) { $parts1 -join " | " }

# Line 2: context% | 5h bar | 7d bar
$parts2 = @()
if ($null -ne $ctxUsed) { $parts2 += "$([int][Math]::Round($ctxUsed))% context" }

if ($null -ne $fivePct) {
  $bar   = Make-Bar $fivePct
  $reset = Format-ResetAt $fiveReset
  $entry = "5h:[$bar]$([int][Math]::Round($fivePct))%"
  if ($reset) { $entry += " $reset" }
  $parts2 += $entry
}

if ($null -ne $weekPct) {
  $bar   = Make-Bar $weekPct
  $reset = Format-ResetAt $weekReset
  $entry = "7d:[$bar]$([int][Math]::Round($weekPct))%"
  if ($reset) { $entry += " $reset" }
  $parts2 += $entry
}

if ($parts2) { $parts2 -join " | " }
