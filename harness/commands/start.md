Start a new task: create a branch and reset task-scoped memory files.

1. Ask for branch details before creating:
   - Type: `feature/` or `hotfix/`
   - Name: JIRA key or short slug (e.g. `NEUR-1234`)
   - Confirm full branch name: `[type][name]`

2. Create and switch to the branch:
   `git checkout -b feature/NEUR-1234`

3. Reset task memory files using skill reset templates (read both files; copy templates exactly):
   - `.cursor/skills/planning-execution-tracking/templates.md` → `PLANNING.md`, `DECISIONS.md`, `RUN_LOG.md`
   - `.cursor/skills/memory-system-protocol/templates.md` → `HOTCACHE.md`, `ANTI-PATTERNS.md`, `LEARNING.md`

   Do not reset files listed under **Do not reset** in `memory-system-protocol/templates.md`.

4. After reset, set `HOTCACHE.md` **Active State** to the new branch, today's UTC date, and the task focus line.

5. Return message:
   `✅ Started : [branch name]`

Rules:
- NEVER create branches on `main`, `master`, or `develop` without explicit user confirmation.
- NEVER run destructive Git operations (`push --force`, `reset --hard`) as part of start.
- Reset content only — do not remove memory files from the repo.
- Ask the user for goal/context if missing; optionally pre-fill `## Goal` and `## Context for AI` in `PLANNING.md` from their reply.
- Branch naming: prefer `feature/[JIRA]` or `hotfix/[JIRA]` to match commit/PR commands.
