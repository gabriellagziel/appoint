# App-Oint Feature Flags

This document lists all environment-based feature toggles across the App-Oint platform.

---

## 1. Status Badge
- **Key**: `NEXT_PUBLIC_STATUS_BADGE` (web apps) / `STATUS_BADGE` (server/env)
- **Values**:
  - `on` (default if unset): Show a small green/red/gray dot in the app header.
    - Polls `/api/healthz` every 30s
    - Green = OK, Red = Down, Gray = Unknown (not yet checked)
  - `off`: Hide the status badge
- **Applies to**: `admin.app-oint.com`, `business.app-oint.com`, `enterprise.app-oint.com`

---

## 2. Status Aggregator
- **Keys**:
  - `STATUS_ADMIN_URL` → URL to admin app origin (used for `/api/healthz` and `/api/version`)
  - `STATUS_BUSINESS_URL` → URL to business app origin
  - `STATUS_ENTERPRISE_URL` → URL to enterprise app origin
- **Purpose**: Feeds `/api/status` on the enterprise app (powers `/status` HTML and JSON API)
- **Applies to**: `enterprise.app-oint.com`

---

## 3. Sentry Observability
- **Keys**: `SENTRY_DSN`, `SENTRY_AUTH_TOKEN`, `SENTRY_ORG`, `SENTRY_PROJECT`, `SENTRY_ENV`
- **Optional tuning**: `SENTRY_TRACES_SAMPLE_RATE`, `REDACTED_TOKEN`
- **Purpose**: Enables Sentry error tracking and CI sourcemap uploads
- **Applies to**: All three Next.js apps

Notes:
- Sentry init is env-gated and includes PII scrubbing via `beforeSend`
- CI sets `SENTRY_RELEASE` to the current commit SHA (used by `/api/version`)

---

## 4. Rate Limit Configuration (Hot-Tunable)
- **Firestore Doc**: `config/rateLimits/{default}`
- **Fields (example)**:
```
{
  "requestsPerMin": 60,
  "burst": 10,
  "perIP": true,
  "perUID": true
}
```
- **Purpose**: Control request volume to Functions endpoints without redeploy
- **Applies to**: All server-side Functions

---

## 5. Misc Environment Keys
- `BUILD_TIME` (injected automatically via Next DefinePlugin)
- `SENTRY_RELEASE` (set in CI to the current commit SHA)
- `ANALYZE` (set `true` to enable `@next/bundle-analyzer` during build)

---

## Notes
- Public env vars (`NEXT_PUBLIC_*`) are embedded at build time
- Private env vars must be set in server env / CI secrets and not prefixed with `NEXT_PUBLIC_`
- For staging vs prod, set values in Hosting/CI per environment


