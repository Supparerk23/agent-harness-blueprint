# How it works

Runtime behavior after a project has been initialized and installed.

## Read order (any agent)

```mermaid
flowchart TD
  A[AGENTS.md] --> B{Local overrides?}
  B -->|yes| L[AGENTS.local.md / CLAUDE.local.md]
  B -->|no| R[Rules under active runtime]
  L --> R
  R --> S[Relevant skill SKILL.md]
  S --> M[Memory files if executing planned work]
```

Claude Code also loads root `CLAUDE.md`, which points at `AGENTS.md` first.

## Layers

```mermaid
flowchart LR
  subgraph always [Always available]
    rules[Rules]
  end
  subgraph onDemand [Loaded when relevant]
    commands[Commands / playbooks]
    skills[Skills]
  end
  subgraph durable [Cross-session state]
    memory[Memory files]
  end

  rules --> skills
  commands --> skills
  skills --> memory
```

| Layer | Role | Typical path |
|---|---|---|
| **Commands** | Named playbooks (`/start`, `/review`, `/commit`, forge) | `<runtime>/commands/` |
| **Rules** | Always-on or path-scoped policy | `<runtime>/rules/` |
| **Skills** | Curated multi-step procedures | `<runtime>/skills/*/SKILL.md` |
| **Memory** | Planning, decisions, telemetry, scratch | Repo root `*.md` |

`<runtime>` is `.cursor` or `.claude`.

## Install / sync conflict policy

```mermaid
flowchart TD
  copy[Copy managed file] --> exists{Dest exists?}
  exists -->|no| write[Write + managed marker]
  exists -->|yes memory state| keep[Preserve local state]
  exists -->|yes managed marker| overwrite[Overwrite from package]
  exists -->|yes unmanaged| conflict[Write *.blueprint-conflict]
```

Local overrides (`*.local.md`, `*.local.mdc`, `.agent-blueprint.local.yaml`) always win.

## Update loop

1. Edit package sources under `harness/` / `templates/` / `blueprints/`.
2. In the consumer: `./blueprint sync --dry-run`, review, then `sync`.
3. Run `./blueprint doctor --target .`.

When consumer state `source` is a git URL, `sync` / `install` fetch or update a local cache (`$XDG_CACHE_HOME/blueprint/repos/`) before copying. Status symbols (`→` `✓` `!` `✗` `⊘` `~` `+`) stream per file; a final summary reports added / updated / skipped / failed counts and a run ID.

Interrupted operations leave `.agent-blueprint/session.json` in the consumer. The next interactive `install` / `sync` offers resume; non-interactive runs start fresh unless `BLUEPRINT_RESUME=1`.

Details: [compatibility.md](compatibility.md), [slash-commands.md](slash-commands.md), [rules.md](rules.md), [skills.md](skills.md).
