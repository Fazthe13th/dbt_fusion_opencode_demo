---
description: Create pull request on git or merge request in gitlab
agent: build
model: ollama/qwen3:14b
subtask: true
---

# Git Pull Request Steps

**Instructions**

1. Inspect the main branch with `git diff` with the feature branch.
2. Add approprite description and also add points regarding the changes taht we are making to the MR or PR.
3. You can use this example github PR template:
```bash
gh pr create --base main --head <feature_branch_name_here> --title <insert_header_here> --body <description_with_points_here>
```
or for gitlab use:
```bash
glab mr create --target-branch main --source-branch <feature_branch_name_here> --title <insert_header_here> --description <description_with_points_here>
```
