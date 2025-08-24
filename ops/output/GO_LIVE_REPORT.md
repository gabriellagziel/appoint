# GO-LIVE REPORT

**Branch:** `fix/deploy-v1.0.2-restore`  
**Commit:** `fd8febda`  
**Date:** 2025-08-24T23:46:56+02:00

## 1) Domains Health (Prod)
```
  ==> ops/output/health_2025-08-24_2322.txt <==
  === HEALTH CHECK 2025-08-24T23:22:00+02:00 ===
  --- app-oint.com ---
  HTTP: 200
  HSTS: OK
  XFO:  
  CSP:  
  WARN: hotfix signature found
  
  --- business.app-oint.com ---
  HTTP: 200
  HSTS: OK
  XFO:  OK
  CSP:  OK
  Content: OK
  
  --- enterprise.app-oint.com ---
  HTTP: 200
  HSTS: OK
  XFO:  
  CSP:  
  Content: OK
  
  
  ==> ops/output/health_2025-08-24_2346.txt <==
  === HEALTH 2025-08-24T23:46:35+02:00 ===
  --- app-oint.com ---
  HTTP: 200
  HSTS: strict-transport-security: max-age=63072000
  OK
  XFO:  MISSING
  CSP:  MISSING
  CONTENT: HOTFIX-SIGNATURE
  --- business.app-oint.com ---
  HTTP: 200
  HSTS: strict-transport-security: max-age=31536000; includeSubDomains; preload
  OK
  XFO:  x-frame-options: SAMEORIGIN
  OK
  CSP:  content-security-policy: default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval' https:; style-src 'self' 'unsafe-inline' https:; img-src 'self' data: https:; font-src 'self' https: data:; connect-src 'self' https: wss:; frame-ancestors 'self'; base-uri 'self'; form-action 'self'
  OK
  CONTENT: CLEAN
  --- enterprise.app-oint.com ---
  HTTP: 200
  HSTS: strict-transport-security: max-age=63072000
  OK
  XFO:  MISSING
  CSP:  MISSING
  CONTENT: CLEAN
  
  ==> ops/output/health_enterprise_head.txt <==
  ---- HEAD https://REDACTED_TOKEN.vercel.app ----
  HTTP/2 200 
  age: 0
  cache-control: public, max-age=0, must-revalidate
  content-security-policy: default-src 'self' vercel.com *.vercel.com vercel.live instant-preview-site.vercel.app instant-preview-site-k5oiz7uj7.vercel.sh;script-src 'self' 'unsafe-eval' 'unsafe-inline' va.vercel-scripts.com vercel.com *.vercel.com vercel.live instant-preview-site.vercel.app instant-preview-site-k5oiz7uj7.vercel.sh;style-src 'self' 'unsafe-inline' vercel.com *.vercel.com vercel.live instant-preview-site.vercel.app instant-preview-site-k5oiz7uj7.vercel.sh;font-src 'self' vercel.com *.vercel.com vercel.live instant-preview-site.vercel.app instant-preview-site-k5oiz7uj7.vercel.sh *.gstatic.com;connect-src data: *;
  content-type: text/html; charset=utf-8
  date: Sun, 24 Aug 2025 19:09:52 GMT
  feature-policy: fullscreen 'self'; camera 'none'
  link: <https://instant-preview-site.vercel.app/_next/static/media/569ce4b8f30dc480-s.p.woff2>; rel=preload; as="font"; crossorigin=""; type="font/woff2", <https://instant-preview-site.vercel.app/_next/static/media/93f479601ee12b01.p.woff2>; rel=preload; as="font"; crossorigin=""; type="font/woff2"
  referrer-policy: origin-when-cross-origin
  server: Vercel
  strict-transport-security: max-age=31536000; includeSubDomains; preload
  vary: rsc, next-router-state-tree, next-router-prefetch, next-router-segment-prefetch
  x-content-type-options: nosniff
  x-dns-prefetch-control: on
  x-download-options: noopen
  x-edge-runtime: 1
  x-frame-options: DENY
  x-matched-path: /[[...slug]]
  x-robots-tag: noindex
  x-vercel-cache: MISS
  x-vercel-id: fra1::fra1::REDACTED_TOKEN
  x-xss-protection: 0
  
  ----------------------------
```

