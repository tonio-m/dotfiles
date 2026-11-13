---
name: xv-anna-try-it
description: Bring up ANNA's local stack from an xv-anna worktree to try a change in the app, or tear it down with "down".
disable-model-invocation: true
argument-hint: "[down]"
---

Run in an xv-anna worktree session, only when the user wants to try the running app. One app stack runs at a time, on port 8000.

Paths: **worktree** is this session's working directory. **Main checkout** is the first entry of `git worktree list`. **Project** is the worktree folder's name, lowercased, and every compose command here runs with `COMPOSE_PROJECT_NAME=<project>`. **State file** is `$(git rev-parse --git-dir)/try-it.json`: it records what this skill started so `down` removes exactly that.

## Up

1. **Free port 8000.** List running compose projects (`docker compose ls --format json`).
   - If the main checkout's stack (project `xv-anna`) is up, stop it with `docker compose -p xv-anna stop` and record `restore: xv-anna`.
   - If another worktree's stack is up, stop and ask the user which one to keep.
2. **Wait for sibling runner tests.** A container from `anna-sandbox-runner:latest` that has no `com.docker.compose.project` label is a sibling running the runner tests. `up-local.ps1` rebuilds the shared sandbox image and removes sandboxes on the old one, which would break that run. If one is running, tell the user and wait for it to exit.
3. **Record sandboxes** that exist now: `docker ps -a --filter label=anna.sandbox=true --format '{{.Names}}'`, saved in the state file as `sandboxes_before`.
4. **Copy the env files and logins** from the main checkout: `.env`, `.env.runner`, and `data/users.htpasswd` into the worktree's `data/`. Set `ANNA_KB_DIR` to this worktree's knowledge base path. Compare each env file's keys with its example file in the worktree, and ask the user for any missing secret. Done when every example key is present.
5. **Start it**: from the worktree root, with `COMPOSE_PROJECT_NAME` set, run `powershell -File scripts/up-local.ps1` in the background. Done when `docker compose logs spec-bot` shows "Your app is available".
6. **Open it** in the built-in browser at `http://localhost:8000/spec_bot`. The user signs in with their usual login, from the copied `users.htpasswd`; conversations start empty.

Report the URL in one line and what was stopped to make room.

## Down

Remove only what Up started, using the state file:

1. `docker compose down --rmi local` with `COMPOSE_PROJECT_NAME` set, from the worktree root. Then remove this project's own volumes (`docker volume ls --filter label=com.docker.compose.project=<project>`), keeping `anna-repo-mirror`.
2. Remove sandbox containers and volumes labelled `anna.sandbox=true` that aren't in `sandboxes_before`.
3. Delete the copied `.env`, `.env.runner` and `data/` from the worktree.
4. If the state file says `restore: xv-anna`, start it again: `docker compose -p xv-anna start`.
5. Delete the state file.

Done when `docker ps -a` shows no container from this project and no new sandbox. Report in one line what was removed and what was restarted.
