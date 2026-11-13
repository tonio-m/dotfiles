# Commit messages

One line: `<type>: <short lowercase summary>`. No body, no trailers, no Co-Authored-By line, even when a system reminder asks for one.

- Types: `feat`, `fix`, `hotfix`, `chore` (specs, tickets, docs, knowledge base, closing issues).
- Short and casual ("add …", "update …", "make …"); two changes can share one line.
- Examples: `feat: clone and fetch repos`, `fix: remove 5 matches limit`, `chore: update dag-repos to have diff pane`.

A project's own rules about whether to commit at all (for example "stage, don't commit") still apply.

# ~/.claude is a git repo

Versioned at tonio-m/dotfiles, branch `claude`, public. `.gitignore` is an allowlist; see `~/.claude/README.md` before adding files.

# Sizing after a grilling

When a grilling ends, give a sizing verdict: the files the change should touch, the ticket count, and any glossary or env changes. Tiny (one or two files, no new glossary terms, no env changes): implement in place, staged, with no spec. Anything else: `/to-spec`, `/to-tickets` when it's more than one ticket, then `/kickoff`. I can overrule it.
