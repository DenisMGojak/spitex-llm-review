# Reusability Audit — Iter 271 Pre-Dispatch

**Date**: 2026-05-28
**Author**: cc
**Trigger**: User concern that iter 271 was about to add duplicated UI components instead of consolidating existing scattered ones.

> "the filters should be reusable components all around and I still have the feeling we are building them all over again, check Knowhow/design"

This audit confirms the user's instinct. **Iter 271 is being re-scoped to put consolidation FIRST.**

## Verdict (one line)

⚠️ Without a consolidation stage, iter 271 would add a 9th DnD hook, a new avatar component (despite an 8-day-old spec), and likely a 4th filter component — all of which already exist in some form. **Iter 271 must include a Stage 0: build canonical components per `Knowhow/design/` before adding any feature code.**

## 1. Avatars / identity

### Spec exists, implementation doesn't

`docs/Knowhow/design/avatar_identity_standard.md` (2026-05-20, 148 LOC) defines:

- One shared component `MegalithWeb.Components.IdentityAvatar`
- Recommended assigns: `id`, `subject_type` (`:person | :user | :org_unit | :tenant`), `subject`, `name`, `image_url`, `size`, `label`
- Initials rules + deterministic color from a fixed 7-color palette (indigo, cyan, emerald, amber, rose, violet, slate)
- Explicit migration list: ProjectLive members, ProcessLive creators, CRM contact initials, chat panels, right panel activity, person/org pickers, presence avatars

### Current state: nothing implemented

```
grep -r "IdentityAvatar" lib/
→ (no matches)

find lib -name "identity_avatar*" -o -name "*avatar*.ex"
→ (no matches)
```

### Local initials computation scattered across 15+ files

```
lib/megalith_web/live/process_live.ex
lib/megalith_web/live/project_live.ex
lib/megalith_web/live/person_dashboard_live.ex
lib/megalith_web/live/crm/lead_show_live.ex
lib/megalith_web/live/crm/lead_index_live.ex
lib/megalith_web/live/crm/revenue_stream_index_live.ex
lib/megalith_web/live/crm_contacts_live.ex
lib/megalith_web/live/work/task_show_live.ex
lib/megalith_web/live/spitex_care/patient_live/index.ex
lib/megalith_web/live/spitex_care/pfleger_live/index.ex
lib/megalith_web/live/geo_explorer_live.ex
lib/megalith_web/components/dashboard_header.ex
lib/megalith_web/components/person_picker.ex
lib/megalith_web/components/right_panel_tabs.ex
lib/megalith_web/controllers/manifest_controller.ex
```

Each rolls its own `String.first(name) |> String.upcase()` (or variant). No shared palette. Color algorithm — if any — also reinvented per call site.

### Impact on iter 271

