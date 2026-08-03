# Example consumer

Example **install state** for a project consuming `shared-agent-blueprints`.

## Install

From the consumer repo:

```bash
# Optional PATH install
ln -s /path/to/agent-harness-blueprint/blueprint /usr/local/bin/blueprint

# Point at a checkout / submodule / vendored copy of this package
/path/to/agent-harness-blueprint/blueprint init --target .

/path/to/agent-harness-blueprint/blueprint install engineering \
  --overlay gitlab \
  --runtime all \
  --target .

/path/to/agent-harness-blueprint/blueprint doctor --target .

# Later: refresh HARNESS.md only
/path/to/agent-harness-blueprint/blueprint update --target .

# Later: refresh runtime projections
/path/to/agent-harness-blueprint/blueprint sync --target .
```

## `.agent-blueprint.yaml` (generated shape)

```yaml
schema_version: 1
source: https://github.com/xxx/agent-harness-blueprint
version: <from package VERSION>   # written by CLI from ./VERSION
blueprint: engineering
overlay: gitlab
runtimes:
  - cursor
  - claude
installed_at_utc: 2026-07-29T00:00:00Z
conflict_policy: preserve-local
harness:
  entrypoint: HARNESS.md
  managed: true
  version: "<from package VERSION>"
agents:
  entrypoint: AGENTS.md
  reference_managed_on_init_only: true
compatibility:
  preserve_existing_agents: true
  preserve_existing_claude: true
```

`source` is a **portable repository identity**. When it is a git URL (`https://…`, `git@…`, `file://…`), `install` / `sync` clone or update a cache under `$XDG_CACHE_HOME/blueprint/repos/` and copy from that cache. Bare names still use whichever package checkout executes `./blueprint`.

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

**Copied (managed):** `.cursor/` and/or `.claude/` commands, skills, rules, and `templates/` (agent-workflow only) from selected blueprint; root `HARNESS.md` from `templates/entrypoints/` (`init` / `update`). Agent instruction files keep a managed harness reference block on `init` only.

Workflow docs such as `review-checklist.md` / `adr.md` land under `.cursor/templates/` or `.claude/templates/` — not the project root.

**Preserved (user-owned):** existing `AGENTS.md` / `agents.md` content outside managed markers; existing `CLAUDE.md` (never modified by init/update).

**Local state (created in the consumer, never part of the blueprint package):** `PLANNING.md`, `DECISIONS.md`, `RUN_LOG.md`, `HOTCACHE.md`, `LEARNING.md`, `ANTI-PATTERNS.md`, `ARCHITECTURE.md`.

**Local overrides (always win):** `*.local.md`, `*.local.mdc`, `.agent-blueprint.local.yaml`.

**Session / history:** `.agent-blueprint/` holds resume state (gitignored). Run history lives in `$XDG_DATA_HOME/blueprint/history.jsonl` on the machine running the CLI.

**Known targets:** the package-local `targets.json` next to the `blueprint` CLI records consumer paths + blueprint version after `init` / state writes. It is gitignored (`templates/gitignore` + package `.gitignore`) and must not be committed.
