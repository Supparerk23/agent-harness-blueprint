# Structured operation events and counters.
# shellcheck shell=bash

BP_COUNT_ADDED=0
BP_COUNT_UPDATED=0
BP_COUNT_REMOVED=0
BP_COUNT_SKIPPED=0
BP_COUNT_FAILED=0
BP_COUNT_CONFLICT=0
BP_COUNT_CHECKED=0
BP_PHASE=""
BP_PHASE_FAILED=""
BP_ERROR_REASON=""
BP_OP_STATUS="running"
BP_OP_STARTED_AT=""
BP_OP_ENDED_AT=""
BP_RUN_ID=""
BP_OP_NAME=""
BP_PROGRESS_ACTIVE=0
BP_PROGRESS_BAR_MODE=0
BP_PROGRESS_CURRENT=0
BP_PROGRESS_TOTAL=0

events_reset() {
  BP_COUNT_ADDED=0
  BP_COUNT_UPDATED=0
  BP_COUNT_REMOVED=0
  BP_COUNT_SKIPPED=0
  BP_COUNT_FAILED=0
  BP_COUNT_CONFLICT=0
  BP_COUNT_CHECKED=0
  BP_PHASE=""
  BP_PHASE_FAILED=""
  BP_ERROR_REASON=""
  BP_OP_STATUS="running"
  BP_OP_STARTED_AT=""
  BP_OP_ENDED_AT=""
  BP_PROGRESS_ACTIVE=0
  BP_PROGRESS_BAR_MODE=0
  BP_PROGRESS_CURRENT=0
  BP_PROGRESS_TOTAL=0
}

events_new_run_id() {
  local ts
  ts="$(date +"%Y%m%d-%H%M%S" 2>/dev/null || echo "unknown")"
  local rand
  rand="$(printf '%04d' $((RANDOM % 10000)))"
  BP_RUN_ID="bp-${ts}-${rand}"
}

events_start_op() {
  local name="$1"
  events_reset
  events_new_run_id
  BP_OP_NAME="$name"
  BP_OP_STARTED_AT="$(date -u +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || date)"
  BP_OP_STATUS="running"
}

events_finish_op() {
  local status="${1:-completed}"
  BP_OP_STATUS="$status"
  BP_OP_ENDED_AT="$(date -u +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || date)"
  if [[ "$BP_COUNT_FAILED" -gt 0 && "$status" == "completed" ]]; then
    BP_OP_STATUS="failed"
  fi
}

emit_phase_start() {
  local phase="$1"
  BP_PHASE="$phase"
  render_finalize_progress
  render_status "running" "$phase"
}

emit_phase_complete() {
  local phase="$1"
  progress_bar_end
  render_finalize_progress
  render_status "success" "$phase"
}

emit_progress() {
  local current="$1"
  local total="${2:-}"
  local item="${3:-}"
  render_progress "$current" "$total" "$item"
}

# Begin in-place loading bar for bulk file work (TTY only; CI keeps per-file lines).
# Optional total estimate; if omitted/0, total grows softly as files are processed.
progress_bar_begin() {
  local total="${1:-0}"
  BP_PROGRESS_BAR_MODE=0
  BP_PROGRESS_CURRENT=0
  BP_PROGRESS_TOTAL=0
  if [[ "${BP_USE_ANIM:-0}" -ne 1 ]]; then
    return 0
  fi
  BP_PROGRESS_BAR_MODE=1
  if [[ "$total" =~ ^[0-9]+$ && "$total" -gt 0 ]]; then
    BP_PROGRESS_TOTAL="$total"
  else
    BP_PROGRESS_TOTAL=0
  fi
  emit_progress 0 "${BP_PROGRESS_TOTAL:-0}" "starting…"
}

progress_bar_end() {
  if [[ "${BP_PROGRESS_BAR_MODE:-0}" -ne 1 ]]; then
    return 0
  fi
  local had_ticks=0
  if [[ "$BP_PROGRESS_CURRENT" -gt 0 ]]; then
    had_ticks=1
    if [[ "$BP_PROGRESS_TOTAL" -lt "$BP_PROGRESS_CURRENT" ]]; then
      BP_PROGRESS_TOTAL="$BP_PROGRESS_CURRENT"
    fi
    emit_progress "$BP_PROGRESS_CURRENT" "$BP_PROGRESS_TOTAL" "done"
  fi
  render_finalize_progress
  if [[ "$had_ticks" -eq 1 ]]; then
    printf '\n'
  fi
  BP_PROGRESS_BAR_MODE=0
}

