# Vortex Client TODO

## Current maintenance priorities
- [x] Keep onboarding/register/SSO changes scoped in `onBoardingHc/*`.
- [x] Keep user strings in locale keys and add missing keys in each targeted locale.
- [ ] Add locale coverage for all languages actually used by local test environments.
- [ ] Add a small "client developer check" section in `README.md` with local launch scripts.
- [ ] Document known external dependency versions (SDK path + browser/launcher expectations).
- [ ] Haxe migration (Phase 1): finalize skeleton modules in `HaxeClient/`.
  - [ ] Define config source strategy (`json`/`env`/query args)
  - [ ] Replace `MockSocket` with real browser socket adapter
  - [ ] Mirror onboarding state transitions (landing/login/register/SSO)
- [ ] Haxe migration (Phase 2): map room/session events and UI state containers.
- [ ] Haxe migration (Phase 3): remove SWF dependency for web usage.

## Working reminders
- Verify config changes in:
  - `HabboHabboConfigurationCom_Habbocommon_configuration_txt.bin`
- Verify translation keys in:
  - `HabboHabboLocalizationCom_Habbodefault_localizations_*.bin`
- Verify onboarding transitions in:
  - `src/onBoardingHc/OnBoardingHc.as`
  - `src/onBoardingHc/steps/*`

## Known gaps to close
- Keep a shared checklist for language fallbacks and duplicate keys cleanup.
- Formalize test matrix for login/no-login/SSO modes.
- Standardize one-click local run steps for the client's current SDK/runtime setup.
