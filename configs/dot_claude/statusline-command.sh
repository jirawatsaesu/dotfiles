#!/bin/sh
input=$(cat)

# Build a visual bar: filled_chars out of 10
make_bar() {
  pct="$1"
  width=10
  filled=$(awk "BEGIN { printf \"%d\", ($pct / 100) * $width + 0.5 }")
  empty=$((width - filled))
  bar=""
  i=0
  while [ $i -lt $filled ]; do bar="${bar}█"; i=$((i+1)); done
  i=0
  while [ $i -lt $empty ];  do bar="${bar}░"; i=$((i+1)); done
  printf "%s" "$bar"
}

# Format reset epoch as countdown: "2h:15m" (h:mm) or "4d:06h" (d:hh)
format_reset_at() {
  epoch="$1"
  if [ -z "$epoch" ] || [ "$epoch" = "null" ]; then return; fi
  now=$(date +%s)
  diff=$((epoch - now))
  if [ "$diff" -le 0 ]; then
    printf "now"
    return
  fi
  days=$((diff / 86400))
  hours=$(( (diff % 86400) / 3600 ))
  mins=$(( (diff % 3600) / 60 ))
  if [ "$days" -gt 0 ]; then
    printf "%dd:%02dh" "$days" "$hours"
  else
    printf "%dh:%02dm" "$hours" "$mins"
  fi
}

five_pct=$(echo "$input"    | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_reset=$(echo "$input"  | jq -r '.rate_limits.five_hour.resets_at // empty')
week_pct=$(echo "$input"    | jq -r '.rate_limits.seven_day.used_percentage // empty')
week_reset=$(echo "$input"  | jq -r '.rate_limits.seven_day.resets_at // empty')
model_name=$(echo "$input"  | jq -r '.model.display_name // empty')
effort=$(echo "$input"      | jq -r '.effort.level // empty')
raw_cwd=$(echo "$input"     | jq -r '.workspace.current_dir // .cwd // empty')
[ -z "$raw_cwd" ] && raw_cwd="$PWD"
home_dir="$HOME"
cwd_display=$(basename "$raw_cwd")
ctx_used=$(echo "$input"    | jq -r '.context_window.used_percentage // empty')

# Line 1: model | effort | cwd
line1=""
[ -n "$model_name" ] && line1="${model_name}"
[ -n "$effort" ] && line1="${line1} | ${effort}"
[ -n "$cwd_display" ] && line1="${line1} | ${cwd_display}"
[ -n "$line1" ] && printf "%s\n" "$line1"

# Line 2: context% | 5h and 7d on the same line, separated by " | "
line2=""

if [ -n "$ctx_used" ]; then
  ctx_label=$(printf '%.0f' "$ctx_used")
  line2="${ctx_label}% context"
fi

if [ -n "$five_pct" ]; then
  bar=$(make_bar "$five_pct")
  pct_label=$(printf '%.0f' "$five_pct")
  reset_label=$(format_reset_at "$five_reset")
  entry="5h:[${bar}]${pct_label}%"
  [ -n "$reset_label" ] && entry="${entry} ${reset_label}"
  if [ -n "$line2" ]; then
    line2="${line2} | ${entry}"
  else
    line2="$entry"
  fi
fi

if [ -n "$week_pct" ]; then
  bar=$(make_bar "$week_pct")
  pct_label=$(printf '%.0f' "$week_pct")
  reset_label=$(format_reset_at "$week_reset")
  entry="7d:[${bar}]${pct_label}%"
  [ -n "$reset_label" ] && entry="${entry} ${reset_label}"
  if [ -n "$line2" ]; then
    line2="${line2} | ${entry}"
  else
    line2="$entry"
  fi
fi

[ -n "$line2" ] && printf "%s\n" "$line2"
