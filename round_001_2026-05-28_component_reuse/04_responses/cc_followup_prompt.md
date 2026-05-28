# cc-authored Follow-up Prompt — Round 001

Use this AFTER an LLM has answered the main `00_brief.md` and you have their verbatim Q1-Q5 response captured. Send this as a follow-up turn in the SAME chat (so the LLM has its earlier output in context).

The follow-up has 4 sections (A/B/C/D):
- A. Prioritize the proposed components by leverage / risk / blocking
- B. Spec the top-2 components precisely (Phoenix.Component attrs)
- C. Verify quantitative claims with confidence tags
- D. Confirm/correct one stale screenshot reference (#14 is now `/reglemente`)

When pasted as a follow-up, prepend the LLM's response into a `### LLM (turn 2):` section in the corresponding `01_response_<provider>.md` file (per the `04_responses/README.md` capture protocol).

---

## Prompt to paste

```
Two follow-ups to make your round-1 response actionable for our iter 271 component consolidation work:

## A. Prioritize your 4 proposed components

Rank `IdentityAvatar`, `StatusChip`, `ResourceCard`, and `GrokFilterBar` along three axes:

1. **Leverage** — how many of the 18 captured surfaces would consolidate onto this component (cite screenshot numbers).
2. **Implementation risk** — what's most likely to go wrong during migration. High/medium/low + one-line reason.
3. **Blocking effect** — does any of the other 3 components depend on this one being shipped first?

If we could only ship ONE in the next 2 working days, which and why?

## B. Spec the top-2 components precisely

For your top-2 picks from (A), output:

1. A `Phoenix.Component` function declaration with `attr/3` definitions:
   - name, type (`:string` / `:atom` / `:integer` / `:boolean` / `:any` / `:list`)
   - `default:` if applicable
   - one-line `doc:`
   - `:required` flag where relevant
2. One realistic usage example per consolidating surface (cite the screenshot number you're consolidating from).
3. What existing code becomes deletable (cite only file paths from `03_code_samples/` — don't speculate about files you can't see).

## C. Verify your quantitative claims

For each numeric claim in your round-1 response (contrast ratios, padding values, spacing values, border widths), tag it with confidence:
- **high** — verified against a specific source (cite which screenshot region or which line of `design_system_summary.md`)
- **medium** — visual estimate, plausible but un-measured
- **low** — speculative; would need a designer to verify

Specifically: re-check the "amber-100 / amber-800 = 4.1:1" claim. Tailwind's amber-100 + amber-800 typically clears AA by a wide margin.

## D. Confirm or correct one thing

Screenshot #14 (`14_right_panel_compact.png`) is now `/reglemente` (a regulations document page), not the compact-right-panel surface — the slug was preserved across a path change. Re-examine that screenshot and either correct your finding about right-panel borders or tell me what you actually see.

Output as 4 numbered sections (A/B/C/D). Be concrete; cite screenshot numbers and file paths from the round materials.
```

---

## Why these 4 sections

- **A drives prioritization** — without ranking, the team can't pick the highest-ROI item for iter 271 Stage 1 (1 week of feature work).
- **B forces concretion** — moves from "we should have a component" to "here's the function signature; here's the migration path".
- **C calibrates the LLM's reliability** — flags hallucinated quant claims so we don't compound errors during synthesis.
- **D is a targeted fact-check** — the round-1 response cited #14 as a right panel based on the slug; the actual screenshot is a regulations doc. This is also a nice meta-test: does the LLM correct itself when shown the gap, or double down?

## When to send

Two strategies:

**Strategy 1 — Per-LLM follow-up (deeper but slower)**: send this to each LLM AFTER their initial response, capture both turns into `01_response_<provider>.md`. Synthesis (`05_synthesis.md`) compares both A/B/C/D sections across providers.

**Strategy 2 — Cross-LLM synthesis follow-up (faster)**: skip the per-LLM follow-up, dispatch the main brief to all 4 LLMs first, then synthesize what's overlapping vs unique. Use this prompt only on the LLM whose round-1 response was strongest.

I recommend Strategy 1 for round 001 since it's our first round and we're calibrating each LLM's signal-to-noise. Round 2+ can switch to Strategy 2 once we trust the providers.
