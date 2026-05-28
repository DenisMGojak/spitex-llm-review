# round 001 2026-05-28 component reuse — Inline Pack

> **For LLMs that cannot fetch external URLs.** This single document inlines
> the brief + all context docs + all code samples that the round references.
> The screenshots cannot be inlined (binary PNGs) — they are attached
> separately or available as URLs at:
> `https://denismgojak.github.io/spitex-llm-review/round_001_2026-05-28_component_reuse/02_screenshots/NN_<slug>.png`
>
> If you CAN fetch URLs, the canonical entry point is:
> `https://denismgojak.github.io/spitex-llm-review/round_001_2026-05-28_component_reuse/00_brief.md`
> — fetch that, then crawl every relative path it references.
>
> If you cannot fetch, just answer the questions in the BRIEF section below
> using the inlined CONTEXT and CODE SAMPLES, and the attached PNG screenshots.

---

# 1. BRIEF (the prompt — answer these questions)

# LLM Review Brief — Round 001 — Component Reusability + Consistency

> **You are a senior UI/UX engineer reviewing a real Phoenix LiveView application.**
> Read this brief first. Then read `01_context/` to ground your understanding. Then study `02_screenshots/` and `03_code_samples/`. Then answer the 5 questions below.
> Your output will be compared with 2 other LLMs' responses and synthesized into actionable backlog items. Be specific, cite evidence, and write for human engineers who will act on your feedback.

## 1. What this app is (one paragraph)

Megalith is a Phoenix 1.8 + Ash Framework 3.0 multi-tenant healthcare/business platform (Swiss origin) for Spitex/Bemeda. It serves ~80 LiveView surfaces across domains: project management (`/projects`), task lanes (`/work/lanes`), CRM (`/crm/*`), organization structure (`/admin/org-units`), AgeOps agent orchestration (`/ageops/*`), healthcare-specific workflows (`/spitex_care/*`, `/spitex_kore/*`), and shared dashboards. Tailwind v4 + LiveView, no separate SPA. The team has a documented design system (see `01_context/design_system_summary.md`), but adoption is uneven — that's the question this round explores.

## 2. What this round asks (specific, in priority order)

Answer each question with **specific evidence**: screenshot file or code file, plus your observation. Avoid generic recommendations.

### Q1 — Component consistency
Where do screenshots show UI elements that look similar but feel slightly off — most likely because they're separate implementations of the same idea? Examples we suspect: filter chips/bars/modals, status badges, avatars/initials, card headers, dropdown menus. Cite the screenshots side by side.

### Q2 — Reusability gaps
What visual patterns repeat across multiple screenshots that should clearly be ONE shared component? For each pattern, list the screenshots it appears in and propose a single component name + 3-4 main props.

### Q3 — Visual quality (concrete only)
Concrete issues with spacing, typography, color contrast, visual hierarchy, alignment. Skip "modernize the UI" or "add gradients" type feedback. We want things like "the status chip on screenshot 1 uses #6B7280 text on #F3F4F6 which is 3.9:1 — below WCAG AA threshold."

### Q4 — Affordance clarity
Interactions that aren't obvious from the screenshot alone. Examples: a button that looks like text, a hover state that isn't visible, a primary action that's the same color as secondary actions, a disabled state that looks active. For each, propose the smallest fix.

### Q5 — Missing patterns (empty / loading / error / "no data" states)
Screenshots that should show empty/loading/error states but don't have an obvious treatment. Patterns we should standardize: empty state for "no tasks in this column", loading state when filters apply, error state when an action fails. Propose a treatment based on what you see.

## 3. What NOT to do

- ❌ Don't suggest unrelated features ("you should add Kanban swimlanes")
- ❌ Don't suggest tech stack changes ("rewrite in React")
- ❌ Don't say generic things ("improve the polish", "modernize the typography")
- ❌ Don't grade the design overall ("this UI is 6/10")
- ❌ Don't worry about i18n / localization (the screenshots may mix German + English in the dev tenant — that's the dev data, not the design)
- ❌ Don't comment on data correctness (the dev tenant has synthetic data; assume all names/emails/projects are fake)

## 4. Output format (please follow precisely)

Structure your response with 5 H1 sections (one per question). Inside each, use bulleted findings:

```markdown
# Q1 — Component consistency

- **Finding**: <short label>
  - **Evidence**: screenshots `02_screenshots/01_lane_dashboard_kanban.png` (filter modal) + `02_screenshots/05_project_index.png` (filter bar)
  - **Observation**: <2-4 sentences>
  - **Proposal**: <1-3 sentences>
  - **Effort estimate**: small / medium / large

- **Finding**: <next>
  ...

# Q2 — Reusability gaps
...

# Q3 — Visual quality
...

# Q4 — Affordance clarity
...

# Q5 — Missing patterns
...
```

Minimum 2 findings per question (10 total). No upper bound — be thorough where you see issues.

At the end, add a brief **"What I would NOT change"** section listing 3-5 things you think are working well. This calibrates your judgment for synthesis.

## 5. Context pointers (READ THESE)

Before answering Q1-Q5, read:

- `01_context/app_overview.md` — what Megalith is and which domains the screenshots cover (~1 page)
- `01_context/design_system_summary.md` — the team's documented design system, palette, spacing tokens (~1 page)
- `01_context/reusability_audit_summary.md` — what the team has already noticed internally (~1 page). **Important**: don't just repeat back what's in this audit. Validate it, extend it, or push back on it.

Then for each screenshot in `02_screenshots/`, read `02_screenshots/README.md` to see the route, description, and what UI patterns to look at.

For code-level claims, the file you need is in `03_code_samples/` and described in `03_code_samples/README.md`.

## 6. Tone

Direct, technical, evidence-driven. Imagine you're reviewing a colleague's PR — useful disagreement is welcome; performative positivity isn't. Confidence levels are encouraged ("I'm 80% sure this is a duplicate implementation; I'd need to see the source to confirm").

---

End of brief. Begin your review when ready.

---

# 2. CONTEXT (background docs the brief references)

## 2.x — `01_context/app_overview.md`

# Megalith — App Overview

> Round 001 context for LLM reviewers. Read this first.

## What Megalith is

Megalith is a **multi-tenant healthcare and business platform** built for the Spitex/Bemeda group in Switzerland. It started as a process-management app for Spitex (home-care services) and has grown into a horizontal platform with about 80 LiveView surfaces covering:

| Domain | Examples | Where it lives |
|---|---|---|
| **Work / task lanes** | Kanban + list + mindmap views, lane filters, task promote-to-project | `/work/lanes`, `/work/lanes?view=mindmap` |
| **Projects** | Project list, project detail, members, project workspace | `/projects`, `/projects/:id`, `/demo/project-workspace` |
| **CRM** | Contacts, leads, deals, pipelines, revenue streams | `/crm/contacts`, `/crm/leads/:id`, `/crm/deals` |
| **Organization** | Org-unit hierarchy, member rosters, role assignment | `/organization`, `/admin/org-units` |
| **People** | Person dashboards, person picker, member presence | `/demo/person/:id/dashboard` |
| **AgeOps** | Internal AI-agent orchestration (different design tradition — flag if it feels off-brand) | `/ageops/agents`, `/ageops/work-units` |
| **Healthcare (Spitex)** | Patient, Pflege (care), KORE accounting — domain-specific surfaces | `/spitex_care/*`, `/spitex_kore/*` |
| **Knowledge** | Documentation browser (Leitbild / Konzepte / Reglemente) | `/leitbild`, `/konzepte`, `/reglemente` |
| **Maps + geo** | Global orientation map, country/region visualizations | `/map`, `/geo` |
| **Personal** | User dashboard with widget grid | `/demo/personal-dashboard` |
| **Design system showcase** | Grok components reference (use as ground truth) | `/grok-demo` |