## 2) Headers
Expect HSTS, XFO, CSP. If missing, listed above.

## 3) Changed Files
```
  .firebaserc
  .githooks/pre-commit
  .github/workflows/android-build.yml
  .github/workflows/auto-merge.yml
  .github/workflows/branch-protection-check.yml
  .github/workflows/ci-baseline.yml
  .github/workflows/ci-cd-pipeline.yml
  .github/workflows/ci.yml
  .github/workflows/codeql.yml
  .github/workflows/core-ci.yml
  .github/workflows/coverage-badge.yml
  .github/workflows/deploy-production.yml
  .github/workflows/digitalocean-ci.yml
  .github/workflows/docker_push.yml
  .github/workflows/flutter-ci.yml
  .github/workflows/ios-build.yml
  .github/workflows/ops-verify.yml
  .github/workflows/release.yml
  .github/workflows/security-qa.yml
  .github/workflows/security.yml
  .github/workflows/smoke-tests.yml
  .github/workflows/staging-deploy.yml
  .github/workflows/update_flutter_image.yml
  .github/workflows/watchdog.yml
  .github/workflows/web-deploy.yml
  .vscode/settings.json
  1{print
  Makefile
  OPS_CHEAT_SHEET.md
  README.md
  admin/.eslintrc.json
  admin/src/middleware.ts
  admin/vercel.json
  app-oint-admin
  app-oint-appoint
  app-oint-business
  app-oint-enterprise-app
  app-oint-marketing
  app/layout.tsx
  audit/urls/env_refs.tsv
  audit/urls/functions.tsv
  audit/urls/public_files.tsv
  audit/urls/raw_urls.tsv
  audit/urls/rewrites.tsv
  business/.gitignore
  business/middleware.ts
  business/pages/index.tsx
  business/public/index.html
  business/vercel.json
  dashboard/package-lock.json
  dashboard/src/app/api/health/route.test.ts
  dashboard/src/app/dashboard/layout.tsx
  dns_debug_after_changes.sh
  dns_fix.sh
  dns_fix_simple.sh
  enterprise-app/.gitignore
  enterprise-app/.next/BUILD_ID
  enterprise-app/.next/app-build-manifest.json
  enterprise-app/.next/app-path-routes-manifest.json
  enterprise-app/.next/build-manifest.json
  enterprise-app/.next/cache/.previewinfo
  enterprise-app/.next/cache/.rscinfo
  enterprise-app/.next/cache/webpack/client-production/0.pack
  enterprise-app/.next/cache/webpack/client-production/1.pack
  enterprise-app/.next/cache/webpack/client-production/2.pack
  enterprise-app/.next/cache/webpack/client-production/index.pack
  enterprise-app/.next/cache/webpack/client-production/index.pack.old
  enterprise-app/.next/cache/webpack/edge-server-production/0.pack
  enterprise-app/.next/cache/webpack/edge-server-production/index.pack
  enterprise-app/.next/cache/webpack/edge-server-production/index.pack.old
  enterprise-app/.next/cache/webpack/server-production/0.pack
  enterprise-app/.next/cache/webpack/server-production/1.pack
  enterprise-app/.next/cache/webpack/server-production/index.pack
  enterprise-app/.next/cache/webpack/server-production/index.pack.old
  enterprise-app/.next/diagnostics/build-diagnostics.json
  enterprise-app/.next/diagnostics/framework.json
  enterprise-app/.next/dynamic-css-manifest.json
  enterprise-app/.next/export-marker.json
  enterprise-app/.next/images-manifest.json
  enterprise-app/.next/next-minimal-server.js.nft.json
  enterprise-app/.next/next-server.js.nft.json
  enterprise-app/.next/package.json
  enterprise-app/.next/prerender-manifest.json
  enterprise-app/.next/react-loadable-manifest.json
  enterprise-app/.next/required-server-files.json
  enterprise-app/.next/routes-manifest.json
  enterprise-app/.next/server/app-paths-manifest.json
  enterprise-app/.next/server/chunks/611.js
  enterprise-app/.next/server/dynamic-css-manifest.js
  enterprise-app/.next/server/functions-config-manifest.json
  enterprise-app/.next/server/REDACTED_TOKEN.js
  enterprise-app/.next/server/middleware-build-manifest.js
  enterprise-app/.next/server/middleware-manifest.json
  enterprise-app/.next/server/REDACTED_TOKEN.js
  enterprise-app/.next/server/next-font-manifest.js
  enterprise-app/.next/server/next-font-manifest.json
  enterprise-app/.next/server/pages-manifest.json
  enterprise-app/.next/server/pages/404.html
  enterprise-app/.next/server/pages/500.html
  enterprise-app/.next/server/pages/_app.js
  enterprise-app/.next/server/pages/_app.js.nft.json
  enterprise-app/.next/server/pages/_document.js
  enterprise-app/.next/server/pages/_document.js.nft.json
  enterprise-app/.next/server/pages/_error.js
  enterprise-app/.next/server/pages/_error.js.nft.json
  enterprise-app/.next/server/server-reference-manifest.js
  enterprise-app/.next/server/server-reference-manifest.json
  enterprise-app/.next/server/webpack-runtime.js
  enterprise-app/.next/static/chunks/4bd1b696-c023c6e3521b1417.js
  enterprise-app/.next/static/chunks/58-a9a30b3a4e0ac291.js
  enterprise-app/.next/static/chunks/framework-a6e0b7e30f98059a.js
  enterprise-app/.next/static/chunks/main-app-c1532ef50aa77d54.js
  enterprise-app/.next/static/chunks/main-bae1aece680c75e1.js
  enterprise-app/.next/static/chunks/pages/_app-7d307437aca18ad4.js
  enterprise-app/.next/static/chunks/pages/_error-cb2a52f75f2162e2.js
  enterprise-app/.next/static/chunks/polyfills-42372ed130431b0a.js
  enterprise-app/.next/static/chunks/webpack-23055d52f9c766c3.js
  enterprise-app/.next/static/tmqmjiLa86gsgJzoqMUsX/_buildManifest.js
  enterprise-app/.next/static/tmqmjiLa86gsgJzoqMUsX/_ssgManifest.js
  enterprise-app/.next/trace
  enterprise-app/.next/types/cache-life.d.ts
  enterprise-app/.next/types/package.json
  enterprise-app/.next/types/routes.d.ts
  enterprise-app/.next/types/validator.ts
  enterprise-app/middleware.ts
  enterprise-app/package-lock.json
  enterprise-app/package.json
  enterprise-app/pages/index.tsx
  enterprise-app/vercel.json
  env.production
  final_smoke.sh
  firebase.json
  fix_domains.sh
  fix_domains_cli.sh
  functions/.eslintignore
  functions/eslint.config.mjs
  functions/index.js
  functions/lib/alerts.js
  functions/lib/ambassador-automation.js
  functions/lib/ambassador-notifications.js
  functions/lib/ambassadors.js
  functions/lib/analytics.js
  functions/lib/billingEngine.js
  functions/lib/broadcasts.js
  functions/lib/businessApi.js
  functions/lib/health.js
  functions/lib/ics.js
  functions/lib/index.js
  functions/lib/meetings.js
  functions/lib/oauth.js
  functions/lib/server.js
  functions/lib/stripe.js
  functions/lib/validation.js
  functions/lib/webhooks.js
  functions/package-lock.json
  functions/package.json
  functions/src/stripe.ts
  functions/tsconfig.json
  go-live.sh
  health_check.sh
  lib/features/studio_business/screens/business_calendar_screen.dart
  lib/l10n/app_en.arb
  lib/l10n/app_localizations.dart
  lib/l10n/app_localizations_en.dart
  lib/main.dart
  lib/services/fcm_service.dart
  lib/services/stripe_service.dart
  marketing/middleware.backup.ts
  marketing/middleware.ts
  marketing/next.config.js
  marketing/pages/index.tsx
  marketing/public/locales/am/common.json
  marketing/public/locales/am/errors.json
  marketing/public/locales/am/features.json
  marketing/public/locales/am/pricing.json
  marketing/public/locales/ar/about.json
  marketing/public/locales/ar/common.json
  marketing/public/locales/ar/contact.json
  marketing/public/locales/ar/enterprise.json
  marketing/public/locales/ar/errors.json
  marketing/public/locales/ar/features.json
  marketing/public/locales/ar/pricing.json
  marketing/public/locales/bg/about.json
  marketing/public/locales/bg/common.json
  marketing/public/locales/bg/contact.json
  marketing/public/locales/bg/enterprise.json
  marketing/public/locales/bg/errors.json
  marketing/public/locales/bg/features.json
  marketing/public/locales/bg/pricing.json
  marketing/public/locales/bn/pricing.json
  marketing/public/locales/bn_BD/about.json
  marketing/public/locales/bn_BD/common.json
  marketing/public/locales/bn_BD/contact.json
  marketing/public/locales/bn_BD/enterprise.json
  marketing/public/locales/bn_BD/errors.json
  marketing/public/locales/bn_BD/features.json
  marketing/public/locales/bn_BD/pricing.json
  marketing/public/locales/bs/contact.json
  marketing/public/locales/bs/enterprise.json
  marketing/public/locales/ca/errors.json
  marketing/public/locales/ca/features.json
  marketing/public/locales/ca/pricing.json
  marketing/public/locales/cs/common.json
  marketing/public/locales/cs/contact.json
  marketing/public/locales/cs/enterprise.json
  marketing/public/locales/cs/errors.json
  marketing/public/locales/cs/pricing.json
  marketing/public/locales/cy/about.json
  marketing/public/locales/cy/common.json
  marketing/public/locales/cy/contact.json
  marketing/public/locales/cy/enterprise.json
  marketing/public/locales/cy/errors.json
  marketing/public/locales/cy/features.json
  marketing/public/locales/da/common.json
  marketing/public/locales/da/contact.json
  marketing/public/locales/da/enterprise.json
  marketing/public/locales/da/features.json
  marketing/public/locales/de/about.json
  marketing/public/locales/de/common.json
  marketing/public/locales/de/contact.json
  marketing/public/locales/de/errors.json
  marketing/public/locales/de/features.json
  marketing/public/locales/de/pricing.json
  marketing/public/locales/en/about.json
  marketing/public/locales/en/common.json
  marketing/public/locales/en/enterprise.json
  marketing/public/locales/en/errors.json
  marketing/public/locales/en/features.json
  marketing/public/locales/en/pricing.json
  marketing/public/locales/es/common.json
  marketing/public/locales/es/contact.json
  marketing/public/locales/es/enterprise.json
  marketing/public/locales/es/features.json
  marketing/public/locales/es/pricing.json
  marketing/public/locales/es_419/about.json
  marketing/public/locales/es_419/common.json
  marketing/public/locales/es_419/errors.json
  marketing/public/locales/es_419/features.json
  marketing/public/locales/es_419/pricing.json
  marketing/public/locales/et/about.json
  marketing/public/locales/et/common.json
  marketing/public/locales/et/contact.json
  marketing/public/locales/et/enterprise.json
  marketing/public/locales/et/pricing.json
  marketing/public/locales/eu/about.json
  marketing/public/locales/eu/common.json
  marketing/public/locales/eu/contact.json
  marketing/public/locales/eu/features.json
  marketing/public/locales/eu/pricing.json
  marketing/public/locales/fa/common.json
  marketing/public/locales/fa/enterprise.json
  marketing/public/locales/fa/errors.json
  marketing/public/locales/fa/features.json
  marketing/public/locales/fa/pricing.json
  marketing/public/locales/fi/about.json
  marketing/public/locales/fi/common.json
  marketing/public/locales/fi/errors.json
  marketing/public/locales/fi/pricing.json
  marketing/public/locales/fo/about.json
  marketing/public/locales/fo/contact.json
  marketing/public/locales/fo/enterprise.json
  marketing/public/locales/fo/pricing.json
  marketing/public/locales/fr/contact.json
  marketing/public/locales/fr/errors.json
  marketing/public/locales/fr/pricing.json
  marketing/public/locales/ga/common.json
  marketing/public/locales/ga/enterprise.json
  marketing/public/locales/ga/errors.json
  marketing/public/locales/gl/about.json
  marketing/public/locales/gl/enterprise.json
  marketing/public/locales/gl/features.json
  marketing/public/locales/gl/pricing.json
  marketing/public/locales/ha/about.json
  marketing/public/locales/ha/common.json
  marketing/public/locales/ha/contact.json
  marketing/public/locales/ha/features.json
  marketing/public/locales/ha/pricing.json
  marketing/public/locales/he/common.json
  marketing/public/locales/he/contact.json
  marketing/public/locales/he/enterprise.json
  marketing/public/locales/hi/about.json
  marketing/public/locales/hi/common.json
  marketing/public/locales/hi/contact.json
  marketing/public/locales/hi/enterprise.json
  marketing/public/locales/hi/features.json
  marketing/public/locales/hi/pricing.json
  marketing/public/locales/hr/common.json
  marketing/public/locales/hr/contact.json
  marketing/public/locales/hr/enterprise.json
  marketing/public/locales/hr/pricing.json
  marketing/public/locales/hu/about.json
  marketing/public/locales/hu/common.json
  marketing/public/locales/hu/contact.json
  marketing/public/locales/hu/enterprise.json
  marketing/public/locales/hu/errors.json
  marketing/public/locales/hu/features.json
  marketing/public/locales/id/common.json
  marketing/public/locales/id/contact.json
  marketing/public/locales/id/enterprise.json
  marketing/public/locales/id/features.json
  marketing/public/locales/id/pricing.json
  marketing/public/locales/is/common.json
  marketing/public/locales/is/contact.json
  marketing/public/locales/is/features.json
  marketing/public/locales/it/about.json
  marketing/public/locales/it/contact.json
  marketing/public/locales/it/enterprise.json
  marketing/public/locales/it/errors.json
  marketing/public/locales/ja/about.json
  marketing/public/locales/ja/enterprise.json
  marketing/public/locales/ja/errors.json
  marketing/public/locales/ja/pricing.json
  marketing/public/locales/ko/about.json
  marketing/public/locales/ko/common.json
  marketing/public/locales/ko/enterprise.json
  marketing/public/locales/ko/features.json
  marketing/public/locales/lt/contact.json
  marketing/public/locales/lt/errors.json
  marketing/public/locales/lv/about.json
  marketing/public/locales/lv/errors.json
  marketing/public/locales/lv/features.json
  marketing/public/locales/mk/about.json
  marketing/public/locales/mk/common.json
  marketing/public/locales/mk/contact.json
  marketing/public/locales/ms/common.json
  marketing/public/locales/ms/contact.json
  marketing/public/locales/ms/enterprise.json
  marketing/public/locales/ms/pricing.json
  marketing/public/locales/mt/enterprise.json
  marketing/public/locales/mt/errors.json
  marketing/public/locales/mt/features.json
  marketing/public/locales/mt/pricing.json
  marketing/public/locales/nl/about.json
  marketing/public/locales/nl/contact.json
  marketing/public/locales/nl/enterprise.json
  marketing/public/locales/nl/errors.json
  marketing/public/locales/nl/features.json
  marketing/public/locales/nl/pricing.json
  marketing/public/locales/no/about.json
  marketing/public/locales/no/common.json
  marketing/public/locales/no/errors.json
  marketing/public/locales/no/features.json
  marketing/public/locales/pl/about.json
  marketing/public/locales/pl/common.json
  marketing/public/locales/pl/contact.json
  marketing/public/locales/pl/enterprise.json
  marketing/public/locales/pl/errors.json
  marketing/public/locales/pt/about.json
  marketing/public/locales/pt/common.json
  marketing/public/locales/pt/contact.json
  marketing/public/locales/pt/errors.json
  marketing/public/locales/pt_BR/about.json
  marketing/public/locales/pt_BR/common.json
  marketing/public/locales/pt_BR/enterprise.json
  marketing/public/locales/pt_BR/errors.json
  marketing/public/locales/ro/errors.json
  marketing/public/locales/ro/pricing.json
  marketing/public/locales/ru/common.json
  marketing/public/locales/ru/contact.json
  marketing/public/locales/ru/enterprise.json
  marketing/public/locales/sk/common.json
  marketing/public/locales/sk/errors.json
  marketing/public/locales/sk/pricing.json
  marketing/public/locales/sl/contact.json
  marketing/public/locales/sl/enterprise.json
  marketing/public/locales/sl/pricing.json
  marketing/public/locales/sq/errors.json
  marketing/public/locales/sq/pricing.json
  marketing/public/locales/sr/enterprise.json
  marketing/public/locales/sr/errors.json
  marketing/public/locales/sr/features.json
  marketing/public/locales/sr/pricing.json
  marketing/public/locales/sv/about.json
  marketing/public/locales/sv/enterprise.json
  marketing/public/locales/th/contact.json
  marketing/public/locales/th/enterprise.json
  marketing/public/locales/th/errors.json
  marketing/public/locales/th/features.json
  marketing/public/locales/tr/common.json
  marketing/public/locales/tr/errors.json
  marketing/public/locales/tr/features.json
  marketing/public/locales/tr/pricing.json
  marketing/public/locales/uk/common.json
  marketing/public/locales/uk/contact.json
  marketing/public/locales/uk/errors.json
  marketing/public/locales/uk/features.json
  marketing/public/locales/uk/pricing.json
  marketing/public/locales/ur/common.json
  marketing/public/locales/ur/contact.json
  marketing/public/locales/ur/enterprise.json
  marketing/public/locales/ur/errors.json
  marketing/public/locales/ur/features.json
  marketing/public/locales/ur/pricing.json
  marketing/public/locales/vi/about.json
  marketing/public/locales/vi/contact.json
  marketing/public/locales/vi/enterprise.json
  marketing/public/locales/vi/errors.json
  marketing/public/locales/vi/features.json
  marketing/public/locales/vi/pricing.json
  marketing/public/locales/zh/contact.json
  marketing/public/locales/zh/errors.json
  marketing/public/locales/zh/features.json
  marketing/public/locales/zh/pricing.json
  marketing/public/locales/zh_Hant/about.json
  marketing/public/locales/zh_Hant/common.json
  marketing/public/locales/zh_Hant/features.json
  marketing/public/locales/zh_Hant/pricing.json
  marketing/public/logo.svg
  marketing/public/next.svg
  marketing/public/sitemap.xml
  marketing/public/splash.html
  marketing/public/vercel.svg
  marketing/public/window.svg
  marketing/vercel.backup.json
  marketing/vercel.json
  middleware.ts
  monitor_personal_ssl.sh
  ops/audit/EXEC_SUMMARY.md
  ops/audit/subdomains/CURL.md
  ops/audit/subdomains/DNS_DOMAINS.md
  ops/audit/subdomains/ENVS.md
  ops/audit/subdomains/EXEC_SUMMARY.md
  ops/audit/subdomains/GAPS.md
  ops/audit/subdomains/ROUTES.md
  ops/audit/subdomains/SUBDOMAINS_MATRIX.md
  ops/audit/subdomains/UI_CHECKLIST.md
  ops/audit/tests/i18n.md
  ops/audit/urls/DUPLICATES.md
  ops/audit/urls/INVENTORY.md
  ops/audit/urls/SUMMARY.json
  ops/audit/urls/TODO.md
  ops/audit/urls/curl_report.md
  ops/audit/urls/env_refs.tsv
  ops/audit/urls/functions.tsv
  ops/audit/urls/pid
  ops/audit/urls/public_files.tsv
  ops/audit/urls/raw_urls.tsv
  ops/audit/urls/rewrites.tsv
  ops/audit/urls/urls.json
  ops/audit/vercel/envs_business.md
  ops/audit/vercel/envs_dashboard.md
  ops/audit/vercel/envs_enterprise-app.md
  ops/audit/vercel/envs_marketing.md
  ops/audit/vercel/mapping.md
  ops/health_check.sh
  ops/inspect_app-oint.com.txt
  ops/inspect_business_domain.txt
  ops/inspect_www.app-oint.com.txt
  ops/output/health.md
  ops/output/health_business.md
  ops/output/health_business_after_dashboard.md
  ops/output/health_business_api_assign.md
  ops/output/health_business_api_fix.md
  ops/output/health_business_domain.md
  ops/output/health_business_fix.md
  ops/output/health_business_reset.md
  ops/output/health_enterprise.md
  ops/output/REDACTED_TOKEN.md
  ops/output/health_enterprise_head.txt
  ops/output/health_marketing.md
  ops/output/REDACTED_TOKEN.md
  ops/output/health_marketing_alias.md
  ops/output/health_marketing_alias_refresh.md
  ops/output/health_marketing_api_assign.md
  ops/output/health_marketing_api_fix.md
  ops/output/health_marketing_domains.md
  ops/output/health_marketing_domains_final.md
  ops/output/health_marketing_fix_mw.md
  ops/output/health_marketing_forced_next.md
  ops/output/health_marketing_prebuilt.md
  ops/output/health_marketing_reset.md
  ops/output/health_marketing_rootfix.md
  ops/output/security_headers_status.md
  ops/perf/LIGHTHOUSE.md
  ops/release/TEMPLATES.md
  ops/scripts/apply_prod.sh
  ops/scripts/enforce_required_checks.sh
  ops/scripts/env_audit_apply.sh
  ops/scripts/env_inventory.sh
  ops/scripts/fetch_and_apply.sh
  ops/scripts/find_booking_url.sh
  ops/scripts/local_core_sanity.sh
  ops/scripts/preflight_apply.sh
  ops/scripts/preflight_sanity.sh
  ops/scripts/smoke_curls.sh
  ops/scripts/url_inventory.sh
  ops/scripts/verify_lockdown.sh
  ops/scripts/verify_user_subdomains.sh
  ops/smoke/SMOKE_CHECKLIST.md
  ops/vercel/README.md
  packages/design-system/src/providers/index.ts
  pages/index.tsx
  qa/ORG_QA/appoint
  qa/ORG_QA/appoint-web-only
  quick_verify.sh
  rollback.sh
  rotate_logs.sh
  untranslated_messages.json
  vercel.json
  vercel_env_checklist.md
  vercel_wire_domains.sh
```

