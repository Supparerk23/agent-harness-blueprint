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
