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
  if printf '%s' "$hay" | grep -qF "$needle"; then
    echo "  PASS  $label"
    PASS=$((PASS + 1))
  else
    echo "  FAIL  $label (missing '$needle')"
    FAIL=$((FAIL + 1))
  fi
}

assert_not_contains() {
  local label="$1" hay="$2" needle="$3"
  if printf '%s' "$hay" | grep -qF "$needle"; then
    echo "  FAIL  $label (unexpected '$needle')"
    FAIL=$((FAIL + 1))
  else
    echo "  PASS  $label"
    PASS=$((PASS + 1))
  fi
}

cleanup() {
  rm -rf "$TMP"
}
trap cleanup EXIT

export CI=1
export NO_COLOR=1
export BLUEPRINT_HISTORY_LIMIT=10
# Isolate history/cache for tests
export XDG_DATA_HOME="${TMP}-xdg/data"
export XDG_CACHE_HOME="${TMP}-xdg/cache"
mkdir -p "$XDG_DATA_HOME" "$XDG_CACHE_HOME"
rm -rf "$TMP"
mkdir -p "$TMP"

echo "== init =="
out="$(CI=1 NO_COLOR=1 "$BP" init --target "$TMP" 2>&1)"
assert_file "AGENTS.md written" "$TMP/AGENTS.md"
assert_file "state written" "$TMP/.agent-blueprint.yaml"
assert_contains "init summary" "$out" "Blueprint synchronization completed"
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
# Unmanaged local file should get conflict sibling, not overwrite.
printf 'local only\n' > "$TMP/AGENTS.md"
# Remove managed marker if present
out="$(CI=1 NO_COLOR=1 "$BP" install default --runtime cursor --target "$TMP" 2>&1)"
assert_file "conflict sibling" "$TMP/AGENTS.md.blueprint-conflict"
content="$(cat "$TMP/AGENTS.md")"
assert_eq "local AGENTS preserved" "$content" "local only"
assert_contains "conflict message" "$out" "Conflict:"

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
cat > "${consumer}/.agent-blueprint.yaml" <<EOF
source: file://${abs_src}
version: 1.0.0
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

echo
echo "Results: ${PASS} passed, ${FAIL} failed"
if [[ "$FAIL" -gt 0 ]]; then
  exit 1
fi
exit 0
