# Terminal capabilities, clear, cursor, width helpers.
# shellcheck shell=bash

BP_IS_TTY=0
BP_IS_CI=0
BP_USE_COLOR=0
BP_USE_ANIM=0
BP_TERM_WIDTH=80
BP_CLEARED=0

term_init() {
  BP_IS_TTY=0
  BP_IS_CI=0
  BP_USE_COLOR=0
  BP_USE_ANIM=0
  if [[ -t 1 ]]; then
    BP_IS_TTY=1
  fi
  if [[ -n "${CI:-}" || -n "${GITHUB_ACTIONS:-}" || -n "${GITLAB_CI:-}" ]]; then
    BP_IS_CI=1
  fi
  if [[ "$BP_IS_TTY" -eq 1 && -z "${NO_COLOR:-}" && "$BP_IS_CI" -eq 0 ]]; then
    BP_USE_COLOR=1
  fi
  if [[ "$BP_IS_TTY" -eq 1 && "$BP_IS_CI" -eq 0 ]]; then
    BP_USE_ANIM=1
  fi
  if [[ -n "${COLUMNS:-}" && "${COLUMNS}" =~ ^[0-9]+$ ]]; then
    BP_TERM_WIDTH="$COLUMNS"
  elif command -v tput >/dev/null 2>&1; then
    BP_TERM_WIDTH="$(tput cols 2>/dev/null || echo 80)"
  else
    BP_TERM_WIDTH=80
  fi
  if [[ "$BP_TERM_WIDTH" -lt 40 ]]; then
    BP_TERM_WIDTH=40
  fi
}

# Banner accent (true-color cyan).
BP_RGB_CYAN_R=34
BP_RGB_CYAN_G=211
BP_RGB_CYAN_B=238

term_color() {
  if [[ "$BP_USE_COLOR" -ne 1 ]]; then
    return 0
  fi
  case "$1" in
    reset) printf '\033[0m' ;;
    dim) printf '\033[2m' ;;
    bold) printf '\033[1m' ;;
    green) printf '\033[32m' ;;
    red) printf '\033[31m' ;;
    yellow) printf '\033[33m' ;;
    cyan) printf '\033[38;2;%s;%s;%sm' "$BP_RGB_CYAN_R" "$BP_RGB_CYAN_G" "$BP_RGB_CYAN_B" ;;
    magenta) printf '\033[35m' ;;
    black) printf '\033[38;2;0;0;0m' ;;
    # Terracotta accent; 256-color fallback.
    orange) printf '\033[38;2;214;125;92m' 2>/dev/null || printf '\033[38;5;173m' ;;
    white) printf '\033[37m' ;;
  esac
}

term_bg() {
  if [[ "$BP_USE_COLOR" -ne 1 ]]; then
    return 0
  fi
  case "$1" in
    cyan) printf '\033[48;2;%s;%s;%sm' "$BP_RGB_CYAN_R" "$BP_RGB_CYAN_G" "$BP_RGB_CYAN_B" ;;
    reset) printf '\033[49m' ;;
  esac
}

# Repeat a single character N times (ASCII-safe for borders).
term_repeat() {
  local ch="$1"
  local n="$2"
  local out=""
  local i
  if [[ "$n" -le 0 ]]; then
    return 0
  fi
  for ((i = 0; i < n; i++)); do
    out+="$ch"
  done
  printf '%s' "$out"
}

# Clear the visible terminal once. Does not wipe history/session files.
# Prefer ANSI home+erase over `clear` so the frame resets immediately and
# predictably in Cursor / VS Code integrated terminals.
term_smart_clear() {
  if [[ "${BLUEPRINT_NO_CLEAR:-0}" == "1" ]]; then
    BP_CLEARED=1
    printf '\n'
    return 0
  fi
  if [[ "$BP_CLEARED" -eq 1 ]]; then
    return 0
  fi
  BP_CLEARED=1

  if [[ "$BP_IS_TTY" -eq 1 && "$BP_IS_CI" -eq 0 ]]; then
    # Cursor home, erase display, erase scrollback (when supported), show cursor.
    # \033[3J clears scrollback in xterm-compatible terminals (modern CLI feel).
    printf '\033[?25h\033[H\033[2J\033[3J' 2>/dev/null || printf '\033[H\033[2J'
    # Ensure the next paint starts at the top-left.
    printf '\033[H'
  else
    printf '\n'
  fi
}

term_reset_clear_flag() {
  BP_CLEARED=0
}

term_hide_cursor() {
  if [[ "$BP_USE_ANIM" -eq 1 ]]; then
    printf '\033[?25l'
  fi
}

term_show_cursor() {
  if [[ "$BP_IS_TTY" -eq 1 ]]; then
    printf '\033[?25h'
  fi
}

term_clear_line() {
  if [[ "$BP_IS_TTY" -eq 1 ]]; then
    printf '\r\033[K'
  fi
}

term_truncate() {
  local s="$1"
  local max="${2:-$BP_TERM_WIDTH}"
  local len=${#s}
  if [[ "$len" -le "$max" ]]; then
    printf '%s' "$s"
    return 0
  fi
  if [[ "$max" -le 3 ]]; then
    printf '%s' "${s:0:$max}"
    return 0
  fi
  printf '%s...' "${s:0:$((max - 3))}"
}

term_home_path() {
  local p="$1"
  if [[ -n "${HOME:-}" && "$p" == "$HOME"* ]]; then
    printf '~%s' "${p#"$HOME"}"
  else
    printf '%s' "$p"
  fi
}

term_redact_url() {
  local u="$1"
  u="$(printf '%s' "$u" | sed -E 's#(https?://)[^/@]+@#\1#; s#(ssh://)[^/@]+@#\1#')"
  printf '%s' "$u"
}

term_interactive() {
  [[ "$BP_IS_TTY" -eq 1 && -t 0 && "$BP_IS_CI" -eq 0 ]]
}

# Preferred panel width: compact on wide terminals, full width when narrow.
term_panel_width() {
  local w="$BP_TERM_WIDTH"
  if [[ "$w" -gt 72 ]]; then
    w=72
  fi
  if [[ "$w" -lt 40 ]]; then
    w=40
  fi
  printf '%s' "$w"
}
