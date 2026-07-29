# AGENTS.md

Package-source instructions for **shared-agent-blueprints**.

This repository is the **blueprint package**, not a product app. Edit shared sources under `harness/`, `prompts/`, `templates/`, and `blueprints/`. Do not keep consumer task-memory files or live `.cursor/` / `.claude/` trees here.

## For adopting projects

Consumers use the CLI (never copy package-root docs as the product contract):

```bash
scripts/agent init --target /path/to/repo
scripts/agent install default --runtime all --target /path/to/repo
scripts/agent install engineering --overlay gitlab --runtime all --target /path/to/repo
scripts/agent sync --target /path/to/repo
scripts/agent doctor --target /path/to/repo
```

`init` writes the consumer `AGENTS.md` / `CLAUDE.md` from `templates/entrypoints/` plus memory skeletons. `install` projects `harness/` into `.cursor/` and/or `.claude/` per `--runtime`.

See [README.md](README.md) and [docs/](docs/).

## Package edit order

1. This file / [CLAUDE.md](CLAUDE.md) for package orientation
2. `harness/` skills, rules, commands relevant to the change
3. `templates/entrypoints/` when changing the consumer contract
4. `docs/` for adoption and compatibility notes

## Don't

- Commit consumer artifacts (`.cursor/`, `.claude/`, `PLANNING.md`, etc.) into this package
- Point product repos at this package-root `AGENTS.md` as their runtime contract
- Treat optional overlays (e.g. GitLab) as universal defaults
