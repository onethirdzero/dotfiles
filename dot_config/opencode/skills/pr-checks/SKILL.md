---
name: pr-checks
description: Run the pre-merge or post-merge checks for a GitHub PR, given its link. Reads the checks from the PR description and, when it exists, a local plan file in the PR branch's worktree. Picks pre-merge or post-merge from the PR's merge state. Use when the user pastes a PR URL and says "check this PR", "is this ready to merge", "verify after merge", "run the pre-merge checks", "did the rollout work", or asks what to verify before or after merging, even if they do not say "pre-merge" or "post-merge".
---

# PR checks

Goal: given a PR link, find the checks the author listed, run the safe ones, and report what passed, failed, or could not be verified.

The PR description is the source of truth. The local plan only adds context. Authors write checks in different places and styles, so read the whole description instead of looking for one heading.

Some environments add extra rules in a companion skill, such as one for a specific company or project. If one was loaded with this skill, follow its rules too.

## 1. Read the PR

Use `gh` (outside the sandbox). Run:

```sh
gh pr view <url> --json number,title,url,state,isDraft,mergedAt,mergeCommit,headRefName,baseRefName,body,reviewDecision,mergeable,statusCheckRollup,comments
```

Decide the mode from `state`:

- `OPEN`: pre-merge mode.
- `MERGED`: post-merge mode.
- `CLOSED` (not merged): tell the user and stop.

## 2. Find the local plan

The plan is optional. Look for it, and do not fail if it is missing.

1. Find the local checkout that matches the PR's repo. Check the current directory first. If it is a different repo, ask the user where the checkout is, unless a companion skill names the location. Run `git worktree list --porcelain` there.
2. Pick the worktree whose branch equals `headRefName`.
3. Read `PLAN-*.md` at the worktree root if it exists.

Use the plan for context only. Good things to pull from it are observability notes, steps that verify or operate a live system, risks, and the order of related PRs. If a plan claim conflicts with the PR description, trust the description and mention the conflict.

After a merge, the worktree may already be removed. Say "no local plan found" and continue.

## 3. Build the checklist

Read the whole description and the author's own comments. Extract every item that is a check, a verification step, a rollback condition, or an operational follow-up. Common places are:

- Testing (commands and manual validation)
- Sections on breaking or operational changes (migrations, config, env vars, deploys, rollback)
- Implementation notes and stack
- Unchecked `- [ ]` boxes

Sort each item into one of these:

- **Pre-merge**: must be true before merging. Examples are CI green, review approved, a command passing locally, or a parent PR being merged.
- **Post-merge**: can only be true after merging. Examples are a deploy finishing, a metric appearing, a migration applied, or a log line showing up.
- **Unclear**: the text does not say. Treat it by the current mode and tell the user you guessed.

Also add the standard checks for the mode. Mark them as "standard" so the user can tell them from the author's items.

Pre-merge standard checks:
- Required CI checks pass. Name any that fail or are pending.
- The PR is not a draft, and review is approved or not blocked.
- `mergeable` is not conflicting.
- If the Stack section lists a parent PR, the parent is merged or this PR targets it on purpose. Follow the **Merge order** list if there is one.

Post-merge standard checks:
- The merge commit exists on the base branch.
- Any CI run on the base branch for that commit has passed.

Only keep checks for the current mode in the run list. List the items that belong to the other mode at the end as "not-yet or already-done items". This shows the user which checks are still ahead (pre-merge mode) or already behind them (post-merge mode).

## 4. Wait for the rollout (post-merge mode only)

`MERGED` only means the code is on the base branch. The change may not be live yet. Checking too early gives false failures, so wait for the rollout first.

1. Find a signal that the rollout is done. Use the first one that applies:
   - One the PR description or plan names, such as an image tag, a version, or a release.
   - One a companion skill names for the deploy platform.
   - The CI or release run on the merge commit. Use `gh run list --commit <sha>` and `gh run watch <id>`.
2. If no signal can be found, ask the user how to tell that the rollout is done. Do not guess.
3. Wait with read-only commands only. Use the command's own timeout, or a sleep loop that uses 1 min intervals. Stop after 20 minutes unless the user gives a different limit.
4. Tell the user what you are waiting for before you start.
5. If the wait ends without a done signal, do not run the post-merge checks as if they were final. Mark them "Unverified: rollout not finished" and suggest running the skill again later.
6. If the rollout itself fails, report that as a Fail and stop. Later checks would not mean anything.

If the PR has no rollout, such as docs only or a library change, say so and skip the wait.

## 5. Run the checks

Sort each check by whether it changes anything.

**Read-only, run it now.** Examples: `gh` reads, `git log` and `git diff`, `kubectl get/describe/logs`, `SELECT` queries, `GET` requests, and test or lint commands that only touch the local worktree.

**Changes something, ask first.** Examples: `kubectl apply/delete/rollout restart`, `helm upgrade`, `terraform apply`, inserts or updates, `POST/PUT/DELETE` requests, and `make` targets that deploy or create cloud resources. Show the exact command and what it changes. Do not run it until the user agrees. If you cannot tell whether a command is safe, treat it as one that changes something.

**Manual or judgment items.** Examples: "confirm the dashboard looks right". Say that you cannot verify these. Give the user the link or command that lets them check.

Environment rules:
- Follow any environment rules from a companion skill, such as which cluster configs to use.
- Run local checks from the PR branch's worktree. If there is none, say so before running local tests, because the main checkout may be on a different branch.
- If a check fails because of an expired login or missing access, stop and ask the user to log in. Do not work around it. Mark the check as unverified with the reason.

## 6. Report

Keep it short. Use simple words. Use this layout:

```markdown
**<PR title>** (<url>) — <pre-merge | post-merge> checks

| # | Check | Source | Result | Evidence |
|---|-------|--------|--------|----------|
| 1 | ...   | PR body / plan / standard | Pass / Fail / Unverified / Needs approval | command output or reason |

**Verdict:** <Ready to merge | Not ready | Healthy after merge | Problem after merge | Incomplete>
**Needs you:** <approvals requested, manual items, or login needed>
**Not-yet or already-done items:** <checks that belong to the other mode: still ahead if pre-merge, already past if post-merge>
**Plan:** <path used, or "no local plan found">
```

Result meanings:
- **Pass**: you ran it and it met the expected result.
- **Fail**: you ran it and it did not. Quote the key output.
- **Unverified**: you could not run it. Give the reason.
- **Needs approval**: it changes something and is waiting for the user.

The verdict is "Ready to merge" or "Healthy after merge" only when every check passed. Any Unverified or Needs approval item makes it "Incomplete", and any Fail makes it "Not ready" or "Problem after merge".

Do not post to the PR, change tickets, or edit the plan unless the user asks.

Never merge, close, or approve the PR, and never enable auto-merge. Merging is the user's decision. If the PR description lists a merge step, report it as a manual item.
