# Rules — concepts (`harness/rules/` → consumer runtime `rules/`)

Rules are markdown files with YAML frontmatter:

- **`alwaysApply: true`** — broadly injected context; keep bullets tight so prompts stay usable.
- **`alwaysApply: false` + `globs`** — only attach when editing matching paths.

Shared defaults live under `harness/rules/`. After install:

- Cursor: `.cursor/rules/*.mdc`
- Claude Code: `.claude/rules/*.md` (same content; Cursor-only frontmatter keys are ignored)

## `planning-execution-tracking`

Thin shim that points agents to the **planning-execution-tracking** skill: after each coded batch ensure `PLANNING.md` stays truthful, append `DECISIONS.md`, and rotate `RUN_LOG.md` telemetry with retention enforced.

## `safety-rules`

Operational red lines for agents—disruptive git/db/infra/credential/package edits default to **destructive** until a human confirms, with preference for previews/dry-runs (`git diff`, `terraform plan`, etc.).

Project-specific engineering etiquette belongs in local overrides (`*.local.mdc` / local rule files) or a team overlay—not in the shared default profile.
