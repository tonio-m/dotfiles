---
name: dispatch
description: Start a worktree session per ready ticket that is safe to run in parallel, and keep starting the next batch as tickets ship.
disable-model-invocation: true
argument-hint: "<feature>, or nothing for the feature branch you're on"
---

Run in the parent session, on the feature branch, after `/kickoff`. Read the repo's workflow doc first: `~/.claude/workflows/<repo>.md`, where `<repo>` is the main checkout's folder name (the first entry of `git worktree list`). Without one, ask the user for the base branch and the test command. Then read the spec and every ticket in `.scratch/<feature>/`.

## The rules

- A ticket is **done** when its `Status:` on the feature branch says `done` (read it with `git show <feature branch>:<ticket path>`, since worktrees don't touch this checkout's files).
- The **frontier** is every ticket whose `Status:` is `ready-for-agent` or `ready-for-human`, whose blockers are all done, and that has no session yet.
- A ticket's **footprint** is every file it will change: code, tests, prompts, docs, `GLOSSARY.md`, the example env files. Predict it from the ticket, the spec and the code it names, grepping until each named behaviour maps to a file.
- Two tickets are **safe** together only when their footprints share no file. Start a ticket only when it is safe with every ticket already running and every one starting in the same batch. A ticket that isn't safe waits for the next ship.
- A `ready-for-human` ticket is proposed to the user, never started by itself.

## First run

1. Check the feature branch has the spec and tickets committed (`git log <base branch>..HEAD -- .scratch/<feature>/`). If not, stop and say `/kickoff` comes first.
2. Work out the frontier and each footprint, then pick the batch: go through the frontier in ticket order and add each ticket that is safe with those already picked.
3. Show the plan in one message: each ticket in the batch with its footprint, and each frontier ticket left out with the file it clashes on. Wait for the user's go.
4. Start the batch (see **Starting a ticket**).

## After each ship

From then on, the user doesn't need to ask: each time a ticket session's note says it committed and fast-forwarded the feature branch, check the ticket is done on the feature branch, then recompute the frontier and start the next safe batch right away. Tell the user in one line what landed and what started. When the frontier is empty and nothing is running, say every ticket is done and stop.

If the app refuses a start (it allows them only shortly after the user's own turn), propose each ticket as a session card instead, with the same brief, and say so.

## Starting a ticket

Start a session with `use_worktree: true`, `source_branch` set to the feature branch, `context: "fresh"`, title `Implement <NN>: <ticket title>`, and this brief, filled in:

```
/mattpocock-skills:implement <ticket path>

Feature branch: <feature branch> at <sha>. Main checkout: <path>. Parent session: <this session's id>.
Spec: .scratch/<feature>/spec.md. Repo workflow: ~/.claude/workflows/<repo>.md.

Footprint: <the predicted files>.
Owned by sibling sessions, leave alone: <file → ticket, for every running or starting ticket>. If the ticket turns out to need one, stop and message the parent session.

Done means: every acceptance box in the ticket is met, the tests in the workflow doc pass, any new env variable is also in its example file, and the changes are staged with git add. The ticket's boxes and Status are left for /ship. Run the local app only when the user asks.

When done, report in this shape and stop:
- Staged: the files.
- Tests: what ran and the result.
- Beyond the ticket: anything changed that the ticket didn't ask for, or "nothing".
- Env and config: new or changed variables, and anything a deploy needs, or "none".
- Not verified: what wasn't checked (for example, the running app).
- Commit message: a suggestion.
The user reviews, then runs /ship "<message>".
```
