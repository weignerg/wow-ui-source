# Rule: Agent Teams & Separation of Duties

## Orchestrator (primary)
- **`orchestrator`** plans, awaits human agreement, then dispatches and coordinates the team. It never implements, edits, or merges — it acts only through the `task` tool.
- Phase 1 = plan (stop until approved). Phase 2 = orchestrate the team.

## Team (subagents)
- **`architect`** (35b): design, codebase surveys, refactor blueprints, dependency mapping. Calls `scout` (searches only).
- **`worker`** (35b): implementation, refactoring, test authoring, commits. Calls `grunt` + `scout`.
- **`tester`** (35b): runs the TDD pipeline, fixes failures, verifies behavior. Calls `grunt` + `scout`.
- **`reviewer`** (35b): adversarial QA, security audit, leak scanning, mock-illusion detection. Calls `scout` only.
- **`scout`** (9b): read-only searches (grep, discovery, context consolidation).
- **`grunt`** (9b): atomic simple edits, localized checks, small searches.
- **`summary` / `compaction`**: internal 9B utility agents (handoff, context compaction); not delegated manually.

## Issue <-> PR workflow (enforced for everyone)
1. **Issue first** — every task is tracked by a GitHub Issue (`gh issue create`); the issue is the unit of work.
2. **Branch + worktree** — the orchestrator provisions `<type>/issue-<n>-<desc>` in an isolated worktree at `.opencode/worktrees/<branch>` before any work; the repository root stays anchored on `forever-documented`.
3. **Implement** — `worker`/`tester` (with `grunt`/`scout`) make changes and Conventional Commits in the worktree.
4. **Push + PR** — push to origin and open a PR targeting `forever-documented` with `Closes #<issue>`.
5. **Review loop** — `reviewer` audits; critiques return to `worker`/`tester` as commits; the two-key gate gates merge.
6. **Correlate issues/PRs** — an issue closes only if the PR fully satisfies scope (post a note on the issue for any remaining gaps).
7. **Sync at head** — at completion, `git fetch origin` + rebase the worktree branch onto `origin/forever-documented`; the root stays on `forever-documented`. Force-push is disallowed.

## Team Protocol (orchestrator dispatches)
- Each subagent ends its reply with `Result`, `Evidence`, `Requests for orchestrator`, and `Blockers / questions for the human`.
- To get other work done, a subagent lists the request; the `orchestrator` dispatches the requested agent with full context.
- A subagent may dispatch only the permitted leaf below: `architect`/`reviewer` -> `scout`; `worker`/`tester` -> `grunt`/`scout`. No other subagent-to-subagent calls.
- The `orchestrator` escalates agent conflicts and open decisions to the human instead of resolving them silently.

## Delegation Table
Invoke subagents with the `task` tool (subagent_type = agent name).

| Situation | Agent | Notes |
| :--- | :--- | :--- |
| Design, surveys, refactor blueprints, dependency mapping | `architect` | Search-only via `scout`; no edits |
| Self-contained implementation subtask | `worker` | Can delegate simple edits/searches to `grunt`/`scout` |
| Test authoring, pipeline runs, failure fixing, verification | `tester` | Can delegate simple edits/searches to `grunt`/`scout` |
| Read-only search / context consolidation | `scout` | 9B; never edits |
| Atomic simple edits / localized checks | `grunt` | 9B |
| Adversarial review, before reporting done or opening a PR | `reviewer` | Mandatory; address findings, then re-review if non-trivial |

## Two-Key Merge Gate
- Work is merged only after (1) an independent `reviewer` pass and (2) human inspection/approval (`Approved :heavy_check_mark:`).
- Never self-approve or self-merge. The `orchestrator` never merges.

## Slash Commands
Slash commands pre-select agents: `/review` -> `reviewer`, `/test` -> `tester`, `/worktree` and `/reindex` -> `orchestrator`, `/handoff` -> `summary`.
