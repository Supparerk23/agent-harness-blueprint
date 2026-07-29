# Example consumer

Example **install state** for a project consuming `shared-agent-blueprints`.

## Install

From the consumer repo:

```bash
# point at a checkout / submodule / vendored copy of this package
/path/to/shared-agent-blueprints/scripts/agent init --target .

/path/to/shared-agent-blueprints/scripts/agent install engineering \
  --overlay gitlab \
  --runtime all \
  --target .

/path/to/shared-agent-blueprints/scripts/agent doctor --target .
```

## `.agent-blueprint.yaml` (generated shape)

```yaml
source: /path/to/shared-agent-blueprints
version: 1.0.0
blueprint: engineering
overlay: gitlab
runtimes:
  - cursor
  - claude
installed_at_utc: 2026-07-29T00:00:00Z
conflict_policy: preserve-local
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
```

## What gets copied vs what stays local

**Copied (managed):** `.cursor/` and/or `.claude/` commands, skills, rules from selected blueprint; `AGENTS.md`, `CLAUDE.md` from `templates/entrypoints/`; `templates/review-checklist.md`.

**Local state (created in the consumer, never part of the blueprint package):** `PLANNING.md`, `DECISIONS.md`, `RUN_LOG.md`, `HOTCACHE.md`, `LEARNING.md`, `ANTI-PATTERNS.md`, `ARCHITECTURE.md`.

**Local overrides (always win):** `*.local.md`, `*.local.mdc`, `.agent-blueprint.local.yaml`.
