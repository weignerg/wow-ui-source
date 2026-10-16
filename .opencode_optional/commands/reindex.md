---
description: Rebuild the ColBERTv2 CPU MaxSim semantic memory index over the Obsidian knowledge vault.
agent: orchestrator
---

Rebuild the ColBERTv2 semantic retrieval index across the repo-local Obsidian
knowledge vault at `opencode_optional/vault`:

```bash
opencode_optional/tools/reindex_vault.sh $ARGUMENTS
```

Verify that the index was updated and report the indexed document count.
