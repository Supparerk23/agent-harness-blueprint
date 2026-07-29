# Local JSONL run history (no secrets).
# shellcheck shell=bash

history_dir() {
  local base="${XDG_DATA_HOME:-$HOME/.local/share}"
  printf '%s/blueprint' "$base"
}

history_file() {
  printf '%s/history.jsonl' "$(history_dir)"
}

history_limit() {
  local n="${BLUEPRINT_HISTORY_LIMIT:-50}"
  if [[ ! "$n" =~ ^[0-9]+$ ]]; then
    n=50
  fi
  printf '%s' "$n"
}

history_json_escape() {
  local s="$1"
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  s="${s//$'\n'/\\n}"
  s="${s//$'\r'/}"
  printf '%s' "$s"
}

history_append() {
  local run_id="${BP_RUN_ID:-}"
  local project_root="${BP_CTX_ROOT:-}"
  local source="${BP_CTX_SOURCE:-}"
  local started="${BP_OP_STARTED_AT:-}"
  local completed="${BP_OP_ENDED_AT:-}"
  local status="${BP_OP_STATUS:-unknown}"
  local operation="${BP_OP_NAME:-}"
  local added="${BP_COUNT_ADDED:-0}"
  local updated="${BP_COUNT_UPDATED:-0}"
  local skipped="${BP_COUNT_SKIPPED:-0}"
  local failed="${BP_COUNT_FAILED:-0}"

  if [[ -z "$run_id" ]]; then
    return 0
  fi

  local dir file
  dir="$(history_dir)"
  file="$(history_file)"
  mkdir -p "$dir" 2>/dev/null || return 0

  local line
  line=$(printf '{"runId":"%s","projectRoot":"%s","sourceRepository":"%s","operation":"%s","startedAt":"%s","completedAt":"%s","result":{"added":%s,"updated":%s,"skipped":%s,"failed":%s},"status":"%s"}' \
    "$(history_json_escape "$run_id")" \
    "$(history_json_escape "$(term_redact_url "$project_root")")" \
    "$(history_json_escape "$(term_redact_url "$source")")" \
    "$(history_json_escape "$operation")" \
    "$(history_json_escape "$started")" \
    "$(history_json_escape "$completed")" \
    "$added" "$updated" "$skipped" "$failed" \
    "$(history_json_escape "$status")")

  # Append; prune if over limit (best-effort, corrupt-tolerant).
  printf '%s\n' "$line" >> "$file" 2>/dev/null || return 0

  local limit
  limit="$(history_limit)"
  local count
  count="$(wc -l < "$file" 2>/dev/null | tr -d ' ' || echo 0)"
  if [[ "$count" =~ ^[0-9]+$ && "$count" -gt "$limit" ]]; then
    local tmp
    tmp="$(mktemp 2>/dev/null || echo "${file}.tmp")"
    if tail -n "$limit" "$file" > "$tmp" 2>/dev/null; then
      mv "$tmp" "$file" 2>/dev/null || rm -f "$tmp"
    else
      rm -f "$tmp"
    fi
  fi
}
