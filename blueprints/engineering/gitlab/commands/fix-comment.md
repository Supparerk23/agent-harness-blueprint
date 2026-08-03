Fix a specific MR review comment. Usage: `/fix-comment [discussion_id, note_id, or description]`

This repo uses **GitLab** — do not use `gh`.

**Prerequisite:** Read and apply [prerequisite.md](prerequisite.md) — run `ensure_glab` before any `glab` command.

```bash
# After ensure_glab:
MR_IID="$(glab mr view "$BRANCH" --output json | jq -r '.iid')"
MR_WEB_URL="$(glab mr view "$BRANCH" --output json | jq -r '.web_url')"
```

---

0. Run `ensure_glab` (see [prerequisite.md](prerequisite.md)).

1. Resolve the current MR:
   ```bash
   glab mr view "$BRANCH" --output json | jq '{iid, web_url, title}'
   ```
   Save `MR_IID`.

2. Find the comment (repo-aware API — `projects/:id` = current repo from git):
   ```bash
   glab api "projects/:id/merge_requests/${MR_IID}/discussions"
   ```
   Or: `glab mr view "$BRANCH" --comments`

   Match the thread by [discussion_id, note_id, or description].

3. Read the comment and the referenced file/line.

4. Implement a minimal fix; run relevant tests (e.g. `pytest path/to/test.py -q`).

5. Commit and push:
   ```bash
   git add [changed-files]
   git commit -m "JIRA | 🤖 fix: address review comment - [summary]"
   git push origin HEAD
   ```

6. Reply on the thread:
   ```bash
   # Thread reply (preferred when discussion_id is known)
   glab api --method POST \
     "projects/:id/merge_requests/${MR_IID}/discussions/${DISCUSSION_ID}/notes" \
     -f body="✅ Fixed in $(git rev-parse --short HEAD): [explanation]"

   # Or a general MR note
   glab mr note "$MR_IID" -m "✅ Fixed in $(git rev-parse --short HEAD): [explanation]"
   ```

   **curl fallback** (only if `glab api` fails and token is set):
   ```bash
   ensure_glab
   curl --silent --show-error --request POST \
     --header "PRIVATE-TOKEN: ${GITLAB_TOKEN:-$GLAB_TOKEN}" \
     --header "Content-Type: application/json" \
     --data "$(jq -n --arg body "✅ Fixed in $(git rev-parse --short HEAD): [explanation]" '{body:$body}')" \
     "${GITLAB_API_BASE}/projects/${GITLAB_PROJECT_PATH_ENC}/merge_requests/${MR_IID}/discussions/${DISCUSSION_ID}/notes"
   ```

7. Report what changed and link: `$MR_WEB_URL` or `glab mr view "$BRANCH" --web`.
