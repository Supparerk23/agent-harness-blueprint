# Package-local known consumer targets (gitignored; no secrets).
# shellcheck shell=bash

targets_file() {
  if [[ -n "${BLUEPRINT_TARGETS_FILE:-}" ]]; then
    printf '%s' "$BLUEPRINT_TARGETS_FILE"
    return 0
  fi
  printf '%s/targets.json' "${ROOT:-.}"
}

targets_limit() {
  local n="${BLUEPRINT_TARGETS_LIMIT:-50}"
  if [[ ! "$n" =~ ^[0-9]+$ ]]; then
    n=50
  fi
  printf '%s' "$n"
}

# Print path<TAB>version lines, newest first. Corrupt-tolerant.
targets_list() {
  local file
  file="$(targets_file)"
  if [[ ! -f "$file" ]]; then
    return 0
  fi
  # Prefer one-object-per-line; fall back to extracting {...} blobs.
  local line t_path ver
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ "$line" == *"\"path\""* ]] || continue
    t_path="$(printf '%s' "$line" | sed -n 's/.*"path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')"
    ver="$(printf '%s' "$line" | sed -n 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')"
    if [[ -n "$t_path" ]]; then
      printf '%s\t%s\n' "$t_path" "${ver:-}"
    fi
  done < "$file"
}

targets_count() {
  local n
  n="$(targets_list | wc -l | tr -d ' ')"
  if [[ ! "$n" =~ ^[0-9]+$ ]]; then
    n=0
  fi
  printf '%s' "$n"
}

# Resolve blueprint version for a consumer path (state file, else package).
targets_version_for_path() {
  local abs_path="$1"
  local ver=""
  if [[ -f "${abs_path}/.agent-blueprint.yaml" ]]; then
    ver="$(grep -E '^version:' "${abs_path}/.agent-blueprint.yaml" 2>/dev/null | head -1 | awk '{print $2}')"
  fi
  if [[ -z "$ver" ]] && command -v package_version >/dev/null 2>&1; then
    ver="$(package_version 2>/dev/null || true)"
  fi
  printf '%s' "${ver:-0.0.0}"
}

