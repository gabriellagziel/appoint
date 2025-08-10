# Personal User Spec — Code Audit (Exists / Partial / Missing)

| Area | Status | Files / Notes |
|------|--------|----------------|
| Create Meeting Flow Engine (stepper) | Missing | Legacy: `lib/features/meeting_creation/meeting_flow_entry.dart` used for preview flow |
| Meeting Types & Rules (≥4 ⇒ event, openCall no location) | Partial | `lib/features/meeting/screens/meeting_details_screen.dart` (type-driven UI to be verified) |
| Meeting Page (live sections, chat, actions) | Partial | `lib/features/meeting/screens/meeting_details_screen.dart`, widgets in `lib/features/meeting/widgets/` |
| WhatsApp Group Share + Guest funnel | Exists | `lib/features/meeting_share/**`, `lib/services/group_sharing_service.dart` |
| Reminders (create/edit, recurrence, family targets) | Missing | No obvious reminders module found |
| Groups (reuse) | Partial | Group UI/widgets under `lib/features/group/**` |
| Playtime (physical/virtual + checklist) | Missing | No `playtime` feature found |
| Family (parent/child, approvals) | Partial | Some group/family-adjacent pieces; needs dedicated flow |
| PWA (manifest, SW, A2HS cadence) | Missing/Partial | `web/index.html` exists; manifest/service worker linkage TBD |
| Ads Gate (free vs premium/kids) | Missing | No `features/ads` present |
| Router (GoRouter) unified | Partial | `lib/app_router.dart` and `lib/router/app_router.dart` both present; legacy route guarded |
| Theme tokens | Exists | `lib/theme/app_theme.dart`, `lib/theme/tokens.dart` |
| Functions: notifications/meetings/reminders/maps/bridges | Missing/Partial | No `functions/src` in repo root |

## Gaps & Actions
- Build modular Create Flow Engine under `lib/features/meeting/create_flow/**`
- Ensure Meeting Page reflects type-driven sections and creation data
- Implement Reminders (fields, recurrence, dashboard, FCM)
- Verify Family approvals & child restrictions
- Add `web/manifest.json` + confirm service worker + A2HS cadence
- Centralize GoRouter (remove duplicate routers)
- Confirm Ads gate and exemptions (premium/kids)
