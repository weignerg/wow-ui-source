---
name: documentation
description: Generate a high-level human-readable Obsidian note for one WoW UI addon module, focused on visual behavior and player-facing functionality. Use when documenting an addon under Interface/AddOns/<Name>.
---

# Documentation Skill

Generate a single, human-readable Obsidian note that describes **one** WoW UI
addon module from the perspective of what the player sees and does — not its
internal Lua machinery.

## Output Location
Write each note as a markdown file at:
`opencode_optional/vault/modules/<AddonName>.md`
where `<AddonName>` is the addon's folder/module name (the directory name under
`Interface/AddOns/<Name>/`). One file per addon.

## Frontmatter
Begin the note with YAML frontmatter that includes the tags `wow-ui` and
`documentation`, plus the module name:
```yaml
---
tags:
  - wow-ui
  - documentation
module: <AddonName>
---
```

## Body — the 5-Part Standard
Follow this structure, in order:

1. **Overview** — In plain English, describe what the UI visibly does for the
   player. What on screen belongs to this module? Link related modules with
   double-bracket wiki links `[[OtherModule]]`.

2. **Key Visual Behaviors** — The user interactions that produce visible
   changes: clicks, drags, keybinds, and frame state changes (shown/hidden,
   enabled/disabled, expanded/collapsed, highlighted, animating). Describe each
   interaction and the visual result it produces.

3. **Essential Functions** — List the module's primary functions, each with a
   single-sentence plain summary describing the visible result it produces
   (e.g. "Shows a glowing border when the item is a valid drop target.").

4. **Linked Components** — Double-bracket `[[...]]` wiki links to the parent
   frames, sub-frames, and related game systems this module connects to.

5. **Rules** — Keep the note accessible:
   - Avoid deep Lua jargon; describe front-end outcomes, not implementation.
   - Use Obsidian `[[Module]]` syntax for **all** cross-references.
   - Example linked modules from this repo: `[[Blizzard_FrameXMLBase]]`,
     `[[Blizzard_ButtonPulse]]`.

## Workflow
1. Identify the addon module under `Interface/AddOns/<Name>/`.
2. Read the module's files there.
3. Produce the note following the sections above.
4. Write it to `opencode_optional/vault/modules/<AddonName>.md`.
5. Do **not** reindex in the same step — run `/reindex` afterward so the new
   note becomes searchable.