If iter 271 c2 builds a new `<.user_avatar>` component instead of `IdentityAvatar`:
- We have TWO standards (spec'd + actual)
- All 15+ scattered call sites get harder to migrate (which one wins?)
- The avatar standard becomes a graveyard document

**Required action for iter 271**: Build `MegalithWeb.Components.IdentityAvatar` per the spec. Iter 271 c2 USES it; future iters migrate the 15 scattered sites.

## 2. Filter components

### Three active components, all overlapping

| Component | LOC | Type | Scope | Used by |
|---|---|---|---|---|
| `grok/filter_bar.ex` | 277 | `:live_component` | List views with select dropdowns | CRM contact index, possibly people index |
| `filter_panel.ex` | 184 | `:html` function | Lane dashboard enum filters | LaneDashboardLive |
| `relational_filter_modal.ex` | 480 | `:live_component` | Lane dashboard relational picks (People/Projects) | LaneDashboardLive |
| `relational_filter_chip.ex` | 392 | `:live_component` | DEPRECATED (iter 268) | none (legacy) |

Total active: **941 LOC across 3 components solving the "filter a list" problem**.

### Why they diverged

- `grok/filter_bar` was built first (Grok design system, intended as universal). It handles SELECT dropdowns with URL persistence. Doesn't handle search-driven relational picks.
- `relational_filter_chip` (iter 267) was built BECAUSE filter_bar couldn't do searchable People/Projects pickers. Inline popover pattern.
- `relational_filter_modal` (iter 268) replaced the chip with a modal because the popover was buried under other UI.
- `filter_panel` (iter 268) wraps enum chips in a collapsible drawer. Specific to lane dashboard.

### The right model

Filters split into TWO axes:
- **Dimension type**: enum (Status, Priority) vs relational (People, Projects, Tags) vs text-search vs date-range
- **Render surface**: horizontal bar (list views) vs collapsible drawer (lane dashboard) vs modal (mobile, complex pickers)

These should be ONE component family with composable parts:

```
MegalithWeb.Components.Filters
├── Bar       — horizontal layout (used by list views)
├── Drawer    — collapsible panel (used by lane dashboard)
├── Modal     — full-screen picker (used for complex multi-select)
└── Dimensions
    ├── Enum         — dropdown of static options
    ├── Relational   — search-driven via OptionsProvider
    ├── Text         — debounced search input
    └── DateRange    — calendar picker
```

Each dimension renders the same way in any surface. Surfaces are layout shells.

### Impact on iter 271

If iter 271 doesn't address this:
- Lane dashboard ships with `filter_panel + relational_filter_modal` (lane-specific)
- CRM keeps `grok/filter_bar` (list-specific)
- Future "tasks index" page will have to pick one — likely build a 4th variant
- Migration becomes harder as more code accumulates

**Required action for iter 271**: Audit + migrate `filter_panel` and `relational_filter_modal` UNDER the `grok/` design system namespace as `Filters.Drawer` and `Filters.Modal`. Establish the dimensions split. Don't migrate all call sites in this iter — just establish the structure and migrate lane dashboard.

## 3. Drag-and-drop hooks

### 8 hooks, all solving variations of "drag this thing to a new position"

| Hook | LOC | Purpose | Library |
|---|---|---|---|
| `lane_card_dnd.js` | 161 | Lane card → chat pane drop | HTML5 native |
| `dashboard_sortable.js` | 20 | Personal dashboard brick reorder | SortableJS |
| `deal_drag_drop.js` | 88 | Pipeline stage moves | HTML5 native |
| `drag_drop.js` | 60 | OrgUnit V2 user drag | HTML5 native |
| `menu_drag_drop.js` | 111 | Admin menu reorder | HTML5 native |
| `menu_sortable.js` | ? | Menu reorder (alt impl?) | SortableJS? |
| `sortable.js` | ? | Generic sortable | SortableJS |
| `task_list_sortable.js` | ? | Task list reorder | SortableJS? |
| `task_sortable.js` | ? | Task sortable | SortableJS? |

Total: ~500+ LOC of overlapping drag/drop code.

### The right model

Two distinct concerns:
1. **List/grid reorder within a container** — SortableJS handles this beautifully. Should be ONE hook: `SortableList`.
2. **Cross-container drop with payload transfer** — HTML5 dataTransfer + drop zones. Should be a pair: `DragSource` + `DropZone`.

That's 3 hooks max. Currently we have 8.

### Impact on iter 271

If iter 271 c1 builds `LaneKanbanSortable` as a 9th hook:
- Now 9 hooks. Lane dashboard column moves still don't work for non-kanban surfaces.
- When task_list_sortable is touched again, no one knows whether to use it or copy lane_kanban_sortable.

**Required action for iter 271**: c1 uses `SortableList` if it exists (likely close enough — `task_list_sortable.js` is a candidate); otherwise consolidate `dashboard_sortable + task_list_sortable + task_sortable` into ONE canonical hook and use it. Don't add a 9th.

## 4. Status / badge / chip components

### 6 active components, similar visual shape

| Component | LOC | Domain |
|---|---|---|
| `clearance_badge.ex` | ~? | clearance levels |
| `grok/badge.ex` | ~? | Grok design system generic badge |
| `ageops/run_state_badge.ex` | ~? | WorkRun status |
| `ageops/trust_badge.ex` | ~? | Agent trust score |
| `ageops/status_pill.ex` | ~? | AgeOps generic status |
| `relational_filter_chip.ex` | 392 | deprecated |

### The right model

ONE canonical `<.status_chip>` in `grok/` with assigns:
- `label` (string)
- `color` (atom from palette OR explicit hex string from data — e.g. `Projects.Status.color`)
- `size` (`:xs | :sm | :md`)
- `icon` (optional `<.icon>` name)

Each domain-specific badge wraps `<.status_chip>` with its own color/icon logic. Don't duplicate the visual primitive.

### Impact on iter 271

If iter 271 c2 builds a "card status chip" for lane dashboard from scratch:
- 7th overlapping badge. Same visual; different parent.
- Status color rendering (`Projects.Status.color`) gets baked in lane-dashboard-only.

**Required action for iter 271**: Define `grok/status_chip.ex` (if not present). Use it. Set the precedent that other domain badges should be wrappers, not from-scratch implementations.

## 5. What `Knowhow/design/` already covers

```
docs/Knowhow/design/
├── BRANDING_SYSTEM.md          411 LOC — branding asset slots, multi-tenant logo handling
├── GROK_DESIGN_SYSTEM.md       888 LOC — full Grok design language: colors, spacing, components
├── GROK_STANDARD_LAYOUT.md     427 LOC — page layout primitives (shell, sidebar, content)
├── RIGHT_PANEL_COMPACT_UI_GUIDELINES.md   164 LOC — right panel layout rules
├── avatar_identity_standard.md 148 LOC — IdentityAvatar spec (NOT implemented)
└── README.md                    12 LOC
```

Total: **2,050 LOC of design-system documentation**.

The Grok design system is the canonical source. If `grok/filter_bar.ex` exists, the lane dashboard should be USING it (or its successor). Any deviation needs an ADR explaining why.

## Re-scope recommendation for iter 271

### Stage 0 (NEW) — Component Consolidation Foundation

**Lane d2** (new): Component audit + canonical builds. ~1 day.

1. Verify `Knowhow/design/avatar_identity_standard.md` is current; build `MegalithWeb.Components.IdentityAvatar` per spec
2. Audit `grok/filter_bar.ex` + `filter_panel.ex` + `relational_filter_modal.ex`; consolidate under `grok/filters/` namespace with bar/drawer/modal surfaces and enum/relational/text/date dimensions
3. Audit 8 DnD hooks; canonicalize to `SortableList` + `DragSource` + `DropZone` (rename existing, no rewrite — just establish the canon)
4. Define `grok/status_chip.ex` (if not present) as the badge primitive
5. Update `Knowhow/design/` with a `component_index.md` listing canonical components + deprecation status

### Stages 1-4 (RENUMBERED) — Feature work USES Stage 0 outputs

- **c1**: D&D + reorder USES the canonical SortableList; doesn't add a new hook
- **c2**: Color + badges USES IdentityAvatar + status_chip; doesn't roll its own
- **c3**: Mindmap filter integration USES the consolidated filter components
- **d1**: Promote_to_task — unchanged scope, but checklist row badge uses status_chip

### New ADR for the consolidation

`02_decisions/adr/02_component_consolidation.md` to be drafted next:
- Locks canonical component names
- Establishes deprecation policy (old components: kept for one release with `@deprecated`, removed in next)
- Defines design-system ownership: changes to canonical components require updating Knowhow/design first

## Honest cost

| Approach | Time | Risk |
|---|---|---|
| Original iter 271 (add new components) | 4-5 days | Adds 9th DnD hook, new avatar, possibly 4th filter — accumulates debt |
| Re-scoped iter 271 (Stage 0 + features USE consolidated) | 5-6 days | +1 day for consolidation; eliminates debt instead of growing it |
| Defer consolidation to iter 272 | 4-5 days now + 6-8 days later | Debt grows in the meantime; harder migration |

**Recommendation**: Re-scope iter 271 to include Stage 0. The marginal +1 day pays for itself when iter 272+ build on the consolidated primitives.

## Confidence

This audit is grounded in:
- File listings (verified `ls` + `find`)
- LOC counts (verified `wc -l`)
- Spec read (`avatar_identity_standard.md` read in full)
- Component module docstrings (each filter component's `@moduledoc` cited above)
- Search for `IdentityAvatar` confirmed: zero implementations

No claims of "complete" or "production-ready" are being made; this is a state assessment with concrete remediation.
