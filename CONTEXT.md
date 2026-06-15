# Vortex Client Context (AS3)

## What is in this repo
This is the Flash/AIR client for Vortex (desktop/web legacy Habbo-style client).

- Entry flow: `src/HabboAir.as`
- Core bootstrap: `src/HabboAirMain.as`
- Login/onboarding, registration, and landing UX: `src/onBoardingHc/*`
- Protocol transport + messages: `src/com/sulake/habbo/communication/*`
- Runtime state/session modules: `src/com/sulake/habbo/session/*`
- UI primitives and windows: `src/com/sulake/habbo/window/*`, `src/com/sulake/habbo/ui/*`
- Room and avatar/game rendering: `src/com/sulake/habbo/room/*`
- Content and subsystem modules: `src/com/sulake/habbo/catalog/*`, `src/com/sulake/habbo/inventory/*`, `src/com/sulake/habbo/navigator/*`, `src/com/sulake/habbo/toolbar/*`
- Runtime config and localization assets: `src/binaryData/*`

## Core boundaries

### 1) Client startup and lifecycle
- `HabboAir` creates the global bootstrap.
- `HabboAirMain` drives bootstrap state (assets, config, login mode, onboarding flow entry).
- Keep initialization order stable when touching startup paths.

### 2) Communication and network protocol
- Protocol messages and handlers live in `src/com/sulake/habbo/communication/messages/*` and `src/com/sulake/habbo/communication/login/*`.
- Encryption/login bootstrap is under `src/com/sulake/habbo/communication/encryption/*`.
- Session behavior and socket/state transitions depend on emulator protocol contracts; do not modify assumptions blindly.

### 3) Login and onboarding flow
- Onboarding includes landing, login, register, SSO/token, avatar creation, and validation.
- Server feature flags from config and login provider output directly influence this flow.
- Keep callback semantics stable when changing button wiring and transitions.

### 4) UI and window layer
- Rendering stack and widgets live across `ui` and `window` namespaces.
- Most screens, modal flows, and HUD pieces are event-driven and key-based for text.
- Avoid changing shared window lifecycles unless intended (create/add/remove/dispose paths can leak or freeze UI).

### 5) Room / game display
- Room entry and in-room modules are handled in `src/com/sulake/habbo/room/*`.
- Do not isolate room logic from avatar/session modules when touching movement, chat, or avatar visual updates.
- Any room-side bugfix should preserve event ordering around enter/leave and scene initialization.

### 6) Localization and configuration
- Runtime config: `HabboHabboConfigurationCom_Habbocommon_configuration_txt.bin`.
- Localizations: `HabboHabboLocalizationCom_Habbodefault_localizations_*.bin`.
- Binary assets are client-packaged resources and must be kept coherent with code key usage.

### 7) Diagnostics
- Primary debug log: `%APPDATA%\\Macromedia\\Flash Player\\Logs\\flashlog.txt`.
- Network/protocol faults usually appear as parser, socket, or connection tags.
- UI issues often surface as missing key warnings or repeated stack traces.

## Invariants to preserve
- Do not edit `bin/` or `obj/` unless explicitly requested.
- Keep onboarding/login and protocol compatibility stable by default.
- Keep UI strings in localization keys (`${key}`), and add missing keys rather than hardcoding literals.
- Do not modify unrelated config keys when patching a single behavior.
- Keep communication changes aligned with emulator counterpart expectations.

## What to read first before changing
1. `AGENTS.md`
2. `README.md`
3. `CONTRIBUTING.md`
4. `CODEX.md`
5. `CLAUDE.md`
6. Target files in the module you edit

## Client task map
- Add/fix onboarding screen: `src/onBoardingHc/*`
- Adjust register/login behavior: `src/com/sulake/habbo/communication/login/*`
- Fix protocol/messages: `src/com/sulake/habbo/communication/messages/*` and related session handlers
- Fix localization display: `src/.../steps/*` + locale `binaryData` bundles
- Fix room entry/visual flow: `src/com/sulake/habbo/room/*`
- Fix window/UI defects: `src/com/sulake/habbo/ui/*`, `src/com/sulake/habbo/window/*`
- Fix config features/flags: `src/binaryData/HabboHabboConfigurationCom_Habbocommon_configuration_txt.bin`
