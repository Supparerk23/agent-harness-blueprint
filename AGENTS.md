# AGENTS.md

Shared agent instructions for repositories using **shared-agent-blueprints**.

## Package vs consumer

- **This package** stores shared sources under `harness/`, `prompts/`, `templates/`, and `blueprints/`.
- **Consuming projects** receive a generated `.cursor/` runtime plus memory files via `scripts/agent install`.

Do not keep task-memory files (`PLANNING.md`, `RUN_LOG.md`, etc.) or a live `.cursor/` tree inside the blueprint package itself.

## Runtime layout (in consumers)

Cursor reads local paths. Install writes:

- `.cursor/commands/` — slash playbooks
- `.cursor/skills/` — curated procedures
- `.cursor/rules/` — always-on / glob policies

Prefer updating package sources under `harness/`, then run `scripts/agent sync --target <consumer>`.

## Memory harness (consumer-only)

When present at the **consumer** repo root:

| File | Role |
|---|---|
| `PLANNING.md` | Goals and task checklists |
| `DECISIONS.md` | Why logs |
| `RUN_LOG.md` | Execution telemetry only |
| `HOTCACHE.md` | Short-lived operational state |
| `LEARNING.md` | Candidate insights |
| `ANTI-PATTERNS.md` | High-confidence safety bans |
| `ARCHITECTURE.md` | Stable design (never auto-reset) |

Pristine templates: `templates/memory/`.

## Overrides (consumer-only)

- `AGENTS.local.md`
- `CLAUDE.local.md`
- `.agent-blueprint.local.yaml`
- `.cursor/rules/*.local.mdc`

Shared installs must not overwrite local state files (`PLANNING.md`, `RUN_LOG.md`, etc.).

## CLI

```bash
scripts/agent init --target /path/to/repo
scripts/agent install default --target /path/to/repo
scripts/agent install engineering-fastapi --overlay gitlab --target /path/to/repo
scripts/agent update --target /path/to/repo
scripts/agent sync --target /path/to/repo
scripts/agent doctor
```

<!-- managed-by: shared-agent-blueprints -->
