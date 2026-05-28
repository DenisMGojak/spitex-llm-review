# Context Docs — Round 001

These docs ground the LLM's understanding before they look at screenshots. Read order matters — they're numbered.

| File | Length target | Purpose |
|---|---|---|
| `app_overview.md` | ~1 page (~400-600 words) | What Megalith is, key domains, tech stack |
| `design_system_summary.md` | ~1 page (~500-800 words) | Knowhow/design distilled: palette, sizes, tokens, naming |
| `reusability_audit_summary.md` | ~1 page (~500-800 words) | Iter 271 reusability audit condensed: known duplication |

## Rules

- Keep each doc to ~1 page. LLM context is precious.
- No internal jargon without definition. Assume the LLM has never seen this codebase.
- Cite paths (`docs/Knowhow/design/avatar_identity_standard.md`) so the LLM can ask follow-up questions referencing them.
- Round-specific additional context goes in numbered files (e.g. `04_lane_dashboard_history.md`) only if the round demands.

## Status

| Doc | Status | Size |
|---|---|---|
| `app_overview.md` | ✅ DONE (2026-05-28 cc) | ~4.7 KB |
| `design_system_summary.md` | ✅ DONE (2026-05-28 cc) | ~6.4 KB |
| `reusability_audit_summary.md` | ✅ DONE (2026-05-28 cc) | ~8.6 KB |
