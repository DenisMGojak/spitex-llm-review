# Code Samples — Round 001

Focused source excerpts that ground the LLM's code-level claims. Topic for round 001 is **component reusability + consistency**, so we include:

1. The 3 active filter components (the duplication)
2. The avatar standard doc (spec without implementation)
3. The Grok design system summary
4. Component index from iter 271 ADR

We do NOT include the full codebase. The LLM doesn't need to know every line — it needs anchors to validate or refute its observations.

## Files included (target ~25-40 KB total)

| File | Purpose | Source location |
|---|---|---|
| `filter_panel.ex` | Iter 268 lane-dashboard enum filter (184 LOC) | `lib/megalith_web/components/filter_panel.ex` |
| `relational_filter_modal.ex` | Iter 268 lane-dashboard relational picks (480 LOC) | `lib/megalith_web/components/relational_filter_modal.ex` |
| `grok_filter_bar.ex` | Grok design-system universal filter bar (277 LOC) | `lib/megalith_web/components/grok/filter_bar.ex` |
| `avatar_identity_standard.md` | The 148-LOC spec that has no implementation | `docs/Knowhow/design/avatar_identity_standard.md` |
| `iter_271_component_consolidation_adr.md` | Locks canonical names for iter 271 | `docs/Iterations/01_active/271_*/02_decisions/adr/02_component_consolidation.md` |
| `iter_271_reusability_audit.md` | The audit that triggered this LLM review | `docs/Iterations/01_active/271_*/01_research/reusability_audit.md` |

## How to use this folder

- Files are copied AS-IS (no abridgment unless explicitly noted)
- File names match what the brief and screenshot READMEs reference
- An LLM citing a finding should be able to say "see line X of `filter_panel.ex`" and have that line exist

## Status

| File | Status | Size |
|---|---|---|
| `filter_panel.ex` | ✅ DONE (2026-05-28 cc) | 6.3 KB |
| `relational_filter_modal.ex` | ✅ DONE (2026-05-28 cc) | 16.7 KB |
| `grok_filter_bar.ex` | ✅ DONE (2026-05-28 cc) | 9.4 KB |
| `avatar_identity_standard.md` | ✅ DONE (2026-05-28 cc) | 4.1 KB |
| `iter_271_component_consolidation_adr.md` | ✅ DONE (2026-05-28 cc) | 6.4 KB |
| `iter_271_reusability_audit.md` | ✅ DONE (2026-05-28 cc) | 12.1 KB |

**Total**: ~55 KB across 6 files.
