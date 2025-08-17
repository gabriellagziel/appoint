### Manual QA Matrix

#### Environments
- business (Next.js)
- enterprise-app (Next.js)
- appoint (Flutter web)

#### Locales
- en (default), it, he

#### Test Areas
- Locale switching or direct deep-linking
- Fallback: missing keys show English
- UI text correctness and completeness
- RTL (he): layout mirroring, alignment, icons, overflow
- Dates, numbers, currency formatting
- Accessibility: aria-labels, screen reader text

#### Test Cases (sample)
- Load home/dashboard in en/it/he; verify text present and not truncated
- Trigger toasts/dialogs/errors; verify translations/fallback
- Forms: labels, placeholders, validation messages localized
- Navigation/menu items localized
- For Flutter: verify generated `AppLocalizations` works; no missing lookup at runtime



