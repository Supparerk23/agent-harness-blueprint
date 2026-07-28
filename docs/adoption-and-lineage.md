# Adoption checklist & naming lineage

## Forking into a new repository

### Preferred (package install)

```bash
/path/to/shared-agent-blueprints/scripts/agent install default --target /path/to/your-repo
# FastAPI lineage + GitLab overlay:
/path/to/shared-agent-blueprints/scripts/agent install engineering-fastapi --overlay gitlab --target /path/to/your-repo
/path/to/shared-agent-blueprints/scripts/agent doctor --target /path/to/your-repo
```

### Legacy (still supported)

1. Copy `.cursor/` wholesale or cherry-pick skills/rules/commands.
2. Decide whether automation targets **GitLab (`glab`)** or needs **GitHub (`gh`)** rewrites.
3. Update `key-principles` / FastAPI / router-doc rules if your tree is not `app/routers/*`.
4. Keep `/start` + the memory protocol when you want cross-session continuity and auditable artifacts.
5. Split additional prose into `docs/` whenever the root `README` risks becoming a novel (`documents/` is a legacy symlink to `docs/`).

## Relationship to *AI Wealth Health Check*

Frontmatter descriptions may still mention the originating service. Treat that text as **lineage metadata**—edit it in forks so future agents know which assumptions (FastAPI layout, Pub/Sub workers, Alembic, etc.) remain true for your project.

Stack-specific rules now live under `blueprints/engineering/fastapi/` and are only installed with `engineering-fastapi`. See [compatibility.md](compatibility.md).
