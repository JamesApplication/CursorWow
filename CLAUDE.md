# CursorWow — Documentation pour Claude Code

## Project Overview

**CursorWow** is a World of Warcraft Retail addon that lets players fully customize their mouse cursor appearance:
- **Shape**: Circle, cross, or arrow (drawn from Blizzard's built-in textures, tinted via SetVertexColor)
- **Color**: Full RGB control via the native ColorPickerFrame
- **Size**: Adjustable via slider

**Stack**: Pure Lua using only the native WoW AddOn API (Retail only). No external frameworks (Ace3, LibStub) — the addon stays lightweight by design.

**Platform**: WoW AddOn (overlays a texture that follows the cursor via GetCursorPosition() in an OnUpdate handler; the OS cursor remains underneath).

**v1 Scope**: Shape, color, and size customization via a native options panel (Settings.RegisterCanvasLayoutCategory API, Dragonflight+). Settings persist account-wide via SavedVariables (CursorWowDB).

**Architecture**: 
- `Core.lua` — Cursor overlay logic and lifecycle
- `Options.lua` — Settings panel and user preferences
- `CursorWow.toc` — Addon manifest

## Review Checkpoints

Run `/thermos` after finishing each execution phase and before marking it complete. Also run `/thermos` after any change touching security-sensitive code, SavedVariables serialization, or cross-module interactions (e.g., Core.lua ↔ Options.lua).

## Documentation

Both README.md and this CLAUDE.md file must be kept up to date. Update them at the end of every milestone and after any significant change — do not wait for the user to ask.

## Self-learning
When I correct you, or you catch yourself making a mistake: before continuing,
add the lesson as a one-line rule under ## Lessons, so it never happens again.

## Lessons
- `CreateFrame` calls that use `_G[frame:GetName() .. "Suffix"]` to reach templated child widgets (labels, text) must pass a real name string, never `nil` — an unnamed frame makes `GetName()` return `nil` and the concatenation errors at load time, silently aborting the rest of the file (e.g. it skipped `Settings.RegisterCanvasLayoutCategory` entirely).
- The `## Interface:` TOC number must match the player's actual client build (`select(4, GetBuildInfo())`), not a guessed/approximate value — verify in-game before considering an addon "done", don't assume from training-data knowledge.
