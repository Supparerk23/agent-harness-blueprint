# CLAUDE.md

Claude Code entrypoint for this repository.

## Read order

1. `AGENTS.md` — shared harness contract and AI workflow (source of truth)
2. `AGENTS.local.md` / `CLAUDE.local.md` if present (project overrides)
3. `.claude/rules/` — always-on / path-scoped policy
4. Relevant `.claude/skills/*/SKILL.md` for the active task
5. Root memory files when executing planned work (`PLANNING.md`, `DECISIONS.md`, `RUN_LOG.md`, `HOTCACHE.md`, etc.)

## Notes

- Commands live under `.claude/commands/` after `scripts/agent install … --runtime claude|all`.
- Do not fork shared playbooks here; sync from the blueprint package or use local overrides.
- Honor safety and memory rules in `AGENTS.md`.
