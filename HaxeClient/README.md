# Haxe Client Migration (Starter Kit)

This folder contains a clean starting point to migrate the legacy AS3 client to Haxe, without changing production AS3 behavior yet.

## Why this exists
The Flash/AIR client is maintained, but web migration requires a staged approach.
This migration kit lets us:
- keep protocol behavior explicit and testable
- map onboarding/session flow in deterministic modules
- reuse domain concepts (`config`, `network`, `state`) before full UI/room rewrite

## Layout
- `build.hxml` : build entry for a JS output (`web/main.js`)
- `src/Main.hx` : application entrypoint
- `src/vortex/client/haxe/Bootstrap.hx` : boot sequence and lifecycle
- `src/vortex/client/haxe/config/ClientConfig.hx` : typed runtime configuration
- `src/vortex/client/haxe/core/AppState.hx` : migration state container
- `src/vortex/client/haxe/net/HabboPacket.hx` : minimal frame codec
- `src/vortex/client/haxe/net/MockSocket.hx` : non-blocking transport stub for local integration

## Run (initially)
- Install Haxe (and optional OpenFL later for UI).
- Build the current skeleton:
  - `cd HaxeClient`
  - `haxe build.hxml`
- Open `web/main.js` in a browser (or use a small test harness) once the project is wired to a host page.

## Migration sequence (recommended)
1. Keep protocol contracts stable while porting.
2. Recreate onboarding flow state transitions in `Bootstrap` and `AppState`.
3. Replace `MockSocket` with a browser socket transport that matches current Habbo endpoint behavior.
4. Add scene/UI abstractions (OpenFL/HaxeUI/other) after login/session path is stable.
