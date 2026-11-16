# xv-anna feature workflow

The repo facts that `/kickoff`, `/dispatch` and `/ship` read. The loop: grill, `/to-spec`, `/to-tickets`, `/kickoff`, `/dispatch`, then per ticket review and `/ship`.

## Branches

- Base branch: `develop`. Pull it before cutting a feature branch.
- Feature branch: `feat/<feature>`, where `<feature>` is the `.scratch/<feature>/` folder name.
- Nothing is pushed by these skills. The user pushes and opens the PR.

## Tests

Run from Git Bash at the repo root (or worktree root). The app tests run in Docker, because the harness is POSIX-only:

```sh
MSYS_NO_PATHCONV=1 docker run --rm -v "$(pwd -W):/app" -v xv-anna-uv:/root/.cache/uv -w /app ghcr.io/astral-sh/uv:python3.12-bookworm-slim \
  sh -c 'grep -v xylem_connectors docker/spec_bot/requirements.txt > /tmp/req.txt && uv run -q --no-project --with-requirements /tmp/req.txt --with pytest --with pytest-asyncio --with mypy python -m pytest -q -p no:cacheprovider'
```

- A clean run is all green. The `grep -v` only matters on branches from before agent-lineup, where the app still needed `xylem_connectors` (from the private Nexus) and the VAC tests skipped without it. Since then only the sandbox image installs it, and its build needs `NEXUS_PYPI_USER`/`NEXUS_PYPI_TOKEN`.
- `app.py` has one old mypy error (`set_chat_profiles`).
- The sandbox runner tests skip in that container. Run them in `anna-sandbox-runner:latest` with the Docker socket mounted; the command is in `packages/sandbox_runner/README.md`. They start real sandbox containers on the host's Docker.

## Env files

Gitignored, so a worktree doesn't get them and they don't update when a ticket adds a variable:

| File | Example |
|---|---|
| `.env` | `.env.example` |
| `.env.runner` | `.env.runner.example` |

- A ticket that adds a variable also adds it, with a comment, to the example file.
- `ANNA_KB_DIR` in `.env.runner` is the absolute path of *this* clone's `packages/spec_bot/knowledge_base` (`packages/spec_bot/neo/knowledge_base` on branches from before agent-lineup 03), with forward slashes. It differs per checkout and worktree, so it's always derived, never copied.
- Any other missing key is a secret or a choice: ask the user for it.

## Local app

Run it only when the user wants to try the app itself. Tests need no stack. `/xv-anna-try-it` brings one up for a worktree, and `/xv-anna-try-it down` removes it. One app stack runs at a time, on port 8000.
