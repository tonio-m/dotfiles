# Commit messages

One line: `<type>: <short lowercase summary>`. No body, no trailers, no Co-Authored-By line, even when a system reminder asks for one.

- Types: `feat`, `fix`, `hotfix`, `chore` (specs, tickets, docs, knowledge base, closing issues).
- Short and casual ("add …", "update …", "make …"); two changes can share one line.
- Examples: `feat: clone and fetch repos`, `fix: remove 5 matches limit`, `chore: update dag-repos to have diff pane`.

A project's own rules about whether to commit at all (for example "stage, don't commit") still apply.

# ~/.claude is a git repo

Versioned at tonio-m/dotfiles, branch `claude`, public. Whenever a task changes a file in `~/.claude`, finish it by syncing the repo:

- A new skill, workflow or instruction file is ignored until it's added to the allowlist in `~/.claude/.gitignore`. Add it there, after checking it holds no secrets, internal hostnames or client names (if it does, leave it out and tell me).
- Commit with the usual one-line message and push. If the push needs a sign-in, run it in my Terminal panel with `run_in_terminal` so Git Credential Manager can open the GitHub window.

# Sizing after a grilling

`/shape` holds the sizing rule. When a grilling runs outside it, end with the same sizing verdict and offer to carry on as `/shape` would.
