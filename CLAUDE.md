# CLAUDE for Vortex Client

Use this with the local contract set:
- `AGENTS.md`
- `CONTEXT.md`
- `README.md`
- `CONTRIBUTING.md`
- `TODO.md`

## Working rules
- Keep patches minimal and reversible.
- Do not touch generated outputs unless requested.
- Keep UI labels in localization keys (`${key}`).
- Keep `.bin` locale/config files in compatible text encoding.

## Execution pattern
1. Confirm understanding of the exact target files.
2. Patch in one pass.
3. Keep behavior consistent with existing onboarding/login flow.
4. Return concise notes with risks and next checks.

## If uncertain
- Ask one focused question with a concrete choice.
- Avoid broad speculative changes.
