# Resolve package content root: local checkout or remote git cache.
# shellcheck shell=bash

repo_is_fetchable() {
  local source="$1"
  [[ -z "$source" ]] && return 1
  case "$source" in
    git@*|https://*|http://*|ssh://*|file://*) return 0 ;;
    *.git) return 0 ;;
    *) return 1 ;;
  esac
}

repo_cache_dir() {
  local source="$1"
  local base="${XDG_CACHE_HOME:-$HOME/.cache}/blueprint/repos"
  local hash
  if command -v shasum >/dev/null 2>&1; then
    hash="$(printf '%s' "$source" | shasum -a 256 | awk '{print $1}')"
  elif command -v sha256sum >/dev/null 2>&1; then
    hash="$(printf '%s' "$source" | sha256sum | awk '{print $1}')"
  else
    # Fallback: sanitized source string
    hash="$(printf '%s' "$source" | tr -c 'A-Za-z0-9' '_')"
  fi
  printf '%s/%s' "$base" "${hash:0:16}"
}

repo_normalize_clone_url() {
  local source="$1"
  # Keep file:// and git URLs as-is for clone; strip trailing slash.
  source="${source%/}"
  printf '%s' "$source"
}

# Sets PACKAGE_ROOT. Uses SCRIPT_ROOT (caller ROOT) when source is not a URL
# or when the running package already matches.
repo_resolve_root() {
  local source="$1"
  local script_root="$2"

  PACKAGE_ROOT="$script_root"

  if ! repo_is_fetchable "$source"; then
    emit_info "Using local package: $script_root"
    return 0
  fi

  # If script root's origin matches source, prefer local checkout.
  if command -v git >/dev/null 2>&1 && [[ -d "${script_root}/.git" || -f "${script_root}/.git" ]]; then
    local origin
    origin="$(git -C "$script_root" remote get-url origin 2>/dev/null || true)"
    if [[ -n "$origin" ]]; then
      local a b
      a="$(term_redact_url "${origin%.git}")"
      b="$(term_redact_url "${source%.git}")"
      # Normalize trailing slashes and compare exact URL strings only.
      a="${a%/}"
      b="${b%/}"
      if [[ "$a" == "$b" ]]; then
        emit_info "Source matches local package checkout"
        PACKAGE_ROOT="$script_root"
        return 0
      fi
      # Also accept when both resolve to the same github/gitlab path without scheme differences.
      local a_path b_path
      a_path="$(printf '%s' "$a" | sed -E 's#^https?://##; s#^git@([^:]+):#\1/#; s#^ssh://##')"
      b_path="$(printf '%s' "$b" | sed -E 's#^https?://##; s#^git@([^:]+):#\1/#; s#^ssh://##')"
      if [[ "$a_path" == "$b_path" && "$a_path" != "$a" ]]; then
        # Only when both look like host/path URLs (not file:// local paths)
        case "$source" in
          file://*) ;;
          *)
            emit_info "Source matches local package checkout"
            PACKAGE_ROOT="$script_root"
            return 0
            ;;
        esac
      fi
    fi
  fi

  if ! command -v git >/dev/null 2>&1; then
    emit_error "git is required to fetch source repository"
    return 1
  fi

  local cache clone_url
  cache="$(repo_cache_dir "$source")"
  clone_url="$(repo_normalize_clone_url "$source")"

  emit_phase_start "Fetching source repository"
  mkdir -p "$(dirname "$cache")" 2>/dev/null || true

  if [[ -d "${cache}/.git" ]]; then
    emit_progress 0 "" "Updating cache"
    if ! git -C "$cache" fetch --depth 1 origin 2>/dev/null; then
      # Retry without depth for older remotes
      if ! git -C "$cache" fetch origin 2>/dev/null; then
        emit_error "Unable to update the remote repository cache"
        return 1
      fi
    fi
    local branch
    branch="$(git -C "$cache" rev-parse --abbrev-ref HEAD 2>/dev/null || echo main)"
    git -C "$cache" reset --hard "origin/${branch}" >/dev/null 2>&1 \
      || git -C "$cache" pull --ff-only >/dev/null 2>&1 \
      || true
  else
    emit_progress 0 "" "Cloning source"
    rm -rf "$cache" 2>/dev/null || true
    if ! git clone --depth 1 "$clone_url" "$cache" >/dev/null 2>&1; then
      if ! git clone "$clone_url" "$cache" >/dev/null 2>&1; then
        emit_error "Unable to connect to the remote repository"
        return 1
      fi
    fi
  fi

  if [[ ! -f "${cache}/manifest.yaml" && ! -d "${cache}/harness" ]]; then
    emit_error "Fetched repository does not look like a blueprint package"
    return 1
  fi

  PACKAGE_ROOT="$cache"
  emit_phase_complete "Fetching source repository"
  emit_info "Package root: $PACKAGE_ROOT"
  return 0
}
