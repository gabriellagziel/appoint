## Main (app-oint.com)

- FAQ standalone page missing
  - Evidence: No `marketing/pages/faq.tsx`; only FAQ section inside `contact.tsx` (marketing/pages/contact.tsx:169-179)
- Blog missing
  - Evidence: No `marketing/pages/blog*.tsx`
- Ambassador Program page missing
  - Evidence: No `marketing/pages/ambassador*.tsx`; grep found none

## Personal (personal.app-oint.com)

- No concrete Flutter UI for requested features (Home, Meeting Flow, Meeting Page, Groups/Family/Playtime)
  - Evidence: `appoint/lib/features/**` directories exist but are empty; grep for routes returned none

## Business (business.app-oint.com)

- Clients module not found
  - Evidence: No `dashboard/src/app/dashboard/clients/*`
- Payments module not found
  - Evidence: No `dashboard/src/app/dashboard/payments/*`

## Enterprise (enterprise.app-oint.com)

- Docs section (/docs) not found
  - Evidence: No `enterprise-app/src/app` content; only `test/`
- Onboarding flow not found
  - Evidence: Not present in codebase
- Enterprise dashboard (API keys/logs/stats) not found
  - Evidence: Not present in codebase

## Admin (admin.app-oint.com)

- Ads (3 free) module not found
  - Evidence: No `admin/src/app/admin/ads/*`
- Fraud module not found
  - Evidence: No `admin/src/app/admin/fraud/*`

## DUPLICATES / Potential Conflicts

- Enterprise content appears under `marketing/pages/enterprise.tsx`, while live `enterprise.app-oint.com` responds 200 but not tied to this codebase
  - Evidence: CURL 200 for enterprise subdomain; code for enterprise content under apex marketing

