# Prerequisite — GitLab + glab

Shared setup for Cursor commands that use **GitLab** and **`glab`**. Do not use `gh`.

**Used by:** [pr.md](pr.md) · [fix-comment.md](fix-comment.md) · [review.md](review.md)

Before any `glab` step in those commands, read this file and run `ensure_glab` in the repo root.

---

## Shell helpers (run once per shell)

Derive host, project, and API base from `origin` — **no hardcoded project URLs**.

```bash
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

resolve_gitlab_from_origin() {
  url="$(git remote get-url origin 2>/dev/null)" || { echo "No origin remote"; return 1; }

  if [[ "$url" =~ ^git@([^:]+):(.+)$ ]]; then
    GITLAB_HOST="${BASH_REMATCH[1]}"
    GITLAB_PROJECT_PATH="${BASH_REMATCH[2]%.git}"
  elif [[ "$url" =~ ^ssh://git@([^/:]+)(:[0-9]+)?/(.+)$ ]]; then
    GITLAB_HOST="${BASH_REMATCH[1]}"
    GITLAB_PROJECT_PATH="${BASH_REMATCH[3]%.git}"
  elif [[ "$url" =~ ^https?://([^/]+)/(.+)$ ]]; then
    GITLAB_HOST="${BASH_REMATCH[1]}"
    GITLAB_PROJECT_PATH="${BASH_REMATCH[2]%.git}"
  else
    echo "Cannot parse GitLab remote: $url" >&2
    return 1
  fi

  GITLAB_PROJECT_PATH_ENC="$(printf '%s' "$GITLAB_PROJECT_PATH" | jq -sRr @uri)"
  GITLAB_API_BASE="https://${GITLAB_HOST}/api/v4"
  GITLAB_WEB_BASE="https://${GITLAB_HOST}/${GITLAB_PROJECT_PATH}"
  BRANCH="$(git branch --show-current)"
  TARGET_BRANCH="${GITLAB_TARGET_BRANCH:-develop}"
}

ensure_glab() {
  if ! command -v glab >/dev/null 2>&1; then
    if command -v brew >/dev/null 2>&1; then
      brew install glab
    else
      echo "Install glab: https://gitlab.com/gitlab-org/cli" >&2
      return 1
    fi
  fi
  resolve_gitlab_from_origin
  if ! glab auth status --hostname "$GITLAB_HOST" >/dev/null 2>&1; then
    echo "Run: glab auth login --hostname $GITLAB_HOST" >&2
    return 1
  fi
}
```

## Conventions

| Variable | Meaning |
|----------|---------|
| `GITLAB_HOST` | Host from `origin` (no port) |
| `GITLAB_PROJECT_PATH` | `group/sub/project` |
| `GITLAB_PROJECT_PATH_ENC` | URL-encoded path for REST API |
| `GITLAB_API_BASE` | `https://{host}/api/v4` |
| `GITLAB_WEB_BASE` | `https://{host}/{project_path}` |
| `BRANCH` | Current branch |
| `TARGET_BRANCH` | `GITLAB_TARGET_BRANCH` or default `develop` |

- In a git checkout, `glab` resolves the current project automatically.
- Prefer `glab mr …` and `glab api "projects/:id/…"` (`:id` = this repo) over hand-built paths.
- Override merge target: `export GITLAB_TARGET_BRANCH=main` before `/pr`.

## JIRA from branch

`feature/ABC-1234` or `hotfix/ABC-1234` → `ABC-1234` for commit/MR titles.
