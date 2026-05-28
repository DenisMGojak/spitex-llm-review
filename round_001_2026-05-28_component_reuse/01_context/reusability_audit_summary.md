# Reusability Audit Summary — What the Team Has Already Noticed

> Condensed from `docs/Iterations/01_active/271_planned_Lane_Dashboard_Maturity_2026-05-28/01_research/reusability_audit.md`. This is the framing for what round 1 is asking the LLMs to validate, extend, or push back on.

> **Important**: don't just repeat back what's in this doc. Validate it from the screenshots and code samples. Extend it if you spot more. Push back if you think we're wrong.

## TL;DR (the team's current position)

Megalith has accumulated **component duplication** that an upcoming iteration (iter 271) wants to consolidate before adding new feature code. Specifically, four areas show overlapping implementations of the same visual idea:

1. **Avatars / initials** — 0 canonical components, 15+ local implementations, despite an 8-day-old spec
2. **Filter components** — 3 active components (941 LOC) doing variations of "filter a list"
3. **Drag-and-drop hooks** — 8 JS hooks (~500+ LOC) doing variations of "drag to reorder"
4. **Status / badge / chip components** — 6+ similar-shape components across domains

Iter 271 will consolidate these. The LLM review is asking: do you see the same patterns from the screenshots and code, or is the team overestimating the problem?

## Area 1: Avatars / Identity

### The spec (exists, 8 days old)

`docs/Knowhow/design/avatar_identity_standard.md` (148 LOC, 2026-05-20) defines:

- ONE shared component: `MegalithWeb.Components.IdentityAvatar`
- Recommended assigns: `id`, `subject_type` (`:person | :user | :org_unit | :tenant`), `subject`, `name`, `image_url`, `size` (`:xs | :sm | :md | :lg`), `label`
- Initials rules (preferred_name + last_name → first/last → email local part → `?`)
- Deterministic color from a 7-color palette (indigo, cyan, emerald, amber, rose, violet, slate)
- Explicit migration list naming 15+ scattered call sites

The full spec is in `03_code_samples/avatar_identity_standard.md`.

### Current state: zero implementations

```bash
$ grep -r "IdentityAvatar" lib/
(no matches)

$ find lib -name "identity_avatar*" -o -name "*avatar*.ex"
(no matches)
```

### Scattered initials computation

15+ LiveViews and components compute `String.first(name) |> String.upcase()` (or a variant) locally:

- `lib/megalith_web/live/project_live.ex`
- `lib/megalith_web/live/process_live.ex`
- `lib/megalith_web/live/person_dashboard_live.ex`
- `lib/megalith_web/live/crm/lead_show_live.ex`
- `lib/megalith_web/live/crm/lead_index_live.ex`
- `lib/megalith_web/live/crm/revenue_stream_index_live.ex`
- `lib/megalith_web/live/crm_contacts_live.ex`
- `lib/megalith_web/live/work/task_show_live.ex`
- `lib/megalith_web/live/spitex_care/patient_live/index.ex`
- `lib/megalith_web/live/spitex_care/pfleger_live/index.ex`
- `lib/megalith_web/live/geo_explorer_live.ex`
- `lib/megalith_web/components/dashboard_header.ex`
- `lib/megalith_web/components/person_picker.ex`
- `lib/megalith_web/components/right_panel_tabs.ex`
- ...

Each rolls its own color algorithm (if any). No shared palette.

### What you (the LLM) should look for in screenshots

