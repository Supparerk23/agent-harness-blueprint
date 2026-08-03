Review the current changes or a specific merge request (MR). This repo uses **GitLab** — do not use `gh`.

**Prerequisite:** Read and apply [prerequisite.md](prerequisite.md) — run `ensure_glab` before any `glab` command.

---

0. Run `ensure_glab` (see [prerequisite.md](prerequisite.md)).

1. Determine scope:
   - If an MR IID is provided: `glab mr diff <iid>`
   - If on a feature/hotfix branch with an open MR: `glab mr diff "$BRANCH"`
   - Otherwise: `git diff origin/${TARGET_BRANCH}...HEAD`

2. Analyze for issues (prioritized):
   🔴 Critical (must fix):
   - Security vulnerabilities (injection, auth, secrets)
   - Correctness bugs (wrong logic, off-by-one, null deref)
   - Missing error handling on external calls

   🟡 Warning (should fix):
   - Performance (N+1 queries, unnecessary re-renders)
   - Missing tests for new business logic
   - Inconsistent error handling patterns

   🟢 Suggestion (optional):
   - Code style inconsistencies (if not caught by linter)
   - Documentation gaps

3. Output format:
   ## Review Summary
   **Files changed:** X | **Issues found:** Y

   ### 🔴 Critical
   - `file.py:42` — [description] | Suggestion: [fix]

   ### 🟡 Warnings
   - ...

4. If asked to fix: implement critical issues first