## Tech stack (relevant to UI review)

- **Phoenix 1.8.1 + LiveView 1.1** — server-rendered, real-time updates over WebSocket. No separate SPA.
- **Ash Framework 3.0** — declarative resource layer (think: ORM + policy engine combined)
- **Tailwind CSS v4** — utility-first, no `tailwind.config.js`, no `@apply`. Tokens via CSS custom properties.
- **HEEx templates** — Phoenix's HTML-with-embedded-Elixir templating
- **React + React Flow** — used for visual process builder and mindmaps only (most UI is pure LiveView)
- **Mermaid** — diagrams in process editor and documentation
- **Heroicons** — icon library via `<.icon name="hero-...">` component

## Design system (called "Grok")

Documented in `docs/Knowhow/design/` (2,050 LOC across 6 docs):

- `GROK_DESIGN_SYSTEM.md` — 888 LOC, the canonical design language (colors, spacing, components)
- `GROK_STANDARD_LAYOUT.md` — 427 LOC, page layout primitives (shell, sidebar, content)
- `RIGHT_PANEL_COMPACT_UI_GUIDELINES.md` — 164 LOC, right panel rules
- `BRANDING_SYSTEM.md` — 411 LOC, multi-tenant branding asset slots
- `avatar_identity_standard.md` — 148 LOC, **spec'd but not implemented** (this round flags that)

The Grok design system IS the source of truth. When a screenshot doesn't look like Grok, that's evidence of drift.

## What this round wants from you

The audit (`01_context/reusability_audit_summary.md`) identified that several surfaces are diverging from Grok:
- 3 filter components solving overlapping problems
- 8 drag-and-drop JS hooks
- 15+ scattered local "compute initials from name" implementations despite a documented `IdentityAvatar` spec
- 6+ status/badge components with similar visual shape

Your job is to **validate, extend, or push back on** these observations using the screenshots and code samples. Iter 271 (currently in planning) will consolidate. The output of your review goes into that iteration's scope.

## Tenant context for screenshots

Screenshots come from the local dev tenant. Names, emails, projects, contacts are **synthetic** (loaded via `mix dev.setup`). Treat any name or email as fake placeholder data. The visual patterns are real; the data isn't.

## What's intentionally NOT in screenshots this round

- Mobile/tablet breakpoints (desktop-only this round)
- Empty / loading / error states (Phase B may add)
- Admin-only utility surfaces (`/admin/*`)
- Sign-in / magic-link flows
- Dev tooling (`/dev/dashboard`, `/dev/mailbox`)

Round 2 may add these based on round 1 synthesis.

## How decisions are made

The team uses an iteration system (`docs/Iterations/01_active/<NNN>_<topic>/`) where each iteration:
1. Plans (research + ADRs)
2. Executes (multi-lane coordination)
3. Verifies (test commands, no "complete" claims without evidence)
4. Documents (lessons learned promote to `docs/Knowhow/`)

The honesty principle is enforced: claims of "production-ready" require pasted verification output, not vibes. Your review is treated the same way — be specific, cite evidence, push back where warranted.


## 2.x — `01_context/design_system_summary.md`

# Megalith Design System — Summary for LLM Review

> Distilled from `docs/Knowhow/design/` (2,050 LOC across 6 docs). Used as ground truth for what the UI "should" look like.

## The Grok design system (in 1 page)

Megalith's design system is called **Grok**. It's documented across 6 files in `docs/Knowhow/design/`:

