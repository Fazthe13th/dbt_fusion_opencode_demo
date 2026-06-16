---
description: Create GitHub PR or GitLab MR
agent: reviewer
model: ollama/qwen3:8b
---

Create a pull request or merge request targeting main.

Required steps:

1. Get current branch:
   git branch --show-current

2. Compare changes:
   git diff main...HEAD
   git log main..HEAD --oneline

3. Generate:
   - concise title (<=72 chars)
   - summary paragraph
   - bullet list of key changes

4. Detect platform:
   - use gh if available
   - otherwise use glab

5. Execute the command.

GitHub:
gh pr create --base main --head "$BRANCH" --title "$TITLE" --body "$BODY"

GitLab:
glab mr create --target-branch main --source-branch "$BRANCH" --title "$TITLE" --description "$BODY"

Do not ask for confirmation for genearting title and body.
Execute the command after generating title and body.