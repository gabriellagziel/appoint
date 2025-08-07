# Translation Guidelines for APP-OINT

## What Should Be Translated

### ✅ User-Facing Components (All 56 Languages)
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

### ✅ Business-Facing Components (All 56 Languages)
- Studio management interface
- Business dashboard text
- Provider interfaces
- Billing and subscription text
- Service management text
- Business analytics (user-facing)
- Client management text

## What Should NOT Be Translated

### ❌ Admin Components (English Only)
- Admin dashboard text
- Admin broadcast messages
- Admin metrics and analytics
- Admin settings and configuration
- Admin user management
- Admin QA tools
- Admin survey tools
- Any interface with 'admin' in the name

### ❌ Technical Components (English Only)
- Firebase error messages
- API error codes
- Authentication error messages
- Technical debugging information
- Internal system messages
- Developer-facing error messages
- FCM tokens and technical identifiers

## Key Naming Conventions

- **Admin keys**: Prefix with `admin` (e.g., `adminDashboard`)
- **Technical keys**: Include terms like `auth`, `firebase`, `api`, `error`
- **User keys**: Descriptive names for UI elements
- **Business keys**: Include terms like `studio`, `business`, `provider`

## Review Process

Before adding new translation keys:
1. Determine if the text is user-facing, business-facing, or admin-facing
2. Check if the text is technical or internal
3. Use appropriate key naming conventions
4. Only add to translation files if it should be translated
5. Run validation scripts to ensure compliance