| File | LOC | What it covers |
|---|---|---|
| `GROK_DESIGN_SYSTEM.md` | 888 | Colors, spacing, typography, component primitives |
| `GROK_STANDARD_LAYOUT.md` | 427 | Page layout: shell, sidebar, content area, right panel |
| `RIGHT_PANEL_COMPACT_UI_GUIDELINES.md` | 164 | Right-panel-specific compact-info rules |
| `BRANDING_SYSTEM.md` | 411 | Multi-tenant branding asset slots |
| `avatar_identity_standard.md` | 148 | `IdentityAvatar` spec (SEE BELOW — spec'd, not implemented) |
| `README.md` | 12 | Index |

The Grok showcase page `/grok-demo` (in your screenshots as #15) is the visual reference: any other screenshot you see should be **comparable** to Grok in feel.

## Layout primitives (per GROK_STANDARD_LAYOUT.md)

```
┌─────────────────────────────────────────────────────────────┐
│ Top bar: brand · tenant switcher · user menu                │
├──────────┬──────────────────────────────────────┬───────────┤
│          │                                      │           │
│  Sidebar │  Main content                        │  Right    │
│  (nav)   │  (page-specific)                     │  panel    │
│          │                                      │  (compact)│
│          │                                      │           │
└──────────┴──────────────────────────────────────┴───────────┘
```

- **Sidebar**: collapsible, persistent nav
- **Main content**: page-owned layout (Kanban, list, dashboard, detail, etc.)
- **Right panel**: optional, compact-info pattern; appears on detail pages and selectively
- **Top bar**: tenant switcher, branding asset slots, user menu

Tip: when reviewing, note where pages deviate from this shell.

## Colors (per GROK_DESIGN_SYSTEM.md)

The Grok palette uses Tailwind's default color names. Standard chrome:

- Background: white / slate-50 (page) / slate-100 (sidebar) / white (panels)
- Text: slate-900 (primary) / slate-700 (secondary) / slate-500 (muted)
- Primary action: indigo-600 (filled buttons)
- Borders: slate-200
- Status colors (chips/badges):
  - Success/done: emerald-100 bg / emerald-800 text
  - Warning/pending: amber-100 / amber-800
  - Error/blocked: rose-100 / rose-800
  - Info/neutral: slate-100 / slate-700

Identity avatar palette (per avatar_identity_standard.md):
- indigo, cyan, emerald, amber, rose, violet, slate
- Color is **deterministic** from a stable identifier (id, email, slug)

## Spacing scale

Tailwind defaults; in practice the team uses:
- 1 (4px) — inline gap inside chips
- 2 (8px) — element padding inside cards
- 3 (12px) — gap between cards in a column
- 4 (16px) — section padding
- 6 (24px) — between major page regions
- 8 (32px) — page-level vertical rhythm

Outliers indicate drift.

## Typography

- Default sans-serif (Tailwind's `font-sans` stack)
- Sizes: text-xs (chips), text-sm (body, buttons), text-base (default), text-lg (section headers), text-xl+ (page titles)
- Weights: 400 (body), 500 (medium UI labels), 600 (semibold headings, buttons), 700 (page titles)

## Component primitives Grok defines (canonical names)

These are the components Grok intends as the source of truth:

- `<Layouts.app>` — the outer shell, ALWAYS the top-level wrapper in a LiveView template
- `<.icon name="hero-...">` — icon component (Heroicons)
- `<.input>` — form input (single canonical)
- `<.button>` — buttons with variant attr
- `<.modal>` — modals with backdrop
- `<.flash_group>` — flash messages (lives in Layouts module)
- `<.table>` — tabular data
- `<.list>` — list views
- Grok-specific: `<.filter_bar>` (LiveComponent, 277 LOC, in `grok/filter_bar.ex`)
- Grok-specific: `<.badge>` (in `grok/`)
- Spec'd but NOT implemented: `<.identity_avatar>` (per `avatar_identity_standard.md`)

## Right panel rules (per RIGHT_PANEL_COMPACT_UI_GUIDELINES.md)

Right panels are for **compact related info**. Rules:
- Width: ~320-400px (does not steal main content width)
- Stacked sections, each with a small uppercase header
- Each section ≤ 5-7 items; show "view all →" if more
- Avatars use `:xs` or `:sm` size
- Avoid heavy controls — those belong in main content

Screenshot #14 in this round is meant to test compliance with these rules.

## The `IdentityAvatar` spec (NOT IMPLEMENTED)

Per `avatar_identity_standard.md`:

- One shared component `MegalithWeb.Components.IdentityAvatar`
- Assigns: `id`, `subject_type` (`:person | :user | :org_unit | :tenant`), `subject`, `name`, `image_url`, `size` (`:xs | :sm | :md | :lg`), `label`
- Initials: prefer `preferred_name + last_name` for users; org-unit code or 2-word initials for teams; tenant slug for tenants; fallback `?`
- Color: deterministic from stable id, palette is 7 colors (see above)
- Always include accessible label (aria/title)

**As of round 1**: zero implementations in `lib/`. 15+ files compute initials locally. Iter 271 Stage 0 will build this.

## What "design-system consistency" means in this review

When you spot inconsistencies, frame them against Grok's intent:

✅ "Two pages render member avatars; one uses a 9px text initial in a 32px circle, the other uses an 11px initial in a 28px circle. Per `avatar_identity_standard.md`, both should be `:sm` size from `IdentityAvatar`."

❌ "The avatars look slightly different." (too vague — what evidence, what spec?)

## Drift signals to look for

- Components that don't use Grok primitives (custom buttons, custom inputs)
- Pages that ignore the standard layout (no top bar, no sidebar)
- Status colors outside the documented palette
- Spacing that breaks the rhythm (random margins)
- Multiple visual implementations of the same idea (the prime concern of this round)


## 2.x — `01_context/reusability_audit_summary.md`

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

---

# 3. CODE SAMPLES (production code referenced by the brief)

## 3.x — `03_code_samples/avatar_identity_standard.md`

# Avatar Identity Standard

**Status:** implementation-ready standard  
**Date:** 2026-05-20

## Decision

Use one shared avatar identity system for people and org units/teams.

Avatars are visual identity only. They do not decide access. Access remains enforced through resource policies, especially `Megalith.Mixins.Visibility`.

## Product Model

Every actor-like subject should have a recognizable compact identity:

| Subject | Default avatar | Uploaded image later |
|---|---|---|
| Person/User | Initials + deterministic color | Profile photo |
| OrgUnit/Team | Team initials/code + deterministic color | Team image/logo |
| Tenant/Company | Company initials + deterministic color | Company logo/brand mark |

This gives the same visual language for:

- project members
- "who sees this?"
- explicit `:custom` visibility grants
- activity feeds
- assignees
- comments/chat
- right panels

## Canonical UI Contract

Create one shared component, tentatively:

```elixir
MegalithWeb.Components.IdentityAvatar
```

Recommended assigns:

| Assign | Meaning |
|---|---|
| `id` | Stable DOM ID. |
| `subject_type` | `:person`, `:user`, `:org_unit`, `:tenant`, or `:unknown`. |
| `subject` | Loaded subject struct/map when available. |
| `name` | Display fallback. |
| `image_url` | Optional uploaded image/logo URL. |
| `size` | `:xs`, `:sm`, `:md`, `:lg`. |
| `label` | Optional accessible label/title override. |

Rendering rules:

1. If `image_url` exists, render the image.
2. Otherwise compute initials from the best available name fields.
3. Use deterministic color from stable identity (`id`, email, slug, or name).
4. Always include a title/aria label with the display name.

## Initials Rules

Person/User:

- Prefer `preferred_name` + last name when available.
- Otherwise use first/last name.
- Otherwise use email local part.
- Fallback: `?`.

OrgUnit/Team:

- Prefer explicit code/short name if present.
- Otherwise use the first letters of up to two words in the name.
- Fallback: `OU`.

Tenant:

- Prefer tenant slug/name.
- Fallback: `TN`.

## Deterministic Color

Use a small fixed palette and choose by hashing the stable identity.

Do not persist color for the MVP unless a resource already has a field for it. Persisting `avatar_color` can come later if users need manual color customization.

Suggested palette:

- indigo
- cyan
- emerald
- amber
- rose
- violet
- slate

## Uploads Later

The MVP should not require new upload flows. Prepare the component so it accepts `image_url`.

Later, add optional fields/resources:

- Person/User: profile photo path or URL
- OrgUnit: avatar/logo path or URL
- Tenant: already covered by branding/logo surfaces

Uploaded avatar storage should use the existing `/var/uploads` backup path and follow the trial backup/restore checklist.

## Custom Visibility UI

`:custom` visibility should be represented with the same avatars:

```text
Who sees this?
[AB] Anna Baumann
[PF] Pflege Team
[MK] Marco Keller
+3 more
```

The UI is a visualization of:

- `shared_with_user_ids`
- `shared_with_unit_ids`

It should never be a separate access model.

## Existing Duplication To Migrate

Several areas currently compute initials/avatars locally. These should gradually move to the shared component:

- `ProjectLive` project member avatars
- `ProcessLive` approval/creator initials
- CRM contact index/show initials
- chat panel message avatars
- right panel activity/task avatars
- person/org pickers
- Page presence avatars

## Implementation Order

1. Build pure helper functions for initials and deterministic color.
2. Build `IdentityAvatar` function component with tests.
3. Replace `ProjectLive` member strip avatars first because project members are in trial scope.
4. Use it for Page visibility custom-grant summary when `:custom` UI lands.
5. Migrate CRM contact and right-panel avatars.

## Release Honesty

The avatar standard is visual infrastructure. It improves clarity for visibility and collaboration, but it does not expand who can read a resource. Only Ash policies and visibility fields do that.


## 3.x — `03_code_samples/iter_271_component_consolidation_adr.md`

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


## 3.x — `03_code_samples/iter_271_reusability_audit.md`

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


## 3.x — `03_code_samples/filter_panel.ex`

```elixir
defmodule MegalithWeb.Components.FilterPanel do
  @moduledoc """
  Filter panel — collapses choice filters (Domain / Priority / Status) behind a
  single button + active-filter badges.

  Parent LV owns `:open` state via `assign(:filter_panel_open, false)` and toggles
  via the `"toggle_filter_panel"` event. Filters are set via `"set_filter"` with
  `phx-value-key={key}` + `phx-value-value={value}`, removed via `"remove_filter"`,
  and reset via `"reset_filters"`.
  """

  use MegalithWeb, :html

  @filter_choices %{
    source_domain: [
      {:all, "All"},
      {:work, "Work"},
      {:crm, "CRM"},
      {:projects, "Projects"},
      {:ageops, "AgeOps"}
    ],
    priority: [
      {:all, "All"},
      {:low, "Low"},
      {:medium, "Medium"},
      {:high, "High"},
      {:urgent, "Urgent"}
    ],
    status: [
      {:all, "All"},
      {:open, "Open"},
      {:in_progress, "In Progress"},
      {:done, "Done"}
    ]
  }

  attr :filters, :map,
    required: true,
    doc: "map %{source_domain: atom, priority: atom, status: atom}"

  attr :open, :boolean, default: false

  attr :visible_keys, :list,
    default: [:source_domain, :priority, :status],
    doc: "Which choice filters to show in the dropdown"

  def filter_panel(assigns) do
    ~H"""
    <div id="filter-panel" class="relative inline-flex flex-wrap items-center gap-1">
      <%!-- Toggle button --%>
      <button
        type="button"
        id="filter-panel-toggle"
        phx-click="toggle_filter_panel"
        aria-haspopup="menu"
        aria-expanded={to_string(@open)}
        class={[
          "inline-flex items-center gap-1 rounded-md px-2.5 py-1.5 text-xs font-medium transition-colors",
          @open && "ring-2 ring-[var(--grok-accent)]"
        ]}
        style={
          if @open,
            do: "background: var(--grok-accent); color: white;",
            else: "background: var(--grok-bg-secondary); color: var(--grok-text-primary);"
        }
      >
        <span>⚙ Filters</span>
        <span :if={active_count(@filters, @visible_keys) > 0}>
          ({active_count(@filters, @visible_keys)})
        </span>
        <span class="text-[var(--grok-text-tertiary)]" style={if @open, do: "color: white;"}>
          {if @open, do: "▴", else: "▾"}
        </span>
      </button>

      <%!-- Active filter badges (shown when panel is closed) --%>
      <%= for key <- @visible_keys, not @open, active?(Map.get(@filters, key)) do %>
        <span
          id={"filter-panel-badge-#{key}"}
          class="inline-flex items-center gap-1 rounded-md px-2 py-1 text-xs"
          style="background: var(--grok-accent); color: white;"
        >
          <span>{filter_label(key)}: {choice_label(key, Map.get(@filters, key))}</span>
          <button
            type="button"
            id={"filter-panel-badge-remove-#{key}"}
            phx-click="remove_filter"
            phx-value-key={to_string(key)}
            aria-label={"Remove #{filter_label(key)} filter (current: #{choice_label(key, Map.get(@filters, key))})"}
            class="ml-0.5 rounded-full px-1 text-xs transition-colors hover:bg-white/20"
          >
            ×
          </button>
        </span>
      <% end %>

      <%!-- Dropdown panel --%>
      <div
        :if={@open}
        id="filter-panel-dropdown"
        role="menu"
        phx-click-away="toggle_filter_panel"
        class="absolute left-0 top-full mt-1 rounded-lg border py-2 px-3 shadow-lg"
        style="background: var(--grok-bg-elevated); border-color: var(--grok-border); z-index: 40; min-width: 280px;"
      >
        <%= for key <- @visible_keys do %>
          <div
            id={"filter-panel-row-#{key}"}
            class="mb-2 last:mb-0"
          >
            <span class="block text-xs mb-1" style="color: var(--grok-text-secondary);">
              {filter_label(key)}:
            </span>
            <div class="flex flex-wrap gap-1">
              <%= for {value, label} <- choices_for(key) do %>
                <button
                  type="button"
                  id={"filter-panel-choice-#{key}-#{value}"}
                  role="menuitemradio"
                  aria-pressed={to_string(Map.get(@filters, key) == value)}
                  phx-click="set_filter"
                  phx-value-key={to_string(key)}
                  phx-value-value={to_string(value)}
                  class={[
                    "px-2 py-0.5 rounded-md text-xs transition-colors",
                    Map.get(@filters, key) == value &&
                      "text-white",
                    Map.get(@filters, key) != value &&
                      "hover:bg-[var(--grok-bg-tertiary)]"
                  ]}
                  style={
                    if Map.get(@filters, key) == value,
                      do: "background: var(--grok-accent);",
                      else: "background: var(--grok-bg-tertiary); color: var(--grok-text-secondary);"
                  }
                >
                  {label}
                </button>
              <% end %>
            </div>
          </div>
        <% end %>

        <div class="mt-2 pt-2 border-t" style="border-color: var(--grok-border);">
          <button
            type="button"
            id="filter-panel-reset"
            phx-click="reset_filters"
            class="w-full rounded-md px-2 py-1 text-xs transition-colors hover:bg-[var(--grok-bg-tertiary)]"
            style="color: var(--grok-text-secondary);"
          >
            Reset all
          </button>
        </div>
      </div>
    </div>
    """
  end

  defp choices_for(key), do: Map.get(@filter_choices, key, [])

  defp filter_label(:source_domain), do: "Domain"
  defp filter_label(:priority), do: "Priority"
  defp filter_label(:status), do: "Status"
  defp filter_label(other) when is_atom(other), do: Atom.to_string(other)

  defp choice_label(key, value) do
    choices_for(key)
    |> Enum.find_value(&if elem(&1, 0) == value, do: elem(&1, 1))
    |> case do
      nil -> to_string(value)
      label -> label
    end
  end

  defp active?(value) when value in [nil, :all], do: false
  defp active?(_value), do: true

  defp active_count(filters, visible_keys) do
    Enum.count(visible_keys, fn key ->
      active?(Map.get(filters, key))
    end)
  end
end
```


## 3.x — `03_code_samples/grok_filter_bar.ex`

```elixir
defmodule MegalithWeb.Components.Grok.FilterBar do
  @moduledoc """
  Reusable Grok-styled filter bar component for list views.

  Provides consistent filtering UI across CRM, People, Projects, and other domains.
  Handles URL persistence via push_patch and supports mobile-friendly layouts.

  ## Features

  - Grok design system styling
  - URL persistence (push_patch)
  - Clear/Reset filters
  - Mobile-responsive
  - Accessible (labels, ARIA)

  ## Usage

      <.live_component
        module={FilterBar}
        id="contact-filters"
        search_value={@search_query}
        filters={[
          %{type: :select, name: "company", label: "Company", options: @companies, value: @filter_company},
          %{type: :select, name: "status", label: "Status", options: @statuses, value: @filter_status}
        ]}
        on_change="filter_change"
        on_clear="clear_filters"
      />

  ## Props

  - `id`: Component ID (required)
  - `search_value`: Current search query (string)
  - `search_placeholder`: Search input placeholder (default: "Search...")
  - `filters`: List of filter configs (see Filter Types below)
  - `on_change`: Event name for filter changes (default: "filter_change")
  - `on_clear`: Event name for clear action (default: "clear_filters")
  - `show_clear`: Show clear button (default: true)

  ## Filter Types

  ### Text Search
  ```elixir
  %{type: :search, name: "search", placeholder: "Search by name...", value: ""}
  ```

  ### Select (Single)
  ```elixir
  %{
    type: :select,
    name: "status",
    label: "Status",
    options: [{"All", ""}, {"Active", "active"}, {"Inactive", "inactive"}],
    value: "active"
  }
  ```

  ### Multiselect
  ```elixir
  %{
    type: :multiselect,
    name: "types",
    label: "Types",
    options: [{"Call", "call"}, {"Meeting", "meeting"}],
    value: ["call", "meeting"]
  }
  ```

  ### Date Range
  ```elixir
  %{
    type: :date_range,
    name_from: "date_from",
    name_to: "date_to",
    label: "Date Range",
    value_from: "2025-01-01",
    value_to: "2025-12-31"
  }
  ```
  """

  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~H"""
    <div
      id={@id}
      data-style-theme="grok"
      style="background: var(--grok-bg-secondary); padding: var(--grok-space-lg); border-radius: var(--grok-radius-lg); margin-bottom: var(--grok-space-xl); border: 1px solid var(--grok-border);"
    >
      <.form
        for={%{}}
        phx-change={@on_change}
        phx-target={@myself}
        style="display: flex; flex-wrap: wrap; gap: var(--grok-space-md); align-items: end;"
      >
        <%!-- Search Field --%>
        <%= if @search_enabled do %>
          <div style="flex: 1; min-width: 250px;">
            <label
              for={"#{@id}-search"}
              style="display: block; font-size: var(--grok-text-sm); font-weight: var(--grok-font-medium); color: var(--grok-text-primary); margin-bottom: var(--grok-space-xs);"
            >
              Search
            </label>
            <input
              type="text"
              name="search"
              id={"#{@id}-search"}
              value={@search_value}
              placeholder={@search_placeholder}
              style="width: 100%; padding: var(--grok-space-sm) var(--grok-space-md); background: var(--grok-bg-primary); border: 1px solid var(--grok-border); border-radius: var(--grok-radius-md); color: var(--grok-text-primary); font-size: var(--grok-text-sm);"
              phx-debounce="300"
            />
          </div>
        <% end %>
        <%!-- Dynamic Filters --%>
        <%= for filter <- @filters do %>
          {render_filter(assigns, filter)}
        <% end %>
        <%!-- Clear Button --%>
        <%= if @show_clear do %>
          <button
            type="button"
            phx-click={@on_clear}
            phx-target={@myself}
            style="padding: var(--grok-space-sm) var(--grok-space-md); background: var(--grok-bg-tertiary); border: 1px solid var(--grok-border); border-radius: var(--grok-radius-md); color: var(--grok-text-secondary); font-size: var(--grok-text-sm); font-weight: var(--grok-font-semibold); cursor: pointer; transition: background 0.2s;"
            onmouseover="this.style.background='var(--grok-bg-secondary)'"
            onmouseout="this.style.background='var(--grok-bg-tertiary)'"
          >
            Clear
          </button>
        <% end %>
      </.form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_defaults()}
  end

  defp assign_defaults(socket) do
    socket
    |> assign_new(:search_enabled, fn -> socket.assigns[:search_value] != nil end)
    |> assign_new(:search_value, fn -> "" end)
    |> assign_new(:search_placeholder, fn -> "Search..." end)
    |> assign_new(:filters, fn -> [] end)
    |> assign_new(:on_change, fn -> "filter_change" end)
    |> assign_new(:on_clear, fn -> "clear_filters" end)
    |> assign_new(:show_clear, fn -> true end)
  end

  @impl true
  def handle_event("filter_change", params, socket) do
    # Forward to parent LiveView with original event name
    send(self(), {:filter_change, params})
    {:noreply, socket}
  end

  @impl true
  def handle_event("clear_filters", _params, socket) do
    # Forward to parent LiveView
    send(self(), :clear_filters)
    {:noreply, socket}
  end

  # ============================================================
  # Filter Rendering
  # ============================================================

  defp render_filter(assigns, %{type: :select} = filter) do
    assigns = assign(assigns, :filter, filter)

    ~H"""
    <div style="width: 200px;">
      <label
        for={"#{@id}-#{@filter.name}"}
        style="display: block; font-size: var(--grok-text-sm); font-weight: var(--grok-font-medium); color: var(--grok-text-primary); margin-bottom: var(--grok-space-xs);"
      >
        {@filter.label}
      </label>
      <select
        name={@filter.name}
        id={"#{@id}-#{@filter.name}"}
        style="width: 100%; padding: var(--grok-space-sm) var(--grok-space-md); background: var(--grok-bg-primary); border: 1px solid var(--grok-border); border-radius: var(--grok-radius-md); color: var(--grok-text-primary); font-size: var(--grok-text-sm);"
      >
        <option
          :for={{label, value} <- @filter.options}
          value={value}
          selected={value == @filter.value}
        >
          {label}
        </option>
      </select>
    </div>
    """
  end

  defp render_filter(assigns, %{type: :date_range} = filter) do
    assigns = assign(assigns, :filter, filter)

    ~H"""
    <div style="display: flex; gap: var(--grok-space-sm);">
      <div style="width: 150px;">
        <label
          for={"#{@id}-#{@filter.name_from}"}
          style="display: block; font-size: var(--grok-text-sm); font-weight: var(--grok-font-medium); color: var(--grok-text-primary); margin-bottom: var(--grok-space-xs);"
        >
          From
        </label>
        <input
          type="date"
          name={@filter.name_from}
          id={"#{@id}-#{@filter.name_from}"}
          value={@filter.value_from || ""}
          style="width: 100%; padding: var(--grok-space-sm) var(--grok-space-md); background: var(--grok-bg-primary); border: 1px solid var(--grok-border); border-radius: var(--grok-radius-md); color: var(--grok-text-primary); font-size: var(--grok-text-sm);"
        />
      </div>
      <div style="width: 150px;">
        <label
          for={"#{@id}-#{@filter.name_to}"}
          style="display: block; font-size: var(--grok-text-sm); font-weight: var(--grok-font-medium); color: var(--grok-text-primary); margin-bottom: var(--grok-space-xs);"
        >
          To
        </label>
        <input
          type="date"
          name={@filter.name_to}
          id={"#{@id}-#{@filter.name_to}"}
          value={@filter.value_to || ""}
          style="width: 100%; padding: var(--grok-space-sm) var(--grok-space-md); background: var(--grok-bg-primary); border: 1px solid var(--grok-border); border-radius: var(--grok-radius-md); color: var(--grok-text-primary); font-size: var(--grok-text-sm);"
        />
      </div>
    </div>
    """
  end

  defp render_filter(assigns, %{type: :multiselect} = filter) do
    assigns = assign(assigns, :filter, filter)

    ~H"""
    <div style="width: 200px;">
      <label
        for={"#{@id}-#{@filter.name}"}
        style="display: block; font-size: var(--grok-text-sm); font-weight: var(--grok-font-medium); color: var(--grok-text-primary); margin-bottom: var(--grok-space-xs);"
      >
        {@filter.label}
      </label>
      <select
        name={"#{@filter.name}[]"}
        id={"#{@id}-#{@filter.name}"}
        multiple
        style="width: 100%; padding: var(--grok-space-sm) var(--grok-space-md); background: var(--grok-bg-primary); border: 1px solid var(--grok-border); border-radius: var(--grok-radius-md); color: var(--grok-text-primary); font-size: var(--grok-text-sm);"
      >
        <option
          :for={{label, value} <- @filter.options}
          value={value}
          selected={value in (@filter.value || [])}
        >
          {label}
        </option>
      </select>
    </div>
    """
  end

  defp render_filter(_assigns, _filter) do
    # Unknown filter type, skip rendering
    nil
  end
end
```


## 3.x — `03_code_samples/relational_filter_modal.ex`

```elixir
defmodule MegalithWeb.Components.RelationalFilterModal do
  @moduledoc """
  OrgUnit-style multi-select modal for relational filter picks (People, Projects).

  Replaces iter 267's `RelationalFilterChip` inline popover with a modal that
  provides pending-selection + Apply/Cancel pattern, more room for result
  rendering, and matches the existing OrgUnit add-person modal pattern
  (`OrganizationGrokLive`).

  ## Public API

      <.live_component
        module={MegalithWeb.Components.RelationalFilterModal}
        id="filter-people"
        label="People"
        modal_title="Filter by people"
        placeholder="Search by name or email..."
        selected={@filters.assignee_ids || []}
        options_provider={Megalith.OptionsProviders.People}
        options_provider_opts={[tenant_id: @current_tenant_id]}
        current_user={@current_user}
      />

  Parent receives: `{:filter_changed, chip_id, list_of_ids}`
  """

  use MegalithWeb, :live_component

  alias Megalith.OptionsProvider

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> assign(:open, false)
     |> assign(:search_query, "")
     |> assign(:results, [])
     |> assign(:loading, false)
     |> assign(:error, nil)
     |> assign(:focused_index, -1)
     |> assign(:pending_selection, MapSet.new())
     |> assign(:label_cache, %{})
     |> assign(:search_timer, nil)}
  end

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_new(:placeholder, fn -> "Search..." end)
      |> assign_new(:selected, fn -> [] end)
      |> assign_new(:options_provider_opts, fn -> [] end)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id={"filter-modal-#{@id}-wrapper"} class="inline-flex items-center">
      <%!-- Trigger button --%>
      <button
        type="button"
        id={"filter-modal-#{@id}-trigger"}
        class={[
          "px-2 py-0.5 rounded-md text-xs transition-colors",
          if(length(MapSet.to_list(@pending_selection)) > 0 or length(@selected) > 0,
            do: "text-white",
            else: "hover:bg-[var(--grok-bg-tertiary)]"
          )
        ]}
        style={
          if length(@selected) > 0 or length(MapSet.to_list(@pending_selection)) > 0,
            do: "background: var(--grok-accent);",
            else: "background: var(--grok-bg-tertiary); color: var(--grok-text-secondary);"
        }
        phx-click="toggle_modal"
        phx-target={@myself}
        aria-haspopup="dialog"
        aria-expanded={to_string(@open)}
      >
        {@label}
        <%= if length(@selected) > 0 do %>
          <span class="ml-1 opacity-75">({length(@selected)})</span>
        <% end %>
      </button>

      <%!-- Modal --%>
      <%= if @open do %>
        <div
          id={"filter-modal-#{@id}-backdrop"}
          style="
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 50;
            padding: var(--grok-space-lg);
          "
        >
          <div
            id={"filter-modal-#{@id}-dialog"}
            phx-click-away="cancel"
            phx-target={@myself}
            phx-window-keydown="handle_keydown"
            phx-target-window={@myself}
            role="dialog"
            aria-modal="true"
            aria-labelledby={"filter-modal-#{@id}-title"}
            style="
              background: var(--grok-bg-primary);
              border-radius: var(--grok-radius-lg);
              border: 1px solid var(--grok-border);
              max-width: 500px;
              width: 100%;
              max-height: 80vh;
              overflow: auto;
              box-shadow: var(--grok-shadow-2xl);
            "
          >
            <%!-- Header --%>
            <div style="
              padding: var(--grok-space-lg);
              border-bottom: 1px solid var(--grok-border);
              display: flex;
              align-items: center;
              justify-content: space-between;
            ">
              <h3
                id={"filter-modal-#{@id}-title"}
                style="font-size: var(--grok-text-xl); font-weight: var(--grok-font-bold); color: var(--grok-text-primary);"
              >
                {@modal_title}
              </h3>
              <button
                type="button"
                phx-click="cancel"
                phx-target={@myself}
                style="
                  padding: var(--grok-space-sm);
                  background: transparent;
                  border: none;
                  color: var(--grok-text-secondary);
                  cursor: pointer;
                "
                aria-label="Close"
              >
                <.icon name="hero-x-mark" class="w-5 h-5" />
              </button>
            </div>

            <%!-- Content --%>
            <div style="padding: var(--grok-space-lg);">
              <%!-- Search input --%>
              <div style="margin-bottom: var(--grok-space-md);">
                <input
                  type="text"
                  id={"filter-modal-#{@id}-search-input"}
                  name="query"
                  value={@search_query}
                  placeholder={@placeholder}
                  autofocus
                  phx-change="search"
                  phx-target={@myself}
                  phx-debounce="250"
                  aria-label={"Search " <> @label}
                  style="
                    width: 100%;
                    padding: var(--grok-space-sm) var(--grok-space-md);
                    border: 1px solid var(--grok-border);
                    border-radius: var(--grok-radius-md);
                    background: var(--grok-bg-primary);
                    color: var(--grok-text-primary);
                    font-size: var(--grok-text-sm);
                    outline: none;
                  "
                />
              </div>

              <%!-- Pending selection chips --%>
              <%= if MapSet.size(@pending_selection) > 0 do %>
                <div class="flex flex-wrap gap-1 mb-3">
                  <%= for id <- MapSet.to_list(@pending_selection) do %>
                    <span
                      id={"filter-modal-#{@id}-chip-#{id}"}
                      style="
                        display: inline-flex;
                        align-items: center;
                        gap: 4px;
                        padding: 2px 8px;
                        background: var(--grok-bg-tertiary);
                        border-radius: var(--grok-radius-full);
                        font-size: var(--grok-text-xs);
                        color: var(--grok-text-primary);
                      "
                    >
                      {Map.get(@label_cache, id, id)}
                      <button
                        type="button"
                        phx-click="toggle_selection"
                        phx-value-id={id}
                        phx-target={@myself}
                        style="
                          background: transparent;
                          border: none;
                          cursor: pointer;
                          color: var(--grok-text-secondary);
                          padding: 0;
                          line-height: 1;
                        "
                        aria-label={"Remove #{Map.get(@label_cache, id, id)}"}
                      >
                        <.icon name="hero-x-mark" class="w-3 h-3" />
                      </button>
                    </span>
                  <% end %>
                </div>
              <% end %>

              <%!-- Results listbox --%>
              <div
                id={"filter-modal-#{@id}-results"}
                role="listbox"
                aria-multiselectable="true"
                aria-activedescendant={
                  if @focused_index >= 0 and @focused_index < length(@results),
                    do: "filter-modal-#{@id}-result-#{elem(Enum.at(@results, @focused_index), 0)}"
                }
                style="
                  max-height: 300px;
                  overflow-y: auto;
                  border: 1px solid var(--grok-border);
                  border-radius: var(--grok-radius-md);
                "
              >
                <%= if @loading do %>
                  <div class="p-4 text-center text-sm" style="color: var(--grok-text-secondary);">
                    Loading...
                  </div>
                <% else %>
                  <%= for {id, label, sub_label} <- @results do %>
                    <div
                      id={"filter-modal-#{@id}-result-#{id}"}
                      role="option"
                      aria-selected={to_string(MapSet.member?(@pending_selection, id))}
                      tabindex="-1"
                      phx-click="toggle_selection"
                      phx-value-id={id}
                      phx-target={@myself}
                      style={[
                        "padding: var(--grok-space-sm) var(--grok-space-md);",
                        "cursor: pointer;",
                        "display: flex;",
                        "align-items: center;",
                        "justify-content: space-between;",
                        "border-bottom: 1px solid var(--grok-border);",
                        if(MapSet.member?(@pending_selection, id),
                          do: "background: color-mix(in srgb, var(--grok-accent) 15%, transparent);",
                          else: ""
                        ),
                        if(
                          @focused_index >= 0 && @focused_index < length(@results) &&
                            elem(Enum.at(@results, @focused_index), 0) == id,
                          do: "background: var(--grok-bg-tertiary);",
                          else: ""
                        )
                      ]}
                    >
                      <div>
                        <div style="color: var(--grok-text-primary); font-size: var(--grok-text-sm);">
                          {label}
                        </div>
                        <%= if sub_label do %>
                          <div style="color: var(--grok-text-secondary); font-size: var(--grok-text-xs); margin-top: 2px;">
                            {sub_label}
                          </div>
                        <% end %>
                      </div>
                      <%= if MapSet.member?(@pending_selection, id) do %>
                        <.icon name="hero-check" class="w-4 h-4" style="color: var(--grok-accent);" />
                      <% end %>
                    </div>
                  <% end %>
                  <%= if @results == [] and @search_query != "" and not @loading do %>
                    <div class="p-4 text-center text-sm" style="color: var(--grok-text-secondary);">
                      No results found
                    </div>
                  <% end %>
                <% end %>
              </div>
            </div>

            <%!-- Footer --%>
            <div style="
              padding: var(--grok-space-md) var(--grok-space-lg);
              border-top: 1px solid var(--grok-border);
              display: flex;
              align-items: center;
              justify-content: space-between;
            ">
              <button
                type="button"
                id={"filter-modal-#{@id}-clear"}
                phx-click="clear"
                phx-target={@myself}
                class="text-xs px-2 py-1 rounded hover:bg-[var(--grok-bg-tertiary)]"
                style="color: var(--grok-text-secondary); background: transparent; border: none; cursor: pointer;"
              >
                Clear
              </button>
              <div class="flex gap-2">
                <button
                  type="button"
                  id={"filter-modal-#{@id}-cancel"}
                  phx-click="cancel"
                  phx-target={@myself}
                  class="text-xs px-3 py-1 rounded"
                  style="
                    background: var(--grok-bg-tertiary);
                    color: var(--grok-text-secondary);
                    border: 1px solid var(--grok-border);
                    cursor: pointer;
                  "
                >
                  Cancel
                </button>
                <button
                  type="button"
                  id={"filter-modal-#{@id}-apply"}
                  phx-click="apply"
                  phx-target={@myself}
                  class="text-xs px-3 py-1 rounded text-white"
                  style="
                    background: var(--grok-accent);
                    border: none;
                    cursor: pointer;
                  "
                >
                  Apply
                </button>
              </div>
            </div>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  @impl true
  def handle_event("toggle_modal", _params, socket) do
    if socket.assigns.open do
      {:noreply, assign(socket, :open, false)}
    else
      {:noreply,
       socket
       |> assign(:open, true)
       |> assign(:pending_selection, MapSet.new(socket.assigns.selected))
       |> assign(:search_query, "")
       |> assign(:results, [])
       |> assign(:focused_index, -1)
       |> assign(:error, nil)}
    end
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    if String.length(query) >= 2 do
      send(self(), {:do_search, query})
    end

    {:noreply, assign(socket, :search_query, query)}
  end

  def handle_info({:do_search, query}, socket) do
    provider = socket.assigns.options_provider
    actor = socket.assigns.current_user
    opts = socket.assigns.options_provider_opts

    case provider.search(actor, query, opts) do
      {:ok, results} ->
        label_cache =
          Enum.reduce(results, socket.assigns.label_cache, fn {id, label, _sub}, acc ->
            Map.put(acc, id, label)
          end)

        {:noreply,
         socket
         |> assign(:results, results)
         |> assign(:loading, false)
         |> assign(:label_cache, label_cache)
         |> assign(:focused_index, -1)}

      {:error, _reason} ->
        {:noreply,
         socket
         |> assign(:results, [])
         |> assign(:loading, false)
         |> assign(:error, "Search failed. Please try again.")}
    end
  end

  @impl true
  def handle_event("toggle_selection", %{"id" => id}, socket) do
    pending = socket.assigns.pending_selection

    updated =
      if MapSet.member?(pending, id) do
        MapSet.delete(pending, id)
      else
        MapSet.put(pending, id)
      end

    {:noreply, assign(socket, :pending_selection, updated)}
  end

  @impl true
  def handle_event("apply", _params, socket) do
    ids = MapSet.to_list(socket.assigns.pending_selection)

    send(self(), {:filter_changed, socket.assigns.id, ids})

    {:noreply, assign(socket, :open, false)}
  end

  @impl true
  def handle_event("clear", _params, socket) do
    {:noreply, assign(socket, :pending_selection, MapSet.new())}
  end

  @impl true
  def handle_event("cancel", _params, socket) do
    {:noreply, assign(socket, :open, false)}
  end

  @impl true
  def handle_event("handle_keydown", %{"key" => key}, socket) do
    if socket.assigns.open do
      case key do
        "Escape" ->
          {:noreply, assign(socket, :open, false)}

        "ArrowDown" ->
          max_idx = max(0, length(socket.assigns.results) - 1)
          new_idx = min(socket.assigns.focused_index + 1, max_idx)
          {:noreply, assign(socket, :focused_index, new_idx)}

        "ArrowUp" ->
          new_idx = max(socket.assigns.focused_index - 1, 0)
          {:noreply, assign(socket, :focused_index, new_idx)}

        "Enter" ->
          if socket.assigns.focused_index >= 0 and
               socket.assigns.focused_index < length(socket.assigns.results) do
            {focused_id, _, _} = Enum.at(socket.assigns.results, socket.assigns.focused_index)
            pending = socket.assigns.pending_selection

            updated =
              if MapSet.member?(pending, focused_id) do
                MapSet.delete(pending, focused_id)
              else
                MapSet.put(pending, focused_id)
              end

            {:noreply, assign(socket, :pending_selection, updated)}
          else
            {:noreply, socket}
          end

        _ ->
          {:noreply, socket}
      end
    else
      {:noreply, socket}
    end
  end
end
```

---

# 4. SCREENSHOTS (attached separately as files)

The PNG screenshots are NOT inlined. They are attached as files (drag-drop in chat) or available at:
`https://denismgojak.github.io/spitex-llm-review/round_001_2026-05-28_component_reuse/02_screenshots/NN_<slug>.png`

## 4.x — `02_screenshots/README.md` (per-screenshot context, including post-capture caveats)

# Screenshots — Round 001

18 desktop screenshots (1440×3000 tall viewport) of representative Megalith surfaces. Captured by `c1_263a` lane via `mix llm_review.screenshots` (Wallaby + headless Chrome) against the local dev tenant `bemeda.lvh.me:4000`, signed in as `denis.gojak@spitex-bemeda.ch` (tenant_admin) via the dev-only `/dev/sign_in_as/:lookup` shim.

> **Re-capture (2026-05-28, post-review)**: rounds 1.0 surfaced 4 errors that have been patched:
> - **#09 person_dashboard** — `KeyError: :branding` in `PersonDashboardLive.continue_person_mount/4` (missing `assign(:branding, ...)`). Patched.
> - **#10 orgunit_dashboard** — `KeyError: :total_contacts` (+ 9 sibling unsafe accesses) in `OrgUnitDashboardLive` lens-card template. All converted to defensive `Map.get/3`. Patched.
> - **#12 handbuch** — `Phoenix.Router.NoRouteError at GET /handbuch` (route doesn't exist; the real routes are `/leitbild`, `/konzepte`, `/reglemente` via `DocumentSectionLive`). PageRegistry path corrected to `/leitbild`.
> - **#14 right_panel_compact** — Same `/handbuch` NoRouteError, but the entry was architecturally broken (right-panel state is interaction-driven, not URL-driven). PageRegistry substituted with `/reglemente` (different real doc surface) so the slot shows real content; honest gap documented in registry notes.
>
> Capture also bumped to 3000px tall viewport (was 900px) so most long pages render without scroll-clipping. Re-capture: `mix llm_review.screenshots --round 1 --topic component_reuse`.

## How to use this folder

Each screenshot is numbered 01-18 with a slug describing the surface. The table below tells you:

- **File**: the PNG (clickable in most markdown viewers)
- **Confirmed route**: actual URL captured (placeholders resolved at capture time)
- **Description**: one line about the page
- **UI patterns**: what visual patterns to look at when reviewing
- **Known limitation**: anything to disregard (synthetic data quirks, dev-only states, captured-state caveats)

## Screenshot index

| # | File | Confirmed route | Description | UI patterns | Known limitation |
|---|---|---|---|---|---|
| 01 | `01_lane_dashboard_kanban.png` (82 KB) | `/work/lanes?view=kanban` | Lane dashboard, kanban view | kanban columns, cards, filter drawer, single-assignee avatars | dev tenant has limited tasks; pagination may not be visible |
| 02 | `02_lane_dashboard_list.png` (66 KB) | `/work/lanes?view=list` | Same data, list view | list rows, filters, status chips | — |
| 03 | `03_lane_dashboard_mindmap.png` (54 KB) | `/work/lanes?view=mindmap` | Mindmap view | node graph, card nodes | viewport may show only part of map |
| 04 | `04_lane_dashboard_filters_modal.png` (82 KB) | `/work/lanes?view=kanban&filter_modal=people` | Lane dashboard with People filter modal (iter 268 pattern) | full-screen modal, search input, multi-select | **⚠️ `?filter_modal=people` query param is NOT consumed at mount** — the LiveView ignores it on initial render, so this screenshot is byte-identical to #01 (kanban view, modal closed). Iter 268 or a follow-up needs to make `filter_modal` mount-aware before re-capture can show the modal. |
| 05 | `05_project_index.png` (88 KB) | `/projects` | Project list | card grid, filter bar (Grok system) | — |
| 06 | `06_project_show_with_members.png` (44 KB) | `/projects/c460599d-24a2-41d5-9481-b0d12eaebc9e` | Project detail page (members strip + task list) | members avatar strip, task list, status chips | **prime evidence of avatar duplication**; UUID resolved at capture time to first project in the dev tenant |
| 07 | `07_crm_contact_index.png` (141 KB) | `/crm/contacts` | CRM contact index | grok filter bar, contact rows, avatar initials | **another avatar duplication site** |
| 08 | `08_crm_lead_show.png` (45 KB) | `/crm/leads` | CRM lead surface | right panel, list rows | **⚠️ `__FIRST_LEAD__` placeholder did NOT resolve** — `Megalith.CRM.Lead.read` returned 0 rows (no leads seeded in the dev tenant) so the pipeline fell back to `/crm/leads` (index). Seed a lead via `mix dev.setup` extensions or `iex -S mix` insert, then re-capture to get a true lead detail screenshot. |
| 09 | `09_person_dashboard.png` (99 KB) | `/demo/person/2aa7a50b-2bd5-42a9-a796-e55ab257eca4/dashboard` | Person dashboard demo | summary cards, KPIs, activity widgets | UUID resolved at capture time to first seeded `Megalith.Core.Person` |
| 10 | `10_orgunit_dashboard.png` (214 KB) | `/demo/org-unit/46dcb4ea-6433-4c45-a764-d7ac0158f92f/dashboard` | OrgUnit dashboard demo (mirrors person dashboard) | summary cards, KPIs, activity widgets | UUID resolved at capture time; compare with #09 for pattern reuse |
| 11 | `11_ageops_agents.png` (130 KB) | `/ageops/agents` | AgeOps agent grid | agent cards, trust badges, status pills | **different design tradition** — worth flagging if it feels off-brand |
| 12 | `12_handbuch.png` (TBD KB) | `/leitbild` | Documentation browser (Leitbild — mission/principles surface) | document list, document section, static content | Round-1 substitutes `/leitbild` for the original `/handbuch` (no such route exists); slug kept as `handbuch` for filename stability. |
| 13 | `13_personal_dashboard.png` (53 KB) | `/demo/personal-dashboard` | Personal dashboard demo (brick/widget grid) | brick grid, widgets, drag handles | — |
| 14 | `14_right_panel_compact.png` (TBD KB) | `/reglemente` | Documentation surface (Reglemente — regulations); substituted for compact right-panel slot | document list, document section, static content | **⚠️ Substitution**: the original compact-right-panel surface (RIGHT_PANEL_COMPACT_UI_GUIDELINES.md) can't be captured today — right-panel state is interaction-driven (no URL-param hook at mount). Reglemente was picked as the second documentation surface so the slot shows real content. Slug kept as `right_panel_compact` for filename stability. Future rounds: add URL-param-driven right-panel state OR include an interactive capture step. |
| 15 | `15_grok_demo.png` (143 KB) | `/grok-demo` | Grok design system showcase | reference components, palette | use as **ground truth** for design language — compare other screenshots to this |
| 16 | `16_megalith_map.png` (91 KB) | `/map` | Global orientation map (user favored) | map visualization, country/region rendering, navigation overlays | does the map UI share button/panel/chrome language with the rest of the app? |
| 17 | `17_organization_grok.png` (45 KB) | `/organization` | Org dashboard, Grok variant (user favored) | org-unit cards, hierarchy display, member rosters | yet another avatar/member display site; yet another dashboard pattern variant |
| 18 | `18_project_workspace_demo.png` (49 KB) | `/demo/project-workspace` | Project workspace demo, iter 20 (user favored) | combined project view, multi-pane workspace, right-panel composition | does the workspace composition feel cohesive with `/projects/:id` and `/work/lanes`? |

## Reviewer notes (artifacts to flag in the LLM brief)

**Post-fix state (re-capture pending)**:

- #04 (`filter_modal=people`) is byte-identical to #01 (kanban): iter 268's `?filter_modal=...` query param is NOT consumed at LiveView mount. This is a real PRODUCTION bug (missing functionality) in the lane-dashboard LiveView, not a pipeline bug. Flagged for iter 268 owner; out of scope for round 1.
- #14 was substituted away from `/handbuch?right_panel=compact` (broken) to `/reglemente` (real doc surface) because the right-panel state is interaction-driven (no URL hook). Honest gap documented in the registry.
- #08 (`/crm/leads/__FIRST_LEAD__` → `/crm/leads`): no leads in dev tenant. Pipeline did the right thing (graceful fallback); review uses the lead-list surface instead. Seed a lead to get the true lead-detail surface in round 2.

## Conventions

- Filename: `NN_slug.png` (zero-padded number; slug = snake_case)
- Format: PNG, full viewport (Wallaby `take_screenshot`), no clipping
- Resolution: 1440×3000 (desktop, tall viewport — bumped from 900 to fit long pages). Mobile/tablet may be added in round 2.
- Capture command: `mix llm_review.screenshots --round 1 --topic component_reuse`
- Re-run safety: pipeline OVERWRITES existing PNGs cleanly; two consecutive runs produced byte-identical files (md5 verified).

## Capture provenance

- Captured: 2026-05-28 by `c1_263a` lane
- Pipeline: `lib/mix/tasks/llm_review.screenshots.ex`
- Page registry: `lib/megalith/llm_review/page_registry.ex` (18 entries)
- Auth shim: `lib/megalith_web/controllers/dev/sign_in_as_controller.ex` (dev-only, `:dev_routes` compile-gated)
- Wallaby: `~> 0.30` (already in `mix.exs`); `:only` relaxed to `[:dev, :test]`
- chromedriver: system dep (assumed installed; macOS `brew install chromedriver`)
- Dev server: `mix phx.server` on `http://bemeda.lvh.me:4000` (lvh.me wildcard DNS → 127.0.0.1)
- Actor: `denis.gojak@spitex-bemeda.ch` (tenant_admin in `bemeda` tenant)

## Status

| Item | Status |
|---|---|
| 18 screenshots captured | ✅ DONE — 18/18 |
| Per-screenshot caption (this README) finalized post-capture | ✅ DONE |
| File size optimization run | ⏭ SKIPPED — `oxipng`/`optipng` not installed; raw PNG sizes are already <250 KB each (largest is 214 KB; total ~1.7 MB) |


---

# 5. ANTI-HALLUCINATION INSTRUCTIONS

1. **Do not cite filenames not in the table above** (Section 4). If you cannot remember a filename, say so explicitly.
2. **Tag every quantitative claim** (contrast ratios, padding values, spacing values) with confidence: `high` (verified against an inlined source), `medium` (visual estimate), or `low` (speculative).
3. **If you cannot see a screenshot**, say so explicitly — do not infer content from the slug or filename.
4. If the brief asks about routes (`/work/lanes`, `/projects`, etc.) and your inlined CONTEXT does not mention them, do not invent them.
5. The Megalith taxonomy uses **Person + UserMembership**, not "Klient" / "Client". The CRM domain uses **Contact + Lead**, not "Kunde". Avoid inventing entity types.

---

End of inline pack. If any section is truncated in your view, ask the user to repaste.
