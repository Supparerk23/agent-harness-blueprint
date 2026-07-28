# CLAUDE.md

Compatibility entrypoint for Claude-oriented agents consuming this harness.

## Read order

### In this package (blueprint source)
1. `AGENTS.md`
2. `harness/` skills/rules/commands relevant to the change
3. `docs/` for adoption and compatibility notes

### In an adopting project
1. `AGENTS.md` (shared instructions)
2. `AGENTS.local.md` / `CLAUDE.local.md` if present (project overrides)
3. `.cursor/rules/*.mdc` (policy)
4. Relevant `.cursor/skills/*/SKILL.md` for the active task
5. Root memory files when executing planned work (`PLANNING.md`, etc.)

## Do

- Keep routes/handlers thin when the project uses that pattern
- Update planning/decisions/run-log together after execution batches **in consumer repos**
- Prefer composition and local overrides over rewriting shared assets

## Don't

- Run destructive Git/DB/infra commands without explicit confirmation
- Commit consumer memory files or `.cursor/` into the blueprint package
- Treat FastAPI/GitLab assumptions as universal unless the installed blueprint includes them
- Promote every learning note into a rule without human review

<!-- managed-by: shared-agent-blueprints -->
