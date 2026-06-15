# Contributing (Vortex Client)

## Quick dev flow
1. Open `Habbo.as3proj` in FlashDevelop.
2. Make the smallest scoped code change possible.
3. Rebuild the client (`bin/Habbo.swf`).
4. Test the impacted flow and inspect `flashlog.txt` for issues.

## Before code changes
- Read:
  - `AGENTS.md`
  - `CONTEXT.md`
  - Relevant `src/...` files
- Keep focus: onboarding/login/localization/config only unless requested.

## Build and test notes
- No standard dotnet build in this repo. Compile is done via FlashDevelop project build.
- After each build:
  - confirm new/updated strings exist in localization files
  - clear old SWF/browser caches if behavior appears stale
  - check `%APPDATA%\Macromedia\Flash Player\Logs\flashlog.txt`

## Non-goals by default
- Rework of unrelated UI modules.
- Refactoring of the full Habbo architecture.
- Manual edits to generated/compiled outputs (`bin/`, `obj/`) in standard tasks.

## Commit hygiene
- Keep patch atomic:
  - one small feature/bugfix per commit
  - avoid mixing locale + deep protocol + config changes in one PR.

## Common command references
- Build: FlashDevelop / project build on `Habbo.as3proj`.
- Logs: `%APPDATA%\Macromedia\Flash Player\Logs\flashlog.txt`

## Logging and safety
- If the client shows raw `${...}` keys, treat it as a localization/config packaging issue first.
- Preserve previous behavior for existing successful login and SSO paths unless explicitly changed.

