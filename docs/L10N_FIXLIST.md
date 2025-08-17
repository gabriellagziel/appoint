### Prioritized Fix Plan (excluding admin)

1) Flutter `appoint`
- Add placeholder ARBs: `app_it.arb`, `app_he.arb` with English values (done)
- Run gen-l10n and verify English fallback
- Extract low-risk visible strings in `lib/` to ARB keys

2) business (Next.js)
- Decide on i18n library (follow existing patterns if any emerge)
- Create locale structure (`public/locales/en`, `it`, `he`) and seed minimal JSON
- Extract highest-impact UI strings

3) enterprise-app (Next.js)
- Same as business: define library, add `public/locales/`, extract strings

4) Tooling
- Keep `tools/l10n/scan.js` to flag hard-coded strings and missing keys
- Add CI job to run scanner for reporting (exclude `admin` from autofix)

5) RTL
- Validate basic RTL layout for Hebrew in translatable apps



