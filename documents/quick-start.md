# Quick start (`/start` ritual)

`/start` (see [.cursor/commands/start.md](../.cursor/commands/start.md)) aligns planning, telemetry, and scratchpads before heavy implementation.

## Steps

1. **Pick a branch** — `feature/[ticket-or-slug]` or `hotfix/[ticket-or-slug]`. Confirm the full name (`feature/NEUR-1234`).
2. **Create & switch**:

   ```bash
   git checkout -b feature/NEUR-1234
   ```

3. **Reset task-scoped templates exactly** (copy bodies verbatim; do not delete files):
   - `.cursor/skills/planning-execution-tracking/templates.md` → `PLANNING.md`, `DECISIONS.md`, `RUN_LOG.md`
   - `.cursor/skills/memory-system-protocol/templates.md` → `HOTCACHE.md`, `ANTI-PATTERNS.md`, `LEARNING.md`
   - Never reset items listed under **Do not reset** inside the memory templates (for example `.cursor/skills/`, `ARCHITECTURE.md`).
4. **Prime `HOTCACHE.md`** with branch name, today’s UTC date, and a one-line focus statement.
5. Optionally pre-fill `PLANNING.md` sections `## Goal` / `## Context for AI` from the user’s summary.

## Safety rails baked into the command

- Do not create work directly on `main`, `master`, or `develop` without explicit confirmation.
- Never pair `/start` with destructive git (`push --force`, `reset --hard`, etc.).
- Replace template **content** only—keep the files in version control.

When finished, announce `✅ Started : [branch name]` so humans know the ritual completed.

See [memory-and-planning.md](memory-and-planning.md) for how the reset files behave afterward.

## Repo-root files after `/start` (counts)

Templates from two skills recreate **six** Markdown trackers at the repository root—no new trackers are spawned on every agent turn:

| When | Repo-root trackers | Count |
| --- | --- | --- |
| After **`/start`** | `PLANNING.md`, `DECISIONS.md`, `RUN_LOG.md`, `HOTCACHE.md`, `ANTI-PATTERNS.md`, `LEARNING.md` | **6** |
| Optional stable layer | Add `ARCHITECTURE.md` when you maintain system design; **`/start` must not reset it** (see [.cursor/skills/memory-system-protocol/templates.md](../.cursor/skills/memory-system-protocol/templates.md) **Do not reset**). | **up to 7** |
| During **delivery batches** | Same files updated in place (checkboxes in `PLANNING`, rows in `DECISIONS`/`RUN_LOG`, scratch edits in `HOTCACHE`). | — |

For the ASCII tree plus the bundled-skill catalogue table, open [README.md](../README.md) and read **Project layout & repo-root memory files**.

## Bundled skills (five folders under `.cursor/skills/`)

| Folder | Typical trigger |
| --- | --- |
| `memory-system-protocol/` | Layered memory read/update; `/start` templates for `HOTCACHE`, `ANTI-PATTERNS`, `LEARNING`. |
| `planning-execution-tracking/` | Tasks from `PLANNING`; `/start` templates for `PLANNING`, `DECISIONS`, `RUN_LOG`. |
| `refactor-code/` | Refactors; human applies risky edits (`disable-model-invocation`). |
| `docs-style/` | README/doc IA refactors (`disable-model-invocation`). |
| `skill-creator/` | Creating or iterating new skills under `.cursor/skills/<name>/`. |

The last three skills do **not** define the six repo-root trackers above; see [skills.md](skills.md) for concepts.
