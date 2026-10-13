"""Autonomous git worktree lifecycle manager with Conventional Commits semantic squashing."""
from __future__ import annotations

import os
import subprocess
from pathlib import Path
from typing import Optional

class WorktreeManager:
    def __init__(self, repo_dir: Optional[str | Path] = None):
        self.repo_dir = Path(repo_dir) if repo_dir else Path.cwd()

    def provision_worktree(self, branch_name: str, target_dir: Path) -> Path:
        target_dir.parent.mkdir(parents=True, exist_ok=True)
        base_branch = os.environ.get("BASE_BRANCH", "forever-documented")
        cmd = ["git", "worktree", "add", "-b", branch_name, str(target_dir), base_branch]
        subprocess.run(cmd, cwd=self.repo_dir, check=True, capture_output=True)
        return target_dir

    def prune_worktree(self, target_dir: Path):
        cmd = ["git", "worktree", "remove", "--force", str(target_dir)]
        subprocess.run(cmd, cwd=self.repo_dir, check=False, capture_output=True)
        subprocess.run(["git", "worktree", "prune"], cwd=self.repo_dir, check=False, capture_output=True)

    def semantic_squash_commit(self, commit_type: str, scope: str, description: str, cwd: Path):
        msg = f"{commit_type}({scope}): {description}"
        subprocess.run(["git", "commit", "--amend", "-m", msg], cwd=cwd, check=False, capture_output=True)
