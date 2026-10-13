# wow-ui-source Obsidian Knowledge Vault

This vault is the repo-local ColBERT semantic-memory index for the
`wow-ui-source` repository (a mirror of ~348 Blizzard UI addon modules under
`Interface/AddOns/`). It lets the agent search the codebase's documentation and
architecture notes semantically on CPU only.

## Layout

```
.opencode/vault/
├── README.md        # this file
├── modules/         # one documentation note per addon: <AddonName>.md
│                   #   (authoritative, searchable knowledge)
├── templates/       # note templates (documented pattern to copy into modules/)
│   └── note-template.md
└── .index/          # ColBERT build artifact (gitignored — never commit)
```

- **`modules/`** holds one `.md` note per addon module. Each note is generated
  with the `documentation` skill (`.opencode/skills/documentation/SKILL.md`)
  and follows the 5-part standard.
- **`templates/`** holds reusable note templates. The pattern in
  `note-template.md` is the reference shape for notes written into `modules/`.
- **`.index/`** is the ColBERTv2 index produced by the reindexer. It is a
  build artifact and is gitignored (see `.opencode/.gitignore`).

## How to reindex

After creating or editing notes, rebuild the index so they become searchable:

```bash
.opencode/tools/reindex_vault.sh --all
```

This reindexes `<repo>/.opencode/vault`, where `<repo>` is the repo root
(`git rev-parse --show-toplevel`). Override with:

- `VAULT_PATH=/path/to/vault .opencode/tools/reindex_vault.sh` — reindex a
  specific vault directory.
- `ENGINE_REPO=/path/to/engine/host .opencode/tools/reindex_vault.sh` — point
  the reindexer at a different ColBERT engine host.

## How to search

Use the ColBERT semantic-retrieval FastMCP tool `harness-tools_colbert_retrieve`
with `index_dir` pointing at this vault's index:

```json
{
  "query": "how does the UI pulse a button border on lootable objects?",
  "top_k": 5,
  "index_dir": ".opencode/vault/.index"
}
```

`index_dir` resolves to the `.index/` directory inside this vault. Prefer this
over raw text search whenever the query is a question or intent rather than a
literal substring.
