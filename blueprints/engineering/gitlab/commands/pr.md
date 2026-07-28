Create a merge request (MR) for the current branch. This repo uses **GitLab** — do not use `gh`.

**Prerequisite:** Read and apply [prerequisite.md](prerequisite.md) — run `ensure_glab` before any `glab` command.

---

1. Write a clear title message:
   - Read `PLANNING.md` if present
   - Format: `type(scope): description`
   - Types: feat|fix|refactor|test|docs|chore
   - Keep under 72 chars

2. Generated description:
   - Context from `PLANNING.md` and `DECISIONS.md` when present

3. Run `ensure_glab` (see [prerequisite.md](prerequisite.md)).

4. Push branch if needed:
   ```bash
   git push -u origin HEAD
   ```

5. Check for an existing open MR on this branch:
   ```bash
   ensure_glab
   glab mr list --source-branch "$BRANCH" --state opened
   ```
   If one exists, return its `web_url` and stop.

6. Create MR — try in order; stop when one succeeds:

   **A. `glab` (preferred — repo-aware)**
   ```bash
   ensure_glab
   glab mr create \
     --title "JIRA | 🤖 type(scope): description" \
     --description "$(cat <<'EOF'
   [Generated description]
   EOF
   )" \
     --target-branch "$TARGET_BRANCH" \
     --draft \
     --label "ai-generated"
   ```

   **B. GitLab REST API (`curl`) — when `GITLAB_TOKEN` or `GLAB_TOKEN` is set**
   ```bash
   ensure_glab
   curl --silent --show-error --request POST \
     --header "PRIVATE-TOKEN: ${GITLAB_TOKEN:-$GLAB_TOKEN}" \
     --header "Content-Type: application/json" \
     --data "$(jq -n \
       --arg title "JIRA | 🤖 type(scope): description" \
       --arg description "..." \
       --arg source "$BRANCH" \
       --arg target "$TARGET_BRANCH" \
       '{source_branch:$source,target_branch:$target,title:$title,description:$description,draft:true,labels:"ai-generated"}')" \
     "${GITLAB_API_BASE}/projects/${GITLAB_PROJECT_PATH_ENC}/merge_requests"
   ```
   Parse `web_url` from JSON.

   **C. Web UI — last resort**
   ```bash
   ensure_glab
   echo "${GITLAB_WEB_BASE}/-/merge_requests/new?merge_request%5Bsource_branch%5D=${BRANCH}&merge_request%5Btarget_branch%5D=${TARGET_BRANCH}"
   ```
   Ask the user to paste title/description, enable **Draft**, add label `ai-generated`.

7. Return the MR URL (`glab` stdout or API `web_url`).

## Rules

- **JIRA** from branch `feature/[KEY]` or `hotfix/[KEY]` → use `[KEY]` in title
- Never target `main` or `master` directly
- On `feature/*` / `hotfix/*`, default target is `develop` (override with `GITLAB_TARGET_BRANCH`)
- MR title: `JIRA | 🤖 type(scope): description`
- Label `ai-generated` on AI-created MRs
- Do not create a duplicate if an open MR already exists for the branch
