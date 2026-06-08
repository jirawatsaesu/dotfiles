---
name: create-pr
description: Create a Bitbucket pull request by reading context from git — branch, commits, and diff — then calling the REST API.
---

Create a Bitbucket pull request by deriving all needed information from git context.

## Check env var

Check that `BITBUCKET_TOKEN` is set. If missing, stop and tell the user:

```
Missing required environment variable:

  BITBUCKET_TOKEN  — Generate one at: Bitbucket → Personal Settings → API tokens
                     Required permissions: Repositories (Read), Pull requests (Read, Write)

Add it to your shell profile (~/.zshrc) or to ~/.claude/settings.json under the "env" key.
```

## Derive workspace and repo slug from git remote

```bash
git remote get-url origin
```

Parse workspace and repo slug:
- HTTPS: `https://bitbucket.org/<workspace>/<repo>.git`
- SSH: `git@bitbucket.org:<workspace>/<repo>.git`

Strip the `.git` suffix if present.

## Derive PR fields from git

```bash
# Source branch
git branch --show-current

# Detect destination — find which remote branch this was most likely forked from
git for-each-ref --format='%(refname:short)' refs/remotes/origin/ \
  | grep -v HEAD \
  | while read b; do
      echo "$(git rev-list --count HEAD ^$b 2>/dev/null) $b"
    done \
  | sort -n \
  | head -5

# Commits in this branch vs the detected destination
git log origin/<DESTINATION>..HEAD --oneline

# Files changed
git diff origin/<DESTINATION>...HEAD --stat

# Recent commit history on the repo to detect title convention
git log --oneline -20
```

Use the output to determine:
- **Source branch**: current branch name
- **Destination branch**: remote branch with fewest commits ahead (closest ancestor). Strip `origin/` prefix.
- **Title**: look at the recent commit history to detect the convention used in this repo (e.g. `feat:`, `fix:`, `[JIRA-123]`, `(scope)`, etc.), then apply the same prefix pattern to a concise summary of the branch's changes.
- **Description**: write a rich description based on the commit messages and changed files. Use bullet points for multiple changes, or a paragraph if the change is focused. Be descriptive enough that a reviewer understands the intent and scope without reading the diff.

## Create the PR

Escape the description for JSON (replace newlines with `\n`, quotes with `\"`).

```bash
curl -s -X POST \
  "https://api.bitbucket.org/2.0/repositories/<WORKSPACE>/<REPO_SLUG>/pullrequests" \
  -H "Authorization: Bearer ${BITBUCKET_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{
    \"title\": \"<TITLE>\",
    \"description\": \"<DESCRIPTION>\",
    \"source\": { \"branch\": { \"name\": \"<SOURCE_BRANCH>\" } },
    \"destination\": { \"branch\": { \"name\": \"<DESTINATION_BRANCH>\" } },
    \"close_source_branch\": true
  }"
```

## Report result

- On success: print the PR URL — `https://bitbucket.org/<WORKSPACE>/<REPO_SLUG>/pull-requests/<id>`
- On error: print the `message` from the response and stop.
