Create a commit for the current changes in **this blueprint package**.

This playbook is for package contributors only. Do not use consumer harness commit rules (no JIRA keys).

1. Check what's changed:
   - Staged: `git diff --staged`
   - Unstaged: `git diff`
   - Stage everything if needed: `git add -A`

2. Write a clear commit message:
   - Format: `type(scope): description`
   - Types: feat|fix|refactor|test|docs|chore
   - Keep under 72 chars
   - Prefer concise, imperative subjects (what / why)

3. Commit and push:
   ```bash
   git commit -m "$(cat <<'EOF'
   type(scope): description

   EOF
   )"
   git push -u origin HEAD
   ```

4. Return message `✅ Committed : [commit hash]`

Rules:
- **No JIRA number** in the commit message or title
- NEVER push to main or master directly
- Do **not** open a pull request. Stop after the commit hash. Use `contributor/commands/pr.md` (or `/pr`) separately.
- Do not commit consumer artifacts (`.cursor/`, `.claude/`, `PLANNING.md`, etc.)
