---
tags:
  - wow-ui
  - documentation
module: Blizzard_ButtonPulse
---

# Blizzard_ButtonPulse

## Overview

`Blizzard_ButtonPulse` drives the *blinking highlight* effect you see on game
buttons. When something wants to draw the player's eye to a button — for
example, an action that is temporarily usable or must be re-confirmed — this
module makes that button's highlight flash on and off for a while, then turns it
off cleanly once the job is done.

The module is intentionally small: it keeps a list of the buttons that are
currently blinking, and it relies on one shared, otherwise-invisible *pulse
frame* as a single timer that advances all of them together. Every button that
blinked is a standard FrameXML button built on `[[Blizzard_FrameXMLBase]]`, the
base framework this module depends on.

## Key Visual Behaviors

- **A button starts to pulse:** its highlight begins to blink on and off at a
  steady rhythm. The pulse *rate* controls how often (in seconds) the highlight
  toggles between on and off, and it keeps blinking until the requested
  *duration* elapses — after which the highlight simply stays off.
- **Buttons pulse independently:** each button runs on its own countdown, so
  several pulsing buttons blink at their own separate rhythms rather than in
  lockstep.
- **The shared pulse frame appears and disappears with the work:** it stays
  "shown" (running the timing loop that makes the highlights blink) whenever at
  least one button is pulsing, and it goes "hidden" the moment the last pulsing
  button finishes. Because the frame itself has no appearance of its own, its
  busy-or-idle state is felt only as the visible blinks starting and stopping
  across the buttons.
- **Stopping a button mid-pulse:** its highlight is turned off immediately, and
  it no longer keeps the shared pulse frame active.

## Essential Functions

- **`SetButtonPulse(button, duration, pulseRate)`** — begins (or restarts)
  blinking a button's highlight, flashing it at the given rate for the given
  amount of time.
- **`UpdatePulseFrameState()`** — shows the shared pulse frame while any button
  is still blinking and hides it once every button has stopped, so the timer
  only runs while there is actually something to blink.
- **`ButtonPulse_OnUpdate`** — every moment it advances each pulsing button's
  remaining time and flips its highlight on/off at the correct interval,
  removing any button whose time has run out.
- **`ButtonPulse_StopPulse(button)`** — stops a button's blink and turns off its
  highlight right away.

## Linked Components

- **`[[Blizzard_FrameXMLBase]]`** — the base FrameXML framework this module
  depends on; the buttons it makes blink are standard FrameXML buttons.
- **The shared pulse frame** — the single, otherwise-invisible frame that runs
  the timing loop and is shown or hidden based on how many buttons are pulsing.
- **The button highlight system** — the per-button highlight overlay that is
  toggled on and off to create the visible blink. It is part of the standard
  FrameXML button appearance family built on `[[Blizzard_FrameXMLBase]]`.

## Rules

- Describe the front-end outcome, not the Lua: this module only cares about
  making highlights blink and keeping the shared pulse frame busy or idle.
- All cross-references use Obsidian `[[Module]]` syntax (see
  `[[Blizzard_FrameXMLBase]]`).
