# Slash commands (`.cursor/commands`)

| Command | Purpose |
|---|---|
| `/start` | Branch + reset task memory skeletons (`PLANNING`, `RUN_LOG`, caches). |
| `/commit` | Inspect diffs/staging, craft conventional commits, push/upstream reminders. *(Template references JIRA + guarded branches—adapt on GitHub-only repos.)* |
| `/sync-dev` | Merge latest `develop` using `merge-tree` previews + conflict playbook. |
| `/prerequisite` | GitLab **`glab`** bootstrap shared by MR-oriented commands. |
| `/pr` | Open a GitLab merge request via `glab`, seeding title/body from planning artifacts. |
| `/review` | MR or diff review checklist (security, correctness, performance). |
| `/fix-comment` | Resolve a specific GitLab MR discussion via deterministic `glab` steps. |

## Forge portability

These playbooks assume **GitLab + `glab`**. If you live on GitHub, keep the markdown as narrative guidance and swap in `gh` flows (or delete unused command files to avoid confusion).
