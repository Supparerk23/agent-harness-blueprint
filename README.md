# Shared Agent Blueprints

Reusable multi-agent harness for **Cursor**, **Claude Code**, and any tool that honors `AGENTS.md`.

This repository is the **blueprint package** (CLI + canonical `harness/` content). Adopting projects run `init` → `install` before product work. Live `.cursor/` / `.claude/` trees and task memory files belong in consumers only.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## Why this project exists

Teams using AI coding agents need a **shared contract**: the same safety rails, planning memory, slash playbooks, and install path across tools—without copying one-off `.cursor/` trees into every repo.

This package keeps harness sources canonical, projects them into tool runtimes on demand, and preserves local consumer overrides and memory state on sync.

## Features

- **Multi-runtime projection** — install into Cursor, Claude Code, or both (`--runtime`)
- **Blueprint profiles** — `default`, `engineering`, `startup` (+ optional GitLab overlay)
- **Managed consumer contract** — `HARNESS.md` + harness reference in `AGENTS.md` / `agents.md`
- **Preserve-local sync** — refreshes managed files without clobbering memory or agent bodies
- **Interactive TTY menu** — guided `init` / `install` / `sync` / `update` / `doctor` / `del`
- **Remote source cache** — git URL sources resolve under `$XDG_CACHE_HOME/blueprint/repos/`
- **Docs + skills** — planning, review, commit, and specialized skill packs under `harness/`

## Architecture

Canonical content lives under `harness/`. Tool runtimes are projections. `AGENTS.md` is the shared contract every agent reads.

```mermaid
flowchart LR
  subgraph package [This package]
    harness[harness/]
    entry[templates/entrypoints/]
    cli[./blueprint]
  end

  subgraph consumer [Your project]
    agents[AGENTS.md]
    cursor[".cursor/"]
    claude[".claude/"]
    memory[Memory files]
  end

  cli -->|init| agents
  cli -->|init| memory
  entry -->|init| agents
  harness -->|install| cursor
  harness -->|install| claude
```

| Concept | Detail |
|---|---|
| Package | `harness/`, `blueprints/`, `templates/`, `./blueprint` |
| Consumer contract | `AGENTS.md` (+ thin `CLAUDE.md`) |
| Runtimes | `.cursor/` and/or `.claude/` from `--runtime` |

Deep dive: [docs/architecture.md](docs/architecture.md) · [docs/compatibility.md](docs/compatibility.md)

## Installation

Requirements: Bash, Git, macOS or Linux.

```bash
git clone https://github.com/Supparerk23/agent-harness-blueprint.git
cd agent-harness-blueprint

# Optional: put the CLI on PATH
ln -sf "$(pwd)/blueprint" /usr/local/bin/blueprint
```

There is no npm/Homebrew package yet — install from a git checkout (or submodule / vendored copy) and symlink the `blueprint` executable.

`scripts/agent` remains a back-compat shim that forwards to `./blueprint`.

## Quick Start

Under 60 seconds from a package checkout:

```bash
./blueprint doctor
./blueprint init --target /path/to/your-repo
./blueprint install default --runtime all --target /path/to/your-repo
./blueprint doctor --target /path/to/your-repo
```

Example output shape:

```text
✓ package OK
✓ wrote HARNESS.md
✓ projected harness → .cursor/ .claude/
✓ target healthy
```

Then open the consumer repo in Cursor or Claude Code and start with `/start`.

Interactive menu (TTY):

```bash
./blueprint
# or
./blueprint menu --target /path/to/your-repo
```

Step-by-step checklist: [docs/setup.md](docs/setup.md)

## Configuration

After `init`, the consumer gets:

| File | Role |
|---|---|
| `.agent-blueprint.yaml` | Installed blueprint, runtime, optional remote `source` |
| `.agent-blueprint.local.yaml` | Local overrides (gitignored stub) |
| `HARNESS.md` | Managed harness entry (refreshed by `update`) |
| `AGENTS.md` / `agents.md` | Agent contract + managed harness reference block |

`--runtime`: `cursor` | `claude` | `all`. Omit for an interactive selector.

Remote `source` git URLs are cached under `$XDG_CACHE_HOME/blueprint/repos/`. Details: [docs/harness-ownership.md](docs/harness-ownership.md)

## CLI usage

```text
Usage: blueprint [<command>] [blueprint] [flags]

Commands:
  (none) / menu        Interactive menu (TTY)
  init                 Write HARNESS.md + agent harness reference, memory, .gitignore
  install <blueprint>  Install blueprint into --target runtimes
  update               Version check, then refresh HARNESS.md + managed runtimes
  sync                 Re-apply installed blueprint with preserve-local
  del                  Remove blueprint from --target
  doctor               Validate package + target install health

Blueprints:  default | engineering | startup

Flags:
  --overlay gitlab     Install GitLab/glab command overlay
  --runtime NAME       cursor | claude | all
  --target PATH        Consumer project root
  --dry-run            Print actions without writing
  --force              Overwrite unmanaged files; required for non-interactive del
```

| Step | Result |
|---|---|
| `init` | `HARNESS.md`, agent harness reference, memory skeletons, managed `.gitignore` — **no** tool runtime yet |
| `install` | Projects commands/rules/skills into `.cursor/` and/or `.claude/` |
| `update` | Version check vs package `VERSION`, refresh `HARNESS.md`, apply skill/rule renames, full-refresh managed skills/rules — never rewrites agent instruction files |
| `sync` | Re-applies the installed blueprint (`preserve-local`); may fetch a remote `source` |
| `del` | Removes managed blueprint + memory files; preserves agent instruction bodies |

