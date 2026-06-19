# Claude Profile Manager
$env:CPM_PROFILES_DIR = "$env:USERPROFILE\.claude-profiles"

function _cpm_setup {
    param([Parameter(Mandatory)][string]$Name)
    $dir = "$env:CPM_PROFILES_DIR\$Name"
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    foreach ($f in @('settings.json', 'CLAUDE.md')) {
        $src = "$env:USERPROFILE\.claude\$f"
        $dst = "$dir\$f"
        if ((Test-Path $src) -and -not (Test-Path $dst)) { Copy-Item $src $dst }
    }
    foreach ($d in @('commands', 'skills', 'agents', 'plugins')) {
        $src = "$env:USERPROFILE\.claude\$d"
        if (Test-Path $src) {
            $link = "$dir\$d"
            if (Test-Path $link) { Remove-Item $link -Force -Recurse }
            New-Item -ItemType Junction -Path $link -Target $src | Out-Null
        }
    }
    Write-Host "Profile '$Name' created. Starting authentication..."
    $prevDir = $env:CLAUDE_CONFIG_DIR; $prevProf = $env:CLAUDE_PROFILE
    $env:CLAUDE_CONFIG_DIR = $dir; $env:CLAUDE_PROFILE = $Name
    try { claude } finally { $env:CLAUDE_CONFIG_DIR = $prevDir; $env:CLAUDE_PROFILE = $prevProf }
}

function _cpm_list {
    if (-not (Test-Path $env:CPM_PROFILES_DIR)) { Write-Host "No profiles yet."; return }
    Get-ChildItem $env:CPM_PROFILES_DIR -Directory | ForEach-Object {
        $name = $_.Name
        $status = if (Test-Path "$($_.FullName)\.credentials.json") { "authenticated" } else { "installed" }
        $marker = if ($name -eq $env:CLAUDE_PROFILE) { "* " } else { "  " }
        "{0}{1,-20} [{2}]" -f $marker, $name, $status
    }
}

function _cpm_link {
    param([Parameter(Mandatory)][string]$Name)
    Set-Content '.claude-profile' $Name
    if ((Test-Path '.gitignore') -and -not (Select-String -Quiet '\.claude-profile' '.gitignore')) {
        Add-Content '.gitignore' '.claude-profile'
    }
    Write-Host "Linked '$(Get-Location)' -> $Name"
}

function _cpm_remove {
    param([Parameter(Mandatory)][string]$Name)
    $dir = "$env:CPM_PROFILES_DIR\$Name"
    if (-not (Test-Path $dir)) { Write-Host "[cpm] no profile '$Name'"; return }
    if ($Name -eq $env:CLAUDE_PROFILE) {
        $env:CLAUDE_CONFIG_DIR = $null; $env:CLAUDE_PROFILE = $null
    }
    Remove-Item $dir -Recurse -Force
    Write-Host "Removed '$Name'"
}

function _cpm_unlink {
    if (Test-Path '.claude-profile') { Remove-Item '.claude-profile'; Write-Host "Removed .claude-profile" }
}

function _cpm_which {
    if ($env:CLAUDE_PROFILE) {
        Write-Host "profile:    $env:CLAUDE_PROFILE"
        Write-Host "config dir: $env:CLAUDE_CONFIG_DIR"
    } else { Write-Host "No active profile" }
}

function _cpm_doctor {
    if (-not (Test-Path $env:CPM_PROFILES_DIR)) { Write-Host "[FAIL] profiles dir missing"; return }
    Get-ChildItem $env:CPM_PROFILES_DIR -Directory | ForEach-Object {
        $name = $_.Name; $dir = $_.FullName
        Write-Host "-- $name"
        if (Test-Path "$dir\.credentials.json") { Write-Host "  [ok] credentials present" }
        else                                     { Write-Host "  [--] not authenticated — run: cpm run $name" }
        foreach ($d in @('commands', 'skills', 'agents', 'plugins')) {
            $link = "$dir\$d"
            if (Test-Path "$env:USERPROFILE\.claude\$d") {
                $item = Get-Item $link -ErrorAction SilentlyContinue
                if ($item -and $item.LinkType -eq 'Junction') { Write-Host "  [ok] $d junction" }
                elseif (Test-Path $link)                      { Write-Host "  [!!] $d junction broken" }
            }
        }
    }
}

function _cpm_help {
    Write-Host "cpm - Claude Profile Manager"
    Write-Host ""
    Write-Host "Usage: cpm <command> [args]"
    Write-Host ""
    Write-Host "Commands:"
    Write-Host "  setup <name>    Create a new profile and authenticate"
    Write-Host "  list            List all profiles with auth status"
    Write-Host "  remove <name>   Delete a profile and its credentials"
    Write-Host "  link <name>     Tag current directory with a profile (.claude-profile)"
    Write-Host "  unlink          Remove .claude-profile from current directory"
    Write-Host "  which           Show the active profile and config dir"
    Write-Host "  doctor          Check for broken symlinks and missing credentials"
    Write-Host "  help            Show this message"
}

# Auto-switch via prompt hook (checks for directory change on each prompt render)
$global:_CpmLastDir = ""
$global:_CpmOriginalPrompt = $function:prompt

function _cpm_autoswitch {
    $dir = $PWD.Path; $found = $null
    while ($dir -and $dir -ne [IO.Path]::GetPathRoot($dir)) {
        $pf = Join-Path $dir '.claude-profile'
        if (Test-Path $pf) { $found = (Get-Content $pf).Trim(); break }
        $dir = Split-Path $dir
    }
    if ($found) {
        if ($found -ne $env:CLAUDE_PROFILE) {
            $profileDir = "$env:CPM_PROFILES_DIR\$found"
            if (-not (Test-Path $profileDir)) { Write-Host "[cpm] unknown profile '$found' — run: cpm setup $found" }
            else {
                $env:CLAUDE_CONFIG_DIR = $profileDir
                $env:CLAUDE_PROFILE = $found
                Write-Host "[cpm] $found"
            }
        }
    } elseif ($env:CLAUDE_PROFILE) {
        $env:CLAUDE_CONFIG_DIR = $null; $env:CLAUDE_PROFILE = $null
    }
}

function prompt {
    if ($global:_CpmLastDir -ne $PWD.Path) {
        $global:_CpmLastDir = $PWD.Path
        _cpm_autoswitch
    }
    & $global:_CpmOriginalPrompt
}

function cpm {
    switch ($args[0]) {
        'setup'               { _cpm_setup  $args[1] }
        'list'                { _cpm_list            }
        'remove'              { _cpm_remove $args[1] }
        'link'                { _cpm_link   $args[1] }
        'unlink'              { _cpm_unlink           }
        'which'               { _cpm_which            }
        'doctor'              { _cpm_doctor           }
        { $_ -in @('help', '--help', '-h') } { _cpm_help }
        default               { Write-Host "unknown command: $($args[0])"; _cpm_help }
    }
}
