# Shared Agent Blueprints

Reusable **Cursor** agent harness packaged as composable blueprints. Preserves the existing `.cursor/` runtime so current projects keep working, while adding `manifest.yaml`, shared sources, and a lightweight install CLI.

Originated with Finnomena's *AI Wealth Health Check* FastAPI + worker service. Stack-specific rules live under `blueprints/engineering/fastapi/` — not in the default profile.

## Quick start (new)

```bash
scripts/agent doctor
scripts/agent install default
# or
scripts/agent install engineering-fastapi --overlay gitlab
scripts/agent sync --dry-run
```

## Quick start (legacy — still supported)

1. Copy `.cursor/` (or cherry-pick files) into the target repo.
2. Run **`/start`** to reset task-memory files from skill templates.
3. See **[docs/quick-start.md](docs/quick-start.md)**.

## Package layout

```
.
├── VERSION / manifest.yaml
├── blueprints/          # default | engineering | engineering-fastapi | startup
├── harness/             # canonical shared commands, rules, skills
├── prompts/             # prompt library
├── templates/           # memory + PRD/ADR/review templates
├── docs/                # canonical package docs
├── documents -> docs    # compatibility symlink (legacy path)
├── scripts/agent        # init | install | update | sync | doctor
├── AGENTS.md / CLAUDE.md
├── .cursor/             # compatibility runtime (unchanged behavior)
└── examples/consumer/   # example consuming project config
```

## Blueprints

| Blueprint | Includes |
|---|---|
| `default` | `/start`, `/review`, safety + planning rules, core skills, memory templates |
| `engineering` | default + commit playbook + refactor skill + ADR/review templates |
| `engineering-fastapi` | engineering + FastAPI/Alembic/router/key-principles rules |
| `startup` | default + PRD/ADR templates |

GitLab/`glab` MR commands are an **overlay**: `--overlay gitlab`.

## Compatibility

See **[docs/compatibility.md](docs/compatibility.md)**. Local overrides: `AGENTS.local.md`, `CLAUDE.local.md`, `.agent-blueprint.local.yaml`, `*.local.mdc`.

## Documentation

| Topic | Path |
|---|---|
| Docs index | [docs/README.md](docs/README.md) |
| Compatibility layer | [docs/compatibility.md](docs/compatibility.md) |
| `/start` ritual | [docs/quick-start.md](docs/quick-start.md) |
| Memory layers | [docs/memory-and-planning.md](docs/memory-and-planning.md) |
| Slash commands | [docs/slash-commands.md](docs/slash-commands.md) |
| Adoption / lineage | [docs/adoption-and-lineage.md](docs/adoption-and-lineage.md) |
