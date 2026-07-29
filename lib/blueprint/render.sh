# Header, live status, progress, menu, and summary rendering.
# shellcheck shell=bash

BP_HEADER_PROJECT=""
BP_HEADER_ROOT=""
BP_HEADER_BRANCH=""
BP_HEADER_SOURCE=""
BP_HEADER_MODE=""
BP_SPINNER_FRAME=0
BP_SPINNER_CHARS='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'

render_status() {
  local kind="$1"
  shift
  local msg="$*"
  local sym color
  case "$kind" in
    running) sym="→"; color="cyan" ;;
    success) sym="✓"; color="green" ;;
    warning) sym="!"; color="yellow" ;;
    error) sym="✗"; color="red" ;;
    skipped) sym="⊘"; color="dim" ;;
    updated) sym="~"; color="cyan" ;;
    added) sym="+"; color="green" ;;
    info) sym="·"; color="dim" ;;
    *) sym="·"; color="dim" ;;
  esac
  if [[ "$kind" == "error" ]]; then
    printf '  %s%s%s  %s\n' "$(term_color "$color")" "$sym" "$(term_color reset)" "$msg" >&2
  else
    printf '  %s%s%s  %s\n' "$(term_color "$color")" "$sym" "$(term_color reset)" "$msg"
  fi
}

# Claude Code–style welcome banner: pixel icon | title · meta · path
# Args: version, meta_line, path_line
render_banner() {
  local version="$1"
  local meta="$2"
  local path_line="$3"
  local width
  width="$(term_panel_width)"

  local ver_disp="v${version#v}"
  local meta_disp path_disp
  meta_disp="$(term_truncate "$meta" $((width - 10)))"
  path_disp="$(term_truncate "$path_line" $((width - 10)))"

  # Compact / CI: no icon, plain three lines.
  if [[ "$BP_IS_TTY" -ne 1 || "$BP_IS_CI" -eq 1 || "$width" -lt 48 || "$BP_USE_COLOR" -ne 1 ]]; then
    printf '%sBlueprint%s  %s%s%s\n' \
      "$(term_color bold)" "$(term_color reset)" \
      "$(term_color dim)" "$ver_disp" "$(term_color reset)"
    printf '%s%s%s\n' "$(term_color dim)" "$meta_disp" "$(term_color reset)"
    printf '%s%s%s\n' "$(term_color dim)" "$path_disp" "$(term_color reset)"
    printf '\n'
    return 0
  fi

  # Cyan face (true-color): border + 4-tone fill + dark eyes.
  #   ▛▀▀▀▀▀▀▀▀▀▜
  #   ▌ ●   ●   ▐  bg1
  #   ▌         ▐  bg2
  #   ▌         ▐  bg3
  #   ▌         ▐  bg4
  #   ▙▄▄▄▄▄▄▄▄▄▟
  local c bg1 bg2 bg3 bg4 k r
  c="$(printf '\033[38;2;6;182;212m')"
  bg1="$(printf '\033[48;2;236;254;255m')"
  bg2="$(printf '\033[48;2;207;250;254m')"
  bg3="$(printf '\033[48;2;165;243;252m')"
  bg4="$(printf '\033[48;2;103;232;249m')"
  k="$(printf '\033[38;2;12;74;110m')"
  r="$(printf '\033[0m')"

  printf '%s▄▄▄▄▄▄▄▄▄▄▄%s  %sBlueprint%s  %s%s%s\n' \
    "$c" "$r" "$(term_color bold)" "$r" "$(term_color dim)" "$ver_disp" "$r"
  printf '%s%s▌ %s●%s   %s●%s   ▐%s %s%s%s\n' \
    "$c" "$bg1" "$k" "$c$bg1" "$k" "$c$bg1" "$r" \
    "$(term_color dim)" "$meta_disp" "$r"
  printf '%s%s▌         ▐%s %s%s%s\n' \
    "$c" "$bg2" "$r" \
    "$(term_color dim)" "$path_disp" "$r"
  printf '%s%s▌         ▐%s\n' \
    "$c" "$bg3" "$r"
  printf '%s%s▌         ▐%s\n' \
    "$c" "$bg4" "$r"
  printf '%s▄▄▄▄▄▄▄▄▄▄▄%s\n' "$c" "$r"
  printf '\n'
}

