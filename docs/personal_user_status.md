# App‑Oint — Personal Frontend Handoff & Runbook

**Scope**: Personal User app (web/PWA) at `app.app-oint.com`. This doc is a one‑pager for onboarding, QA, and release.

---

## 1) What’s Implemented (✅)

### Core user journeys

* **Create Meeting Flow (modular)**

  * Type‑aware steps; review validation; submit → Firestore `/meetings/{id}` → route to `/#/meeting/{id}`.
  * Open Call shows **Join** (no map). Events (≥4 participants) unlock event sections.
* **Meeting Details Page parity**

  * Conditional UI (location vs virtual), **Go / Join**, late/arrived, checklist/chat sections for event/playtime.
  * **Guest mode**: read‑only view + **Sign in / Get app** CTA; invalid/expired handling.
* **Reminders**

  * Create, dashboard, recurrence badge, next‑occurrence text, **mark done** (optimistic), **Snooze**.
  * **Default Snooze preference** (10/15/30) in Settings; dashboard tooltip reflects current pref.
  * **Per‑reminder Snooze menu** (5/10/15/30) via ⋮, default Snooze button uses user pref.
* **WhatsApp Group Share** (earlier work)

  * Deep links; guest read‑only; auto‑join for signed‑in users; tracking params preserved.

### Analytics & data

* **Analytics breadcrumbs** (never‑throw helper)

  * `create_meeting_submitted`, `meeting_details_opened`, `guest_meeting_viewed`, `meeting_action(join/go)`, `meeting_status(late/arrived)`.
  * `reminder_created`, `reminder_list_opened`, `reminder_snoozed {minutes, recurrence, hasTime}`, `reminder_marked_done`.
  * Stored at `/analytics_events/{uid or _anon}/events/{autoId}`.
* **Security rules** (analytics)

  * Writer‑only on events; admin‑only read via custom claims.
* **BigQuery pipeline (optional)**

  * Cloud Function: Firestore → BigQuery (`app_oint.analytics_events`), `props_json` payload.

---

## 2) Project Map (paths & files)

### Client (Flutter Web)

* **Routing**: `appoint/lib/app_router.dart`

  * `/#/create/meeting` → Create flow screen
  * `/#/meeting/:id` → `MeetingDetailsScreen` (guest aware inside screen)
  * `/#/reminders`, `/#/reminders/create`
  * `/#/settings/notifications` (Default Snooze)
* **Create Flow**: `appoint/lib/features/meeting/create_flow/**`

  * `controller/create_meeting_flow_controller.dart`
  * `steps/*` (incl. `review_step.dart` with validation & submit)
  * `create_meeting_flow_screen.dart`
* **Meeting Details**: `appoint/lib/features/meeting/screens/meeting_details_screen.dart`
* **Reminders**: `appoint/lib/features/reminders/**/*`

  * `reminders_dashboard.dart`, `create_reminder_screen.dart`, `providers.dart`, `services/reminder_service.dart`
* **Settings (Snooze)**:

  * `features/settings/models/user_settings.dart`
  * `features/settings/providers/settings_providers.dart`
  * `features/settings/screens/notification_settings_screen.dart`
* **Auth stream**: `appoint/lib/services/auth/auth_providers.dart` (`authUserProvider`)
* **Analytics**: `appoint/lib/services/analytics_service.dart`
* **Web bootstrap**: `web/index.html` (hash routing loader; no SW in preview)

### Cloud Functions (optional analytics sink)

* `functions/src/analytics_to_bq.ts`
* `functions/src/index.ts`
* `functions/package.json`, `functions/tsconfig.json`

### Firestore rules

* `firestore.rules` — analytics writer‑only + admin read on parent doc

---

## 3) How to Run

### Dev (Chrome)

```bash
flutter clean && flutter pub get
flutter run -d chrome
```

### Prod Preview (serve build)

```bash
flutter clean && flutter pub get && flutter build web --release
cd build/web
npx serve -s -l 3020
# Open → http://localhost:3020/
# Then → http://localhost:3020/#/reminders  and  http://localhost:3020/#/create/meeting
```

**Note**: Always serve from `build/web`. If you see a blank page: Chrome DevTools → Application → Service Workers → **Unregister**; Clear storage; hard reload.

---

## 4) QA Checklist (5 min)

### Meetings

* `/#/create/meeting` → leave Title/Time empty → “Missing: …” appears; Create disabled.
* Fill valid data → Create → routes to `/#/meeting/{id}`.
* OpenCall → shows **Join**, no map. Event (≥4) → event sections visible.
* Incognito `/#/meeting/{id}` → guest read‑only view + CTA; invalid id → friendly message; past meeting → “ended”.

### Reminders

* `/#/reminders/create` → Save disabled until text entered.
* Create **daily** reminder → dashboard shows “Repeats daily — next …”.
* Snooze via main button → uses default pref from `/#/settings/notifications`.
* Snooze via ⋮ menu → 5/10/15/30 works; timestamp updates.
* Toggle **Done** → persists without reload.

### Analytics

* Firestore: `/analytics_events/{uid or _anon}/events` shows entries for actions above.
* (If BQ enabled) BigQuery `app_oint.analytics_events` receives rows.

---

## 5) Monitoring & Analytics

* Collector: `lib/services/analytics_service.dart` (fallback to Firestore; optional Firebase Analytics later).
* Event schema: `{ name, props, ts, uid? }` (props as map; in BQ as `props_json`).
* Suggested dashboards: Meeting conversion (create→details), Reminder engagement (snooze/done), Guest link sources.

---

## 6) Security & Privacy

* **Analytics events**: writer‑only (no public reads). Admins read parent via custom claims.
* **Reminders & Meetings**: ensure owner/participant rules (outside this doc’s changes) are enforced per project policy.
* **Guests**: shared links show limited info + CTA, no edits.

---

## 7) Deploy Notes

### Frontend

* Build: `flutter build web --release`
* Serve from `build/web` (CDN or static hosting). Prefer hash URLs for stability.

### Cloud Functions (optional)

```bash
cd functions
npm i
npm run build
firebase deploy --only functions:analyticsToBigQuery
# Optional env:
#   BQ_DATASET=app_oint  BQ_TABLE=analytics_events
```

### Firestore Rules

* Publish `firestore.rules` (analytics section included). Verify with the Rules Playground before production.

---

## 8) Known Items / Next Tasks

* **Create Flow**: additional step polish (microcopy, edge validation, back‑to‑step anchors).
* **Meeting Details**: attachments & forms builder (events), richer participant roles.
* **Guest**: optional Accept intent capture + download prompt analytics.
* **Reminders**: categories and per‑category default snooze; templates.
* **PWA**: enable SW for prod, add “Clear cached app” helper action.
* **Rules**: confirm meetings/reminders ownership and participant scopes.

---

## 9) Troubleshooting

* **White screen on prod build**: ensure server root is `build/web`; clear SW/storage; confirm `main.dart.js` & `flutter.js` 200 OK.
* **Analytics not writing**: check auth state; security rules (writer‑only); `_anon` path should still write.
* **Guest link params**: deep link meta parser is tolerant; verify query params on incoming URLs.

---

## 10) Point of Contact

* Personal Frontend: this doc + commit history in `feature/personal-user-spec-apply`.
* Data/Analytics: Cloud Function `analyticsToBigQuery` owner (see repo CODEOWNERS if present).

---

**End of handoff — you can onboard a new dev with this page, run QA, and ship.**


