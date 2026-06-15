# Vortex Client (Flash AS3)

Legacy Flash/AIR client for Vortex (ActionScript 3, Flash Player 25), compiled to `bin/Habbo.swf`.

## What this client is
- Entry point: `src/HabboAir.as`
- Project: `Habbo.as3proj`
- Build config: `asconfig.json`, `habbo-compile-config.xml`
- Output: `bin/Habbo.swf`

## Quick start
1. Open `Habbo.as3proj` in FlashDevelop.
2. Build the SWF.
3. Configure your local endpoint in:
   - `src/binaryData/HabboHabboConfigurationCom_Habbocommon_configuration_txt.bin`
4. Launch and check runtime logs at:
   - `%APPDATA%\\Macromedia\\Flash Player\\Logs\\flashlog.txt`

## Repository map
- `src/` : ActionScript sources
- `src/HabboAir.as` + `src/HabboAirMain.as` : application bootstrap and startup flow
- `src/onBoardingHc/*` : onboarding + landing + register/login/SSO path
- `src/com/sulake/habbo/communication/*` : protocol, connection, messages, and login providers
- `src/com/sulake/habbo/session/*` : session/user lifecycle
- `src/com/sulake/habbo/room/*` : in-room engine, avatar placement, interactions, renderer modules
- `src/com/sulake/habbo/ui/*`, `src/com/sulake/habbo/window/*` : UI widgets, dialogs, menus, HUD
- `src/com/sulake/habbo/catalog/*` : catalog workflows
- `src/com/sulake/habbo/inventory/*` : inventory flows
- `src/com/sulake/habbo/navigator/*` : room discovery/navigation
- `src/com/sulake/habbo/toolbar/*` : toolbar/quick actions
- `src/binaryData/*` : embedded config and localization bundles
- `bin/`, `obj/` : build artifacts (do not edit manually)
- `HaxeClient/` : staged migration scaffold to Haxe (bootstrap + protocol skeleton)

## Common areas to touch
- Onboarding flow:
  - `src/onBoardingHc/OnBoardingHc.as`
  - `src/onBoardingHc/steps/OnBoardingHcStep*.as`
- Communication/protocol:
  - `src/com/sulake/habbo/communication/messages/*`
  - `src/com/sulake/habbo/communication/login/WebApiLoginProvider.as`
- UI/window:
  - `src/com/sulake/habbo/ui/*`
  - `src/com/sulake/habbo/window/*`
- Rooms:
  - `src/com/sulake/habbo/room/*`
- Localizations:
  - `src/binaryData/HabboHabboLocalizationCom_Habbodefault_localizations_*.bin`
- Runtime config:
  - `src/binaryData/HabboHabboConfigurationCom_Habbocommon_configuration_txt.bin`

## Validation notes
- Rebuild SWF after any AS or binary-data key change.
- Clear/reload the old SWF after build.
- If text appears as `${...}` keys, check locale bundles.
- For protocol-related edits, verify there are no connection/parser loops in `flashlog.txt`.
- For room/UI edits, confirm no repeated runtime exceptions while opening a room.

## Contributing policy
- Keep changes minimal and scoped to the asked behavior.
- Do not modify `bin/` and `obj/` for regular feature work.
- Avoid mixing unrelated areas in the same patch unless specifically requested.
- Keep user-facing text in localization files, not hardcoded in AS.

## Haxe migration (starter)
- `HaxeClient/build.hxml` contains a JS build entry for the migration skeleton.
- `HaxeClient/src/` contains:
  - `Main.hx`
  - `vortex/client/haxe/Bootstrap.hx`
  - `vortex/client/haxe/config/ClientConfig.hx`
  - `vortex/client/haxe/core/AppState.hx`
  - `vortex/client/haxe/net/HabboPacket.hx`
  - `vortex/client/haxe/net/MockSocket.hx`
- Build locally with:
  - `haxe HaxeClient/build.hxml`
