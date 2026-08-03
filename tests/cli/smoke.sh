#!/usr/bin/env bash
# Smoke tests for the Blueprint CLI terminal UX.
# Run from package root: ./tests/cli/smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BP="${ROOT}/blueprint"
TMP="${ROOT}/.tmp-consumer-test"
PASS=0
FAIL=0

assert_eq() {
  local label="$1" got="$2" want="$3"
  if [[ "$got" == "$want" ]]; then
    echo "  PASS  $label"
    PASS=$((PASS + 1))
  else
    echo "  FAIL  $label (got='$got' want='$want')"
    FAIL=$((FAIL + 1))
  fi
}

assert_file() {
  local label="$1" path="$2"
  if [[ -f "$path" ]]; then
    echo "  PASS  $label"
    PASS=$((PASS + 1))
  else
    echo "  FAIL  $label (missing $path)"
    FAIL=$((FAIL + 1))
  fi
}

assert_dir() {
  local label="$1" path="$2"
  if [[ -d "$path" ]]; then
    echo "  PASS  $label"
    PASS=$((PASS + 1))
  else
    echo "  FAIL  $label (missing $path)"
    FAIL=$((FAIL + 1))
  fi
}

assert_contains() {
  local label="$1" hay="$2" needle="$3"
  if printf '%s' "$hay" | grep -qF -- "$needle"; then
    echo "  PASS  $label"
    PASS=$((PASS + 1))
  else
    echo "  FAIL  $label (missing '$needle')"
    FAIL=$((FAIL + 1))
  fi
}

assert_not_contains() {
  local label="$1" hay="$2" needle="$3"
  if printf '%s' "$hay" | grep -qF -- "$needle"; then
    echo "  FAIL  $label (unexpected '$needle')"
    FAIL=$((FAIL + 1))
  else
    echo "  PASS  $label"
    PASS=$((PASS + 1))
  fi
}

cleanup() {
  rm -rf "$TMP" "${TMP}-xdg" "${TMP}-empty" "${TMP}-remote-consumer" "${TMP}-targets.json"
}
trap cleanup EXIT

export CI=1
export NO_COLOR=1
export BLUEPRINT_HISTORY_LIMIT=10
# Isolate history/cache/targets for tests
export XDG_DATA_HOME="${TMP}-xdg/data"
export XDG_CACHE_HOME="${TMP}-xdg/cache"
export BLUEPRINT_TARGETS_FILE="${TMP}-targets.json"
mkdir -p "$XDG_DATA_HOME" "$XDG_CACHE_HOME"
rm -rf "$TMP" "${TMP}-targets.json"
mkdir -p "$TMP"

echo "== init =="
out="$(CI=1 NO_COLOR=1 "$BP" init --target "$TMP" 2>&1)"
assert_file "AGENTS.md written" "$TMP/AGENTS.md"
assert_file "HARNESS.md written" "$TMP/HARNESS.md"
assert_file "state written" "$TMP/.agent-blueprint.yaml"
assert_contains "init summary" "$out" "Blueprint synchronization completed"
assert_contains "init harness banner" "$out" "Blueprint initialized"
assert_contains "managed harness markers" "$(cat "$TMP/AGENTS.md")" "<!-- BLUEPRINT:HARNESS:START -->"
assert_contains "run id present" "$out" "Run  bp-"
assert_not_contains "no ANSI clear in CI" "$out" $'\033[2J'

echo "== install =="
out="$(CI=1 NO_COLOR=1 "$BP" install default --runtime cursor --target "$TMP" 2>&1)"
assert_dir "cursor commands" "$TMP/.cursor/commands"
assert_file "start command" "$TMP/.cursor/commands/start.md"
assert_contains "install completed" "$out" "Blueprint synchronization completed"
assert_contains "source validated" "$out" "Validating source repository"

echo "== sync =="
out="$(CI=1 NO_COLOR=1 "$BP" sync --target "$TMP" 2>&1)"
assert_eq "sync exit" "0" "0"
assert_contains "sync completed" "$out" "Blueprint synchronization completed"

echo "== dry-run =="
before="$(find "$TMP/.cursor" -type f | wc -l | tr -d ' ')"
out="$(CI=1 NO_COLOR=1 "$BP" install default --runtime cursor --target "$TMP" --dry-run 2>&1)"
after="$(find "$TMP/.cursor" -type f | wc -l | tr -d ' ')"
assert_eq "dry-run no new files" "$before" "$after"
assert_contains "dry-run events" "$out" "Run  bp-"

