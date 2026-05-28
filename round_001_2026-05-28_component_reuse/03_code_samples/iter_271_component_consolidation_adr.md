# ADR-02 — Component Consolidation Policy

**Date**: 2026-05-28
**Status**: APPROVED (user confirmed 2026-05-28: Stage 0 wide)
**Context**: Iter 271 reusability audit found 15+ scattered initials computations, 3 overlapping filter components (941 LOC), 8 DnD hooks, and 6 badge components — all while `Knowhow/design/` documents canonical patterns that aren't implemented.

## Decisions

### D1: Canonical component names locked

| Canonical | Replaces / supersedes | Module |
|---|---|---|
| `IdentityAvatar` | Local `String.first` initials in 15+ files | `MegalithWeb.Components.IdentityAvatar` |
| `Grok.Filters.Bar` | (current `Grok.FilterBar`, possibly extended) | `MegalithWeb.Components.Grok.Filters.Bar` |
| `Grok.Filters.Drawer` | `MegalithWeb.Components.FilterPanel` (iter 268) | `MegalithWeb.Components.Grok.Filters.Drawer` |
| `Grok.Filters.Modal` | `MegalithWeb.Components.RelationalFilterModal` (iter 268) | `MegalithWeb.Components.Grok.Filters.Modal` |
| `Grok.Filters.Dimension.{Enum,Relational,Text,DateRange}` | inline enum/relational picks scattered across iter 267/268 | `MegalithWeb.Components.Grok.Filters.Dimension.*` |
| `Grok.StatusChip` | Ad-hoc status pills (probably extends `grok/badge.ex`) | `MegalithWeb.Components.Grok.StatusChip` |
| `SortableList` (JS hook) | `dashboard_sortable + task_list_sortable + task_sortable` | `assets/js/hooks/sortable_list.js` |
| `DragSource` + `DropZone` (JS hooks) | `lane_card_dnd`, `deal_drag_drop`, `drag_drop`, `menu_drag_drop` payload transfer halves | `assets/js/hooks/drag_source.js`, `drop_zone.js` |

### D2: Deprecation policy

- Old components: **renamed in-place to new canonical name OR aliased** during Stage 0. NOT deleted.
- Add `@deprecated` to the OLD module with redirect text: `Use Megalith.Web.Components.Grok.Filters.Drawer instead. Removed in iter 273.`
- Removal happens 1 iteration later (iter 273 = "design system cleanup") after confirming zero non-test usages.
- This pattern is identical to the iter 267 → 268 `RelationalFilterChip` deprecation.

### D3: Design-system change protocol

After iter 271 ships:

1. Any new component proposed under `Megalith.Web.Components.Grok.*` MUST first update `Knowhow/design/component_index.md`
2. Any deviation from `Knowhow/design/*.md` requires an ADR explaining why
3. Local initials/avatar/badge computation in new code is **forbidden** — must use canonical components
4. Reviewers (cc) reject PRs that violate D3 with the message "see ADR-02"

### D4: Stage 0 scope (wide, per user decision 2026-05-28)

Inside Stage 0, the d2 lane delivers:

**0a — IdentityAvatar** (~2-3h)
- Implement per `Knowhow/design/avatar_identity_standard.md` (no scope creep)
- 7-color deterministic palette from spec
- Initials rules from spec (person/org_unit/tenant)
- Tests: 6-10 component tests (initials, color determinism, size variants, fallbacks)

**0b — Grok.StatusChip** (~1-2h)
- Wraps or replaces `grok/badge.ex`
- Assigns: `label`, `color` (atom from palette OR explicit hex), `size`, `icon` (optional)
- Tests: 4-6 tests covering color modes + sizes + icon

**0c — Filter consolidation** (~4-6h)
- Create `lib/megalith_web/components/grok/filters/` namespace
- `Grok.Filters.Bar` = current `Grok.FilterBar` moved + (possibly) extended to accept relational dimensions
- `Grok.Filters.Drawer` = `FilterPanel` moved
- `Grok.Filters.Modal` = `RelationalFilterModal` moved
- `Grok.Filters.Dimension.Enum/Relational/Text/DateRange` = extracted dimension renderers (function components)
- Add `@deprecated` to old modules; alias them to new ones for one-iter backcompat
- Tests: existing tests still pass under new namespace

**0d — DnD canonicalization** (~2-3h)
- Audit 8 hooks; pick the strongest implementation per category
- Create `sortable_list.js` (consolidate `dashboard_sortable.js` style)
- Create `drag_source.js` + `drop_zone.js` (extract pattern from `lane_card_dnd.js`)
- Mark old hooks as deprecated via JSDoc; KEEP them functional for one iter
- Register new hooks in `assets/js/app.js`

**0e — 5 high-value avatar migrations** (~3-4h)
- ProjectLive: project members strip → `IdentityAvatar`
- CRM contact index: contact row initials → `IdentityAvatar`
- `person_picker.ex`: picker option avatars → `IdentityAvatar`
- `right_panel_tabs.ex`: activity feed avatars → `IdentityAvatar`
- LaneDashboardLive: assignee renders → `IdentityAvatar` (note: assignee_stack is c2's responsibility; d2 just makes single-assignee rendering use IdentityAvatar)
- For each: 1-2 lines per file changed; one screenshot diff in d2_status.md

**0f — Documentation** (~1h)
- Create `Knowhow/design/component_index.md` listing canonical components + deprecation status
- Update `Knowhow/design/avatar_identity_standard.md` § "Existing Duplication To Migrate" to mark which sites are done

Total d2 effort: ~13-19h ≈ 1.5-2 days. Single lane (one agent). cc audits at completion.

### D5: Stage 1 cannot start until Stage 0 lands

- cc dispatches d2 NOW
- cc does NOT draft c1/c2/c3/d1 prompts until d2 reports complete + cc audits
- Rationale: Stage 1 lanes need to reference canonical component names. If those names change during Stage 0, prompts go stale.

### D6: Cross-iteration coordination

Iter 269 P3 is in flight, touching `lane_dashboard_live.ex` reads. Iter 271 d2 also touches `lane_dashboard_live.ex` (avatar migration). Conflicts handled via `handoffs.md` (per AGENTS.md shared-file convention):

```elixir
# ── iter 269 P3 reader switch ──────────────────
# (Projects.Task → Work.Task read paths)

# ── iter 271 d2 avatar migration (5 call sites) ──
# (single-assignee render now uses <.identity_avatar ...>)
```

cc reconciles at merge time.

## Reversal cost

If a canonical name needs to change after Stage 0:
- ~30 min per name (search-and-replace + update ADR-02)
- Acceptable. Locking names now is worth the small reversal cost.

If Stage 0 itself proves over-scoped:
- Sub-stages 0a, 0b are independent and can ship without 0c/0d/0e
- Worst case: ship 0a + 0b only, defer 0c/0d/0e to iter 273
- d2 status doc must report per-sub-stage completion so cc can make this call

## Approval

- [x] User reviewed reusability audit (2026-05-28)
- [x] User approved Stage 0 wide (2026-05-28)
- [ ] cc dispatches d2 prompt
- [ ] d2 returns Stage 0 complete
- [ ] cc audits + drafts Stage 1 prompts
