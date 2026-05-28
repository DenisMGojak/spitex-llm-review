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
