# Agent harness blueprint

Portable **Cursor** harness: `.cursor/commands` (slash playbooks), `.cursor/skills` (curated procedures), and `.cursor/rules` (`.mdc` policy). The bundle nudges agents toward safer automation, traceable planning, and layered memory.

Originated with Finnomena's *AI Wealth Health Check* FastAPI + worker service—update or delete rules that mention `app/` layouts, GitLab `glab`, or Alembic when you target a different stack.

## Quick start

1. Copy `.cursor/` (or cherry-pick files) into the repo you want to instrument.
2. Run **`/start`**: branch `feature/[slug]` or `hotfix/[slug]`, reset task-memory files from [.cursor/commands/start.md](.cursor/commands/start.md) + template sources under `.cursor/skills/*/templates.md`.
3. Browse **[documents/quick-start.md](documents/quick-start.md)** for the full ritual and file list.

```bash
# optional sanity check once the kit is copied
git status
```

## Project layout & repo-root memory files

The harness ships as **Cursor config + docs** alongside your codebase. Typical tree (exact names may vary if you add skills or prose):

```
.
├── README.md                    # landing page (keep short; details in documents/)
├── documents/                   # deeper guides (see documents/README.md)
├── .cursor/
│   ├── commands/                # slash playbooks (/start, /pr, ...)
│   ├── rules/                   # always-on *.mdc policy
│   └── skills/
│       ├── memory-system-protocol/    # SKILL.md (+ templates.md for /start)
│       ├── planning-execution-tracking/
│       ├── refactor-code/
│       ├── docs-style/
│       └── skill-creator/
├── PLANNING.md                  # rewritten each /start
├── DECISIONS.md                 # skeleton on /start; append afterward
├── RUN_LOG.md                   # header reset on /start; capped telemetry rows
├── HOTCACHE.md                  # replaced often; operational scratchpad
├── ANTI-PATTERNS.md             # safety defaults restored on /start
├── LEARNING.md                  # cleared on /start; draft reflections only
└── ARCHITECTURE.md              # optional; never auto-reset by /start
```

### Bundled skills (`.cursor/skills/`, five folders)

This blueprint ships **five** procedure bundles—each is a directory with at least `SKILL.md` (plus optional sidecars like `templates.md`):

| Folder | Role |
| --- | --- |
| [`memory-system-protocol/`](.cursor/skills/memory-system-protocol/SKILL.md) | Layered memory protocol; [`templates.md`](.cursor/skills/memory-system-protocol/templates.md) feeds `/start` (`HOTCACHE`, `ANTI-PATTERNS`, `LEARNING`). |
| [`planning-execution-tracking/`](.cursor/skills/planning-execution-tracking/SKILL.md) | Checklist + `DECISIONS` / `RUN_LOG` hygiene; [`templates.md`](.cursor/skills/planning-execution-tracking/templates.md) feeds `/start` (`PLANNING`, `DECISIONS`, `RUN_LOG`). |
| [`refactor-code/`](.cursor/skills/refactor-code/SKILL.md) | Python refactor playbook (`disable-model-invocation`—invoke deliberately). |
| [`docs-style/`](.cursor/skills/docs-style/SKILL.md) | Thin README + `documents/` IA; optional richer `ARCHITECTURE.md` guidance. |
| [`skill-creator/`](.cursor/skills/skill-creator/SKILL.md) | Meta workflow for authoring new skills under `.cursor/skills/<name>/`. |

Only the first two participate in the **six** repo-root files reset by `/start`; the others do not define a fixed tracker set at the repository root.

### When tracking skills are engaged (`/start` + delivery batches)

Together **[memory-system-protocol](.cursor/skills/memory-system-protocol/SKILL.md)** and **[planning-execution-tracking](.cursor/skills/planning-execution-tracking/SKILL.md)** funnel work into predictable files—not new files every message.

| Phase | Repo-root Markdown files touched | Count |
|---|---|---|
| After **`/start`** (templates copied from `.cursor/skills/*/templates.md`) | `PLANNING.md`, `DECISIONS.md`, `RUN_LOG.md`, `HOTCACHE.md`, `ANTI-PATTERNS.md`, `LEARNING.md` | **6** |
| Same workflow, **`ARCHITECTURE.md` adopted** | above + maintained `ARCHITECTURE.md` (not reset by `/start`) | **up to 7** |
| During **execution batches** (planning skill checklist) | same files updated in place (`PLANNING` checkboxes, `DECISIONS`/`RUN_LOG` appended, optionally `HOTCACHE` rewritten) | no extra *new* files by default |

`ARCHITECTURE.md` is optional until you create it; **don’t** delete or reset it on `/start` (see memory skill [templates.md](.cursor/skills/memory-system-protocol/templates.md)).

### Beyond `/start`: optional file churn

- **`refactor-code`** — analysis guidance; no fixed set of new repo files when invoked.
- **`docs-style`** — scaffolding its *default* `documents/` layout can add **many** topic files beyond this blueprint’s slim set ([docs-style SKILL.md](.cursor/skills/docs-style/SKILL.md) lists suggested filenames).
- **`skill-creator`** — adds **`SKILL.md`** (and optional `scripts/`, `references/`, `assets/`) under `.cursor/skills/<skill-name>/` when you author procedures; folder count varies.

For layer-by-layer behavior, see **[documents/memory-and-planning.md](documents/memory-and-planning.md)**.

## Documentation map

Detailed concepts live under **[documents/](documents/README.md)**:

| Topic | File |
|---|---|
| **`/start` + branch ritual** | [documents/quick-start.md](documents/quick-start.md) |
| **Repo-root memory layers** (`PLANNING`, `RUN_LOG`, …) | [documents/memory-and-planning.md](documents/memory-and-planning.md) |
| **Slash commands** | [documents/slash-commands.md](documents/slash-commands.md) |
| **Skills (concepts)** | [documents/skills.md](documents/skills.md) |
| **Rules (`.mdc` concepts)** | [documents/rules.md](documents/rules.md) |
| **Adopting in new repos + naming lineage** | [documents/adoption-and-lineage.md](documents/adoption-and-lineage.md) |

Need the docs index first? Start at **[documents/README.md](documents/README.md)**.
