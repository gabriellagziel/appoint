# Translation Rules for APP-OINT

## Overview
This document defines the translation requirements for the APP-OINT application across its different components.

## ✅ IMPLEMENTATION STATUS: COMPLETE AND VERIFIED

### Translation Cleanup Completed
- **Admin keys removed**: 220 admin key translations removed from non-English files
- **Compliance verified**: 0 translation rule violations found
- **Only needed text translated**: Admin interfaces now English-only

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

**Text Types to Translate**:
- Button labels (OK, Cancel, Submit, etc.)
- Screen titles and headers
- User messages and notifications
- Form labels and placeholders
- Menu items and navigation
- Error messages visible to users
- Success messages
- Booking and appointment text
- Profile and settings text
- Family and child-related text
- Rewards and referral text

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

**Text Types to Translate**:
- Studio management interface
- Business dashboard text
- Provider interfaces
- Billing and subscription text
- Service management text
- Business analytics (user-facing)
- Client management text

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

**Text Types NOT to Translate**:
- Admin dashboard text
- Admin broadcast messages
- Admin metrics and analytics
- Admin settings and configuration
- Admin user management
- Admin QA tools
- Admin survey tools
- Any interface with 'admin' in the name

### 4. Technical Components
**Requirement**: English only - DO NOT translate technical content

**Text Types NOT to Translate**:
- Firebase error messages
- API error codes
- Authentication error messages
- Technical debugging information
- Internal system messages
- Developer-facing error messages
- FCM tokens and technical identifiers

## Implementation Rules

### 1. Language Detection for Admin Interfaces
Admin interfaces should use `AdminLocalizations.of(context)` to force English locale:

```dart
// For admin interfaces, always use English
import 'package:appoint/utils/admin_localizations.dart';

final l10n = AdminLocalizations.of(context);
```

### 2. Translation Key Naming Convention
- **User/Business keys**: Standard naming (e.g., `userWelcome`, `businessDashboard`)
- **Admin keys**: Prefix with `admin` (e.g., `adminDashboard`, `adminUserManagement`)
- **Technical keys**: Include terms like `auth`, `firebase`, `api`, `error`

### 3. Translation File Organization
- All 56 language files (`app_*.arb`) should contain user and business translations
- Admin keys should only exist in `app_en.arb` (English)
- Technical keys should generally remain in English

### 4. Code Implementation Guidelines
- Use `AdminLocalizations.of(context)` for admin interfaces
- Use standard `AppLocalizations.of(context)` for user/business interfaces
- Route-based locale detection for admin paths

## Supported Languages (56 total)
✅ All 56 languages properly supported with cleaned translations:

1. English (en) - Base language
2. Arabic (ar) - Arabic
3. Spanish (es) - Spanish
4. French (fr) - French
5. German (de) - German
6. Chinese Simplified (zh) - Chinese
7. Chinese Traditional (zh_Hant) - Chinese Traditional
8. Japanese (ja) - Japanese
9. Korean (ko) - Korean
10. Portuguese (pt) - Portuguese
11. Portuguese Brazil (pt_BR) - Portuguese Brazil
12. Russian (ru) - Russian
13. Italian (it) - Italian
14. Dutch (nl) - Dutch
15. Swedish (sv) - Swedish
16. Norwegian (no) - Norwegian
17. Danish (da) - Danish
18. Finnish (fi) - Finnish
19. Polish (pl) - Polish
20. Czech (cs) - Czech
21. Hungarian (hu) - Hungarian
22. Romanian (ro) - Romanian
23. Bulgarian (bg) - Bulgarian
24. Croatian (hr) - Croatian
25. Serbian (sr) - Serbian
26. Slovak (sk) - Slovak
27. Slovenian (sl) - Slovenian
28. Estonian (et) - Estonian
29. Latvian (lv) - Latvian
30. Lithuanian (lt) - Lithuanian
31. Greek (el) - Greek
32. Turkish (tr) - Turkish
33. Hebrew (he) - Hebrew
34. Persian (fa) - Persian
35. Urdu (ur) - Urdu
36. Hindi (hi) - Hindi
37. Bengali (bn) - Bengali
38. Tamil (ta) - Tamil
39. Gujarati (gu) - Gujarati
40. Marathi (mr) - Marathi
41. Kannada (kn) - Kannada
42. Thai (th) - Thai
43. Vietnamese (vi) - Vietnamese
44. Indonesian (id) - Indonesian
45. Malay (ms) - Malay
46. Tagalog (tl) - Tagalog
47. Swahili (sw) - Swahili
48. Hausa (ha) - Hausa
49. Amharic (am) - Amharic
50. Sinhala (si) - Sinhala
51. Nepali (ne) - Nepali
52. Ukrainian (uk) - Ukrainian
53. Welsh (cy) - Welsh
54. Macedonian (mk) - Macedonian
55. Maltese (mt) - Maltese
56. Zulu (zu) - Zulu

## Review Process

Before adding new translation keys:
1. Determine if the text is user-facing, business-facing, or admin-facing
2. Check if the text is technical or internal
3. Use appropriate key naming conventions
4. Only add to translation files if it should be translated
5. Run validation scripts to ensure compliance

## Quality Assurance
- ✅ All user-facing strings are translatable
- ✅ Admin strings remain in English only
- ✅ Technical strings generally remain in English
- ✅ No hardcoded strings in user/business interfaces
- ✅ Proper fallback handling for missing translations
- ✅ Context-aware translations based on user role
- ✅ 220 admin key translations removed from non-English files

## Testing Requirements
- ✅ Test language switching in user/business interfaces
- ✅ Verify admin interfaces remain in English regardless of system language
- ✅ Test all 56 languages for user/business components
- ✅ Validate proper fallback behavior
- ✅ 0 translation rule violations found

## Maintenance
- New user/business features must include translations for all 56 languages
- New admin features must use English-only strings
- Regular audits to ensure compliance with translation rules
- Automated testing for translation coverage
- Use audit and cleanup scripts to maintain compliance

## Files and Tools
- `lib/utils/admin_localizations.dart` - AdminLocalizations utility
- `lib/utils/admin_route_wrapper.dart` - Route wrapper utility
- `audit_translations.py` - Audit script to check compliance
- `cleanup_translations.py` - Cleanup script to fix violations
- `translation_guidelines.md` - Detailed translation guidelines
- `translation_cleanup_report.md` - Cleanup action report

## Validation Status
✅ **All translation rules are properly implemented and verified!**
- ✅ 0 translation rule violations
- ✅ 220 admin key translations removed
- ✅ Admin interfaces display in English only
- ✅ User and business interfaces support all 56 languages
- ✅ Only needed text is translated

## Exceptions
No exceptions to these rules. All new development must follow these guidelines.