render_header() {
  local project="${BP_HEADER_PROJECT:-unknown}"
  local root="${BP_HEADER_ROOT:-.}"
  local branch="${BP_HEADER_BRANCH:-unknown}"
  local source="${BP_HEADER_SOURCE:-local}"
  local mode="${BP_HEADER_MODE:-Run}"
  local run="${BP_RUN_ID:-}"
  local display_root display_source
  display_root="$(term_home_path "$root")"
  display_source="$(term_redact_url "$source")"

  local ver
  ver="$(package_version 2>/dev/null || echo "0.0.0")"
  local meta
  meta="${mode} · ${branch} · ${display_source}"
  render_banner "$ver" "$meta" "$display_root"

  # Compact run context under the banner (no heavy box).
  if [[ -n "$run" ]]; then
    printf '  %srun%s  %s  %s·%s  %s%s%s\n\n' \
      "$(term_color dim)" "$(term_color reset)" "$run" \
      "$(term_color dim)" "$(term_color reset)" \
      "$(term_color dim)" "$project" "$(term_color reset)"
  fi
}

# Full-screen menu chrome (clears first when called via cmd_menu).
render_menu() {
  local version="$1"
  local target="$2"
  local display_target
  display_target="$(term_home_path "$target")"

  render_banner "$version" "shared agent blueprints · install · sync" "$display_target"

  printf '  %sCommands%s\n' "$(term_color bold)" "$(term_color reset)"
  printf '\n'
  printf '  %s1%s  init       Shared contract + memory + .gitignore\n' "$(term_color cyan)" "$(term_color reset)"
  printf '  %s2%s  install    Blueprint + runtime (cursor / claude / all)\n' "$(term_color cyan)" "$(term_color reset)"
  printf '  %s3%s  sync       Re-apply installed blueprint\n' "$(term_color cyan)" "$(term_color reset)"
  printf '  %s4%s  update     Show update plan vs package VERSION\n' "$(term_color cyan)" "$(term_color reset)"
  printf '  %s5%s  doctor     Validate package / target health\n' "$(term_color cyan)" "$(term_color reset)"
  printf '  %s6%s  target     Change consumer project path\n' "$(term_color cyan)" "$(term_color reset)"
  printf '  %s7%s  help       Show CLI usage\n' "$(term_color cyan)" "$(term_color reset)"
  printf '  %s8%s  back       Return to target project picker\n' "$(term_color cyan)" "$(term_color reset)"
  printf '  %s0%s  quit\n' "$(term_color cyan)" "$(term_color reset)"
  printf '\n'
  printf '  %s›%s ' "$(term_color magenta)$(term_color bold)" "$(term_color reset)"
}

render_finalize_progress() {
  if [[ "${BP_PROGRESS_ACTIVE:-0}" -eq 1 ]]; then
    term_clear_line
    BP_PROGRESS_ACTIVE=0
    term_show_cursor
  fi
}

