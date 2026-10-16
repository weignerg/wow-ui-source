# `.opencode_optional/` — OpenCode Agent Harness (opt-in)

This directory holds a **repo-local OpenCode agent harness**: the charter
(`AGENTS.md`), the rules, agent roles, slash commands, skills, and the
ColBERT knowledge-vault tooling.

## Why `.opencode_optional` and not `.opencode`?

OpenCode **auto-loads a project config only from a directory named
`.opencode/`** (e.g. `.opencode/opencode.json`, `.opencode/AGENTS.md`). If this
repository shipped a tracked `.opencode/`, OpenCode would treat it as the
project's own config/workspace directory — which collides with OpenCode's
expected location, with the host's home config (`~/.config/opencode`), and with
the local git-worktree directory that lives under the repo-root
`.opencode/worktrees`.

To stay **out of OpenCode's way**, this harness ships under the deliberately
non-conflicting name `.opencode_optional/`. OpenCode will **not** auto-load it,
so it stays inert until you choose to activate it.

## Activate it (opt-in) — choose one

1. **Rename in your local checkout** so OpenCode auto-loads it:

       git mv .opencode_optional .opencode

   After the rename, OpenCode loads `.opencode/opencode.json`,
   `.opencode/AGENTS.md`, `.opencode/rules/*.md`, the slash commands in
   `.opencode/commands/`, the roles in `.opencode/agents/`, the skills in
   `.opencode/skills/`, and the tooling in `.opencode/tools/`.

2. **Install into your home config** — copy the files you want into your host
   config directory (`~/.config/opencode/`) instead of keeping them in the repo.

3. **Ignore it** — leave this directory alone. It is inert; it changes nothing
   unless you rename it.

## Tracking / .gitignore

- `.opencode_optional/` is **committed and tracked** — the harness ships here.
- The repo-root `.gitignore` ignores `.opencode` (OpenCode's managed /
  git-worktree-parent directory). Do **not** commit a tracked `.opencode/` here;
  keep this name until you opt in.

## Licensing

This harness is AGPL-3.0-derived material; see `NOTICE.md` and
`AGPL-3.0-LICENSE`.