## 4) PRs
- marketing: https://github.com/gabriellagziel/appoint/pull/542
- business:  https://github.com/gabriellagziel/appoint/pull/543
- enterprise: https://github.com/gabriellagziel/appoint/pull/544

## 5) Vercel Deployments (latest)
```
MARKETING
https://REDACTED_TOKEN.vercel.app
https://REDACTED_TOKEN.vercel.app
https://REDACTED_TOKEN.vercel.app
https://REDACTED_TOKEN.vercel.app
https://REDACTED_TOKEN.vercel.app

BUSINESS
https://REDACTED_TOKEN.vercel.app
https://REDACTED_TOKEN.vercel.app
https://REDACTED_TOKEN.vercel.app
https://REDACTED_TOKEN.vercel.app
https://REDACTED_TOKEN.vercel.app

ENTERPRISE
https://REDACTED_TOKEN.vercel.app
https://REDACTED_TOKEN.vercel.app
https://REDACTED_TOKEN.vercel.app
https://REDACTED_TOKEN.vercel.app
https://REDACTED_TOKEN.vercel.app
```

## 6) Middleware Scope (Enterprise)
`matcher: /app/:path*, /dashboard/:path*, /api/:path*` — root `/` excluded.

## 7) Sentry
Report whether NEXT_PUBLIC_SENTRY_DSN is set at project level and events visible.
(If unknown, mark **PENDING**; do not prompt user for tokens.)

## 8) Rollback
- Code: `git revert -m 1 <merge_commit>` or re-deploy previous commit.
- Vercel: `npx vercel -y rollback <deploymentId>`
- DNS unchanged.


