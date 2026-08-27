# Architecture

How the blueprint package relates to consuming projects and AI tools.

## Package vs consumer

```mermaid
flowchart LR
  subgraph package [Blueprint package]
    harness[harness/]
    templates[templates/]
    blueprints[blueprints/]
    cli[blueprint]
  end

  subgraph consumer [Adopting project]
    agents[AGENTS.md]
    memory[Memory files]
    cursor[".cursor/"]
    claude[".claude/"]
    agentsRt[".agents/"]
  end

  cli -->|"init"| agents
  cli -->|"init"| memory
  harness -->|"install --runtime"| cursor
  harness -->|"install --runtime"| claude
  harness -->|"install --runtime"| agentsRt
  templates -->|"init / install"| agents
  blueprints -->|"install profile"| cursor
  blueprints -->|"install profile"| claude
  blueprints -->|"install profile"| agentsRt
```

## Source of truth

| Layer | Lives in package | Lands in consumer |
|---|---|---|
| Commands / rules / skills | `harness/` | `.cursor/`, `.claude/`, and/or `.agents/` |
| Shared AI contract | `templates/entrypoints/` | `HARNESS.md`, `AGENTS.md` (+ optional user `CLAUDE.md`) |
| Memory skeletons | `templates/memory/` | `PLANNING.md`, … (once; never overwritten) |
| Profiles | `blueprints/` | Selected extras + overlays |

Canonical content is always edited under `harness/` (and templates), then projected with `install` / `sync`. Tool dirs are adapters, not forks.

## Multi-runtime projection

```mermaid
flowchart TB
  H[harness/commands rules skills]
  H --> C[".cursor/ Cursor"]
  H --> L[".claude/ Claude Code"]
  H --> X[".agents/ Codex"]
  A[AGENTS.md] -.->|read by all agents| C
  A -.->|read by all agents| L
  A -.->|read by all agents| X
  CM[CLAUDE.md] -->|points to AGENTS.md| A
```

| Source | Cursor | Claude Code | Codex |
|---|---|---|---|
| `harness/commands/*.md` | `.cursor/commands/` | `.claude/commands/` | `.agents/commands/` |
| `harness/skills/*/` | `.cursor/skills/` | `.claude/skills/` | `.agents/skills/` |
| `harness/rules/*.mdc` | `.cursor/rules/*.mdc` | `.claude/rules/*.md` | `.agents/rules/*.md` |
| Workflow templates (`adr`, `prd`, …) | `.cursor/templates/` | `.claude/templates/` | `.agents/templates/` |

Codex discovers repository skills from `.agents/skills/` ([Codex skills](https://developers.openai.com/codex/skills)). Playbooks under `.agents/commands/` are the same files as other runtimes; Codex does not treat them as slash commands — invoke via `$skill-name` or `AGENTS.md` / `HARNESS.md`.

`--runtime all` projects all three trees. Cursor also loads `.agents/skills/` and `.claude/skills/` for compatibility, so skills can appear more than once when multiple runtimes are installed.

See also [compatibility.md](compatibility.md).
