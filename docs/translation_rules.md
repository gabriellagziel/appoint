# Translation Rules for APP-OINT

## Overview
This document defines the translation requirements for the APP-OINT application across its different components.

## Translation Requirements

### 1. User Application Components
**Requirement**: Must be translated in all 56 supported languages

**Components that require full translation**:
- User-facing features (`lib/features/personal_app/`)
- Booking system (`lib/features/booking/`)
- Calendar interface (`lib/features/calendar/`)
- Profile management (`lib/features/profile/`)
- Settings (`lib/features/settings/`)
- Notifications (`lib/features/notifications/`)
- Onboarding (`lib/features/onboarding/`)
- Payment interfaces (`lib/features/payments/`)
- Family support (`lib/features/family_support/`)
- Child-related features (`lib/features/child/`)
- Personal scheduler (`lib/features/personal_scheduler/`)
- Rewards system (`lib/features/rewards/`)
- Referral system (`lib/features/referral/`)
- Authentication screens (`lib/features/auth/`)
- Search functionality (`lib/features/search/`)
- Navigation components (`lib/features/navigation/`)
- Common UI components (`lib/features/common/`)
- Shared components (`lib/shared/`)
- Global widgets (`lib/widgets/`)

### 2. Business/Studio Application Components
**Requirement**: Must be translated in all 56 supported languages

**Components that require full translation**:
- Studio features (`lib/features/studio/`)
- Studio profile (`lib/features/studio_profile/`)
- Studio business (`lib/features/studio_business/`)
- Business features (`lib/features/business/`)
- Business dashboard (`lib/features/business_dashboard/`)
- Billing (`lib/features/billing/`)
- Analytics (business-facing) (`lib/features/analytics/`)
- Provider interfaces (`lib/features/providers/`)
- Scheduler (business) (`lib/features/scheduler/`)
- Services management (`lib/features/services/`)
- Messaging (business) (`lib/features/messaging/`)
- Subscriptions (`lib/features/subscriptions/`)

### 3. Admin Dashboard Components
**Requirement**: English only - DO NOT translate admin interfaces

**Components that must remain in English**:
- Admin panel (`lib/features/admin_panel/`)
- Admin features (`lib/features/admin/`)
- Admin dashboard screens
- Admin broadcast functionality
- Admin metrics and analytics
- Admin user management
- Admin organization management
- Admin playtime games management
- Admin monetization features
- Admin QA tools (`lib/features/qa/`)
- Admin survey tools
- Any interface with "admin" in the path or name

## Implementation Rules

### 1. Language Detection for Admin Interfaces
Admin interfaces should use `AppLocalizations.of(context)` but force English locale:

```dart
// For admin interfaces, always use English
AppLocalizations.of(context.withLocale(Locale('en')))
```

### 2. Translation Key Naming Convention
- User/Business keys: Standard naming (e.g., `userWelcome`, `businessDashboard`)
- Admin keys: Prefix with `admin` (e.g., `adminDashboard`, `adminUserManagement`)

### 3. Translation File Organization
- All 56 language files (`app_*.arb`) should contain user and business translations
- Admin keys should only exist in `app_en.arb` (English)
- Admin keys in non-English files should reference English fallbacks

### 4. Code Implementation Guidelines
- Use `AdminLocalizations` wrapper for admin interfaces
- Use standard `AppLocalizations` for user/business interfaces
- Route-based locale detection for admin paths

## Supported Languages (56 total)
1. English (en) - Base language
2. Arabic (ar)
3. Spanish (es)
4. French (fr)
5. German (de)
6. Chinese Simplified (zh)
7. Chinese Traditional (zh_Hant)
8. Japanese (ja)
9. Korean (ko)
10. Portuguese (pt)
11. Portuguese Brazil (pt_BR)
12. Russian (ru)
13. Italian (it)
14. Dutch (nl)
15. Swedish (sv)
16. Norwegian (no)
17. Danish (da)
18. Finnish (fi)
19. Polish (pl)
20. Czech (cs)
21. Hungarian (hu)
22. Romanian (ro)
23. Bulgarian (bg)
24. Croatian (hr)
25. Serbian (sr)
26. Slovak (sk)
27. Slovenian (sl)
28. Estonian (et)
29. Latvian (lv)
30. Lithuanian (lt)
31. Greek (el)
32. Turkish (tr)
33. Hebrew (he)
34. Persian (fa)
35. Urdu (ur)
36. Hindi (hi)
37. Bengali (bn)
38. Tamil (ta)
39. Gujarati (gu)
40. Marathi (mr)
41. Kannada (kn)
42. Thai (th)
43. Vietnamese (vi)
44. Indonesian (id)
45. Malay (ms)
46. Tagalog (tl)
47. Swahili (sw)
48. Hausa (ha)
49. Amharic (am)
50. Sinhala (si)
51. Nepali (ne)
52. Ukrainian (uk)
53. Welsh (cy)
54. Macedonian (mk)
55. Maltese (mt)
56. Zulu (zu)

## Quality Assurance
- All user-facing strings must be translatable
- Admin strings must remain in English
- No hardcoded strings in user/business interfaces
- Proper fallback handling for missing translations
- Context-aware translations based on user role

## Testing Requirements
- Test language switching in user/business interfaces
- Verify admin interfaces remain in English regardless of system language
- Test all 56 languages for user/business components
- Validate proper fallback behavior

## Maintenance
- New user/business features must include translations for all 56 languages
- New admin features must use English-only strings
- Regular audits to ensure compliance with translation rules
- Automated testing for translation coverage

## Exceptions
No exceptions to these rules. All new development must follow these guidelines.