# App-Oint – Release Smoke Checklist

## Meta
- Release tag: `vX.Y.Z`
- Date/Time:
- Executor:

## API / Functions
- [ ] `/api/status` returns 200 in <300ms (no errors in logs)
- [ ] Critical endpoints (list):
  - [ ] POST /meetings → 200/201
  - [ ] GET  /meetings/:id → 200

## Marketing (Next.js)
- [ ] Homepage 200, no console errors
- [ ] Links: header/footer nav click-through OK
- [ ] Any env-driven text visible (if applicable)

## Business (Next.js)
- [ ] Login → redirect → dashboard loads
- [ ] Create meeting → review → confirm (no 4xx/5xx)
- [ ] Timezone/locale formatting correct

## Enterprise (Next.js)
- [ ] SSO flow (if used) works
- [ ] Org-level pages load without 4xx/5xx

## Dashboard (Next.js)
- [ ] Graphs/tables render; no “undefined” labels
- [ ] Filters/sorting function

## Flutter Web (Personal PWA)
- [ ] Load home in mobile + desktop
- [ ] Create meeting end-to-end (guest → confirm)
- [ ] Translation keys: no missing placeholders
- [ ] (If SW enabled) Reload shows latest assets

## Observability
- [ ] Sentry/Logs receiving events
- [ ] No new error spikes

## Go/No-Go
- [ ] All boxes above checked → **GO**
- [ ] Any red? attach URL + screenshot and **NO-GO**
