---
tags:
  - wow-ui
  - documentation
module: Blizzard_FrameXMLBase
---

# Blizzard_FrameXMLBase

> This is a filled example note showing the 5-part standard. Copy this shape
> into `modules/<AddonName>.md` when documenting a real addon; replace the
> content with what that module actually does.

## Overview
`[[Blizzard_FrameXMLBase]]` provides the shared, reusable frame and utility
building blocks that the Blizzard user-interface addons construct their screens
on top of. For the player it is the invisible scaffolding behind common control
types (windows, dialogs, lists, and draggable panels) — the reason addon windows
behave consistently, can be resized or dragged, and share the same baseline
styling as the default UI. See also `[[Blizzard_ButtonPulse]]` for the button
pulse behavior these frames expose.

## Key Visual Behaviors
- When a frame is shown, its contents fade/anchor into place according to the
  default transition the base frames apply.
- Draggable panels follow the pointer while the mouse button is held, then
  stay where the player dropped them.
- Disabled controls render dimmed and do not respond to clicks; enabled
  controls highlight on hover.
- Overcrowded lists scroll and virtualize, only drawing rows that are visible.

## Essential Functions
- `CreateFrame` — create a new frame/control of a given type; the visible result
  is a new on-screen element that participates in the normal UI layout.
- `ShowFrame` / `HideFrame` — make or remove a frame from view; the visible
  result is the element appearing or disappearing on the player's screen.
- `RegisterFrameForTooltips` — associate a frame with tooltip behavior; the
  visible result is that hovering over the frame shows its tooltip.
- `UpdateExpandFrames` — reconcile child frames against their parent; the visible
  result is that the layout stays correct when things are added or removed.

## Linked Components
- Parent / base system: `[[Blizzard_FrameXMLBase]]`
- Related controls: `[[Blizzard_ButtonPulse]]`
- The player-facing surfaces that consume these blocks live under `Interface/
  AddOns/`.

## Rules
- Avoid deep Lua jargon; describe the front-end outcome the player observes.
- Use Obsidian `[[Module]]` syntax for all cross-references (as shown above).
