Create a commit for the current changes.

1. Check what's changed:
   - Staged: `git diff --staged`
   - Unstaged: `git diff`
   - Stage everything if needed: `git add -A`

2. Write a clear commit message:
   - Format: `type(scope): description`
   - Types: feat|fix|refactor|test|docs|chore
   - Keep under 72 chars

3. Commit and push:
   `git commit -m "jira number | 🤖 [message]"`
   `git push origin HEAD --set-upstream`

4. Return message `✅ Committed : [commit hash]`

Rules:
- [jira number] find from branch name `feature/[jira number]` or `hotfix/[jira number]`
- NEVER push to main or master directly
- Do **not** create a pull request or merge request. Stop after the commit hash. Use `/pr` to open a PR/MR.
