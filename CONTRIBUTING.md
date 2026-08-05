# Contributing

Thanks for helping improve **shared-agent-blueprints**. This package is the source for a reusable multi-agent harness (CLI + `harness/` content). Contributions that keep the consumer contract clear and the CLI predictable are especially welcome.

Please read the [Code of Conduct](CODE_OF_CONDUCT.md) before participating.

## Development setup

Requirements: Bash, Git, and a Unix-like shell (macOS / Linux).

```bash
git clone https://github.com/Supparerk23/agent-harness-blueprint.git
cd agent-harness-blueprint

# Optional: put the CLI on PATH
ln -s "$(pwd)/blueprint" /usr/local/bin/blueprint

# Sanity-check the package
./blueprint doctor
```

Package orientation for agents and contributors:

1. [AGENTS.md](AGENTS.md) / [CLAUDE.md](CLAUDE.md)
2. Relevant files under `harness/`, `blueprints/`, `templates/`
3. [docs/](docs/) for adoption and compatibility notes

Bump the package semver only in [`VERSION`](VERSION).

## Branch naming

| Type | Pattern | Example |
|---|---|---|
| Feature | `feature/<short-slug>` | `feature/sync-resume` |
| Bug fix | `fix/<short-slug>` or `hotfix/<short-slug>` | `fix/add-command` |
| Docs | `docs/<short-slug>` | `docs/contributing` |
| Chore | `chore/<short-slug>` | `chore/gitignore` |

Use lowercase kebab-case slugs. Prefer short, descriptive names over ticket-only names when no tracker ID exists.

## Commit convention

Prefer concise, imperative subjects (what / why), for example:

- `fix add command resume path`
- `docs: clarify install --runtime selector`
- `feat: add doctor check for remote cache`

Keep commits focused. Do not commit consumer artifacts (`.cursor/`, `.claude/`, `PLANNING.md`, `targets.json`, etc.).

## Pull request process

1. Fork (or branch from the default branch) and make a focused change.
2. Run the smoke and harness tests (see [Testing](#testing-requirements)).
3. Open a PR using the template. Describe **why** the change exists and how you verified it.
4. Link related issues when applicable.
5. Keep the PR scoped — large mixed refactors are harder to review and more likely to be deferred.
6. Address review feedback with follow-up commits (prefer not to force-push unless asked).

Maintainers may ask for docs updates when CLI or projection behavior changes.

## Coding style

- **CLI / Bash:** Match existing patterns in `blueprint` and `lib/blueprint/`. Prefer small, composable helpers over large one-off scripts.
- **Harness content:** Prefer composition and blueprint overlays over forking entire profiles.
- **Docs:** Keep root docs concise; put deep detail under `docs/`. Update docs when user-facing CLI behavior changes.
- **Consumer contract:** Entrypoints live in `templates/entrypoints/`. Do not treat package-root `AGENTS.md` as a product-app contract.
- **Do not** commit live `.cursor/` / `.claude/` trees or task-memory files into this package.

## Testing requirements

Before requesting review:

```bash
./tests/cli/smoke.sh
./tests/cli/harness.sh
./blueprint doctor
```

If you change install/sync/init/del behavior, exercise a temporary consumer target with `--dry-run` first, then a real throwaway directory.

## Review expectations

- Clarity and safety over cleverness
- No silent overwrites of consumer memory or agent instruction files
- Backward-compatible defaults unless the PR explicitly documents a breaking change
- Tests and docs updated when behavior changes
- Kind, specific feedback — suggest alternatives when requesting changes

Questions are welcome via GitHub Issues (label `question`).

## Security

Do not open public issues for vulnerabilities. See [SECURITY.md](SECURITY.md).
