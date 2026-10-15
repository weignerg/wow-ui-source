# NOTICE — Attribution & Licensing for `.opencode/`

## Scope of this notice

This directory (`.opencode/`) contains the **OpenCode harness** shipped with the
`wow-ui-source` repository. It comprises the harness configuration, agent
definitions, rules, skills, slash commands, harness scripts/tools, and the
in-repo ColBERT knowledge vault:

```
.opencode/
├── AGENTS.md                 # authoritative harness instructions
├── opencode.json             # provider + MCP + agent config
├── agents/                   # agent role definitions
├── rules/                    # process, git, code-quality, process-safety rules
├── skills/                   # reusable skill packs
├── commands/                 # slash commands
├── tools/                    # harness scripts (reindexer, worktree manager, …)
└── vault/                    # repo-local ColBERTv2 semantic-memory vault
```

## Derivation from upstream open-code-harness

The material in `.opencode/` is **derived from and copied** (with local
enhancements) from the upstream **open-code-harness** project. On this machine
the upstream source is available as a local mirror at:

```
/WHNAS/agy/git/open-code-harness
```

Reference to the remote, non-existent URL is intentionally avoided; see the
"External engine dependency" note below for how upstream is referenced.

Local enhancements made when porting the harness into `wow-ui-source` are noted
inline where they live (for example, repo-specific vault paths, the WOW UI
addon source at `Interface/AddOns/`, and the git-worktree location under
`.opencode/worktrees/`).

## Copyright & license

- **Copyright (C) 2026 weignerg**
- **License: GNU AGPL-3.0-only**
- Full license text: **`.opencode/AGPL-3.0-LICENSE`**

Copied material **retains its original copyright notice and license terms** per
AGPL-3.0 §2(b) (§6 obligations) — the `(C) 2026 weignerg` header and the full
AGPL-3.0 license text are preserved verbatim. Any locally-authored enhancements
to that material are attributed in-place within the relevant files.

## External engine dependency

Several `.opencode/` features depend on the **open-code-harness /
open-code-sglang-stack** engine, which is itself AGPL-3.0 and is **not vendored**
into this repo. Those features are:

- the `vault-memory` MCP server (`harness.mcp.vault_server`)
- the `worktree-manager` MCP server (`harness.mcp.worktree_server`)
- the `tools/reindex_vault.sh` ColBERT reindexer (`harness.memory.colbert_engine`)

For the expected runtime (the venv that supplies these importable packages), see
**`.opencode/DEPENDENCIES.md`**. If the engine is absent, those features fail
fast with an explanatory message rather than silently crashing.

## Repo-level license

This repository declares **no top-level software license** of its own.

- The `.opencode/` harness material above remains **GNU AGPL-3.0-only** and is
  documented here and in `.opencode/AGPL-3.0-LICENSE`.
- The remainder of the repository is **unlicensed unless otherwise stated**
  (individual files may carry their own notice where one exists).
