# CLAUDE.md

Compatibility entrypoint for Claude-oriented agents consuming this harness.

## Read order

1. `AGENTS.md` (shared instructions)
2. `AGENTS.local.md` / `CLAUDE.local.md` if present (project overrides)
3. `.cursor/rules/*.mdc` (policy)
4. Relevant `.cursor/skills/*/SKILL.md` for the active task
5. Root memory files when executing planned work (`PLANNING.md`, etc.)

## Do

- Keep routes/handlers thin when the project uses that pattern
- Update planning/decisions/run-log together after execution batches
- Prefer composition and local overrides over rewriting shared assets

## Don't

- Run destructive Git/DB/infra commands without explicit confirmation
- Treat FastAPI/GitLab assumptions as universal unless the installed blueprint includes them
- Promote every learning note into a rule without human review

<!-- managed-by: shared-agent-blueprints -->
