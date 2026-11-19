---
name: xv-anna-code-health
description: Weekly code-health sweep of the whole xv-anna repo, written to a dated report in .scratch/code-health/. Use when asked to run code health, a code-wide sweep, or the weekly checks.
---

# Code health

Run at the root of the xv-anna checkout. A read-only sweep. The only file you write is the report. Code stays untouched, nothing is staged or committed, and credential findings are reported as they are, with no rotation advice.

Scope: tracked source under `packages/`, `test/`, `scripts/`, `docker/`, `compose/`. Leave out `.scratch/` and `packages/spec_bot/knowledge_base/`.

## Steps

1. **Previous report.** Read the newest file in `.scratch/code-health/` if one exists, including the `Commit:` line at its top. Each finding in this run gets a mark against it: **new**, **still open**, or (listed at the end) **gone**.

2. **Files doing too many jobs.** Rule: 500+ lines, 5+ jobs, and at least one job of 100+ lines. List files with `git ls-files | xargs wc -l` over the scope. For each file at 500+, outline it (classes, functions, constants), group them into jobs, and count each job's lines. Also count commits touching the file (`git log --oneline -- <file> | wc -l`). For every file that meets the rule, say which job to move out first (the one that changes most often) and where it would go. Say "leave it" when all its jobs go through one class or one piece of plumbing. Done when every 500+ line file has a verdict.

3. **Comment and docstring bloat.** Run `python -I ~/.claude/skills/xv-anna-code-health/density.py` from the repo root. Read the top hits and judge each one: a docstring that records a non-obvious *why* is fine, and pydantic-ai tool docstrings are prompts the model reads, so length there is fine. Flag commented-out code and comments that restate the code.

4. **Docstrings drifting from the code.** For the longest docstrings and every docstring that states specifics (status codes, limits, timeouts, file names, behaviours), check each claim against the code. Also grep for names of things that no longer exist. Done when each such claim is marked as holding or as drifted.

5. **Bottlenecks for parallel sessions.** Features are built by agent sessions running side by side, and two can only run together when they change different files. A file that almost any new feature has to edit becomes a queue. Look for files where adding something new means editing the file, instead of adding a new file beside it:
   - a central handler that every new behaviour goes into (one `on_message`, one dispatcher, one big `if`/`match` on agent, tool or action names);
   - every callback, route, tool or setting registered in one place, when the code it calls could register itself in its own module;
   - one module that several unrelated features read and write (shared state, a catch-all helpers file, a config object every feature adds fields to);
   - a prompt or doc that every feature appends to, when the addition could be its own file (a skill folder, a doc page).

   Use history as evidence, not as the test: `git log --since=<previous report's date, or 60 days> --name-only --format=%s` over the scope, counting for each file the commits and the distinct features (by commit subject) that touched it. A file many features touched is a lead. Read it and decide whether the *next* unrelated feature would have to touch it too.

   For each bottleneck, say what draws every feature into it and give one verdict: **split** (name the job to move out and where, matching step 2 when the file is there too), **make it an extension point** (how a new feature would add a file instead of editing this one, for example callbacks registered in each pane's module, or one folder per agent), or **leave it** (each feature adds one line, such as an import, and the clash is a trivial rebase). Done when every lead has a verdict.

6. **Review of what changed.** Review only source files changed since the previous report's commit: `git diff --name-only <commit>..HEAD` over the scope. With no previous report, or on the first Friday of the month, review the whole scope instead. No changed files means no review this week: carry the previous report's open findings over as **still open** after checking that each one's code is unchanged.

   Dispatch one subagent with `model: "sonnet"` for the changed files, or one per area on a full sweep (`packages/spec_bot` top-level modules; `packages/spec_bot/agents/` + `tools/` + `tooling.py` + `registry.py` + `models.py`; `packages/sandbox_runner` with its Dockerfiles, compose and egress config). Each reviewer reads `~/.claude/skills/thermo-nuclear-code-quality-review/SKILL.md` and applies it as its review standard: to `git diff <commit>..HEAD` on a weekly run, to the area's files as they stand on a full sweep. Add `docs/adr/*.md` and `GLOSSARY.md` as the repo's own boundaries. Brief: report only URGENT and worth-fixing findings, each with file:line, what's wrong and the concrete restructuring that fixes it; under 300 words. Read the code yourself for every URGENT finding and drop or downgrade any that doesn't hold.

## Report

Write `.scratch/code-health/<YYYY-MM-DD>.md`:

- Top line: `Commit: <git rev-parse HEAD>`, and whether step 6 reviewed the changes or the whole scope.
- **Urgent** first. Each one: a bold title, then two short lines (the problem, then the fix) with its file:line and its new / still-open mark.
- Then **Worth fixing**, one line each.
- Then the step 2–5 results: a table of jobs per flagged file, the bloat hits, the drifted claims, and a **Bottlenecks** table (file, what draws features into it, commits and features in the window, verdict). A bottleneck that most new features would hit goes under **Urgent**.
- Close with **Gone since last report**.

Once written, rewrite the report's prose with the `anthropic-skills:bro` skill (plain, short, no jargon), then the `anthropic-skills:unslop` skill, and save the result over it. Keep file:line references, counts and code names exactly as they are.

End the run with a three-line summary in chat: the number of urgent findings, the number of new findings, and the report's path.

## Notify

As the very last action, once the report is written, send one phone notification through Bark (URL-encode the body, spaces as `%20`). The device key is in `~/.claude/bark-key`, which is kept out of the dotfiles repo; never write it into a file or a message:

```bash
curl -s "https://api.day.app/$(cat ~/.claude/bark-key)/Code%20health/<N>%20urgent%2C%20<M>%20new?group=code-health"
```

The message goes through a third-party server, so it carries the two counts only: no finding text, file names or paths. If the run fails before the report is written, send `Run%20failed` as the body instead.
