# Blueprint: `default`

Core shared agent harness for any repository.

## Installs

- Commands: `/start`, `/review`
- Rules: safety, task-execution
- Skills: `context-recall`, `task-execution`, `docs-style`, `skill-creator`, `i-have-adhd`, `ponytail` (+ review/audit/debt/gain/help), `generate-test-cases`, `update-api-docs`
- `refactor-code` is added by the `engineering` profile (consumer `install` still projects the full package skill set from `package_skill_names`)
- Memory templates under `templates/memory/`
- Consumer entrypoints from `templates/entrypoints/`

## Does not include

- GitLab `glab` MR automation
- Project-specific engineering etiquette

Use `engineering` plus forge overlays (`--overlay gitlab`) when those are needed. Choose `--runtime cursor|claude|codex|all` for the tool projection.
