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
