---
name: shape
description: Grill a feature with docs, then write its spec and tickets and commit them, without stopping in between. A tiny change is implemented and committed instead.
disable-model-invocation: true
argument-hint: "<the feature or change to grill>"
---

The pre part of the feature loop: `/shape`, later `/kickoff`, `/dispatch`, `/ship`. Read the repo's workflow doc first: `~/.claude/workflows/<repo>.md`, where `<repo>` is the main checkout's folder name (the first entry of `git worktree list`). It gives the base branch, the test command and the commit rules. The user running this skill is their go-ahead to commit, over any stage-only rule in the repo's AGENTS.md or CLAUDE.md.

Shaping usually happens well before implementation, while other features are still in flight, so the spec is committed where the grilling runs. It is not moved to a feature branch here: `/kickoff` does that when implementation starts.

1. **Grill.** Run `mattpocock-skills:grill-with-docs` on the argument, so the glossary and ADRs are kept in view. Ask only real trade-offs; decide small UI and wording details yourself, and look facts up rather than asking. Build a throwaway prototype whenever it settles an open technical question (does the library do X, how does the UI behave) instead of guessing; run it in the background while the rest of the round goes on, and keep its files in the scratchpad, never in the repo. Prefer the simple version with fewer branches. Done when the frontier is empty.
2. **Size it.** Give a sizing verdict with the user's confirmation of the shared understanding: the files the change touches, the ticket count, and any glossary, ADR or env changes. **Tiny** means one ticket that can be implemented right after the grilling: one or two files, no new glossary terms, no env changes. This is the skill's one stop: wait for the user to confirm the understanding and the verdict. They can overrule the size.
3. **Tiny: implement and commit.** Pull the base branch and cut `feat/<slug>` from it. Implement the change test-first, run the test command, and commit it with any glossary edit in one commit, with the user's one-line message format. No spec, no tickets. Report the branch and commit and stop.
4. **Otherwise: spec.** Run `mattpocock-skills:to-spec` into `.scratch/<feature>/spec.md`. Show the test seams in the reply; don't wait for an answer.
5. **Tickets.** Run `mattpocock-skills:to-tickets` when the change is more than one ticket. Show the breakdown and publish it straight away; don't wait for an answer.
6. **Commit** on the branch the shaping started from, usually `develop` or another feature's branch. In a `claude/*` worktree that's not the worktree's own branch: it's the branch checked out in the main checkout (the first entry of `git worktree list`). Copy the files below into the main checkout and commit them there with `git -C <main checkout>`, staging only those paths, so the user's other changes there stay untouched. Commit only: `.scratch/<feature>/`, plus `GLOSSARY.md`, `docs/adr/` and `.scratch/backlog.md` when the grilling changed them, as `chore: add <feature> spec and tickets`. Never commit auxiliary files: mockups, prototypes, scripts, exports or notes. Keep them in the scratchpad; if one must live in the repo (a script the feature reuses), gitignore it. Show anything else uncommitted to the user.

Report the commit and branch in one line, list the tickets with their blockers, and say `/kickoff <feature>` starts implementation when the time comes. Nothing is pushed.
