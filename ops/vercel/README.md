# Vercel Projects Mapping

This document mirrors `ops/scripts/vercel_mapping.sh` output and the intended configuration for Vercel.

For each app (marketing, business, enterprise-app, dashboard):

- Link the project to the respective subdirectory
- Framework: Next.js
- Build Command: `npm ci && npm run build`
- Output Directory: `.next`
- Set required environment variables as referenced in code (see `ops/audit/vercel/mapping.md`)

Promotion flow:

1. Create Preview build per PR
2. Validate Preview is green (use smoke + Lighthouse)
3. Promote Preview → Production in Vercel UI

Keep CI green:

- Only `core-ci.yml` runs on push/PR; all other workflows are manual
- Required checks on `main`: Flutter (web) build, Next.js apps build, Cloud Functions compile
