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
- Do not move long-running report generation or Pub/Sub processing into FastAPI routes.
- Do not bypass existing service and worker boundaries when adding pitch-buddy or report-generation behavior.

## Local Test Cleanup Against Non-Local Environments
- Do not run local helper scripts that delete report rows or call Redis `FLUSHALL` unless the environment is explicitly gated as `local` or `localhost`.

```

Domain-specific anti-patterns (e.g. bond pitch buddy) live in curated skills or may be re-added to `ANTI-PATTERNS.md` after human review — not on every task start.

## LEARNING.md

Clear reflection buffer on task start; do not carry prior task insights forward.

```markdown
# LEARNING.md

Candidate insights for human review. Not authoritative — promote to skills or rules only after consolidation.

```

## Do not reset on task start

- `ARCHITECTURE.md` — system design
- `.cursor/skills/` — curated procedural knowledge