# Upsert by absolute path; newest-first; prune to limit.
targets_upsert() {
  local abs_path="$1"
  local version="${2:-}"
  local updated_at
  updated_at="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

  if [[ -z "$abs_path" ]]; then
    return 0
  fi
  if [[ -d "$abs_path" ]]; then
    abs_path="$(cd "$abs_path" && pwd)"
  fi
  if [[ -z "$version" ]]; then
    version="0.0.0"
  fi

  local file dir
  file="$(targets_file)"
  dir="$(dirname "$file")"
  mkdir -p "$dir" 2>/dev/null || return 0

  local limit
  limit="$(targets_limit)"

  # Snapshot existing entries before rewrite (cannot read file while rebuilding).
  local -a existing_paths=()
  local -a existing_vers=()
  local t_path ver
  while IFS=$'\t' read -r t_path ver || [[ -n "${t_path:-}" ]]; do
    [[ -n "$t_path" ]] || continue
    existing_paths+=("$t_path")
    existing_vers+=("${ver:-}")
  done < <(targets_list)

  local tmp
  tmp="$(mktemp 2>/dev/null || echo "${file}.tmp")"

  {
    printf '[\n'
    printf '  {"path":"%s","version":"%s","updatedAt":"%s"}' \
      "$(history_json_escape "$abs_path")" \
      "$(history_json_escape "$version")" \
      "$(history_json_escape "$updated_at")"

    local count=1
    local i
    for ((i = 0; i < ${#existing_paths[@]}; i++)); do
      t_path="${existing_paths[$i]}"
      ver="${existing_vers[$i]}"
      if [[ "$t_path" == "$abs_path" ]]; then
        continue
      fi
      if [[ "$count" -ge "$limit" ]]; then
        break
      fi
      printf ',\n  {"path":"%s","version":"%s","updatedAt":"%s"}' \
        "$(history_json_escape "$t_path")" \
        "$(history_json_escape "${ver:-}")" \
        "$(history_json_escape "$updated_at")"
      count=$((count + 1))
    done
    printf '\n]\n'
  } > "$tmp" 2>/dev/null || {
    /bin/rm -f "$tmp"
    return 0
  }

  /bin/mv "$tmp" "$file" 2>/dev/null || /bin/rm -f "$tmp"
}

# Remove a consumer path from the known-targets registry (does not delete project files).
# Match the path exactly as stored in targets.json (same string shown in the TUI list).
targets_remove() {
  local abs_path="$1"
  if [[ -z "$abs_path" ]]; then
    return 0
  fi

  local file
  file="$(targets_file)"
  if [[ ! -f "$file" ]]; then
    return 0
  fi

  local found=0
  local keep_file
  keep_file="$(mktemp 2>/dev/null || echo "${file}.keep")"
  : > "$keep_file"

  local t_path ver
  while IFS=$'\t' read -r t_path ver; do
    [[ -n "$t_path" ]] || continue
    if [[ "$t_path" == "$abs_path" ]]; then
      found=1
      continue
    fi
    printf '%s\t%s\n' "$t_path" "${ver:-}" >> "$keep_file"
  done < <(targets_list)

  if [[ "$found" -eq 0 ]]; then
    /bin/rm -f "$keep_file"
    return 1
  fi

  local tmp updated_at
  updated_at="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  tmp="$(mktemp 2>/dev/null || echo "${file}.tmp")"
  if [[ ! -s "$keep_file" ]]; then
    printf '[]\n' > "$tmp" || {
      /bin/rm -f "$keep_file" "$tmp"
      return 1
    }
  else
    {
      printf '[\n'
      local count=0
      while IFS=$'\t' read -r t_path ver; do
        [[ -n "$t_path" ]] || continue
        if [[ "$count" -gt 0 ]]; then
          printf ',\n'
        fi
        printf '  {"path":"%s","version":"%s","updatedAt":"%s"}' \
          "$(history_json_escape "$t_path")" \
          "$(history_json_escape "${ver:-}")" \
          "$(history_json_escape "$updated_at")"
        count=$((count + 1))
      done < "$keep_file"
      printf '\n]\n'
    } > "$tmp" || {
      /bin/rm -f "$keep_file" "$tmp"
      return 1
    }
  fi
  /bin/rm -f "$keep_file"
  /bin/mv "$tmp" "$file" 2>/dev/null || {
    /bin/rm -f "$tmp"
    return 1
  }
  return 0
}

# Remember a locked/inited consumer (version from state or package).
targets_remember() {
  local abs_path="$1"
  local version="${2:-}"
  if [[ -z "$abs_path" ]]; then
    return 0
  fi
  if [[ -z "$version" ]]; then
    version="$(targets_version_for_path "$abs_path")"
  fi
  targets_upsert "$abs_path" "$version" || true
}

# One-time fill from run history when targets.json is empty.
targets_bootstrap_from_history() {
  if [[ "$(targets_count)" -gt 0 ]]; then
    return 0
  fi
  local hist
  hist="$(history_file)"
  if [[ ! -f "$hist" ]]; then
    return 0
  fi

  local line root pkg
  pkg="${ROOT:-}"
  # Newest history lines last → walk reverse so first upsert wins as newest.
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ "$line" == *"projectRoot"* ]] || continue
    root="$(printf '%s' "$line" | sed -n 's/.*"projectRoot"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')"
    [[ -n "$root" ]] || continue
    [[ -d "$root" ]] || continue
    if [[ -n "$pkg" ]] && [[ "$root" == "$pkg" ]]; then
      continue
    fi
    # Skip obvious package test leftovers.
    case "$root" in
      */.tmp-consumer-test|*/.tmp-consumer-test/*|*/.tmp-consumer-test-*) continue ;;
    esac
    targets_remember "$root" || true
  done < <(tail -r "$hist" 2>/dev/null || tac "$hist" 2>/dev/null || cat "$hist")
}