echo "== conflict =="
# Unmanaged local runtime file should get conflict sibling, not overwrite.
mkdir -p "$TMP/.cursor/commands"
printf 'local start\n' > "$TMP/.cursor/commands/start.md"
out="$(CI=1 NO_COLOR=1 "$BP" install default --runtime cursor --target "$TMP" 2>&1)"
assert_file "conflict sibling" "$TMP/.cursor/commands/start.md.blueprint-conflict"
content="$(cat "$TMP/.cursor/commands/start.md")"
assert_eq "local start preserved" "$content" "local start"
assert_contains "conflict message" "$out" "Conflict:"

echo "== agent files preserved on install =="
printf 'user agents\n' > "$TMP/AGENTS.md"
before_agents="$(cat "$TMP/AGENTS.md")"
CI=1 NO_COLOR=1 "$BP" install default --runtime cursor --target "$TMP" >/dev/null 2>&1
assert_eq "install leaves AGENTS.md" "$(cat "$TMP/AGENTS.md")" "$before_agents"
echo "== sync without state =="
empty="${TMP}-empty"
rm -rf "$empty"
mkdir -p "$empty"
set +e
out="$(CI=1 NO_COLOR=1 "$BP" sync --target "$empty" 2>&1)"
rc=$?
set -e
assert_eq "sync missing state fails" "$rc" "1"
assert_contains "missing state message" "$out" "no .agent-blueprint.yaml"

echo "== narrow terminal =="
out="$(CI=1 NO_COLOR=1 COLUMNS=40 "$BP" doctor --target "$TMP" 2>&1)"
assert_contains "narrow doctor" "$out" "Healthy"

echo "== monochrome / non-TTY symbols =="
out="$(CI=1 NO_COLOR=1 "$BP" doctor --target "$ROOT" 2>&1)"
assert_contains "doctor package mode" "$out" "package-source"
assert_contains "lib modules checked" "$out" "lib/blueprint"

echo "== history written =="
hist="${XDG_DATA_HOME}/blueprint/history.jsonl"
assert_file "history jsonl" "$hist"
assert_contains "history has runId" "$(head -1 "$hist")" '"runId"'

echo "== targets registry =="
assert_file "targets.json written" "$BLUEPRINT_TARGETS_FILE"
assert_contains "targets has path" "$(cat "$BLUEPRINT_TARGETS_FILE")" "$TMP"
assert_contains "targets has version" "$(cat "$BLUEPRINT_TARGETS_FILE")" '"version"'
# Second consumer should upsert a distinct path (newest first).
other="${TMP}-other"
rm -rf "$other"
mkdir -p "$other"
CI=1 NO_COLOR=1 "$BP" init --target "$other" >/dev/null 2>&1
tg="$(cat "$BLUEPRINT_TARGETS_FILE")"
assert_contains "targets has second path" "$tg" "$other"
# Count path entries (should be 2 unique).
path_count="$(printf '%s' "$tg" | grep -c '"path"' || true)"
assert_eq "targets unique count" "$path_count" "2"
# Re-init same target should not duplicate.
CI=1 NO_COLOR=1 "$BP" init --target "$TMP" >/dev/null 2>&1
path_count="$(grep -c '"path"' "$BLUEPRINT_TARGETS_FILE" || true)"
assert_eq "targets upsert no duplicate" "$path_count" "2"
rm -rf "$other"

echo "== remote fetchable detection (unit via bash) =="
# shellcheck source=lib/blueprint/repo.sh
source "${ROOT}/lib/blueprint/term.sh"
source "${ROOT}/lib/blueprint/repo.sh"
if repo_is_fetchable "https://github.com/example/shared-blueprint"; then
  echo "  PASS  https URL fetchable"
  PASS=$((PASS + 1))
else
  echo "  FAIL  https URL fetchable"
  FAIL=$((FAIL + 1))
fi
if ! repo_is_fetchable "agent-harness-blueprint"; then
  echo "  PASS  bare name not fetchable"
  PASS=$((PASS + 1))
else
  echo "  FAIL  bare name not fetchable"
  FAIL=$((FAIL + 1))
fi

echo "== file:// cache clone =="
# Create a bare-ish git repo copy for file:// fetch without network.
# Keep outside the package tree so path substring matching cannot confuse identity.
src_repo="$(mktemp -d "${TMPDIR:-/tmp}/bp-src-XXXXXX")"
rm -rf "$src_repo"
mkdir -p "$src_repo"
cp -R "${ROOT}/harness" "${ROOT}/blueprints" "${ROOT}/templates" "${ROOT}/manifest.yaml" "${ROOT}/VERSION" "$src_repo/"
mkdir -p "${src_repo}/prompts/system"
echo "# sys" > "${src_repo}/prompts/system/README.md"
cp "${ROOT}/blueprint" "$src_repo/blueprint"
mkdir -p "${src_repo}/lib"
cp -R "${ROOT}/lib/blueprint" "${src_repo}/lib/"
(
  cd "$src_repo"
  git init -q
  git config user.email "test@example.com"
  git config user.name "Test"
  git add -A
  git commit -qm "fixture"
)
consumer="${TMP}-remote-consumer"
rm -rf "$consumer"
mkdir -p "$consumer"
CI=1 NO_COLOR=1 "$BP" init --target "$consumer" >/dev/null 2>&1
abs_src="$(cd "$src_repo" && pwd)"
pkg_ver="$(tr -d '[:space:]' < "${ROOT}/VERSION")"
cat > "${consumer}/.agent-blueprint.yaml" <<EOF
source: file://${abs_src}
version: ${pkg_ver}
blueprint: default
overlay: null
runtimes:
  - cursor
