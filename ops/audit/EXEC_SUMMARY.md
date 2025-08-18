# EXEC SUMMARY

| Area | Status | Notes |
|---|---|---|
| CI/CD | 🟩 | core-ci is sole workflow on push/PR; legacy workflows set to manual |
| Secrets | 🟧 | verify env coverage in Vercel + GH Environments |
| Vercel | 🟧 | mapping.md generated; verify env + project linking in UI |
| Firebase | 🟩 | functions/package.json enforces CommonJS + Node 18 |
| Dependencies | 🟧 | see monorepo/deps.md |
| Tests (Web) | 🟧 | ops/audit/tests/web.md |
| Tests (Flutter) | 🟩 | ops/audit/tests/flutter.md |
| i18n | 🟩 | ops/audit/tests/i18n.md shows no missing keys |
| Perf/PWA | 🟧 | ops/perf/LIGHTHOUSE.md; run on all apps, store under ops/perf/DATE |
| Release/Meta | 🟧 | release/status.md |

## Top Risks

- Artifact ≠ Artifact (CI builds something different than what you tested)
- Runtime ENV ≠ Build ENV (missing/incorrect secrets/env per target)
- Cache/PWA/CDN serving stale assets

## Minimal Stabilization Plan

1) Create **.github/workflows/core-ci.yml** running: Flutter (web), Node apps (Next.js), and Functions build-only.
2) Disable noisy jobs by setting `on: workflow_dispatch` in legacy workflows.
3) Ensure Functions use Node 18 + CommonJS.
4) Document Vercel mapping and set only 3 required checks: Flutter, Web, Functions.
