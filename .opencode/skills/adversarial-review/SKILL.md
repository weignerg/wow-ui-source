---
name: adversarial-review
description: Perform adversarial code review, credential leak scanning, and regression audits. Use when auditing git diffs, checking staged commits, verifying secret boundaries, or evaluating mock integrity before merging.
---

# Adversarial Code Review Skill

Use this skill to conduct suspicious, rigorous audits of proposed or staged code changes.

## Audit Checklist
1. **Secret & Credential Leak Detection**:
   - Check for hardcoded API keys, tokens (`HF_TOKEN`), passwords, or absolute home paths.
   - Credentials must load via `%h/.config/opencode-backends/env`.
2. **Process Safety**:
   - Scan for dangerous commands like `kill`, `pkill`, or `systemctl stop` targeting host orchestrators or inference engines (`ornith-30000.service`).
3. **Mock Illusion Hunting**:
   - Ensure tests reflect true integration behavior and don't rely on overly permissive fake mocks that hide bugs.
4. **Platform Portability**:
   - Verify dynamic path resolution using `$HOME` or standard XDG base directory specifications.
