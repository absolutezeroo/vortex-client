# Vortex Client (AS3) - AGENTS

This file defines the AI coding contract for edits in `vortex-client`.

## Goal
Keep changes small, deterministic, and consistent with the client architecture across:

- startup/boot
- onboarding/login
- communication and protocol dispatch
- UI/window composition
- room/game rendering
- localization and configuration

## Platform and build context
- Language: ActionScript 3
- Runtime: Flash Player (AS3 target player 25)
- Main entry: `src/HabboAir.as`
- Project: `Habbo.as3proj`
- Compiler config: `asconfig.json`
- Output: `bin/Habbo.swf`

## High-priority constraints
- Do not edit `bin/` or `obj/` unless explicitly requested.
- Do not invent runtime behavior outside existing module patterns.
- Keep packet/protocol behavior stable unless the task explicitly targets protocol/communication.
- Preserve current behavior for normal login and SSO when both are configured.
- Keep user-visible labels as localization keys with `${key}` syntax.
- Avoid broad silent failures (`catch {}`); use meaningful handling and logging where available.

## Required context files
- `AGENTS.md` (this file)
- `asconfig.json`
- `Habbo.as3proj`
- `src/HabboAir.as`
- `src/HabboAirMain.as`
- `src/binaryData/HabboHabboConfigurationCom_Habbocommon_configuration_txt.bin`

If your task touches protocol/network/UI/room systems, also read:
- `src/com/sulake/habbo/communication/*`
- `src/com/sulake/habbo/room/*`
- `src/com/sulake/habbo/ui/*`
- `src/com/sulake/habbo/window/*`

## Priority order before editing
- Read local neighboring files in the target module first.
- Keep changes in the smallest impacted surface.
- Never refactor unrelated modules to satisfy one task.

## Common locations
- Onboarding: `src/onBoardingHc/*`
- Onboarding steps: `src/onBoardingHc/steps/*`
- Login provider: `src/com/sulake/habbo/communication/login/*`
- Communication messages: `src/com/sulake/habbo/communication/messages/*`
- Room/engine: `src/com/sulake/habbo/room/*`
- UI/window: `src/com/sulake/habbo/ui/*`, `src/com/sulake/habbo/window/*`
- Runtime config: `src/binaryData/HabboHabboConfigurationCom_Habbocommon_configuration_txt.bin`
- Localization bundles: `src/binaryData/HabboHabboLocalizationCom_Habbodefault_localizations_*.bin`

## Cross-module editing checklists

### Onboarding behavior change
- Required references: `OnBoardingHc.as`, relevant step files, provider entry points.
- Invariant checks:
  - flow still works with environment, login, register, and avatar steps
  - no duplicated flow transitions

### Communication/protocol change
- Required references: communication message/packet files and the callers in session/UI flow.
- Invariant checks:
  - packet IDs and payload expectations remain aligned with emulator expectations
  - no change to connect/reconnect semantics without explicit request
  - keep login/session fallback paths unchanged unless explicitly requested

### UI/room rendering change
- Required references: touched screen/window classes and related lifecycle modules.
- Invariant checks:
  - key-driven text remains intact (`${key}`)
- resource managers and room lifecycle transitions stay coherent
  - no blocking UI freezes from synchronous room/game work

### Localization update
- Required references: locale bundle files and AS screens that display those keys.
- Rules:
  - add missing keys in each targeted locale
  - keep key format `key=value`
  - preserve file encoding and CRLF style

### Configuration update
- Required references: related feature key and reading code.
- Rules:
  - keep all existing unrelated keys untouched
  - do not remove default keys unless requested
  - validate runtime impact by logs

## Validation protocol
1. Build from `Habbo.as3proj` in FlashDevelop.
2. If changed onboarding texts, test both login and SSO flows.
3. If changed communication flow, verify parse/dispatch and protocol errors in `flashlog.txt`.
4. If changed UI/room modules, open rooms and ensure no runtime exception loops.
5. If changed locale keys, verify no raw `${...}` appears on screen.
6. If changed config, confirm expected runtime lines in `flashlog.txt`.

## Debug location
- `%APPDATA%\\Macromedia\\Flash Player\\Logs\\flashlog.txt`
- For protocol and room issues, capture exception traces around communication/session/room tags.

## AI request format
1. Goal
2. Target files
3. Required context files used
4. Invariants preserved
5. Forbidden changes
6. Validation results
7. Concise summary

## Forbidden changes by default
- Massive cross-module refactors for small UX issues.
- Hardcoding user-facing copy in AS when a key exists.
- Removing error handling or weakening existing guard logic.
- Changing message schemas or packet assumptions outside explicit request scope.
- Editing binary assets in isolation (e.g., only config or locales) without the corresponding code path.