- Member strips on `/projects/:id` (#06) — what do the initials look like vs CRM contact list (#07) vs Organization (#17) vs person dashboard (#09)?
- Are colors consistent? Sizes? Border radius?
- Does the same person appear with different visual identity on different pages?

## Area 2: Filter components

### Three active filter components

| Component | File | LOC | Type | Used by |
|---|---|---|---|---|
| Grok filter bar | `lib/megalith_web/components/grok/filter_bar.ex` | 277 | `live_component` | CRM contacts, projects index |
| Filter panel (drawer) | `lib/megalith_web/components/filter_panel.ex` | 184 | `html` function | Lane dashboard |
| Relational filter modal | `lib/megalith_web/components/relational_filter_modal.ex` | 480 | `live_component` | Lane dashboard |

Total: **941 LOC across 3 components** all solving "filter a list" with overlapping mechanics.

A 4th component `relational_filter_chip.ex` (392 LOC) was deprecated in iter 268 but the file is still in the repo.

### The team's proposed canonical structure

Filters split into TWO axes:

- **Dimension type**: enum (Status, Priority), relational (People, Projects, Tags), text-search, date-range
- **Render surface**: Bar (horizontal), Drawer (collapsible), Modal (full-screen)

The proposed namespace:

```
MegalithWeb.Components.Grok.Filters
├── Bar       — horizontal layout (used by list views)
├── Drawer    — collapsible panel (used by lane dashboard)
├── Modal     — full-screen picker (used for complex multi-select)
└── Dimensions
    ├── Enum         — dropdown of static options
    ├── Relational   — search-driven via OptionsProvider
    ├── Text         — debounced search input
    └── DateRange    — calendar picker
```

### What you should look for in screenshots

- Compare filter UIs in #1 (lane dashboard drawer), #4 (lane dashboard modal), #5 (project index Grok bar), #7 (CRM contact Grok bar)
- Do they feel like ONE family or THREE separate solutions?
- Do they share visual language (chip shape, color, search input style, multi-select indicators)?
- All 3 filter source files are in `03_code_samples/` for code-level claims.

## Area 3: Drag-and-drop JS hooks

### 8 hooks, all in `assets/js/hooks/`

| Hook | LOC | Purpose | Library |
|---|---|---|---|
| `lane_card_dnd.js` | 161 | Lane card → chat pane drop | HTML5 native |
| `dashboard_sortable.js` | 20 | Personal dashboard brick reorder | SortableJS |
| `deal_drag_drop.js` | 88 | Pipeline stage moves | HTML5 native |
| `drag_drop.js` | 60 | OrgUnit V2 user drag | HTML5 native |
| `menu_drag_drop.js` | 111 | Admin menu reorder | HTML5 native |
| `menu_sortable.js` | ? | Menu reorder (alt impl) | SortableJS |
| `sortable.js` | ? | Generic sortable | SortableJS |
| `task_list_sortable.js` | ? | Task list reorder | SortableJS |
| `task_sortable.js` | ? | Task sortable | SortableJS |

### The team's proposed canonical structure

Two distinct concerns:

1. **List/grid reorder within a container** — SortableJS handles. ONE hook: `SortableList`.
2. **Cross-container drop with payload** — HTML5 dataTransfer + drop zones. Pair: `DragSource` + `DropZone`.

Target: 3 hooks max. Currently 8.

### What you should look for in screenshots

- Drag handles on the personal dashboard (#13) vs lane dashboard (#1) vs anywhere else with reordering — do they look the same?
- Are draggable items visually distinct from non-draggable items (cursor, handle icon, hover state)?
- Code samples for these hooks are not included in `03_code_samples/` (round 1 focuses on visible UI components, not JS). Comment based on visual evidence only.

## Area 4: Status / badge / chip components

### 6+ similar-shape components across domains

| Component | Approx LOC | Domain |
|---|---|---|
| `clearance_badge.ex` | ? | Clearance levels (security) |
| `grok/badge.ex` | ? | Grok generic badge |
| `ageops/run_state_badge.ex` | ? | WorkRun status (AgeOps) |
| `ageops/trust_badge.ex` | ? | Agent trust score (AgeOps) |
| `ageops/status_pill.ex` | ? | AgeOps generic status |
| `relational_filter_chip.ex` | 392 | Deprecated (iter 268) |

### Proposed canonical

ONE `<.status_chip>` in `grok/`:
- `label` (string)
- `color` (atom from palette OR explicit hex)
- `size` (`:xs | :sm | :md`)
- `icon` (optional)

Each domain-specific badge becomes a thin wrapper that supplies its own color/icon logic.

### What you should look for in screenshots

- Status indicators in #1, #5, #11 — same shape? Same color logic? Same border radius?
- Project status badges (#06) vs AgeOps trust badges (#11) — are they visually consistent or distinct enough that they signal "different system"?

## What this audit might be WRONG about

The team has not fully audited:

- Card/list-row components (project cards, contact rows, task cards)
- Empty / loading / error state primitives (likely scattered)
- Modal patterns (besides filter modal)
- Right-panel section headers + dividers
- Form patterns across CRM / Projects / Spitex

If you see duplication in these areas, raise it.

## Cost of NOT consolidating

```
Original iter 271 (add new components without consolidation):  4-5 days now
Re-scoped iter 271 (consolidation first):                      5-6 days now
Deferred consolidation (iter 271 + future iter to clean up):   4-5 + 6-8 days later
```

The team has committed to consolidation FIRST (iter 271 Stage 0). Your review will sharpen what gets consolidated and how.
