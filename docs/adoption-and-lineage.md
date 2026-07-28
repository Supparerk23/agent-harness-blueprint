# Adoption checklist & naming lineage

## Install into a new repository

```bash
/path/to/shared-agent-blueprints/scripts/agent install default --target /path/to/your-repo
# FastAPI lineage + GitLab overlay:
/path/to/shared-agent-blueprints/scripts/agent install engineering-fastapi --overlay gitlab --target /path/to/your-repo
/path/to/shared-agent-blueprints/scripts/agent doctor --target /path/to/your-repo
```

That writes consumer-only artifacts into the target:

- `.cursor/` (from `harness/` + selected blueprint/overlay)
- memory files from `templates/memory/` if absent
- install state `.agent-blueprint.yaml`

## Manual cherry-pick (optional)

1. Copy from `harness/commands|skills|rules` (and optional blueprint overlays) into the target `.cursor/`.
2. Decide whether automation targets **GitLab (`glab`)** or needs **GitHub (`gh`)** rewrites.
3. Skip FastAPI/Alembic/key-principles rules unless the target is that stack.
4. Keep `/start` + the memory protocol when you want cross-session continuity and auditable artifacts.
5. Split additional prose into `docs/` whenever the root `README` risks becoming a novel.

## Relationship to *AI Wealth Health Check*

Frontmatter descriptions may still mention the originating service. Treat that text as **lineage metadata**—edit it in forks so future agents know which assumptions (FastAPI layout, Pub/Sub workers, Alembic, etc.) remain true for your project.

Stack-specific rules live under `blueprints/engineering/fastapi/` and are only installed with `engineering-fastapi`. See [compatibility.md](compatibility.md).
