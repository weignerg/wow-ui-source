---
description: Generate an Obsidian documentation note for one UI addon module under Interface/AddOns.
agent: worker
---
Generate a single Obsidian note for the given addon module using the `documentation` skill (.opencode/skills/documentation/SKILL.md). Read the module's files under Interface/AddOns/<Name>/, then write .opencode/vault/modules/<Name>.md following the 5-part standard. Avoid Lua jargon; describe visual/player-facing behavior. Do not reindex here (use /reindex).
