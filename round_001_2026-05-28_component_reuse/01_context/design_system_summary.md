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
