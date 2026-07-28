# HOTCACHE.md

Last updated UTC: 2026-07-28

## Active State
- Branch: `feature/init-shared` · HEAD: `bd0fbd2`
- Focus: Docs tree deduplicated (`docs/` canonical; `documents` → `docs` symlink)

## Working Assumptions
- Narrative docs live only under `docs/`
- `documents/` is a legacy symlink alias, not a second content tree
- `.cursor/` remains the compatibility runtime; `harness/` is the shared source for generic assets

## Immediate Next Steps
- Optional: add GitHub/`gh` overlay mirroring GitLab commands
- Optional: first managed sync pass to stamp markers on copied runtime files in consumers
