# AGENTS.md — wow-ui-source (opencode agent harness)

This file is the repo-specific setup for the opencode agent and defines the branch model and documentation workflow used in this fork.

## Repo context & safety
- This fork is a **read-only upstream mirror** of Blizzard FrameXML (`wow-ui-source`).
- **Never** edit, add, or delete files inside `Interface/`. Only harness/config files (e.g. this `AGENTS.md`) may be modified locally.
- Work is done on `forever-documented` (via `epic`); `forever` is pinned as the mirror base and the PR target.
- Scope searches to specific `Blizzard_*` AddOn directories. Full-tree `grep`/`find` floods context (4,400+ files).
- Blizzard FrameXML in `Interface/` is the source of truth. Never assume API names or argument order — locate the actual definition first.

## Branch model
- `forever` — upstream mirror base (`Gethe/wow-ui-source` forever). Read-only source of truth; pin to its latest tag, never modify `Interface/`. Documentation parity is measured against `forever`.
- `epic` — staging branch for all work under the current GitHub Epic (#1). Each documented module's changes are merged here first.
- `forever-documented` — our consolidation branch, derived from `epic`. Pull requests from `forever-documented` target `forever`.

Flow: per-AddOn doc work → merge into `epic` → merge `epic` into `forever-documented` → open a PR targeting `forever`.

## Documentation task standard (Obsidian vault)
When working on any documentation module issue, the deliverable is a high-level, human-readable Obsidian note. Focus on **visual behavior and player-facing functionality**, not low-level Lua. Each sub-issue must produce a note following this structure exactly:

1. **Frontmatter:** YAML metadata with tags `wow-ui`, `documentation`, and the module name.
2. **Overview:** Describe what the UI component visually does on the player's screen, linking related modules with double-bracket wiki links (`[[Module Name]]`).
3. **Key Visual Behaviors:** Explain user interactions (clicks, drags, keybinds, frame state changes) in plain English.
4. **Essential Functions:** List primary functions with a single-sentence plain-text summary of each function's visible result.
5. **Linked Components:** Provide double-bracket wiki links to parent frames, sub-frames, and related game systems to build the Obsidian vault graph.

## Agent execution checklist
- Read the assigned module code and identify visual UI elements and user interactions.
- Avoid deep Lua technical jargon; focus strictly on functional front-end outcomes.
- Format all cross-references using standard Obsidian wiki syntax (`[[Module Name]]`).
- Open a pull request containing the generated markdown file and link it directly to the corresponding module issue.

## Work-order (documentation epic)
Documentation work is organized under Epic #1 (`https://github.com/weignerg/wow-ui-source/issues/1`). Its `### Linkage` block lists the parent/child structure, batch grouping of remaining AddOns, and the recommended sequence: pre-flight → tooling/mirror → controller subsystem docs → remaining AddOn docs → final repo sweep.
