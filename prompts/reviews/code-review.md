# Code review prompt

Review the current branch or selected diff.

## Focus areas
1. Correctness and regressions
2. Security and secret hygiene
3. Performance and reliability
4. Maintainability and consistency with local conventions
5. Test coverage for changed behavior

## Output format
- Summary (2–4 sentences)
- Blocking issues (if any)
- Non-blocking suggestions
- Explicit “looks good” only when no blocking issues remain

Use `<runtime>/templates/review-checklist.md` when available (`.cursor/templates/` or `.claude/templates/`).
