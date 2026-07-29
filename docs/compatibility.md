# Compatibility layer

This repository is the **shared blueprint package**. Consuming projects receive a shared `AGENTS.md` contract, memory files, and optional tool runtimes via `./blueprint`.

## Package paths (source of truth)

| Path | Role |
|---|---|
| `harness/` | Canonical shared commands, rules, skills |
| `prompts/` | Prompt library |
| `templates/entrypoints/` | Consumer `AGENTS.md` / `CLAUDE.md` contract |
| `templates/` | Memory + PRD/ADR/review templates |
| `blueprints/` | Composable profiles (`default`, `engineering`, `startup`) |
| `docs/` | Package documentation |
| `manifest.yaml` / `VERSION` | Package metadata |
| `./blueprint` | Init / install / sync / doctor CLI |
| `AGENTS.md` / `CLAUDE.md` | Package-source orientation only |

## Consumer-only paths (do not commit in this package)

| Path | Role |
|---|---|
| `.cursor/` | Cursor runtime projected from `harness/` |
| `.claude/` | Claude Code runtime projected from `harness/` |
| `PLANNING.md`, `DECISIONS.md`, `RUN_LOG.md` | Task planning / rationale / telemetry state |
| `HOTCACHE.md`, `LEARNING.md`, `ANTI-PATTERNS.md` | Short-lived / curated consumer memory |
| `ARCHITECTURE.md` | Optional stable design doc in the consumer |
| `.agent-blueprint.yaml` | Install state for that consumer |

## How adopting projects work

1. Run `./blueprint init --target /path/to/repo` — writes `AGENTS.md`, `CLAUDE.md`, memory skeletons, and a managed `.gitignore` section from `templates/gitignore` (no tool runtime yet).
2. Run `./blueprint install <blueprint> --runtime all --target /path/to/repo` — projects `harness/` into `.cursor/` and/or `.claude/`.
3. Local overrides (`*.local.md`, `*.local.mdc`, `.agent-blueprint.local.yaml`) always win over managed files.
4. Memory state files are never overwritten by install/sync when they already exist in the target.

## Runtime projection

| Source | Cursor | Claude Code |
|---|---|---|
| `harness/commands/*.md` | `.cursor/commands/` | `.claude/commands/` |
| `harness/skills/*/` | `.cursor/skills/` | `.claude/skills/` |
| `harness/rules/*.mdc` | `.cursor/rules/*.mdc` | `.claude/rules/*.md` |
| `templates/adr.md`, `review-checklist.md`, … | `.cursor/templates/` | `.claude/templates/` |

Workflow templates (`adr`, `prd`, `review-checklist`) live **inside the runtime** only — they are not copied to the project root `templates/` folder.
