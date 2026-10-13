---
description: Provision, list, or prune isolated git worktrees for task branches.
agent: orchestrator
---

Manage git worktrees for isolated task branching and execution. The default
worktree location is `.opencode/worktrees/`:

```bash
python3 .opencode/tools/worktree_manager.py $ARGUMENTS
```

Verify that the worktree directory is ready and isolated from the main working copy.
