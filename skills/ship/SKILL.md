---
name: ship
description: Land a reviewed ticket from its worktree onto the feature branch, marked done, as one commit.
disable-model-invocation: true
argument-hint: "[\"<commit message>\"]"
---

Run in a ticket's worktree session once the user has reviewed the staged work. The argument is the commit message, used exactly as given. Without one, use the commit message this session suggested in its last report, and say which one you used; if it suggested none, ask the user. Read the repo's workflow doc first: `~/.claude/workflows/<repo>.md`, where `<repo>` is the main checkout's folder name (the first entry of `git worktree list`). Without one, ask the user for the base branch and the test command. The user running this skill is their go-ahead to commit, over any stage-only rule in the repo's AGENTS.md or CLAUDE.md.

From the session's brief, take the **ticket** path, the **feature branch**, the **main checkout** path and the **parent session**. When the brief lacks one, find it (`git worktree list`, the ticket the session implemented) and say what you found.

1. **Mark the ticket done.** Tick every acceptance box the work meets and set its `Status:` to `done`. If a box isn't met, stop: name it and wait for the user. Stage the ticket. Done when every box is ticked and the ticket is staged.
2. **Bring down the local app** if this worktree has one running (the workflow doc says how).
3. **Commit** the staged changes with the message, on one line. Done when `git status` shows nothing staged.
4. **Catch up with the feature branch.** If it moved since this worktree was cut, rebase onto its tip, then rerun the tests from the workflow doc; they must pass as before. A rebase conflict means two tickets touched the same file: abort the rebase and stop, telling the user which files.
5. **Fast-forward the feature branch** to this commit:
   - If the main checkout has the feature branch checked out, check it has no uncommitted changes to tracked files, then `git -C <main checkout> merge --ff-only <commit>`. Untracked files are fine. Other changes, stop and show them.
   - Otherwise `git fetch . HEAD:refs/heads/<feature branch>` from the worktree.
   Done when `git log -1 <feature branch>` is this commit.
6. **Sync the main checkout's env files.** For each env file in the workflow doc, compare its keys with its example file on the feature branch. Add derived keys as the doc says; list the others for the user to fill in. Done when every key in every example file is present or listed.

7. **Tell the parent session.** Send it a message with `SendMessage` (`to`: its session id): the ticket that shipped, the commit, and that the feature branch was fast-forwarded to it. Ask it to run `/dispatch`'s **After each ship** step now. The app won't let it start sessions from your message, only from the user's own words, so it puts the next tickets up as cards. Without a parent session in the brief, skip this and tell the user to run `/dispatch` in the parent session.

Report in three lines: the commit and the feature branch it's on now, any env keys left for the user, and that the next tickets wait as cards in the parent session (one click each, or all at once with `/dispatch` there). Nothing is pushed.
