# Blueprint: `default`

Core shared agent harness for any repository.

## Installs

- Commands: `/start`, `/review`
- Rules: safety, planning-execution-tracking
- Skills: memory-system-protocol, planning-execution-tracking, docs-style, skill-creator
- Memory templates under `templates/memory/`
- Consumer entrypoints from `templates/entrypoints/`

## Does not include

- GitLab `glab` MR automation
- Project-specific engineering etiquette

Use `engineering` plus forge overlays (`--overlay gitlab`) when those are needed. Choose `--runtime cursor|claude|all` for the tool projection.
