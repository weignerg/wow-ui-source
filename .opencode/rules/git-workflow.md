# Rule: Git Workflow

- **Issue-First**: Every task must have a GitHub Issue (`gh issue create`) before work starts.
- **Worktree Isolation**: Never develop directly on `forever-documented` or `release`. Provision a worktree via the `worktree_create` MCP tool or `tools/worktree_manager.py` (default location `.opencode/worktrees/<branch>`).
- **Branch Naming**: `<type>/issue-<number>-<description>` (e.g., `feat/issue-140-rules-architecture`).
- **Conventional Commits**: `feat(...)`, `fix(...)`, `docs(...)`, `test(...)`, `refactor(...)`, `chore(...)`.
- **Pushes**: Never force-push to overwrite remote history. Rebase onto the updated branch, or create a fresh commit, then make a normal fast-forward push. Only `gh pr merge` asks for confirmation.
- **Sync at head**: At completion, `git fetch origin` and rebase the worktree branch onto `origin/forever-documented`; leave the repo root on `forever-documented` so it tracks the latest head.
- **PR Lifecycle**: Open the PR with `Closes #<issue>` in the body, address review comments, then squash or rebase merge.
- Remove worktrees (`worktree_remove`) once the branch is merged.
