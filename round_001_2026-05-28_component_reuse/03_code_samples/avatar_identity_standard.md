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
