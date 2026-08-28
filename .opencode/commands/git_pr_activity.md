---
description: Create GitHub PR or GitLab MR
agent: reviewer
model: ollama/qwen3:14b
subtask: true
return: "Now execute the exact gh or glab command drafted by the subtask in my primary console."
---


# Git Pull Request Steps

**Instructions**

1. Inspect the main branch with `git diff` against the feature branch.
2. `git`, `gh`, and `glab` are three different command-line tools. Do not confuse one with another.

**head** Use `git branch --show-current` for getting head.
**title** Summarize the changes between `main` branch and head branch.
**body** Provide a short description of the changes and add bullet points.
Example syntex for github PR:
```bash
gh pr create --base main --head <head> --title <title> --body <body>
```
or for gitlab MR use:
```bash
glab mr create --target-branch main --source-branch <head> --title <title> --description <body>
```

Do not ask for confirmation.
Generate PR command after generating title and body.