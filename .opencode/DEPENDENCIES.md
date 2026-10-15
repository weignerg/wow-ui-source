# Dependencies — `.opencode/` external-engine requirement

This document lists the **external-engine dependencies** of the `.opencode/`
harness. Everything else in `.opencode/` (rules, agents, skills, slash commands,
the git-worktree tooling, the WOW UI addon vault) runs with just this repository
and the local SGLang inference endpoint.

## Why this exists

The following features require the **open-code-harness / open-code-sglang-stack**
engine, which is itself **GNU AGPL-3.0-only** and is **NOT vendored** into this
repository. On this machine the engine lives at:

```
/WHNAS/agy/git/open-code-harness   (local source mirror)
```

A remote URL is intentionally not referenced here; see `.opencode/NOTICE.md`.

If the engine is not importable, the affected `.opencode/` features **fail fast**
with an explanatory message instead of crashing silently. That behavior is what
`.opencode/opencode.json` enforces for the two MCP servers, and what
`.opencode/tools/reindex_vault.sh` enforces for the ColBERT reindexer.

## Required features

| Feature | Role | Provider identifier | Requires |
| --- | --- | --- | --- |
| `vault-memory` MCP server | ColBERT semantic-memory search over `.opencode/vault` | `harness.mcp.vault_server` | engine + venv |
| `worktree-manager` MCP server | Isolated git worktree provisioning / lifecycle | `harness.mcp.worktree_server` | engine + venv |
| ColBERT reindexer script | Builds/refreshes `.opencode/vault/.index` | `harness.memory.colbert_engine` | engine + venv |

All three import the `harness` package; the `venv` below is where that package
(and the `ColUColBERTIndex`/ColBERT machinery) is importable from.

## Expected venv location

The engine ships a Python virtual environment. The `.opencode/` tooling looks
for it at:

```
${HOME}/.local/share/opencode-sglang-stack/venv
```

Within that venv, the `harness` package exposes:

- `harness.mcp.vault_server`
- `harness.mcp.worktree_server`
- `harness.memory.colbert_engine`

This `${HOME}/.../opencode-sglang-stack/venv` path is the **only** documented
external-runtime dependency. If it is absent, the interpreter selection in
`opencode.json` and `reindex_vault.sh` falls back to a bare `python3` and the
call surfaces the import error, which this file explains.

## What happens if the engine is missing

- **MCP servers** (`opencode.json`): each launch first runs a `import` guard. If
  the module cannot be imported, it prints an explicit `ERROR:` line pointing at
  this file and exits `2`, so `opencode` reports a clear message rather than a
  generic launch failure.
- **reindexer** (`tools/reindex_vault.sh`): if no ColBERT engine can be located
  (no `ENGINE_REPO`, no parent dir containing `harness/memory/colbert_engine.py`),
  the script prints an error directing you to set `ENGINE_REPO` or install the
  engine, then exits non-zero.
- **ColBERT retrieval tool** (`harness-tools_colbert_retrieve`): the search tool
  is served by the `vault-memory` MCP server above, so it is unavailable until
  that server can import `harness.mcp.vault_server`.

## Optional overrides

- `ENGINE_REPO=<path-to-open-code-harness>` — point `reindex_vault.sh` at a
  different ColBERT engine host (see `tools/reindex_vault.sh`).
- `VAULT_PATH=<path-to-vault>` — point `reindex_vault.sh` at a different vault
  directory (see `tools/reindex_vault.sh`).

## Unrelated dependencies

- The local SGLang inference endpoint (`http://127.0.0.1:30000/v1`) is required
  to run the agents. It is configured in `opencode.json` under the `ornith-local`
  provider and is outside the scope of this engine-dependency list.
