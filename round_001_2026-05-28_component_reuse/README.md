# Round 001 — Component Reusability + Consistency Review

**Date**: 2026-05-28
**Topic**: Component reuse, design-system consistency, reusability gaps
**Goal**: get 3 external LLM perspectives on Megalith's UI that inform iter 271 Stage 1 (component consolidation feature work)
**Lead**: cc
**Status**: STRUCTURE READY → awaiting screenshots from `c1_263a` lane

## What this round asks

The brief (`00_brief.md`) asks 3 LLMs (Claude Sonnet 4.7, GPT-5, Gemini 2 Pro) to assess:

1. **Component consistency** — UI elements that look similar but feel slightly off (different implementations of the same idea)
2. **Reusability gaps** — visual patterns that repeat and should clearly be one component
3. **Visual quality** — concrete issues (spacing, typography, color, hierarchy)
4. **Affordance clarity** — interactions that aren't obvious
5. **Missing patterns** — empty/loading/error states absent or inconsistent

Explicitly **NOT** asked:
- Generic "add more polish" / "modernize" feedback
- New feature suggestions
- Anything that doesn't tie to a specific screenshot or code file

## What gets uploaded

The full `round_001_2026-05-28_component_reuse/` folder (zipped or per-file, depending on LLM). Contents:

| Path | What | Size estimate |
|---|---|---|
| `00_brief.md` | THE prompt the LLM reads first | ~3-5 KB |
| `01_context/app_overview.md` | What Megalith is | ~3-5 KB |
| `01_context/design_system_summary.md` | Knowhow/design distilled | ~5-8 KB |
| `01_context/reusability_audit_summary.md` | Iter 271 audit findings (the framing) | ~5-8 KB |
| `02_screenshots/*.png` | 18 desktop screenshots | ~50-70 MB total |
| `02_screenshots/README.md` | Per-screenshot context | ~3-5 KB |
| `03_code_samples/*.ex` | 4-6 source files (filter components, avatar standard) | ~25-40 KB |
| `03_code_samples/README.md` | Why each file is included | ~2 KB |

Estimated total ZIP size: ~60-80 MB. Within Claude/GPT/Gemini web upload limits (Claude: 200MB project; GPT: 25MB per file but multi-file OK; Gemini: 100MB).

## Outputs (filled during round)

- `04_responses/claude_sonnet_4.7.md` — raw response, verbatim, YAML frontmatter
- `04_responses/gpt_5.md` — same
- `04_responses/gemini_2_pro.md` — same
- `05_synthesis.md` — cc's aggregated findings + backlog rows feeding iter 271 c-lanes

## Sequencing (so this lands fast)

```
NOW: cc writes 00_brief.md + 01_context/* + 03_code_samples/* in parallel
NOW: c1_263a lane builds Wallaby script + captures 15 screenshots → 02_screenshots/
↓
~24h: All inputs ready
↓
cc opens 3 LLM chats; uploads ZIP; pastes brief
↓
~2-4h: LLM responses captured to 04_responses/
↓
cc writes 05_synthesis.md
↓
cc updates iter 271 c-lane prompts with synthesis findings (Phase A deliverable for iter 271)
```

## What "done" means for this round

- [x] 00_brief.md finalized
- [x] 01_context/ docs (3 files) written
- [x] 03_code_samples/ files copied + README explains each
- [ ] 02_screenshots/ — 18 PNGs delivered by c1_263a (IN FLIGHT)
- [ ] 02_screenshots/README.md — caption per screenshot updated post-capture
- [ ] 3 LLM responses captured in 04_responses/ with full provenance frontmatter
- [ ] 05_synthesis.md written
- [ ] Convergent findings table populated (LLMs agreed on X)
- [ ] Backlog rows added to `04_execution/04_backlog/ui_improvements_prioritized.md`
- [ ] Iter 271 c-lane prompts updated with relevant findings

## Current state (2026-05-28 15:55)

✅ **Round folder is READY for ZIP upload, MINUS screenshots.**

When c1_263a returns the 18 PNGs into `02_screenshots/`:
1. cc spot-checks 3 random PNGs
2. cc ZIPs the entire `round_001_2026-05-28_component_reuse/` folder
3. cc opens 3 LLM chats
4. cc uploads ZIP + pastes `00_brief.md` to each
5. cc captures responses verbatim into `04_responses/<provider>_<model>.md`
6. cc writes `05_synthesis.md`

The whole round can be uploaded to an LLM by zipping THIS DIRECTORY.
