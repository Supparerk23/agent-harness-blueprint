# Example consumer: FastAPI service

This is an example **install state** for a project consuming `shared-agent-blueprints`.

## Install

From the consumer repo:

```bash
# point at a checkout / submodule / vendored copy of this package
/path/to/shared-agent-blueprints/scripts/agent install engineering-fastapi \
  --overlay gitlab \
  --target .

/path/to/shared-agent-blueprints/scripts/agent doctor --target .
```

## `.agent-blueprint.yaml` (generated shape)

```yaml
source: /path/to/shared-agent-blueprints
version: 1.0.0
blueprint: engineering-fastapi
overlay: gitlab
installed_at_utc: 2026-07-28T00:00:00Z
conflict_policy: preserve-local
runtime_root: .cursor
```

## `.agent-blueprint.local.yaml` (project overrides)

```yaml
variables:
  forge: gitlab
  default_branch: main
  integration_branch: develop
  test_command: "uv run pytest"
  branch_prefix: "feature/"
overrides:
  - AGENTS.local.md
  - CLAUDE.local.md
  - .cursor/rules/key-principles.local.mdc
```

## What gets copied vs what stays local

**Copied (managed):** `.cursor/commands`, `.cursor/skills`, `.cursor/rules` from selected blueprint, `AGENTS.md`, `CLAUDE.md`, `templates/review-checklist.md`.

**Local state (created in the consumer, never part of the blueprint package):** `PLANNING.md`, `DECISIONS.md`, `RUN_LOG.md`, `HOTCACHE.md`, `LEARNING.md`, `ANTI-PATTERNS.md`, `ARCHITECTURE.md`.

**Local overrides (always win):** `*.local.md`, `*.local.mdc`, `.agent-blueprint.local.yaml`.