History is stored under `$XDG_DATA_HOME/blueprint/history.jsonl` (no secrets).

## Examples

```bash
# Core harness for any repo
./blueprint install default --runtime all --target ~/code/my-app

# Engineering workflows + GitLab MR playbooks
./blueprint install engineering --overlay gitlab --runtime all --target ~/code/my-app

# Startup / PRD-heavy profile
./blueprint install startup --runtime cursor --target ~/code/my-app

# Refresh later
./blueprint sync --target ~/code/my-app
./blueprint update --target ~/code/my-app

# Preview without writing
./blueprint install default --runtime all --target ~/code/my-app --dry-run
```

| Blueprint | Use when |
|---|---|
| `default` | Any repo — start/review, safety, core skills |
| `engineering` | Commit/refactor/ADR workflows |
| `startup` | PRD/ADR-heavy early product work |

Example consumer layout: [examples/consumer/](examples/consumer/)

After install, the delivery loop is: orient → `/start` → plan → execute → update memory → ship → learn. See [docs/harness-workflow.md](docs/harness-workflow.md).

## Upgrade

```bash
cd /path/to/agent-harness-blueprint
git pull

# Refresh managed files in each consumer
./blueprint update --target /path/to/your-repo
# or re-apply projections while preserving local memory
./blueprint sync --target /path/to/your-repo
```

Package semver lives only in [`VERSION`](VERSION). See [CHANGELOG.md](CHANGELOG.md).

## Uninstall

From a consumer project:

```bash
./blueprint del --target /path/to/your-repo          # interactive confirm
./blueprint del --target /path/to/your-repo --force # non-interactive / CI
```

Remove the PATH symlink if you added one:

```bash
rm -f /usr/local/bin/blueprint
```

Optionally delete the package checkout. `del` does not rewrite `AGENTS.md` / `CLAUDE.md` bodies.

## Troubleshooting

| Symptom | What to try |
|---|---|
| `doctor` fails on package | Run from the package root; ensure `VERSION`, `manifest.yaml`, and `harness/` are present |
| `install` asks for runtime in CI | Pass `--runtime cursor\|claude\|all` explicitly |
| Target must not be this package | Point `--target` at a **consumer** repo, not this checkout |
| Conflicts (`*.blueprint-conflict`) | Compare sibling files; merge manually; re-run `sync` |
| Stale remote blueprint | `sync` again, or clear `$XDG_CACHE_HOME/blueprint/repos/` and retry |
| Interrupted install/sync | Re-run the same command; resume state lives under consumer `.agent-blueprint/` |
| Menu has no targets | Add a path when prompted; package-local `targets.json` is gitignored |

More detail: [docs/setup.md](docs/setup.md) · [docs/how-it-works.md](docs/how-it-works.md)

## Development

```bash
git clone https://github.com/Supparerk23/agent-harness-blueprint.git
cd agent-harness-blueprint
./blueprint doctor
```

| Path | Purpose |
|---|---|
| `harness/` | Canonical commands, rules, skills |
| `blueprints/` | Profiles (`default`, `engineering`, `startup`) |
| `templates/` | Entrypoints, memory, PRD/ADR |
| `lib/blueprint/` | CLI terminal UX modules |
| `prompts/` | Prompt library |
| `tests/cli/` | Smoke and harness tests |

See [CONTRIBUTING.md](CONTRIBUTING.md) and [AGENTS.md](AGENTS.md).

## Testing

```bash
./tests/cli/smoke.sh
./tests/cli/harness.sh
./blueprint doctor
```

## Roadmap

- Packaged distribution (Homebrew and/or release binaries)
- Richer `doctor` diagnostics for remote cache and overlay drift
- Additional forge overlays beyond GitLab
- More `good first issue` labeled tasks for community contributors

Ideas welcome via [GitHub Issues](https://github.com/Supparerk23/agent-harness-blueprint/issues).

## Contributing

Contributions are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for setup, branch naming, commits, PRs, and testing. Everyone is expected to follow the [Code of Conduct](CODE_OF_CONDUCT.md).

## Docs index

| Category | Doc |
|---|---|
| Architecture | [architecture.md](docs/architecture.md), [compatibility.md](docs/compatibility.md), [harness-ownership.md](docs/harness-ownership.md) |
| Setup | [setup.md](docs/setup.md), [adoption-and-lineage.md](docs/adoption-and-lineage.md) |
| How it works | [how-it-works.md](docs/how-it-works.md), [skills.md](docs/skills.md), [rules.md](docs/rules.md), [slash-commands.md](docs/slash-commands.md) |
| Workflow | [harness-workflow.md](docs/harness-workflow.md), [quick-start.md](docs/quick-start.md), [memory-and-planning.md](docs/memory-and-planning.md) |
| Community | [CONTRIBUTING.md](CONTRIBUTING.md), [SECURITY.md](SECURITY.md), [CHANGELOG.md](CHANGELOG.md), [github-labels.md](docs/github-labels.md) |
| Index | [docs/README.md](docs/README.md) |

### Package layout

```text
.
├── harness/             # canonical commands, rules, skills
├── blueprints/          # default | engineering | startup
├── templates/           # entrypoints + memory + PRD/ADR
├── lib/blueprint/       # CLI terminal UX modules
├── prompts/             # prompt library
├── docs/                # diagrams + deep docs
├── tests/cli/           # CLI smoke tests
├── blueprint            # CLI: init | install | sync | doctor | menu
└── examples/consumer/   # example consumer install state
```

## License

MIT © [Supparerk Arikarn](https://github.com/Supparerk23) — see [LICENSE](LICENSE).
