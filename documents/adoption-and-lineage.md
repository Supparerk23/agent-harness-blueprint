# Adoption checklist & naming lineage

## Forking into a new repository

1. Copy `.cursor/` wholesale or cherry-pick skills/rules/commands.
2. Decide whether automation targets **GitLab (`glab`)** or needs **GitHub (`gh`)** rewrites.
3. Update `key-principles` / FastAPI / router-doc rules if your tree is not `app/routers/*`.
4. Keep `/start` + the memory protocol when you want cross-session continuity and auditable artifacts.
5. Split additional prose into `documents/` whenever the root `README` risks becoming a novel.

## Relationship to *AI Wealth Health Check*

Frontmatter descriptions may still mention the originating service. Treat that text as **lineage metadata**—edit it in forks so future agents know which assumptions (FastAPI layout, Pub/Sub workers, Alembic, etc.) remain true for your project.
