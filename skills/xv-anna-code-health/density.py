"""Comment and docstring density of every tracked Python file.

Run from the repo root: python -I .claude/skills/code-health/density.py
Prints three tables: files by share of comment+docstring lines, the longest docstrings,
and docstrings longer than the code under them.
"""

import ast
import io
import subprocess
import tokenize

SKIP = ("knowledge_base", ".scratch/")


def tracked_python_files() -> list[str]:
    listing = subprocess.check_output(["git", "ls-files", "*.py"], text=True)
    return [path for path in listing.split() if not any(skip in path for skip in SKIP)]


def main() -> None:
    files, docs = [], []
    for path in tracked_python_files():
        source = open(path, encoding="utf-8").read()
        lines = source.count("\n") + 1
        comments = sum(
            1
            for token in tokenize.generate_tokens(io.StringIO(source).readline)
            if token.type == tokenize.COMMENT
        )
        try:
            tree = ast.parse(source)
        except SyntaxError:
            continue
        doc_lines = 0
        for node in ast.walk(tree):
            if not isinstance(node, (ast.Module, ast.ClassDef, ast.FunctionDef, ast.AsyncFunctionDef)):
                continue
            doc = ast.get_docstring(node, clean=False)
            if not doc:
                continue
            length = doc.count("\n") + 1
            doc_lines += length
            body = node.body
            code = body[-1].end_lineno - body[0].end_lineno if len(body) > 1 else 0
            name = getattr(node, "name", "<module>")
            docs.append((length, code, f"{path}:{getattr(node, 'lineno', 1)}", name))
        files.append(((comments + doc_lines) / lines, comments, doc_lines, lines, path))

    print("## Files by comment+docstring share (80+ lines, top 12)")
    for share, comments, doc_lines, lines, path in sorted(
        (f for f in files if f[3] >= 80), reverse=True
    )[:12]:
        print(f"{share:.0%}  comments={comments} docstrings={doc_lines} lines={lines}  {path}")

    print("\n## Longest docstrings (top 15)")
    for length, code, where, name in sorted(docs, reverse=True)[:15]:
        print(f"{length} doc lines, {code} code lines  {name}  {where}")

    print("\n## Docstrings longer than their code (4+ doc lines)")
    for length, code, where, name in sorted(docs, key=lambda d: d[0] - d[1], reverse=True):
        if length > code and length >= 4:
            print(f"{length} doc lines, {code} code lines  {name}  {where}")


if __name__ == "__main__":
    main()
