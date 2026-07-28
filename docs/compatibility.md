# Compatibility layer

This repository remains usable as a **direct Cursor kit** while also acting as a **shared blueprint package**.

## Stable paths (do not break)

| Path | Status |
|---|---|
| `.cursor/commands/` | Compatibility runtime — still authoritative for current Cursor sessions |
| `.cursor/skills/` | Compatibility runtime |
| `.cursor/rules/` | Compatibility runtime |
| `docs/` | Canonical narrative documentation |
| `documents/` | Compatibility symlink → `docs/` (legacy path) |
| Root memory files | Local state — not package sources |
| `AGENTS.md` / `CLAUDE.md` | Compatibility agent entrypoints |

## Shared sources

| Path | Role |
|---|---|
| `harness/` | Canonical shared commands/rules/skills |
| `prompts/` | Prompt library |
| `templates/` | Memory + PRD/ADR/review templates |
| `blueprints/` | Composable profiles (`default`, `engineering`, `engineering-fastapi`, `startup`) |
| `docs/` | Package documentation (single source of truth) |
| `manifest.yaml` / `VERSION` | Package metadata |
| `scripts/agent` | Install / sync / doctor CLI |

## How existing projects keep working

1. Continue copying or using `.cursor/` as before.
2. Or run `scripts/agent install <blueprint>` which writes into `.cursor/` with `preserve-local` conflict policy.
3. Local overrides (`*.local.md`, `*.local.mdc`, `.agent-blueprint.local.yaml`) always win over managed files.
4. Memory state files are never overwritten by install/sync when they already exist.
5. Old `documents/*` links resolve via the `documents` → `docs` symlink.
