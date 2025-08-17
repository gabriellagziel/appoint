### Next.js apps i18n scaffolding required

- business: No i18n library/config detected; add `public/locales/{en,it,he}` and implement a lightweight i18n (e.g., next-intl or next-i18next). Extract critical UI strings.
- enterprise-app: Same as business. Avoid touching Pro Groups logic per constraints.

Fallback policy: default to English when locale not present.


