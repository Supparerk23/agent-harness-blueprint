# Documentation index

Narrative docs for this shared agent blueprint package. Start from the root [README](../README.md) for the categorized overview with diagrams.

## By category

### Architecture

| Document | Contents |
|---|---|
| [architecture.md](architecture.md) | Package vs consumer, multi-runtime projection (mermaid) |
| [compatibility.md](compatibility.md) | Package sources vs consumer-only artifacts |

### Setup

| Document | Contents |
|---|---|
| [setup.md](setup.md) | Init → install → doctor flow (mermaid) |
| [adoption-and-lineage.md](adoption-and-lineage.md) | Adoption checklist |

### How it works

| Document | Contents |
|---|---|
| [how-it-works.md](how-it-works.md) | Read order, layers, conflict policy (mermaid) |
| [skills.md](skills.md) | Skill concepts under `harness/skills/` |
| [rules.md](rules.md) | Rule concepts under `harness/rules/` |
| [slash-commands.md](slash-commands.md) | Slash playbook inventory |

### Harness workflow

| Document | Contents |
|---|---|
| [harness-workflow.md](harness-workflow.md) | Step-by-step AI delivery loop (mermaid) |
| [quick-start.md](quick-start.md) | `/start` ritual in adopting projects |
| [memory-and-planning.md](memory-and-planning.md) | Consumer memory files + template sources |

## CLI

```bash
./blueprint doctor
./blueprint init --target /path/to/repo
./blueprint install default --runtime all --target /path/to/repo
./blueprint install engineering --overlay gitlab --runtime all --target /path/to/repo
```
