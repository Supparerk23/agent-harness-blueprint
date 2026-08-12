# Task-start templates (planning execution)

Use when `/start` or the user asks to reset task-scoped planning and execution telemetry files. Copy templates exactly; keep section headers; do not delete files.

## PLANNING.md

```markdown
## Goal

## Task

## ✅ Done

## Blockers
- None currently

## Context for AI

```

## DECISIONS.md

```markdown
# DECISIONS.md

```

Append new entries during work; do not pre-fill history on reset.

## DECISIONS entry format

Append during work (do not pre-fill on reset):

- `YYYY-MM-DD HH:MM` - Did: `<changes>` | Why: `<reasoning>`

## RUN_LOG.md

Header and separator only on task reset — no execution rows:

```markdown
| Timestamp UTC | Agent | Branch | Commit | Scope | Files | Input Tok | Output Tok | Duration | Tests | Retry | Status | Errors | Notes |
|---|---|---|---|---|---:|---:|---:|---|---|---:|---|---|---|
```

When repopulating after reset: keep latest 30 execution entries; newest rows at the top (below header).

## RUN_LOG example rows

Reference only — do not copy into `RUN_LOG.md` on `/start`:

| Timestamp UTC | Agent | Branch | Commit | Scope | Files | Input Tok | Output Tok | Duration | Tests | Retry | Status | Errors | Notes |
|---|---|---|---|---|---:|---:|---:|---|---|---:|---|---|---|
| 2026-05-08 09:12 | Claude Sonnet 4 | feature/auth-jwt | a81f9c2 | JWT middleware | 3 | 18.2k | 1.0k | 3m22s | lint:pass unit:pass e2e:pending | 0 | Partial | - | Integration tests pending |
| 2026-05-08 10:03 | Cursor Agent | feature/auth-refresh | b92de11 | Refresh token flow | 3 | 24.1k | 1.8k | 5m11s | lint:pass unit:pass e2e:pass | 1 | Complete | Race condition during refresh | Added optimistic session lock |
| 2026-05-08 11:40 | OpenHands | chore/observability | d14ca77 | OpenTelemetry integration | 4 | 31.5k | 2.4k | 8m03s | lint:pass integration:pass | 0 | Complete | - | Added request tracing + correlation IDs |
| 2026-05-08 13:21 | Claude Sonnet 4 | refactor/router-cleanup | e67aa21 | Router modularization | 8 | 42.8k | 3.9k | 14m08s | lint:pass unit:fail | 2 | Failed | Circular dependency in route loader | Refactor reverted partially |
| 2026-05-08 14:02 | Cursor Agent | hotfix/payment-timeout | f82bb09 | Payment timeout fix | 2 | 9.7k | 0.7k | 2m41s | lint:pass smoke:pass | 0 | Complete | - | Increased upstream timeout to 15s |
