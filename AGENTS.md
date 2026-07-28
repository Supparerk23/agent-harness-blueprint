# AGENTS.md

Shared agent instructions for repositories using **shared-agent-blueprints**.

## Runtime layout (compatibility)

Cursor reads local paths. This package installs into:

- `.cursor/commands/` — slash playbooks
- `.cursor/skills/` — curated procedures
- `.cursor/rules/` — always-on / glob policies

Canonical shared sources live in this package under `harness/`, `prompts/`, and `templates/`. Prefer updating those sources, then run `scripts/agent sync`.

## Memory harness

When present at the repo root:

| File | Role |
|---|---|
| `PLANNING.md` | Goals and task checklists |
| `DECISIONS.md` | Why logs |
| `RUN_LOG.md` | Execution telemetry only |
| `HOTCACHE.md` | Short-lived operational state |
| `LEARNING.md` | Candidate insights |
| `ANTI-PATTERNS.md` | High-confidence safety bans |
| `ARCHITECTURE.md` | Stable design (never auto-reset) |

## Overrides

Project-specific customizations belong in:

- `AGENTS.local.md`
- `CLAUDE.local.md`
- `.agent-blueprint.local.yaml`
- `.cursor/rules/*.local.mdc`

Shared installs must not overwrite local state files (`PLANNING.md`, `RUN_LOG.md`, etc.).

## CLI

```bash
scripts/agent init
scripts/agent install default
scripts/agent install engineering-fastapi --overlay gitlab
scripts/agent update
scripts/agent sync
scripts/agent doctor
```

<!-- managed-by: shared-agent-blueprints -->
