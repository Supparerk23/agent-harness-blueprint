# Architecture

How the blueprint package relates to consuming projects and AI tools.

## Package vs consumer

```mermaid
flowchart LR
  subgraph package [Blueprint package]
    harness[harness/]
    templates[templates/]
    blueprints[blueprints/]
    cli[scripts/agent]
  end

  subgraph consumer [Adopting project]
    agents[AGENTS.md]
    memory[Memory files]
    cursor[".cursor/"]
    claude[".claude/"]
  end

  cli -->|"init"| agents
  cli -->|"init"| memory
  harness -->|"install --runtime"| cursor
  harness -->|"install --runtime"| claude
  templates -->|"init / install"| agents
  blueprints -->|"install profile"| cursor
  blueprints -->|"install profile"| claude
```

## Source of truth

| Layer | Lives in package | Lands in consumer |
|---|---|---|
| Commands / rules / skills | `harness/` | `.cursor/` and/or `.claude/` |
| Shared AI contract | `templates/entrypoints/` | `AGENTS.md`, `CLAUDE.md` |
| Memory skeletons | `templates/memory/` | `PLANNING.md`, … (once; never overwritten) |
| Profiles | `blueprints/` | Selected extras + overlays |

Canonical content is always edited under `harness/` (and templates), then projected with `install` / `sync`. Tool dirs are adapters, not forks.

## Multi-runtime projection

```mermaid
flowchart TB
  H[harness/commands rules skills]
  H --> C[".cursor/ Cursor"]
  H --> L[".claude/ Claude Code"]
  A[AGENTS.md] -.->|read by all agents| C
  A -.->|read by all agents| L
  CM[CLAUDE.md] -->|points to AGENTS.md| A
```

| Source | Cursor | Claude Code |
|---|---|---|
| `harness/commands/*.md` | `.cursor/commands/` | `.claude/commands/` |
| `harness/skills/*/` | `.cursor/skills/` | `.claude/skills/` |
| `harness/rules/*.mdc` | `.cursor/rules/*.mdc` | `.claude/rules/*.md` |
| Workflow templates (`adr`, `prd`, …) | `.cursor/templates/` | `.claude/templates/` |

See also [compatibility.md](compatibility.md).
