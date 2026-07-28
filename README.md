# Shared Agent Blueprints

Reusable **Cursor** agent harness packaged as composable blueprints. This repository is the **package source** — it does not ship a live project `.cursor/` tree or task-memory files.

Originated with Finnomena's *AI Wealth Health Check* FastAPI + worker service. Stack-specific rules live under `blueprints/engineering/fastapi/` — not in the default profile.

## Quick start

```bash
scripts/agent doctor
scripts/agent install default --target /path/to/your-repo
# or
scripts/agent install engineering-fastapi --overlay gitlab --target /path/to/your-repo
scripts/agent sync --dry-run --target /path/to/your-repo
```

Install writes `.cursor/`, optional `AGENTS.md` / `CLAUDE.md`, and memory files **into the target project** from `harness/` + `templates/`.

## Package layout

```
.
├── VERSION / manifest.yaml
├── blueprints/          # default | engineering | engineering-fastapi | startup
├── harness/             # canonical shared commands, rules, skills
├── prompts/             # prompt library
├── templates/           # memory + PRD/ADR/review templates
├── docs/                # package docs
├── scripts/agent        # init | install | update | sync | doctor
├── AGENTS.md / CLAUDE.md
└── examples/consumer/   # example consuming project config
```

## Not in this package (consumer-only)

These are created in adopting projects by `scripts/agent init|install` or `/start`:

| Artifact | Why consumer-only |
|---|---|
| `.cursor/` | Runtime install target generated from `harness/` + blueprint overlays |
| `PLANNING.md` `DECISIONS.md` `RUN_LOG.md` | Task state |
| `HOTCACHE.md` `LEARNING.md` `ANTI-PATTERNS.md` | Operational / reflection memory |
| `.agent-blueprint.yaml` | Install state for that project |

Pristine sources live under `templates/memory/` and `harness/`.

## Blueprints

| Blueprint | Includes |
|---|---|
| `default` | `/start`, `/review`, safety + planning rules, core skills, memory templates |
| `engineering` | default + commit playbook + refactor skill + ADR/review templates |
| `engineering-fastapi` | engineering + FastAPI/Alembic/router/key-principles rules |
| `startup` | default + PRD/ADR templates |

GitLab/`glab` MR commands are an **overlay**: `--overlay gitlab`.

## Compatibility

See **[docs/compatibility.md](docs/compatibility.md)**. Local overrides in consumers: `AGENTS.local.md`, `CLAUDE.local.md`, `.agent-blueprint.local.yaml`, `*.local.mdc`.

## Documentation

| Topic | Path |
|---|---|
| Docs index | [docs/README.md](docs/README.md) |
| Compatibility layer | [docs/compatibility.md](docs/compatibility.md) |
| `/start` ritual | [docs/quick-start.md](docs/quick-start.md) |
| Memory layers | [docs/memory-and-planning.md](docs/memory-and-planning.md) |
| Slash commands | [docs/slash-commands.md](docs/slash-commands.md) |
| Adoption / lineage | [docs/adoption-and-lineage.md](docs/adoption-and-lineage.md) |
