---
tags:
  - wow-ui
  - documentation
  - Blizzard_StaticPopup
module: Blizzard_StaticPopup
parent: Blizzard_SharedXML
---

# Blizzard_StaticPopup

## Overview

`Blizzard_StaticPopup` is the engine behind nearly every modal dialog the game
drops over the UI: confirm prompts, delete/cancel warnings, timed warnings that
auto-close, typed-field ("type CONFIRM to continue") requests, dropdowns, and
progress-bar dialogs. Rather than each system building its own popup, every
AddOn registers a definition in the global `StaticPopupDialogs` table and calls
`StaticPopup_Show`, so the appearance, stacking, timeout countdown, and gamepad
behavior are shared everywhere. It is the central "pop-up dialog" system that
`Blizzard_SharedXML`'s `StaticPopup` frame template renders.

## Key Visual Behaviors

- **Modal overlay.** A popup raises above the game, darkens/retards unfocused
  sibling dialogs, and blocks interaction with the UI behind it until one of its
  buttons is chosen. Exclusive popups close any other open popup first
  (`StaticPopup_Show`, `StaticPopup.lua:309`).
- **Repeated types reuse one frame.** When the same kind of popup is requested
  while one is already visible, the game closes and re-shows the existing
  dialog instead of layering a second one (`StaticPopup_FindVisible`,
  `StaticPopup.lua:156`).
- **A live countdown.** Popups with a timeout show their remaining time; when it
  reaches zero the dialog closes itself automatically. The countdown is redrawn
  each frame by `StaticPopup_OnUpdate` (`StaticPopup.lua:481`), and a timed
  popup can optionally fill a shrinking progress bar (`StaticPopup_UpdateProgressBar`,
  `StaticPopup.lua:557`).
- **Typed-field confirmation.** A "type the word to proceed" prompt hides its
  confirm button until the correct text is entered, then enables it
  (`StaticPopup_StandardConfirmationTextHandler`, `StaticPopup.lua:140`).
- **Gamepad focus.** While using a controller, the focused popup is shown at full
  opacity with gamepad button icons on its actions, while other popups are
  visually dimmed (`UpdateGamepadUI`, `StaticPopupGamepad.lua:83`).

## Essential Functions

- `StaticPopupDialogs` (`StaticPopup.lua:21`) — the global table that maps a
  popup name (e.g. `GENERIC_CONFIRMATION`) to its buttons, text, and callbacks.
- `StaticPopup_AddDialog` / `StaticPopup_RemoveDialog` (`StaticPopup.lua:58`,
  `StaticPopup.lua:62`) — register or unregister a popup definition.
- `StaticPopup_Show` (`StaticPopup.lua:309`) — opens (or re-shows) a dialog of
  the requested type, sets its text/buttons, positions it, and makes it modal.
- `StaticPopup_ShowGenericConfirmation` (`StaticPopup.lua:225`) — shows a simple
  yes/no confirmation.
- `StaticPopup_ShowCustomGenericInputBox` (`StaticPopup.lua:265`) — shows a
  dialog with a text-entry field.
- `StaticPopup_ShowGenericDropdown` (`StaticPopup.lua:269`) — shows a
  single-select dropdown prompt.
- `StaticPopup_Hide` (`StaticPopup.lua:450`) — closes a single popup.
- `StaticPopup_HideAll` (`StaticPopup.lua:472`) — closes every open popup.
- `StaticPopup_OnShow` (`StaticPopup.lua:591`) — raises the dialog, runs its
  `OnShow` handler, locks keys, and fires the `PopupOpened` event (and screen-
  reader narration).
- `StaticPopup_UpdateAll` (`StaticPopup.lua:571`) — ticks every visible popup
  (timers, progress bars, enter delays) by one frame.
- `StaticPopup_Queue` / `StaticPopup_CheckQueuedDialogs` (`StaticPopup.lua:274`,
  `StaticPopup.lua:285`) — defer a popup until a modal dialog closes.

## Linked Components

- **`Blizzard_SharedXML`** — supplies the `StaticPopup` frame template that each
  popup window is built from, plus the `PopupEventManager` that publishes
  `PopupOpened`.
- **`Blizzard_Gamepad` / `GamepadMode`** — provide the gamepad button icons that
  `GamepadPopupHandler` (see `StaticPopupGamepad.lua`) attaches to popup actions
  and toggles on focus (`GamepadPopupHandler:FocusPopup`, `StaticPopupGamepad.lua:301`).
- **`NarrationUtil`** — reads the popup region so the in-game screen reader
  announces new dialogs (`StaticPopup_OnShow`, `StaticPopup.lua:591`).
- **`GlueParent`** — handles modal popups that appear over the character-select /
  lobby ("Glue") screens via the `cover` flag.
- **Player interaction points** — the dialog's accept/cancel buttons, optional
  text field, dropdown, and keyboard/gamepad selection (see
  `StaticPopupEditBoxMixin` in `SharedTemplates.lua:27`).
