# Task-start templates (memory system)

Use when `/start` or the user asks to reset short-lived operational memory. Copy templates exactly; keep section headers; do not delete files.

## HOTCACHE.md

Replace entire file. Substitute `[branch]`, `[YYYY-MM-DD]`, and focus summary after reset.

```markdown
# HOTCACHE.md

Last updated UTC: [YYYY-MM-DD]

## Active State
- Branch: `[branch]` · HEAD: `-`
- Focus: [one-line task summary]

## Working Assumptions
- (none yet)

## Immediate Next Steps
- (none yet)

```

## ANTI-PATTERNS.md

Restore **task-start default** (global safety only). Do not add task-specific notes here.

```markdown
# ANTI-PATTERNS.md

High-confidence operational safety memory. Keep entries concise and actionable.

## Destructive Operations Without Confirmation
- Do not run destructive filesystem, Git, database, infrastructure, or credential operations without explicit user confirmation.
- Examples include `rm -rf`, force push, hard reset, production migrations, irreversible SQL, infrastructure deletion, credential rotation, and mass refactors with unclear blast radius.

## Memory Layer Pollution
- Do not store reflections, lessons, or generalized knowledge in `RUN_LOG.md`; it is telemetry only.
- Do not append endlessly to `HOTCACHE.md`; replace stale operational state.
- Do not promote every `LEARNING.md` observation into a skill or rule without human consolidation.

## Architecture Drift
- Do not invent new architectural layers when an existing project pattern already covers the need.
- Do not bypass established service, worker, or module boundaries without an explicit decision recorded in `DECISIONS.md`.

## Environment Safety
- Do not run cleanup scripts, mass deletes, or cache flushes against shared/staging/production environments.
- Gate destructive local helpers so they only run when the environment is explicitly `local` or `localhost`.

```

Domain-specific anti-patterns live in curated skills or may be re-added to `ANTI-PATTERNS.md` after human review — not on every task start.

## LEARNING.md

Clear reflection buffer on task start; do not carry prior task insights forward.

```markdown
# LEARNING.md

Candidate insights for human review. Not authoritative — promote to skills or rules only after consolidation.

```

## Do not reset on task start

- `ARCHITECTURE.md` — system design
- Installed skill trees under the active runtime (`.cursor/skills/`, `.claude/skills/`, `.agents/skills/`) — curated procedural knowledge
