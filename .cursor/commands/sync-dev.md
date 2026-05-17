Sync current branch with develop and resolve any conflicts.

1. Fetch latest:
   `git fetch origin develop`

2. Check for conflicts:
   `git merge-tree $(git merge-base HEAD origin/develop) HEAD origin/develop`

3. If no conflicts:
   `git merge origin/develop --no-edit`
   `git push origin HEAD`

4. If conflicts:
   - List conflict files
   - For each file: read both versions and resolve
   - Prefer our changes for feature code
   - Prefer theirs for config/dependency changes
   - Mark each resolution: `git add [file]`
   - Complete merge: `git commit --no-edit`
   - Push: `git push origin HEAD`

5. Run tests after sync: `npm test --silent`

Rules:
- NEVER use `git rebase` on shared branches
- Always use merge for develop sync
- If >10 conflicts: stop and ask for human help