---
name: vault-retrieval
description: Query and search the repo-local Obsidian knowledge vault using CPU ColBERTv2 MaxSim semantic retrieval. Use when looking up architecture decisions, entity notes, system design, or memory in opencode_optional/vault/.
---

# Vault Retrieval Skill

Use this skill to query and inspect notes in the repo-local Obsidian Knowledge Vault (`opencode_optional/vault/`).

## When to Use
- Searching for architecture decisions, design rationale, or protocol guidelines.
- Looking up hardware profiles, entity definitions (`entities/`), or project specs (`projects/`).
- Retrieving context across the documents stored under `opencode_optional/vault/`.

## Retrieval Methods

### 1. Via FastMCP Tool (`harness-tools_colbert_retrieve`)
When the `vault-memory` MCP server is enabled, call `harness-tools_colbert_retrieve`,
pointing it at the ColBERT index that the reindexer writes:
```json
{
  "query": "SGLang KV-cache memory fraction",
  "top_k": 5,
  "index_dir": "<repo>/opencode_optional/vault/.index"
}
```
`index_dir` is the path to the `/.index/` directory inside `opencode_optional/vault/`
(the directory the reindexer populates). Expand `<repo>` to the absolute path of
the repo root when the tool does not substitute the placeholder itself.

### 2. Via Reindexer CLI
To update or rebuild the index over newly modified notes:
```bash
opencode_optional/tools/reindex_vault.sh --all
```
