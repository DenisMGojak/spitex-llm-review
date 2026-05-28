# Round 001 Synthesis — Component Reuse

**Status**: 🔒 LOCKED v2 (2026-05-29). 3 responses captured + 2 follow-ups. Re-open as v3 only when materially new evidence arrives (additional responses, ground-truth contrast measurements, or implementation findings).
**Last updated**: 2026-05-29 (v2 — locked)
**Author**: cc (coordinator)
**Inputs**: `04_responses/01_response_pending_provider.md` (+ follow-up A–D), `04_responses/02_response_pending_provider.md` (+ follow-up A–D), `04_responses/03_response_pending_provider.md`, `04_responses/README.md` (cross-LLM convergence table + retracted findings).

## Purpose

Aggregate the verbatim LLM responses into actionable backlog rows for **Iter 271 Stage 0 (Component Consolidation)**. Each finding is ranked by:

- **Vote count** — how many independent LLMs raised it (3/3, 2/3, 1/3)
- **Trust adjustment** — discount low-trust responses (response 02 admitted no folder access; response 03 used wrong filenames)
- **Effort** — small / medium / large (LLM-provided estimates, sanity-checked by cc)
- **Blocking effect** — does it unblock other work?

Citations use response file + section. Verbatim text lives in `04_responses/`; this doc only synthesizes.

## Top backlog (ship next)

### Top-pick debate: IdentityAvatar vs StatusChip (1 vote each)

After both follow-ups, the two LLMs disagreed on which component to ship first:

| Argument | Vote source |
|---|---|
| **IdentityAvatar first** — smallest spec, ready spec-doc, find-replace migration, no dynamic logic | Response 01 follow-up A |
| **StatusChip first** — higher leverage (10+ surfaces vs 7+), no dynamic color hashing, unblocks ResourceCard slot internals | Response 02 follow-up A |

**cc tie-break recommendation**: ship **StatusChip first**. Reasoning:
1. Higher surface count (verifiable: appears in every dashboard, every list, every detail page).
2. Pure presentation — no `:show_online` boolean, no avatar-color hash logic, no fallback-string handling. Lower implementation surface.
3. Unblocks downstream work: response 01's `IdentityAvatar` and `<.card_header>` both render status chips inside their slots. Shipping StatusChip first means those downstream components get a consistent inner primitive.
4. If StatusChip turns out to need a redesign mid-iteration, the blast radius is smaller (CSS-only change).

But: this is a 1-1 tie until more LLMs vote. Suggest treating BOTH as "must ship in Iter 271 Stage 0" and letting the implementer pick the order.

### #1 — StatusChip component (PROMOTED to top after follow-up debate)

**Convergent vote**: 3/3 implicit (badge consistency theme raised by all three LLMs) + 2/2 explicit specs in follow-ups (responses 01 + 02).

**Why ship first** (tie-break above):
- 10+ surfaces (response 01 follow-up A: kanban, list, project card, CRM, dashboards, agents, org cards, workspace).
- Pure presentation; no policy/data implications.
- Unlocks downstream affordance fixes (responses 01 Q4 + 03 Q4: passive badges look like buttons).

**Spec debate** (TWO valid schemas proposed):

| LLM | Schema axis | Pro | Con |
|---|---|---|---|
| Response 01 follow-up B | `:status` (semantic atom: `:active, :prospect, :inactive, :done, :in_progress, :coming_soon`) + `:variant` (filled/outline) | Semantic-by-default — call site says what it means, color follows | Hardcoded value list won't match Megalith's domain-specific status enums (Work.Task vs CRM.Contact vs Project) |
| Response 02 follow-up B | `:variant` (solid/subtle/outline) × `:color` (neutral/brand/success/warning/error/info) | Decoupled & flexible — matches modern design-system conventions (Chakra/Mantine) | Call site must know which color maps to which status; risk of drift over time |

**cc recommendation**: **Adopt response 02's decoupled schema** with one addition. Rationale:
- Megalith has multiple Ash enums for "status" (Work.Task, CRM.Contact, Project, Lead, etc.) — they don't share atoms. A semantic enum approach forces hardcoding all of them in the component.
- The decoupled approach lets each domain define its own `defp status_to_color/1` mapping in the call-site module, while the component stays generic.
- Add a third axis: `:size` (`:sm | :md`, default `:sm`) — both LLMs' specs implicitly assume this but neither makes it explicit.

**Final synthesized spec** (cc, normalized to project conventions):

```elixir
# lib/megalith_web/components/status_chip.ex
attr :variant, :atom, values: [:solid, :subtle, :outline], default: :subtle
attr :color, :atom, values: [:neutral, :brand, :success, :warning, :error, :info], default: :neutral
attr :size, :atom, values: [:sm, :md], default: :sm
attr :class, :string, default: ""
slot :inner_block, required: true
```

**Effort**: small. Both LLMs agree.

**Owner candidate**: d-lane in Iter 271 Stage 0.

### #2 — IdentityAvatar component

**Convergent vote**: 2/3 explicit + 1 implicit. Response 01 follow-up A ranks this as the highest-leverage component if shipping only ONE.

