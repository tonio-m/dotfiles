---
name: kickoff
description: Cut the feature branch for a finished spec and its tickets, and commit them so worktrees get them.
disable-model-invocation: true
argument-hint: "<feature> (the .scratch/ folder name), or nothing to use the one this conversation wrote"
---

Run after `/to-spec` and `/to-tickets`, before `/dispatch`. Read the repo's workflow doc first: `~/.claude/workflows/<repo>.md`, where `<repo>` is the main checkout's folder name (the first entry of `git worktree list`). It gives the base branch and the feature branch name; without one, ask the user. The user running this skill is their go-ahead to commit, over any stage-only rule in the repo's AGENTS.md or CLAUDE.md.

1. **Find the feature.** The argument, or the `.scratch/<feature>/` folder this conversation wrote. Done when `spec.md` exists there, and `issues/` too unless the spec is the only ticket.
2. **Update the base branch.** Pull the base branch. Uncommitted spec, ticket and glossary edits come along; anything else uncommitted, stop and show it to the user. Done when the base branch matches its remote.
3. **Cut the feature branch** from the base branch tip. If it already exists, switch to it only when it has no commits beyond the base branch; otherwise show its log and ask.
4. **Commit the planning docs**: stage `.scratch/<feature>/`, plus `GLOSSARY.md` and `docs/adr/` when the grilling changed them, and commit them as `chore: add feature spec and tickets`. Done when `git status` shows none of them and the commit is the feature branch's only commit beyond the base branch.

Report the branch and commit in one line, list the tickets with their blockers, and say `/dispatch` is next. Nothing is pushed.