# Tick loading bar for one managed file (used instead of per-file lines in bar mode).
progress_bar_tick() {
  local path="$1"
  local kind="${2:-}"
  BP_PROGRESS_CURRENT=$((BP_PROGRESS_CURRENT + 1))
  if [[ "$BP_PROGRESS_TOTAL" -eq 0 || "$BP_PROGRESS_CURRENT" -gt "$BP_PROGRESS_TOTAL" ]]; then
    # Soft ceiling so the bar never looks stuck at 100% mid-run.
    BP_PROGRESS_TOTAL=$((BP_PROGRESS_CURRENT + 8))
  fi
  local label
  label="$(basename "$path")"
  if [[ -n "$kind" ]]; then
    label="${kind} ${label}"
  fi
  emit_progress "$BP_PROGRESS_CURRENT" "$BP_PROGRESS_TOTAL" "$label"
}

emit_file_added() {
  local path="$1"
  BP_COUNT_ADDED=$((BP_COUNT_ADDED + 1))
  BP_COUNT_CHECKED=$((BP_COUNT_CHECKED + 1))
  if [[ "${BP_PROGRESS_BAR_MODE:-0}" -eq 1 ]]; then
    progress_bar_tick "$path" "+"
    session_mark_file_done "$path" "added" || true
    return 0
  fi
  render_finalize_progress
  render_status "added" "$path"
  session_mark_file_done "$path" "added" || true
}

emit_file_updated() {
  local path="$1"
  BP_COUNT_UPDATED=$((BP_COUNT_UPDATED + 1))
  BP_COUNT_CHECKED=$((BP_COUNT_CHECKED + 1))
  if [[ "${BP_PROGRESS_BAR_MODE:-0}" -eq 1 ]]; then
    progress_bar_tick "$path" "~"
    session_mark_file_done "$path" "updated" || true
    return 0
  fi
  render_finalize_progress
  render_status "updated" "$path"
  session_mark_file_done "$path" "updated" || true
}

emit_file_skipped() {
  local path="$1"
  local reason="${2:-}"
  BP_COUNT_SKIPPED=$((BP_COUNT_SKIPPED + 1))
  BP_COUNT_CHECKED=$((BP_COUNT_CHECKED + 1))
  if [[ "${BP_PROGRESS_BAR_MODE:-0}" -eq 1 ]]; then
    progress_bar_tick "$path" "⊘"
    session_mark_file_done "$path" "skipped" || true
    return 0
  fi
  render_finalize_progress
  if [[ -n "$reason" ]]; then
    render_status "skipped" "$path ($reason)"
  else
    render_status "skipped" "$path"
  fi
  session_mark_file_done "$path" "skipped" || true
}

emit_file_removed() {
  local path="$1"
  BP_COUNT_REMOVED=$((BP_COUNT_REMOVED + 1))
  BP_COUNT_CHECKED=$((BP_COUNT_CHECKED + 1))
  if [[ "${BP_PROGRESS_BAR_MODE:-0}" -eq 1 ]]; then
    progress_bar_tick "$path" "−"
    session_mark_file_done "$path" "removed" || true
    return 0
  fi
  render_finalize_progress
  render_status "removed" "$path"
  session_mark_file_done "$path" "removed" || true
}

emit_file_conflict() {
  local path="$1"
  BP_COUNT_CONFLICT=$((BP_COUNT_CONFLICT + 1))
  BP_COUNT_SKIPPED=$((BP_COUNT_SKIPPED + 1))
  BP_COUNT_CHECKED=$((BP_COUNT_CHECKED + 1))
  render_finalize_progress
  render_status "warning" "Conflict: $path"
  render_status "info" "The destination file contains local modifications."
  render_status "info" "The file was not overwritten."
  session_mark_file_done "$path" "conflict" || true
}

emit_file_failed() {
  local path="$1"
  local reason="${2:-}"
  BP_COUNT_FAILED=$((BP_COUNT_FAILED + 1))
  BP_COUNT_CHECKED=$((BP_COUNT_CHECKED + 1))
  render_finalize_progress
  if [[ -n "$reason" ]]; then
    render_status "error" "$path — $reason"
  else
    render_status "error" "$path"
  fi
}

emit_warning() {
  local message="$1"
  render_finalize_progress
  render_status "warning" "$message"
}

emit_error() {
  local message="$1"
  BP_PHASE_FAILED="${BP_PHASE:-unknown}"
  BP_ERROR_REASON="$message"
  BP_OP_STATUS="failed"
  render_finalize_progress
  render_status "error" "$message"
}

emit_info() {
  local message="$1"
  render_finalize_progress
  render_status "info" "$message"
}
