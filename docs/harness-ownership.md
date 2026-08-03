# Harness ownership and agent entrypoints

How `HARNESS.md` relates to `AGENTS.md` / `agents.md` / `CLAUDE.md` in adopting projects.

## Ownership model

| File or section | Owner | `init` may modify | `update` may modify |
|---|---|---|---|
| `HARNESS.md` | Blueprint Service | Yes | Yes |
| Managed runtime projections (`.cursor/` / `.claude/`) | Blueprint Service | via `install` | Yes (when runtimes declared) |
| Managed `.gitignore` section | Blueprint Service | Yes | Yes |
| `.agent-blueprint.yaml` version fields | Blueprint Service | Yes | Yes |
| Managed block in `AGENTS.md` | Blueprint Service | Yes | No |
| Managed block in `agents.md` | Blueprint Service | Yes | No |
| Content outside managed markers | User | No | No |
| `CLAUDE.md` | User | No | No |

The Blueprint Service never overwrites a user-owned file completely unless it is **creating** a file that does not exist.

## Precedence (agent instruction files)

Case-sensitive detection at the project root:

1. `AGENTS.md`
2. `agents.md`
3. Create `AGENTS.md`

Rules:

- Do not rename `agents.md` → `AGENTS.md`
- Do not merge the two files
- If both exist, select `AGENTS.md`, leave `agents.md` untouched, emit a non-fatal warning
- `CLAUDE.md` is never a substitute for the agents entrypoint and is never modified by `init` / `update`

## Initialization (`blueprint init`)

1. Detect `CLAUDE.md` (report only)
2. Resolve agents entrypoint by precedence
3. Create or safely install root `HARNESS.md` from `templates/entrypoints/HARNESS.md`
4. Insert or reconcile the managed Harness Reference block in the selected agents file
5. Write memory skeletons / managed `.gitignore` / state as before

Managed reference markers (stable):

```markdown
<!-- BLUEPRINT:HARNESS:START -->
## Shared Harness
…
<!-- BLUEPRINT:HARNESS:END -->
```

Only content between the markers is Blueprint-owned. Everything else is preserved byte-for-byte aside from the smallest patch needed to add or replace that block.

### Existing `HARNESS.md`

- If Blueprint-managed (`<!-- managed-by: shared-agent-blueprints -->` present): refresh from template
- If unmanaged: leave unchanged and warn; use `--force` to backup (`HARNESS.md.blueprint-backup.<timestamp>`) then replace

### Malformed markers

If only `START` or only `END` is present (or duplicates), `init` leaves the agents file unchanged and warns. Repair markers manually, then re-run `init`. The service does not guess how to splice a broken region.

## Update (`blueprint update`)

1. **Version check** — compare target `.agent-blueprint.yaml` `version` to package `./VERSION`. On mismatch, show a red notice (TUI prompts to confirm).
2. Refresh managed blueprint context:
   - root `HARNESS.md`
   - managed runtime projections (`.cursor/` / `.claude/` skills, commands, rules, templates) when runtimes are declared
   - managed `.gitignore` section
   - stamp package version into state + targets registry

Does **not** modify:

- `AGENTS.md`
- `agents.md`
- `CLAUDE.md`

even when the managed reference block is missing or outdated. Reconcile the reference block with `blueprint init` (or a future dedicated repair command), not `update`.

`sync` remains available to re-apply the installed blueprint without the version-gated update UX.

## Recovery

| Situation | Action |
|---|---|
| Missing harness reference | `blueprint init --target .` |
| Malformed markers | Fix or remove the partial markers by hand, then `init` |
| Unmanaged `HARNESS.md` | Migrate content, then `init --force` / `update --force` to backup + replace |
| Need runtime projections | `blueprint sync` (still does not rewrite agent instruction files) |

Filesystem remains the source of truth; `.agent-blueprint.yaml` records harness/agents metadata for humans and tooling but is not required for detection.
