# Release Templates

Standardized, copy-paste-ready templates to ensure every deployment follows the same checklist, with an auditable decision gate.

## 1) Vercel – Promote Preview → Production

```md
Promote Preview → Production: <app-name>

Preview: https://<preview-url>
Production: https://<prod-url>

Env parity
- Preview envs configured per `ops/vercel/README.md`
- Production envs match Preview

Smoke (must be green)
- API health 200: https://<api-domain>/api/status
- App homepage 200, no console errors
- Key route loads (specify): /
- Auth (if applicable) OK
- Critical path OK (specify: e.g., create meeting → confirm)
- i18n: no missing keys (see `ops/audit/tests/i18n.md`)
- Lighthouse meets targets (see `ops/perf/LIGHTHOUSE.md`)

Rollback ready
- Vercel: promote previous deployment
- Functions: redeploy previous tag

Decision Gate
- GO ✅ / NO-GO ❌
- Reviewer: @<reviewer>
- Date/Time: <yyyy-mm-dd HH:mm>

Promote
- Vercel UI: Promote Preview → Production
- CLI (optional): `vercel promote <project-name> --scope <team> --yes`
```

## 2) Functions – Backend-first Deploy

```md
Functions deploy (backend-first)

Build & deploy
- Built locally: `cd functions && npm ci && npm run build`
- Runtime guard: type=commonjs, node=18 (`functions/package.json`)
- Deployed: `firebase deploy --only functions`

Health
- 200: https://<api-domain>/api/status

Rollback
- `git checkout v<prev-tag> && firebase deploy --only functions`

Decision Gate
- GO ✅ / NO-GO ❌
- Reviewer: @<reviewer>
- Date/Time: <yyyy-mm-dd HH:mm>
```

## Usage

- Paste the relevant template as a PR comment or tracking issue during release.
- Ensure the Decision Gate is filled to maintain an approval trail.
- Keep env parity aligned with `ops/vercel/README.md`.
