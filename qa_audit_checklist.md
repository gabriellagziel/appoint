### QA Audit Checklist – Round 1 (Initial Scan)

> This checklist is generated from an automated scan (grep, analyzer logs, manual spot‐checks).
> It will be continuously updated and ticked off as fixes land in `fix/qa-cleanup-round-1`.

---

#### Legend
- [ ] Open
- [/] Partially fixed – follow-up required
- [x] Fixed & verified

---

## 1. Core / Infrastructure

- [ ] **Logging** – Replace `print()` / `debugPrint()` with structured logger across codebase (e.g. `Logger` or `flutter_logs`).
- [ ] **Unhandled Futures** – Wrap potentially throwing async calls in `try {} catch {}` with meaningful handling or propagate up.
- [ ] **Null-safety** – Audit every explicit `!.` and add graceful fallback or early return where applicable.
- [ ] **Environment Secrets** – Ensure no hard-coded API keys / tokens inside repo; move to env files.
- [ ] **Dead Code** – Remove unused imports, private helpers flagged by analyzer (see `flutter_final_analysis.txt`).

## 2. Localization (l10n)

- [ ] **Missing Strings** – Hundreds of `undefined_getter` / `undefined_method` errors for `AppLocalizations` keys (see `flutter_analysis_report.txt`).  Needs end-to-end reconciliation of `.arb` files + code.
    - Admin → `admin_broadcast_*`, `admin_dashboard_*`
    - Dashboard → `dashboard_screen.dart`
    - Family → `family_dashboard_screen.dart`
    - Invite → `invite_*`
    - Notifications → `notification_*`
    - Playtime → `playtime_*`
    - Profile → `user_profile_screen.dart`
    - Wrapper / Widgets → `auth_wrapper.dart`, `whatsapp_share_button.dart`
- [ ] **Hard-coded User-visible Strings** – Scan & extract to l10n (still many TODOs marked `// TODO(l10n)`).

## 3. Auth

- [x] **`user_role_provider`** – Now derives role from Firebase custom claims and falls back gracefully.
- [ ] **`login_screen.dart`** – TODO: notification token saving + auth state refresh – implement & test.

## 4. Booking / Scheduler

- [ ] **`booking_confirm_screen.dart`** – Raw `debugPrint` inside catch; replace with error handler + UX feedback.
- [ ] **`booking_request_screen.dart`** – Commented out error handling; restore proper flows.
- [ ] **Edge-cases** – Double booking race-condition when offline sync merges.

## 5. Notifications

- [ ] **`broadcast_service.dart`** – Uses `print()` instead of logger; errors swallowed.
- [ ] **`notification_settings_screen.dart`** – `AppLocalizations` keys missing; FCM token display not localized.

## 6. Rewards / Referrals / Ambassador

- [ ] Analyzer warns about unused helpers in `ambassador_dashboard_screen.dart`.
- [ ] Chart values cast to `double` unnecessarily – potential precision loss.

## 7. Payments / Subscriptions

- [/] **`subscription_service.dart`** – replaced raw `print` with `dart:developer` log; still needs error-handling for Stripe API failures.
- [ ] **UI** – `subscription_screen.dart` has TODO for billing history screen.

## 8. Studio / Business Module

- [ ] Dozens of TODO placeholders for booking, calendar, analytics, messages – need implementation or feature flags.
- [ ] Lat/Lng parsing: use `?.toDouble()` guards.

## 9. Playtime Module

- [ ] Missing l10n keys across hub & dashboard.
- [ ] TODO: friend picker dialog.

## 10. Settings / Preferences

- [ ] `enhanced_settings_screen.dart` – Multiple unimplemented dialogs & actions.

## 11. Miscellaneous

- [ ] Replace all commented-out debugPrint lines with proper logging or delete.
- [ ] Remove lingering placeholder comments like `// TODO(username): …` after implementation.

---

> **Next step:** Prioritise critical compile/runtime blockers (Localization errors) then iterate through remaining items.  All fixes will be committed individually with clear messages and the above checkboxes will be updated accordingly.