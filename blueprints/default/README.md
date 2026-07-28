# Blueprint: `default`

Core shared agent harness for any repository.

## Installs

- Commands: `/start`, `/review`
- Rules: safety, planning-execution-tracking
- Skills: memory-system-protocol, planning-execution-tracking, docs-style, skill-creator
- Memory templates under `templates/memory/`

## Does not include

- FastAPI / Alembic / router README rules
- GitLab `glab` MR automation
- Project-specific `key-principles`

Use `engineering-fastapi` or forge overlays when those are needed.
