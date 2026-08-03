# Incomplete-run session state for safe resume.
# shellcheck shell=bash

BP_SESSION_ACTIVE=0
BP_SESSION_RESUME=0
BP_SESSION_DONE_FILES=""

session_path() {
  local dest="${1:-${BP_CTX_ROOT:-$TARGET}}"
  printf '%s/.agent-blueprint/session.json' "$dest"
}

session_dir() {
  local dest="${1:-${BP_CTX_ROOT:-$TARGET}}"
  printf '%s/.agent-blueprint' "$dest"
}

session_clear() {
  local dest="${1:-${BP_CTX_ROOT:-$TARGET}}"
  local f
  f="$(session_path "$dest")"
  rm -f "$f" 2>/dev/null || true
  BP_SESSION_ACTIVE=0
  BP_SESSION_RESUME=0
  BP_SESSION_DONE_FILES=""
}

session_start() {
  local dest="$1"
  local operation="$2"
  local source="$3"
  if [[ "${DRY_RUN:-0}" -eq 1 ]]; then
    return 0
  fi
  local dir
  dir="$(session_dir "$dest")"
  mkdir -p "$dir" 2>/dev/null || true
  local f
  f="$(session_path "$dest")"
  cat > "$f" <<EOF
{
  "runId": "$(history_json_escape "${BP_RUN_ID:-}")",
  "operation": "$(history_json_escape "$operation")",
  "projectRoot": "$(history_json_escape "$dest")",
  "sourceRepository": "$(history_json_escape "$(term_redact_url "$source")")",
  "phase": "$(history_json_escape "${BP_PHASE:-}")",
  "status": "running",
  "startedAt": "$(history_json_escape "${BP_OP_STARTED_AT:-}")",
  "completedFiles": [],
  "completedCount": 0
}
EOF
  BP_SESSION_ACTIVE=1
  BP_SESSION_DONE_FILES=""
}

session_update_phase() {
  local dest="${1:-${BP_CTX_ROOT:-$TARGET}}"
  local phase="$2"
  local f
  f="$(session_path "$dest")"
  [[ -f "$f" ]] || return 0
  # Best-effort rewrite of phase field without full JSON parser.
  local tmp
  tmp="$(mktemp 2>/dev/null || echo "${f}.tmp")"
  sed "s/\"phase\": \"[^\"]*\"/\"phase\": \"$(history_json_escape "$phase")\"/" "$f" > "$tmp" 2>/dev/null && mv "$tmp" "$f" || rm -f "$tmp"
}

session_mark_file_done() {
  local path="$1"
  local _status="${2:-done}"
  [[ "${BP_SESSION_ACTIVE:-0}" -eq 1 ]] || return 0
  BP_SESSION_DONE_FILES="${BP_SESSION_DONE_FILES}"$'\n'"${path}"
  local dest="${BP_CTX_ROOT:-$TARGET}"
  local f
  f="$(session_path "$dest")"
  [[ -f "$f" ]] || return 0
  # Append path to a sibling list file for robust resume (JSON array edits are fragile in bash).
  local list="${dest}/.agent-blueprint/completed.paths"
  printf '%s\n' "$path" >> "$list" 2>/dev/null || true
  local count
  count="$(grep -c . "$list" 2>/dev/null || echo 0)"
  local tmp
  tmp="$(mktemp 2>/dev/null || echo "${f}.tmp")"
  sed -E "s/\"completedCount\": [0-9]+/\"completedCount\": ${count}/" "$f" > "$tmp" 2>/dev/null && mv "$tmp" "$f" || rm -f "$tmp"
}

session_mark_interrupted() {
  local dest="${1:-${BP_CTX_ROOT:-$TARGET}}"
  local f
  f="$(session_path "$dest")"
  [[ -f "$f" ]] || return 0
  local tmp
  tmp="$(mktemp 2>/dev/null || echo "${f}.tmp")"
  sed 's/"status": "running"/"status": "interrupted"/' "$f" > "$tmp" 2>/dev/null && mv "$tmp" "$f" || rm -f "$tmp"
}

session_mark_failed() {
  local dest="${1:-${BP_CTX_ROOT:-$TARGET}}"
  local f
  f="$(session_path "$dest")"
  [[ -f "$f" ]] || return 0
  local tmp
  tmp="$(mktemp 2>/dev/null || echo "${f}.tmp")"
  sed 's/"status": "running"/"status": "failed"/' "$f" > "$tmp" 2>/dev/null && mv "$tmp" "$f" || rm -f "$tmp"
}