installed_at_utc: 2026-01-01T00:00:00Z
conflict_policy: preserve-local
EOF
out="$(CI=1 NO_COLOR=1 "$BP" sync --target "$consumer" 2>&1)"
assert_contains "fetched from file url" "$out" "Fetching source repository"
assert_dir "remote sync wrote cursor" "$consumer/.cursor/commands"
rm -rf "$src_repo" "$consumer"

echo "== del =="
# Rebuild a clean consumer for removal tests.
del_t="${TMP}-del"
rm -rf "$del_t"
mkdir -p "$del_t"
CI=1 NO_COLOR=1 "$BP" init --target "$del_t" >/dev/null 2>&1
CI=1 NO_COLOR=1 "$BP" install default --runtime all --target "$del_t" >/dev/null 2>&1
printf 'keep this planning\n' > "$del_t/PLANNING.md"
printf 'user note\n' > "$del_t/AGENTS.md"
# Re-inject harness ref so del has something to strip
CI=1 NO_COLOR=1 "$BP" init --target "$del_t" >/dev/null 2>&1
assert_contains "agents has ref before del" "$(cat "$del_t/AGENTS.md")" "<!-- BLUEPRINT:HARNESS:START -->"
assert_file "harness before del" "$del_t/HARNESS.md"
assert_dir "cursor before del" "$del_t/.cursor"
assert_file "planning before del" "$del_t/PLANNING.md"

set +e
out="$(CI=1 NO_COLOR=1 "$BP" del --target "$del_t" 2>&1)"
rc=$?
set -e
assert_eq "del without --force fails in CI" "$rc" "1"
assert_contains "del needs force" "$out" "--force"

out="$(CI=1 NO_COLOR=1 "$BP" del --force --target "$del_t" 2>&1)"
assert_contains "del completed" "$out" "Blueprint removal completed"
assert_eq "HARNESS.md removed" "$([[ -f "$del_t/HARNESS.md" ]] && echo yes || echo no)" "no"
assert_eq "state removed" "$([[ -f "$del_t/.agent-blueprint.yaml" ]] && echo yes || echo no)" "no"
assert_eq "cursor removed" "$([[ -d "$del_t/.cursor" ]] && echo yes || echo no)" "no"
assert_eq "claude removed" "$([[ -d "$del_t/.claude" ]] && echo yes || echo no)" "no"
assert_eq "PLANNING removed" "$([[ -f "$del_t/PLANNING.md" ]] && echo yes || echo no)" "no"
assert_eq "DECISIONS removed" "$([[ -f "$del_t/DECISIONS.md" ]] && echo yes || echo no)" "no"
assert_eq "RUN_LOG removed" "$([[ -f "$del_t/RUN_LOG.md" ]] && echo yes || echo no)" "no"
assert_eq "HOTCACHE removed" "$([[ -f "$del_t/HOTCACHE.md" ]] && echo yes || echo no)" "no"
assert_eq "LEARNING removed" "$([[ -f "$del_t/LEARNING.md" ]] && echo yes || echo no)" "no"
assert_eq "ANTI-PATTERNS removed" "$([[ -f "$del_t/ANTI-PATTERNS.md" ]] && echo yes || echo no)" "no"
assert_file "AGENTS.md preserved" "$del_t/AGENTS.md"
assert_not_contains "harness ref stripped" "$(cat "$del_t/AGENTS.md")" "<!-- BLUEPRINT:HARNESS:START -->"
assert_not_contains "managed gitignore gone" "$(cat "$del_t/.gitignore" 2>/dev/null || true)" "# --- shared-agent-blueprints (managed) ---"
# Help documents keyword-only del
help_out="$(CI=1 NO_COLOR=1 "$BP" help 2>&1)"
assert_contains "help lists del" "$help_out" "del"
assert_contains "help keyword note" "$help_out" "keyword only"
rm -rf "$del_t"

echo
echo "Results: ${PASS} passed, ${FAIL} failed"
if [[ "$FAIL" -gt 0 ]]; then
  exit 1
fi
exit 0