**Why ship second**:
- 7+ surfaces across CRM, projects, dashboards, agents, organization (response 01 follow-up A).
- Reusability audit (`Iter 271 01_research/reusability_audit.md`) found 15+ files compute avatar colors locally.
- Complete ready-made spec at `03_code_samples/avatar_identity_standard.md`.
- No blocking dependencies; pure presentation primitive.

**Spec** (from response 01 follow-up B, normalized to project conventions):

```elixir
# lib/megalith_web/components/identity_avatar.ex
attr :entity, :any, required: true,
  doc: "Person, contact, org_unit, agent, or map containing id/email/slug for deterministic color"
attr :size, :atom, values: [:xs, :sm, :md, :lg], default: :md
attr :show_online, :boolean, default: false
attr :class, :string, default: ""
```

Convention: snake_case function component (`<.identity_avatar>`), not PascalCase.

**Migration targets** (audit before implementation):
- `lib/megalith_web/components/identity_avatar.ex` (existing — likely needs unification)
- `lib/megalith_web/components/org_unit_avatar.ex`
- Ad-hoc avatar HEEx in: `person_dashboard_live.ex`, `org_unit_dashboard_live.ex`, CRM contact index, agent index, lane card components.

**Effort**: small (LLM estimate), confirmed small by cc.

**Owner candidate**: d-lane in Iter 271 Stage 0, in parallel with StatusChip if capacity allows; otherwise after.

### #3 — Empty-state component

**Convergent vote**: 3/3 (responses 01 Q5, 02 Q5 `<.empty_state>`, 03 Q5 `<.empty_state>`).

**Why ship third**:
- 3/3 LLM consensus on missing pattern.
- Surfaces: project detail (no checklists / no activity), kanban empty columns (response 03 Q5), lead empty results (response 03 Q5), dashboard widget grids.
- Currently rendered as plain gray text — looks broken / unstyled.

**Spec** (synthesized from all three responses):

```elixir
# lib/megalith_web/components/empty_state.ex
attr :icon, :string, default: "hero-inbox"
attr :title, :string, required: true
attr :description, :string, default: nil
attr :action_label, :string, default: nil
attr :action_href, :string, default: nil
attr :action_phx_click, :string, default: nil
attr :class, :string, default: ""
```

**Effort**: small. All three LLMs agree.

## Medium-priority backlog (ship after Stage 0)

### #4 — GrokFilterBar consolidation

**Convergent vote**: 3/3 (responses 01 Q1 GrokFilterBar, 02 Q1 `<.filter_bar>`, 03 Q1 `<.filter_panel>`).

**Why defer**:
- Stateful component (filters need to round-trip through LiveView assigns).
- Already partially in scope for Iter 271 Stage 0 (3 existing impls: `grok_filter_bar.ex`, `filter_panel.ex`, `relational_filter_modal.ex`).
- Owner is already specced in `Iter 271 02_decisions/adr/02_component_consolidation.md`.

**Action**: cross-link this synthesis row to the existing Iter 271 ADR; do not duplicate the spec here.

### #5 — Card header pattern (`<.card_header>`)

**Convergent vote**: 2/3 (responses 02 Q2, 03 Q2).

**Why defer**:
- Lower leverage than IdentityAvatar / StatusChip.
- Not a primitive — composes title + badge + actions; harder to unify cleanly.
- Useful but no urgency; depends on StatusChip + IdentityAvatar already shipping.

**Effort**: medium.

### #6 — ResourceCard / DomainCard

**Convergent vote**: 2/3 (responses 01 Q2 ResourceCard, 03 Q2 `<.domain_card>`).

**Why defer**:
- Multiple variants (icon-grid vs simple card) — needs UX decision before implementation.
- 5 surfaces (response 01 follow-up A) but several are similar enough to live as variants of one component.

**Effort**: medium.

## Low-priority / single-source findings

These were raised by only 1 LLM and may be valid but deserve more evidence before action:

| Finding | Source | Effort | cc note |
|---|---|---|---|
| `<.metric_badge>` for count indicators | 03 Q1 | small | NEW idea; not raised by 01/02. Pilot in #1 dashboard widget, then expand. |
| `<.table_row_actions>` standardization | 03 Q2 | medium | Real pattern but tables are scattered. Defer until table audit. |
| Tab bar visual hierarchy | 03 Q4 | small | Genuine; affects #18 project workspace. Bundle with future tab refactor. |
| Spacing scale violations (`space-y-4` vs `space-y-6`) | 02 Q3 | medium | LLM lacked folder access (low trust). Re-raise via grep audit before action. |
| Form group spacing tokens | 02 Q3 | medium | Same low-trust caveat. |
| Skeleton/loading states | 01 Q5 + 02 Q5 | medium | 2/3 vote — bumping up. **Promote to medium priority.** |
| Affordance: passive badges look like buttons | 01 Q4 + 03 Q4 | small | 2/3 vote — bumping up. **Promote**, but requires StatusChip first to add `:subtle` variant. |
| Affordance: inline `+ Add` looks like text | 01 Q4 + 03 Q4 | small | 2/3 vote — bumping up. **Promote** as part of button-style cleanup. |
| Top nav, mindmap canvas, view switcher (DO NOT change) | 01 + 02 + 03 (3/3 "what NOT to change") | — | Keep as-is. Useful negative constraints. |

