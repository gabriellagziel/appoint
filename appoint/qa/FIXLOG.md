# FIXLOG — App-Oint Personal User App (appoint/)

This file lists all changes made during the QA & Stabilization audit.

## 2025-08-09

- test/widget_test.dart
  - fix(test): Wrap `AppOintApp` with `ProviderScope` to satisfy Riverpod in tests.

- lib/services/security/group_share_security_service.dart
  - fix(security): Safe-cast Firestore document data to `Map<String, dynamic>` before reading `timestamp` to prevent runtime type errors.

- qa/AUDIT_REPORT.md
  - chore(audit): Add comprehensive audit report with status, logs, improvements, and verdict.

- dashboard/src/app/dashboard/layout.tsx (dashboard web app)
  - chore(ux): Compose app dashboard route inside shared `DashboardLayout` for consistent Navbar/Sidebar.

- dashboard/src/app/dashboard/page.tsx (dashboard web app)
  - chore(ux): Replace placeholder with overview cards, quick actions, and trend chart using mock data.

- dashboard/src/components/Sidebar.tsx (dashboard web app)
  - chore(a11y): Add `aria-current` and `aria-label` for active link and sidebar; adjust background token.

Notes:
- Analyzer still reports warnings (`avoid_print`, `deprecated_member_use` of `.withOpacity`, and unused fields). These are non-blocking and queued as improvements in `qa/AUDIT_REPORT.md`.



