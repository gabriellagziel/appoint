### Supported Languages

| App | i18n Framework | Locales Found | Default Locale | Notes |
| --- | --- | --- | --- | --- |
| admin | None / English only | en only | en | Do not translate |
| business | None detected | - | en | No i18n config/locales found |
| enterprise-app | None detected | - | en | No i18n config/locales found |
| appoint | Flutter gen-l10n | en, it, he | en | it & he added as placeholders |

### Audit Details

#### admin (Next.js)
- Framework: None (English-only by requirement)
- Locales: en
- Fallback: N/A
- Hard-coded strings: Present throughout (reference-only; do not convert)
- RTL readiness: Not applicable

Scanner summary: 3617 strings across 84 files with findings. See `tools/l10n/report.json`.

#### business (Next.js)
- Framework: None detected (no `public/locales/`, no i18n hooks found)
- Locales: -
- Fallback: N/A
- Hard-coded strings: Likely present. See scanner report.
- RTL readiness: Unknown

Scanner summary: 1834 strings across 32 files with findings. See `tools/l10n/report.json`.

#### enterprise-app (Next.js)
- Framework: None detected (no `public/locales/`, no i18n hooks found)
- Locales: -
- Fallback: N/A
- Hard-coded strings: Likely present. See scanner report.
- RTL readiness: Unknown

Scanner summary: 904 strings across 21 files with findings. See `tools/l10n/report.json`.

#### appoint (Flutter PWA)
- Framework: Flutter gen-l10n
- Locales: en (source), it (placeholder), he (placeholder)
- Fallback: English
- Hard-coded strings: Some likely in `lib/` (see scanner report)
- RTL readiness: Ensure `Directionality` and fonts support

Scanner summary: 1286 strings across 65 files with findings. See `tools/l10n/report.json`.

### Known Gaps
- business, enterprise-app: No i18n setup; strings likely hard-coded.
- appoint: Missing non-English content; placeholders added.

### Notes
- Admin must remain English-only; no changes planned there.
- Per team preference, keep the term "system admin" in English across locales.


