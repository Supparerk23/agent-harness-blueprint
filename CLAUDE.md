# CLAUDE.md

Package-source entrypoint for Claude-oriented agents working on **shared-agent-blueprints**.

## Read order

1. `AGENTS.md` (package orientation)
2. `contributor/` for package-contributor commit/PR/skill standards (not consumer harness)
3. `harness/` skills/rules/commands relevant to the change
4. `templates/entrypoints/` when editing the consumer contract
5. `docs/` for adoption and compatibility notes

## Contributor harness

Package-source only — does not install into target projects:

- Commits: `contributor/commands/commit.md` (conventional commits, **no JIRA**)
- PRs: `contributor/commands/pr.md` (GitHub `gh` + short **Release notes** for `CHANGELOG.md`)
- Skill: `skill-creator` only (`harness/skills/skill-creator/SKILL.md` + [docs/standards/skill-naming.md](docs/standards/skill-naming.md)). Consumer skills are not part of this harness — see [docs/skills.md](docs/skills.md).
- Optional local IDE projection: `./blueprint install-contributor --runtime all` (`/commit`, `/pr`, `skill-creator`)

## Do

- Prefer composition and blueprint overlays over one-off forks
- Keep consumer entrypoints in `templates/entrypoints/`; keep package docs at the root
- Update docs when CLI or runtime projection behavior changes

## Don't

- Commit consumer memory files or `.cursor/` / `.claude/` / `.agents/` into this package
- Assume GitLab or stack-specific overlays apply to every install
- Promote every learning note into a shared rule without human review
- Treat `contributor/` as content for consumer blueprint installs
