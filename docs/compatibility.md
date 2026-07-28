# Compatibility layer

This repository is the **shared blueprint package**. Consuming projects receive a generated Cursor runtime and memory files via `scripts/agent`.

## Package paths (source of truth)

| Path | Role |
|---|---|
| `harness/` | Canonical shared commands, rules, skills |
| `prompts/` | Prompt library |
| `templates/` | Memory + PRD/ADR/review templates |
| `blueprints/` | Composable profiles (`default`, `engineering`, `engineering-fastapi`, `startup`) |
| `docs/` | Package documentation |
| `manifest.yaml` / `VERSION` | Package metadata |
| `scripts/agent` | Install / sync / doctor CLI |
| `AGENTS.md` / `CLAUDE.md` | Package entrypoint docs (also copied into consumers on install) |

## Consumer-only paths (do not commit in this package)

| Path | Role |
|---|---|
| `.cursor/` | Runtime install target generated from `harness/` + blueprint overlays |
| `PLANNING.md`, `DECISIONS.md`, `RUN_LOG.md` | Task planning / rationale / telemetry state |
| `HOTCACHE.md`, `LEARNING.md`, `ANTI-PATTERNS.md` | Short-lived / curated consumer memory |
| `ARCHITECTURE.md` | Optional stable design doc in the consumer |
| `.agent-blueprint.yaml` | Install state for that consumer |

## How adopting projects work

1. Run `scripts/agent install <blueprint> --target /path/to/repo`.
2. The installer writes `.cursor/` and memory templates into the target with `preserve-local` conflict policy.
3. Local overrides (`*.local.md`, `*.local.mdc`, `.agent-blueprint.local.yaml`) always win over managed files.
4. Memory state files are never overwritten by install/sync when they already exist in the target.
