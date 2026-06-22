# Claude Profile Manager
_CPM_PROFILES_DIR="$HOME/.claude-profiles"

_cpm_ensure_mcp() {
  local dir="$1" name="$2"; shift 2
  CLAUDE_CONFIG_DIR="$dir" claude mcp get "$name" >/dev/null 2>&1 && return
  CLAUDE_CONFIG_DIR="$dir" claude mcp add -s user "$name" "$@"
}

# MCP servers differ per profile — add a case below for any profile that needs them.
_cpm_provision_mcp() {
  local dir="$1" name="$2"
  case "$name" in
    coraline)
      _cpm_ensure_mcp "$dir" chrome-devtools -- npx chrome-devtools-mcp@latest
      _cpm_ensure_mcp "$dir" clickup --transport http https://mcp.clickup.com/mcp
      _cpm_ensure_mcp "$dir" figma --transport http https://mcp.figma.com/mcp
      ;;
  esac
}

_cpm_setup() {
  local name="${1:?usage: cpm setup <name>}"
  local dir="$_CPM_PROFILES_DIR/$name"
  mkdir -p "$dir"
  for f in settings.json CLAUDE.md; do
    [[ -f "$HOME/.claude/$f" && ! -f "$dir/$f" ]] && cp "$HOME/.claude/$f" "$dir/$f"
  done
  for d in commands skills agents plugins; do
    [[ -d "$HOME/.claude/$d" ]] && ln -sfn "$HOME/.claude/$d" "$dir/$d"
  done
  _cpm_provision_mcp "$dir" "$name"
  print "Profile '$name' created. Starting authentication..."
  CLAUDE_CONFIG_DIR="$dir" CLAUDE_PROFILE="$name" claude
}

_cpm_list() {
  [[ -d "$_CPM_PROFILES_DIR" ]] || { print "No profiles yet. Run: cpm setup <name>"; return }
  local dir name auth marker
  for dir in "$_CPM_PROFILES_DIR"/*/; do
    [[ -d "$dir" ]] || continue
    name="${${dir%/}##*/}"
    auth="installed"
    [[ -f "$dir/.credentials.json" ]] && auth="authenticated"
    marker="  "; [[ "$name" == "$CLAUDE_PROFILE" ]] && marker="* "
    printf "%s%-20s [%s]\n" "$marker" "$name" "$auth"
  done
}

_cpm_link() {
  local name="${1:?usage: cpm link <profile>}"
  print "$name" > .claude-profile
  if [[ -f .gitignore ]] && ! grep -qxF '.claude-profile' .gitignore 2>/dev/null; then
    print '.claude-profile' >> .gitignore
  fi
  print "Linked '$(pwd)' -> $name"
}

_cpm_remove() {
  local name="${1:?usage: cpm remove <name>}"
  local dir="$_CPM_PROFILES_DIR/$name"
  [[ -d "$dir" ]] || { print "[cpm] no profile '$name'"; return 1 }
  if [[ "$name" == "$CLAUDE_PROFILE" ]]; then
    unset CLAUDE_CONFIG_DIR CLAUDE_PROFILE
  fi
  rm -rf "$dir"
  print "Removed '$name'"
}

_cpm_unlink() { rm -f .claude-profile && print "Removed .claude-profile" }

_cpm_which() {
  if [[ -n "$CLAUDE_PROFILE" ]]; then
    print "profile:    $CLAUDE_PROFILE"
    print "config dir: $CLAUDE_CONFIG_DIR"
  else
    print "No active profile"
  fi
}

_cpm_doctor() {
  local ok=1
  [[ -d "$_CPM_PROFILES_DIR" ]] || { print "[FAIL] $_CPM_PROFILES_DIR does not exist"; return 1 }
  local dir name
  for dir in "$_CPM_PROFILES_DIR"/*/; do
    [[ -d "$dir" ]] || continue
    name="${${dir%/}##*/}"
    printf "-- %s\n" "$name"
    [[ -f "$dir.credentials.json" ]] \
      && print "  [ok] credentials present" \
      || print "  [--] not authenticated — run: cpm run $name"
    for d in commands skills agents plugins; do
      [[ -d "$HOME/.claude/$d" ]] || continue
      local link="${dir}${d}"
      if [[ -L "$link" && -d "$link" ]]; then
        print "  [ok] $d symlink"
      elif [[ -e "$link" ]]; then
        print "  [!!] $d symlink broken — run: cpm setup $name"; ok=0
      fi
    done
  done
  (( ok )) && print "\nAll checks passed." || print "\nSome checks failed."
}

_cpm_help() {
  print "cpm — Claude Profile Manager"
  print ""
  print "Usage: cpm <command> [args]"
  print ""
  print "Commands:"
  print "  setup <name>    Create a new profile and authenticate"
  print "  list            List all profiles with auth status"
  print "  remove <name>   Delete a profile and its credentials"
  print "  link <name>     Tag current directory with a profile (.claude-profile)"
  print "  unlink          Remove .claude-profile from current directory"
  print "  which           Show the active profile and config dir"
  print "  doctor          Check for broken symlinks and missing credentials"
  print "  help            Show this message"
}

# Auto-switch: walk up dirs to find .claude-profile, set or clear env vars
_cpm_autoswitch() {
  local quiet="$1"
  local dir="$PWD" name=""
  while [[ "$dir" != "/" ]]; do
    [[ -f "$dir/.claude-profile" ]] && { name="$(<"$dir/.claude-profile")"; break }
    dir="${dir:h}"
  done
  if [[ -n "$name" ]]; then
    if [[ "$name" != "$CLAUDE_PROFILE" ]]; then
      if [[ ! -d "$_CPM_PROFILES_DIR/$name" ]]; then
        [[ -n "$quiet" ]] || print "[cpm] unknown profile '$name' — run: cpm setup $name"
        return
      fi
      export CLAUDE_CONFIG_DIR="$_CPM_PROFILES_DIR/$name"
      export CLAUDE_PROFILE="$name"
      [[ -n "$quiet" ]] || print "[cpm] $name"
    fi
  elif [[ -n "$CLAUDE_PROFILE" ]]; then
    unset CLAUDE_CONFIG_DIR CLAUDE_PROFILE
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd _cpm_autoswitch
_cpm_autoswitch quiet

# Optional p10k segment — silent unless you add 'custom_cpm' to POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS
function prompt_custom_cpm { [[ -n $CLAUDE_PROFILE ]] && p10k segment -f 170 -t "$CLAUDE_PROFILE" }

cpm() {
  case "${1:-help}" in
    setup)        _cpm_setup  "${@:2}" ;;
    list)         _cpm_list            ;;
    remove)       _cpm_remove "${@:2}" ;;
    link)         _cpm_link   "${@:2}" ;;
    unlink)       _cpm_unlink          ;;
    which)        _cpm_which           ;;
    doctor)       _cpm_doctor          ;;
    help|--help|-h) _cpm_help          ;;
    *)            print "unknown command: $1"; _cpm_help ;;
  esac
}
