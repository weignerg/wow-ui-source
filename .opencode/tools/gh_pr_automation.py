"""GitHub Draft PR automation, comment responder, and CI failure log analyzer."""
from __future__ import annotations

import json
import re
import subprocess
from typing import Dict, List, Optional

class GitHubPRAutomation:
    def __init__(self, gh_bin: str = "gh"):
        self.gh_bin = gh_bin

    def create_draft_pr(self, title: str, body: str, base: str = "develop") -> str:
        cmd = [self.gh_bin, "pr", "create", "--draft", "--base", base, "--title", title, "--body", body]
        proc = subprocess.run(cmd, capture_output=True, text=True, check=True)
        return proc.stdout.strip()

    def parse_ci_log_failures(self, log_text: str) -> List[Dict[str, str]]:
        failures = []
        pattern = re.compile(r"(FAIL|ERROR):\s+(test_[a-zA-Z0-9_]+)\s+\((.*?)\)")
        for match in pattern.finditer(log_text):
            failures.append({
                "type": match.group(1),
                "test": match.group(2),
                "module": match.group(3)
            })
        return failures

    def reply_to_comment(self, pr_number: int, comment_body: str) -> bool:
        cmd = [self.gh_bin, "pr", "comment", str(pr_number), "--body", comment_body]
        proc = subprocess.run(cmd, capture_output=True, text=True)
        return proc.returncode == 0
