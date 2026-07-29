# CLAUDE.md

Package-source entrypoint for Claude-oriented agents working on **shared-agent-blueprints**.

## Read order

1. `AGENTS.md` (package orientation)
2. `harness/` skills/rules/commands relevant to the change
3. `templates/entrypoints/` when editing the consumer contract
4. `docs/` for adoption and compatibility notes

## Do

- Prefer composition and blueprint overlays over one-off forks
- Keep consumer entrypoints in `templates/entrypoints/`; keep package docs at the root
- Update docs when CLI or runtime projection behavior changes

## Don't

- Commit consumer memory files or `.cursor/` / `.claude/` into this package
- Assume GitLab or stack-specific overlays apply to every install
- Promote every learning note into a shared rule without human review
