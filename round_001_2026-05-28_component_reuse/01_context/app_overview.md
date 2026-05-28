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
