# Rules — concepts (`.cursor/rules/`)

Rules are `.mdc` files with YAML frontmatter:

- **`alwaysApply: true`** — broadly injected context; keep bullets tight so prompts stay usable.
- **`alwaysApply: false` + `globs`** — only attach when editing matching paths.

## `planning-execution-tracking.mdc`

Thin shim that points agents to the **planning-execution-tracking** skill: after each coded batch ensure `PLANNING.md` stays truthful, append `DECISIONS.md`, and rotate `RUN_LOG.md` telemetry with retention enforced.

## `key-principles.mdc`

Anchors repo-wide Python engineering etiquette for the originating service:

- distinguish API routers vs asynchronous workers (`typer`, Pub/Sub),
- reinforce stack norms (`uv`, Ruff, pytest),
- emphasize typing + Pydantic contracts at boundaries,
- keep persistence adapters and observability practices consistent.

## `fastapi-guidelines.mdc`

Adds FastAPI-layer specifics beyond `key-principles`: thin routers, explicit models/prefix parity, guarded async/sync selection, pragmatic error/logging/perf guidance.

## `safety-rules.mdc`

Operational red lines for agents—disruptive git/db/infra/credential/package edits default to **destructive** until a human confirms, with preference for previews/dry-runs (`git diff`, `terraform plan`, etc.).

## `router-endpoint-readme-sync.mdc`

**Scoped** (`globs: app/routers/*.py`): whenever router decorators change endpoints, update the companion router README so external consumers stay aligned.

Remove or rewrite if your framework/layout differs.

## `alembic-cli-migrations-only.mdc`

Keep schema drift reproducible:

- generate migrations exclusively via **`alembic revision --autogenerate`**, not hand-written files,
- sync companion SQL/scripts under `migration/` when that directory exists,
- avoid manual revision-id surgery unless there is an explicit exception.

Drop this rule entirely when Alembic is not part of your stack.