render_progress() {
  local current="$1"
  local total="${2:-}"
  local item="${3:-}"

  if [[ "${BP_USE_ANIM:-0}" -ne 1 ]]; then
    return 0
  fi

  if [[ "${BP_PROGRESS_ACTIVE:-0}" -eq 0 ]]; then
    term_hide_cursor
  fi
  BP_PROGRESS_ACTIVE=1
  local line=""
  if [[ -n "$total" && "$total" =~ ^[0-9]+$ && "$total" -gt 0 ]]; then
    local width=20
    local filled=$((current * width / total))
    if [[ "$filled" -gt "$width" ]]; then filled=$width; fi
    local bar=""
    local i
    for ((i = 0; i < filled; i++)); do bar+="█"; done
    for ((i = filled; i < width; i++)); do bar+="░"; done
    line="  [${bar}] ${current} / ${total}"
    if [[ -n "$item" ]]; then
      local remain=$((BP_TERM_WIDTH - ${#line} - 4))
      if [[ "$remain" -lt 8 ]]; then remain=8; fi
      line="${line}  $(term_truncate "$item" "$remain")"
    fi
  else
    local n=${#BP_SPINNER_CHARS}
    local ch="${BP_SPINNER_CHARS:BP_SPINNER_FRAME:1}"
    BP_SPINNER_FRAME=$(( (BP_SPINNER_FRAME + 1) % n ))
    line="  ${ch} ${BP_PHASE:-Working}"
    if [[ -n "$item" ]]; then
      local remain=$((BP_TERM_WIDTH - ${#line} - 4))
      if [[ "$remain" -lt 8 ]]; then remain=8; fi
      line="${line}: $(term_truncate "$item" "$remain")"
    fi
  fi
  term_clear_line
  printf '%s' "$(term_truncate "$line" "$BP_TERM_WIDTH")"
}

render_divider() {
  local width
  width="$(term_panel_width)"
  printf '\n'
  printf '%s%s%s\n' "$(term_color dim)" "$(term_repeat '─' "$width")" "$(term_color reset)"
}

render_summary_success() {
  local source="${1:-}"
  local duration="${2:-}"
  render_divider
  if [[ "$BP_COUNT_ADDED" -eq 0 && "$BP_COUNT_UPDATED" -eq 0 && "$BP_COUNT_FAILED" -eq 0 && "$BP_COUNT_CONFLICT" -eq 0 ]]; then
    printf '\n  %s✓%s  Blueprint is already up to date.\n' "$(term_color green)" "$(term_color reset)"
    printf '      Checked %s managed files' "$BP_COUNT_CHECKED"
    if [[ -n "$duration" ]]; then
      printf ' in %s' "$duration"
    fi
    printf '.\n'
  else
    printf '\n  %s✓%s  Blueprint synchronization completed\n' "$(term_color green)" "$(term_color reset)"
    if [[ -n "$source" ]]; then
      printf '      Source    %s\n' "$(term_redact_url "$source")"
    fi
    if [[ -n "$duration" ]]; then
      printf '      Duration  %s\n' "$duration"
    fi
    printf '\n'
    printf '      %s+%s Added     %s\n' "$(term_color green)" "$(term_color reset)" "$BP_COUNT_ADDED"
    printf '      %s~%s Updated   %s\n' "$(term_color cyan)" "$(term_color reset)" "$BP_COUNT_UPDATED"
    printf '      %s⊘%s Skipped   %s\n' "$(term_color dim)" "$(term_color reset)" "$BP_COUNT_SKIPPED"
    printf '      %s✗%s Failed    %s\n' "$(term_color red)" "$(term_color reset)" "$BP_COUNT_FAILED"
  fi
  printf '\n      %sRun%s  %s\n\n' "$(term_color dim)" "$(term_color reset)" "$BP_RUN_ID"
}

render_summary_failure() {
  local phase="${BP_PHASE_FAILED:-$BP_PHASE}"
  local reason="${BP_ERROR_REASON:-unknown error}"
  render_divider
  printf '\n  %s✗%s  Blueprint synchronization failed\n' "$(term_color red)" "$(term_color reset)"
  printf '      Phase   %s\n' "${phase:-unknown}"
  printf '      Reason  %s\n' "$reason"
  if [[ "$BP_COUNT_ADDED" -eq 0 && "$BP_COUNT_UPDATED" -eq 0 ]]; then
    printf '      No destination files were modified.\n'
  fi
  printf '\n      %sRun%s  %s\n\n' "$(term_color dim)" "$(term_color reset)" "$BP_RUN_ID"
}
