### Marketing (Apex app-oint.com)

- `/` → landing with cards linking to subdomains
  - Evidence: marketing/pages/index.tsx:59-85, 86-110, 111-134
- `/business/api-docs`
  - Evidence: marketing/pages/business/api-docs.tsx:3-12, 25-47
- `/enterprise`
  - Evidence: marketing/pages/enterprise.tsx:69-76, 101-128
- `/contact` (includes Support + FAQ section)
  - Evidence: marketing/pages/contact.tsx:15-23, 169-179
- `robots.txt`, `sitemap.xml`
  - Evidence: marketing/public/robots.txt:9-12; marketing/public/sitemap.xml:3-11

### Business (business.app-oint.com)

- `/dashboard`
  - Evidence: dashboard/src/app/dashboard/page.tsx:19-22
- `/dashboard/appointments`
  - Evidence: dashboard/src/app/dashboard/appointments/page.tsx:20-41
- `/dashboard/appointments/new`
  - Evidence: dashboard/src/app/dashboard/appointments/new/page.tsx:1-3
- `/dashboard/reports`
  - Evidence: dashboard/src/app/dashboard/reports/page.tsx:20-61
- `/api/auth/[...nextauth]`
  - Evidence: dashboard/src/app/api/auth/[...nextauth]/route.ts:13-21, 40-46
- `/api/health`
  - Evidence: dashboard/src/app/api/health/route.ts:7-15

### Enterprise (enterprise.app-oint.com)

- Landing served (no Next.js app here). Marketing enterprise page exists under apex at `/enterprise`.
  - Evidence: marketing/pages/enterprise.tsx:69-76, 101-128

### Admin (admin.app-oint.com)

- `/` (root) → Admin dashboard (with mobile redirect to `/quick`)
  - Evidence: admin/src/app/page.tsx:20-29; admin/src/middleware.ts:82-89
- Guarded admin routes (RBAC via env and token)
  - Evidence: admin/src/middleware.ts:6-12, 21-31, 38-46, 70-79, 101-112
- `/admin/ambassadors`
  - Evidence: admin/src/app/admin/ambassadors/page.tsx:11-21
- `/admin/analytics`
  - Evidence: admin/src/app/admin/analytics/page.tsx:10-22
- `/admin/system`
  - Evidence: admin/src/app/admin/system/page.tsx:171-181, 228-236
- Other placeholders exist: `/admin/payments`, `/admin/users`, `/admin/settings`, etc.
  - Evidence: admin/src/app/admin/payments/page.tsx (file exists); admin/src/app/admin/users/page.tsx (file exists)

### Personal (personal.app-oint.com)

- No concrete Flutter routes/screens found in `appoint/lib/**` (directories empty or placeholders)
  - Evidence: appoint/lib/features/meeting_flow/steps (empty), widgets (empty); grep yielded no routes

