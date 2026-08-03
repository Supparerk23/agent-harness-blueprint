---
name: planning-execution-tracking
description: Execute tasks from PLANNING.md and keep project tracking files synchronized. Use when the user asks to run items from planning, update task status, log implementation rationale in DECISIONS.md, or record execution telemetry in RUN_LOG.md.
---

# Planning Execution Tracking

## Purpose
Keep execution traceable and consistent by updating planning, decisions, and run telemetry in the same delivery batch.

## When to use
Use this skill when:
- The user asks to execute work from `PLANNING.md`.
- A planning task status has changed (done/in-progress/pending).
- Work outcomes need to be documented in `DECISIONS.md`.
- Execution telemetry needs to be captured in `RUN_LOG.md`.

## Required workflow (in order)
1. Read `PLANNING.md` and identify task checkboxes.
2. Execute requested work.
3. After implementation, update task states:
   - Completed => `- [x]`
   - Not done => `- [ ]`
4. Update the `## ✅ Done` section with concise delivered outcomes.
5. Create or update `DECISIONS.md` with a new timestamped entry:
   - What changed (files + behavior)
   - Why this approach was chosen (practical rationale/tradeoff)
6. Create or update `RUN_LOG.md` with one execution row for this batch.
7. Enforce retention in `RUN_LOG.md`: keep latest 30 entries.
8. Keep wording concise and factual. Do not include private reasoning.

## Required execution checklist
For every execution batch, the agent must complete this checklist and keep it true in resulting files:

```markdown
Execution Tracking Checklist
- [ ] PLANNING.md task checkboxes updated
- [ ] PLANNING.md `## ✅ Done` updated
- [ ] DECISIONS.md appended with timestamp + Did/Why
- [ ] RUN_LOG.md appended with one execution row
- [ ] RUN_LOG.md retention enforced (<= 30 entries)
```

Before finishing, all items above must be logically satisfied by actual file updates.

## Task start reset

When resetting files for a new task (`/start`), read and apply [templates.md](templates.md) for `PLANNING.md`, `DECISIONS.md`, and `RUN_LOG.md`.

## Planning and DECISIONS formats

- `PLANNING.md` copy-paste body: [templates.md](templates.md) (`## PLANNING.md`).
- `DECISIONS.md` entry format: [templates.md](templates.md) (`## DECISIONS entry format`).
- `RUN_LOG.md` table header on reset and example rows (reference only): [templates.md](templates.md) (`## RUN_LOG.md`, `## RUN_LOG example rows`). Row defaults: see `### RUN_LOG row defaults` below.

## RUN_LOG.md

Execution telemetry only — not reflections or lessons. Keep latest **30** entries; newest rows at the top (below header).

### RUN_LOG workflow
1. Create `RUN_LOG.md` if it does not exist.
2. Add one row per execution batch after implementation/testing.
3. Fill available telemetry only; use `-` for unknown values.
4. Keep newest rows at the top (below header).
5. Enforce retention: keep only latest 30 execution entries.

### RUN_LOG row defaults
- If branch/commit/token/duration are unavailable, use `-`.
- `Status` should be one of: `Complete`, `Partial`, `Failed`.
- `Retry` should be numeric (`0`, `1`, `2`, ...).

## Notes
- If `DECISIONS.md` does not exist, create it.
- Keep new `DECISIONS.md` entries append-only unless the user asks to rewrite history.
- Prefer minimal edits and preserve user-authored content.
- Do not modify unrelated files.
