# App-Oint — Personal User Subdomain (app.app-oint.com)

## One-liner
Conversational time organizer: meetings, smart reminders, family controls, Playtime, group sharing, and bridges to Business/Enterprise — PWA first.

## Stack
- Client: Flutter Web (PWA) — Riverpod, GoRouter, design tokens
- Backend: Firebase (Auth Google-only, Firestore, Functions, FCM, Storage)
- Maps: Google Places (validation) + OSM/Leaflet (render)
- Payments: Stripe Web (€4/mo; kids free)

## Core UX Flows
1) Create Meeting (stepper: Type → Participants → Where → When → Extras → Review)
   - Types: oneOnOne, group, event (≥4), openCall (virtual-only), business, playtime
   - Rules: ≥4 ⇒ event; openCall ⇒ no location; event ⇒ forms/checklist/chat
2) Meeting Page (live): details, statuses, chat, late/arrived, Go/Join
3) Reminders: me/family, recurrence, checklist, in-app notifications
4) Groups & Sharing: invite links (WhatsApp etc.), reuse groups
5) Playtime: physical/virtual; “what to bring”; child approvals
6) Family: parent/child linking, approvals, dashboards
7) Bridges: Business discovery/booking; Enterprise API display
8) PWA & Monetization: A2HS cadence; ad gate on confirm (no ads for kids/premium)

## Data (key collections)
- `/users`, `/meetings`, `/meeting_messages`, `/groups`, `/group_invites`,
  `/reminders`, `/families`, `/ad_impressions`, `/analytics_events`

## File map (expected)
- `lib/features/meeting/create_flow/**` (new stepper engine)
- `lib/features/meeting/meeting_page.dart`
- `lib/features/reminders/**`
- `lib/features/groups/**`
- `lib/features/playtime/**`
- `lib/features/family/**`
- `lib/features/pwa/**`
- `lib/features/ads/ad_gate.dart`
- `functions/src/**`
- `web/index.html`, `web/manifest.json`, `web/flutter_service_worker.js`
- `lib/theme/**`, `lib/router.dart` or `lib/app_router.dart`


