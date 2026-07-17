#!/usr/bin/env bash
# Claude Code status line
# Reads JSON payload from stdin and prints a single formatted status line.

input=$(cat)

# --- Colors (dim-friendly ANSI) ---
DIM='\033[2m'
RESET='\033[0m'
CYAN='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'
MAGENTA='\033[35m'
RED='\033[31m'
BLUE='\033[34m'

SEP="${DIM}│${RESET}"

# --- Model ---
model=$(echo "$input" | jq -r '.model.display_name // .model.id // "unknown"')

# --- Current directory (basename) ---
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
dir_base=$(basename "${cwd:-$PWD}")

# --- Git branch + dirty indicator (skip optional locks, quiet) ---
branch=""
dirty=""
if git -C "${cwd:-$PWD}" rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  branch=$(git -C "${cwd:-$PWD}" --no-optional-locks branch --show-current 2>/dev/null)
  if [ -n "$(git -C "${cwd:-$PWD}" --no-optional-locks status --porcelain 2>/dev/null | head -1)" ]; then
    dirty="${RED}✗${RESET}"
  else
    dirty="${GREEN}✓${RESET}"
  fi
fi

# --- Context window usage (progress bar) ---
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
ctx_segment=""
if [ -n "$used_pct" ] && [ "$used_pct" != "null" ]; then
  used_rounded=$(printf '%.0f' "$used_pct")
  if [ "$used_rounded" -ge 90 ]; then
    ctx_color="$RED"
  elif [ "$used_rounded" -ge 70 ]; then
    ctx_color="$YELLOW"
  else
    ctx_color="$GREEN"
  fi
  # 10-segment bar
  filled=$(( used_rounded / 10 ))
  [ "$filled" -gt 10 ] && filled=10
  empty=$(( 10 - filled ))
  bar=""
  for _ in $(seq 1 $filled); do bar="${bar}█"; done
  for _ in $(seq 1 $empty);  do bar="${bar}░"; done
  ctx_segment="${ctx_color}${bar} ${used_rounded}%${RESET}"
fi

# --- Session cost ---
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')
cost_segment=""
if [ -n "$cost" ] && [ "$cost" != "null" ]; then
  cost_segment=$(printf "${DIM}\$${RESET}${BLUE}%.2f${RESET}" "$cost")
fi

# --- Lines added/removed this session ---
added=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
removed=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')
lines_segment=""
if [ "$added" != "0" ] || [ "$removed" != "0" ]; then
  lines_segment="${GREEN}+${added}${RESET}${DIM}/${RESET}${RED}-${removed}${RESET}"
fi

# --- Build output ---
out="${MAGENTA}⚡ ${model}${RESET}"
out="${out} ${SEP} ${CYAN}${dir_base}${RESET}"

if [ -n "$branch" ]; then
  out="${out} ${SEP} ${YELLOW}⎇ ${branch}${RESET} ${dirty}"
fi

if [ -n "$ctx_segment" ]; then
  out="${out} ${SEP} ${ctx_segment}"
fi

if [ -n "$cost_segment" ]; then
  out="${out} ${SEP} ${cost_segment}"
fi

if [ -n "$lines_segment" ]; then
  out="${out} ${SEP} ${lines_segment}"
fi

printf "%b\n" "$out"