## Spec hallucinations to avoid

When implementing components from this synthesis, do **NOT** copy LLM spec code verbatim. Several specs contained framework-foreign syntax. Use the spec **shapes** (attrs, slots, prop names) but write the implementation against project conventions:

| LLM spec | Hallucination | Correct project convention |
|---|---|---|
| Response 02 follow-up B `ResourceCard` HEEx | `<div v-if={@metadata}>` | `<div :if={@metadata != []}>` (Vue.js `v-if` is NOT HEEx) |
| Response 02 follow-up B `ResourceCard` HEEx | `phx-click-stop` attribute | NOT a real LiveView attribute. Use `Phoenix.LiveView.JS.dispatch/2` or stop-propagation in JS hook |
| Response 02 follow-up B `ResourceCard` HEEx | `<i class="hero-trash text-base" />` | `<.icon name="hero-trash" class="w-5 h-5" />` (per AGENTS.md: ALWAYS use `<.icon>`, NEVER raw `<i>` for hero icons) |

Also:
- Response 01 follow-up B's StatusChip `:status` enum hardcoded `[:active, :prospect, ...]` — Megalith status atoms vary by domain. Synthesis chose response 02's decoupled schema (`:variant` × `:color`) precisely to avoid this.

## Retracted / dropped findings

See `04_responses/README.md` § "Retracted findings" for the canonical list. Do not carry into Iter 271 backlog:

1. ❌ amber-100 / amber-800 = 4.1:1 contrast (response 01 Q3) — RETRACTED in follow-up.
2. ❌ Right-panel `14_right_panel_compact.png` slate-200 / 16px padding (response 01 Q3) — RETRACTED in follow-up; the screenshot is `/reglemente` (documented substitution).
3. ❌ Error boundary / unhandled crash on `/demo/org-unit/` (response 03 Q5) — already patched in commit `65244d39`. Screenshot is stale; re-capture pending.

## Cross-LLM signals worth preserving

These are not actionable items but inform process improvements for future rounds:

- **Filename hygiene matters**: response 03 used its own filenames (`05_crm_table.png` for our `07_crm_contact_index.png`). Future rounds: include a filename manifest at the top of `00_brief.md` so LLMs anchor on canonical paths.
- **LLMs that admit they cannot fetch URLs** (response 02): the inline pack (`00_brief_inline.md`) was built specifically for this. Surface it more prominently in `00_brief.md`.
- **Self-retraction is a quality signal**: response 01's follow-up withdrew 2 findings cleanly. Future follow-up prompts should explicitly invite self-correction (current `cc_followup_prompt.md` § C does this — keep).
- **Pre-fix screenshots cause confusion**: response 03's "error boundary" finding came from a stale PNG. Re-capture #09 + #10 BEFORE next round dispatch.
- **Specific contrast ratios from LLMs are unreliable** (new in v2): on the same amber-100/800 question, response 01 follow-up said ~12:1+, response 02 follow-up said 4.92:1, cc-computed truth was ~6.1:1. Three different numbers, three different conclusions. **Trust directional claims (above/below AA threshold), not specific ratios**. For exact ratios, run `mix llm_review.contrast_check` (TODO: build this helper) or paste the hex pair into a deterministic tool.
- **Spec code from LLMs needs translation** (new in v2): response 02 follow-up's ResourceCard HEEx mixed Vue.js syntax with invented Phoenix attributes and wrong icon conventions. Future synthesis should NEVER copy LLM HEEx blocks verbatim. Take the prop shapes, write implementation from scratch.
- **LLMs claim "I don't have access" then proceed to invent** (new in v2): response 02 follow-up Section D explicitly said #14 wasn't supplied, then described its (fabricated) layout. Always treat "I can't see X but here's what X looks like" as full hallucination.

## Next steps

- [ ] Re-capture #09 (`person_dashboard`) + #10 (`org_unit_dashboard`) post-`65244d39` so future rounds don't repeat response 03's stale-data finding.
- [ ] User to fill in `provider:` / `model:` for responses 01/02/03 (so we can re-target follow-up prompts to the same chats).
- [ ] Dispatch round 1 to remaining LLMs (Anthropic Claude, OpenAI GPT, Google Gemini, xAI Grok — whichever are not yet in the captured set).
- [ ] Open Iter 271 Stage 0 backlog rows for: IdentityAvatar, StatusChip, EmptyState (priorities 1–3 above). Cross-link this synthesis as the source.
- [ ] After 5–6 responses captured, re-rank by vote count and update this doc to v2.

## Provenance

Each finding above cites the response file + question section in `04_responses/`. To verify any claim:

1. Open the cited response file.
2. Read the verbatim LLM output.
3. Cross-reference with `04_responses/README.md` for trust adjustments.
4. Cross-reference with `04_responses/README.md` § "Retracted findings" for invalidations.

If a finding in this synthesis cannot be traced back to a response file section, it is a synthesis error — please flag it.