session_has_incomplete() {
  local dest="$1"
  local f
  f="$(session_path "$dest")"
  [[ -f "$f" ]] || return 1
  if grep -q '"status": "interrupted"\|"status": "failed"\|"status": "running"' "$f" 2>/dev/null; then
    return 0
  fi
  return 1
}

session_read_field() {
  local f="$1"
  local key="$2"
  # naive: "key": "value"
  grep -E "\"${key}\":" "$f" 2>/dev/null | head -1 | sed -E "s/.*\"${key}\":[[:space:]]*\"?([^\",}]*)\"?.*/\1/"
}

session_view_summary() {
  local dest="$1"
  local f list
  f="$(session_path "$dest")"
  list="${dest}/.agent-blueprint/completed.paths"
  [[ -f "$f" ]] || return 0
  local run_id phase status completed
  run_id="$(session_read_field "$f" runId)"
  phase="$(session_read_field "$f" phase)"
  status="$(session_read_field "$f" status)"
  completed="$(session_read_field "$f" completedCount)"
  printf '\nAn unfinished Blueprint run was found.\n'
  printf 'Run       : %s\n' "$run_id"
  printf 'Project   : %s\n' "$(basename "$dest")"
  printf 'Status    : %s\n' "$status"
  printf 'Completed : %s files\n' "${completed:-0}"
  printf 'Stopped at: %s\n' "${phase:-unknown}"
  if [[ -f "$list" ]]; then
    printf 'Recent:\n'
    tail -n 5 "$list" 2>/dev/null | while read -r p; do
      printf '  - %s\n' "$p"
    done
  fi
}

session_prompt_resume() {
  local dest="$1"
  BP_SESSION_RESUME=0
  if ! session_has_incomplete "$dest"; then
    return 0
  fi

  if [[ "${BLUEPRINT_RESUME:-}" == "1" ]]; then
    BP_SESSION_RESUME=1
    session_load_done_files "$dest"
    emit_info "Resuming previous run (BLUEPRINT_RESUME=1)"
    return 0
  fi

  if ! term_interactive; then
    emit_info "Unfinished session found; starting a new run (non-interactive)."
    session_archive "$dest"
    return 0
  fi

  session_view_summary "$dest"
  printf '\n[R] Resume\n[N] Start new run\n[V] View summary\n'
  printf 'Esc) back (start new)\n'
  local choice=""
  while true; do
    if ! term_prompt_read 'Choice [R/N/V] (Esc back): '; then
      session_archive "$dest"
      BP_SESSION_RESUME=0
      return 0
    fi
    choice="${BP_READ_RESULT:-}"
    case "$choice" in
      R|r|resume)
        BP_SESSION_RESUME=1
        session_load_done_files "$dest"
        return 0
        ;;
      N|n|new)
        session_archive "$dest"
        BP_SESSION_RESUME=0
        return 0
        ;;
      V|v|view)
        session_view_summary "$dest"
        ;;
      *)
        warn "invalid choice: $choice (use R, N, V, or Esc)"
        ;;
    esac
  done
}

session_load_done_files() {
  local dest="$1"
  local list="${dest}/.agent-blueprint/completed.paths"
  BP_SESSION_DONE_FILES=""
  if [[ -f "$list" ]]; then
    BP_SESSION_DONE_FILES="$(cat "$list" 2>/dev/null || true)"
  fi
}

session_file_already_done() {
  local path="$1"
  [[ "${BP_SESSION_RESUME:-0}" -eq 1 ]] || return 1
  printf '%s\n' "$BP_SESSION_DONE_FILES" | grep -Fxq "$path" 2>/dev/null
}

session_archive() {
  local dest="$1"
  local dir f
  dir="$(session_dir "$dest")"
  f="$(session_path "$dest")"
  if [[ -f "$f" ]]; then
    mkdir -p "${dir}/archive" 2>/dev/null || true
    mv "$f" "${dir}/archive/session-$(date +%Y%m%d%H%M%S 2>/dev/null || echo old).json" 2>/dev/null || rm -f "$f"
  fi
  rm -f "${dir}/completed.paths" 2>/dev/null || true
  BP_SESSION_ACTIVE=0
  BP_SESSION_RESUME=0
  BP_SESSION_DONE_FILES=""
}

session_complete() {
  local dest="${1:-${BP_CTX_ROOT:-$TARGET}}"
  session_clear "$dest"
  rm -f "${dest}/.agent-blueprint/completed.paths" 2>/dev/null || true
  # Remove empty dir if possible
  rmdir "${dest}/.agent-blueprint" 2>/dev/null || true
}
