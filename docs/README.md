# Documentation index

Narrative docs for this shared agent blueprint package. Canonical path: `docs/`.

| Document | Contents |
|---|---|
| [compatibility.md](compatibility.md) | Package sources vs consumer-only runtime/memory artifacts |
| [quick-start.md](quick-start.md) | `/start` workflow in adopting projects |
| [memory-and-planning.md](memory-and-planning.md) | Consumer memory files + template sources |
| [slash-commands.md](slash-commands.md) | Slash playbook inventory |
| [skills.md](skills.md) | Skill concepts under `harness/skills/` |
| [rules.md](rules.md) | Rule concepts under `harness/rules/` + blueprint overlays |
| [adoption-and-lineage.md](adoption-and-lineage.md) | Checklist for adopting the kit + lineage metadata |

## CLI

```bash
scripts/agent doctor
scripts/agent install default --target /path/to/repo
scripts/agent install engineering-fastapi --overlay gitlab --target /path/to/repo
```
