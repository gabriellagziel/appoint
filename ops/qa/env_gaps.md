# Environment Variables Gaps Analysis

## Overview
This document identifies gaps between required environment variables and current configuration across all applications.

## Current Environment Configuration

### Preview Environment Template
Based on `ops/vercel/preview.env.example`:

```bash
# Common Variables (All Apps)
NODE_ENV=preview
NEXT_PUBLIC_APP_ENV=preview
NEXT_TELEMETRY_DISABLED=1

# API Endpoints (Preview)
NEXT_PUBLIC_API_URL=https://preview-api.app-oint.com
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_...
NEXT_PUBLIC_SENTRY_DSN=https://...

# Marketing App
# No additional variables needed

# Business Portal
NEXT_PUBLIC_ANALYTICS_ID=G-XXXXXXXXXX
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_...

# Admin Panel
NEXT_PUBLIC_ADMIN_API_KEY=admin_preview_key_123
NEXT_PUBLIC_AUTH_DOMAIN=preview.auth.app-oint.com

# Dashboard
NEXT_PUBLIC_METRICS_ENDPOINT=https://preview-metrics.app-oint.com

# Enterprise Apps
NEXT_PUBLIC_ENTERPRISE_API_KEY=enterprise_preview_key_123
NEXT_PUBLIC_SSO_ENABLED=true
```

## Application-Specific Requirements

### Flutter PWA (appoint/)
#### Current Configuration
- **Firebase config**: `firebase_options.dart`
- **Environment**: Production/development via build flags

#### Missing Environment Variables
| Variable | Where Used | Needs Preview | Needs Prod | Description |
|----------|------------|---------------|-------------|-------------|
| `FIREBASE_API_KEY` | Firebase config | ✅ Yes | ✅ Yes | Firebase API key |
| `FIREBASE_PROJECT_ID` | Firebase config | ✅ Yes | ✅ Yes | Firebase project ID |
| `FIREBASE_AUTH_DOMAIN` | Firebase config | ✅ Yes | ✅ Yes | Firebase auth domain |
| `FIREBASE_STORAGE_BUCKET` | Firebase config | ✅ Yes | ✅ Yes | Firebase storage bucket |
| `FIREBASE_MESSAGING_SENDER_ID` | Firebase config | ✅ Yes | ✅ Yes | Firebase messaging sender ID |
| `FIREBASE_APP_ID` | Firebase config | ✅ Yes | ✅ Yes | Firebase app ID |

### Marketing Site
#### Current Configuration
- **Environment**: Basic Next.js setup
- **Missing**: No environment-specific config

#### Missing Environment Variables
| Variable | Where Used | Needs Preview | Needs Prod | Description |
|----------|------------|---------------|-------------|-------------|
| `NEXT_PUBLIC_GA_ID` | Analytics | ✅ Yes | ✅ Yes | Google Analytics ID |
| `NEXT_PUBLIC_SENTRY_DSN` | Error tracking | ✅ Yes | ✅ Yes | Sentry error tracking |
| `NEXT_PUBLIC_CONTACT_EMAIL` | Contact forms | ✅ Yes | ✅ Yes | Contact form endpoint |
| `NEXT_PUBLIC_SUPPORT_URL` | Support links | ✅ Yes | ✅ Yes | Support documentation URL |

### Business Portal
#### Current Configuration
- **Environment**: Basic Next.js setup
- **Missing**: No environment-specific config

#### Missing Environment Variables
| Variable | Where Used | Needs Preview | Needs Prod | Description |
|----------|------------|---------------|-------------|-------------|
| `NEXT_PUBLIC_BUSINESS_API_URL` | Business API | ✅ Yes | ✅ Yes | Business API endpoint |
| `NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY` | Payments | ✅ Yes | ✅ Yes | Stripe public key |
| `NEXT_PUBLIC_STRIPE_SECRET_KEY` | Payments | ❌ No | ✅ Yes | Stripe secret key (server only) |
| `NEXT_PUBLIC_BUSINESS_ANALYTICS_ID` | Analytics | ✅ Yes | ✅ Yes | Business analytics ID |
| `NEXT_PUBLIC_SUPPORT_EMAIL` | Support | ✅ Yes | ✅ Yes | Business support email |

### Admin Panel
#### Current Configuration
- **Environment**: Basic Next.js setup
- **Missing**: No environment-specific config

#### Missing Environment Variables
| Variable | Where Used | Needs Preview | Needs Prod | Description |
|----------|------------|---------------|-------------|-------------|
| `NEXT_PUBLIC_ADMIN_API_URL` | Admin API | ✅ Yes | ✅ Yes | Admin API endpoint |
| `NEXT_PUBLIC_ADMIN_AUTH_DOMAIN` | Authentication | ✅ Yes | ✅ Yes | Admin auth domain |
| `ADMIN_JWT_SECRET` | JWT signing | ❌ No | ✅ Yes | JWT secret key (server only) |
| `NEXT_PUBLIC_ADMIN_FEATURES` | Feature flags | ✅ Yes | ✅ Yes | Admin feature flags |
| `NEXT_PUBLIC_ADMIN_VERSION` | Version info | ✅ Yes | ✅ Yes | Admin panel version |

### Enterprise App
#### Current Configuration
- **Environment**: Basic Next.js setup
- **Missing**: No environment-specific config

#### Missing Environment Variables
| Variable | Where Used | Needs Preview | Needs Prod | Description |
|----------|------------|---------------|-------------|-------------|
| `NEXT_PUBLIC_ENTERPRISE_API_URL` | Enterprise API | ✅ Yes | ✅ Yes | Enterprise API endpoint |
| `NEXT_PUBLIC_SSO_PROVIDER` | SSO integration | ✅ Yes | ✅ Yes | SSO provider configuration |
| `NEXT_PUBLIC_ENTERPRISE_FEATURES` | Feature flags | ✅ Yes | ✅ Yes | Enterprise feature flags |
| `NEXT_PUBLIC_TEAM_MANAGEMENT_URL` | Team management | ✅ Yes | ✅ Yes | Team management endpoint |

### Dashboard
#### Current Configuration
- **Environment**: Basic Next.js setup
- **Missing**: No environment-specific config

#### Missing Environment Variables
| Variable | Where Used | Needs Preview | Needs Prod | Description |
|----------|------------|---------------|-------------|-------------|
| `NEXT_PUBLIC_DASHBOARD_API_URL` | Dashboard API | ✅ Yes | ✅ Yes | Dashboard API endpoint |
| `NEXT_PUBLIC_METRICS_ENDPOINT` | Metrics data | ✅ Yes | ✅ Yes | Metrics data endpoint |
| `NEXT_PUBLIC_CHART_LIBRARY` | Chart library | ✅ Yes | ✅ Yes | Chart library configuration |
| `NEXT_PUBLIC_REFRESH_INTERVAL` | Data refresh | ✅ Yes | ✅ Yes | Data refresh interval |

### Cloud Functions
#### Current Configuration
- **Environment**: Firebase Functions
- **Missing**: Limited environment config

#### Missing Environment Variables
| Variable | Where Used | Needs Preview | Needs Prod | Description |
|----------|------------|---------------|-------------|-------------|
| `FIREBASE_PROJECT_ID` | Firebase config | ✅ Yes | ✅ Yes | Firebase project ID |
| `STRIPE_SECRET_KEY` | Payment processing | ❌ No | ✅ Yes | Stripe secret key |
| `SENDGRID_API_KEY` | Email sending | ❌ No | ✅ Yes | SendGrid API key |
| `JWT_SECRET` | JWT signing | ❌ No | ✅ Yes | JWT secret key |
| `CORS_ORIGINS` | CORS configuration | ✅ Yes | ✅ Yes | Allowed CORS origins |

### Enterprise Onboarding Portal
#### Current Configuration
- **Environment**: Basic Node.js setup
- **Missing**: No environment-specific config

#### Missing Environment Variables
| Variable | Where Used | Needs Preview | Needs Prod | Description |
|----------|------------|---------------|-------------|-------------|
| `PORT` | Server port | ✅ Yes | ✅ Yes | Server port number |
| `NODE_ENV` | Environment | ✅ Yes | ✅ Yes | Node environment |
| `DATABASE_URL` | Database connection | ✅ Yes | ✅ Yes | Database connection string |
| `JWT_SECRET` | JWT signing | ❌ No | ✅ Yes | JWT secret key |
| `SMTP_CONFIG` | Email configuration | ❌ No | ✅ Yes | SMTP server config |

## Environment Gaps Summary

### High Priority Gaps
| Category | Count | Impact | Priority |
|----------|-------|--------|----------|
| **API Endpoints** | 8 | Critical | 🔴 High |
| **Authentication** | 6 | Critical | 🔴 High |
| **Payment Processing** | 3 | Critical | 🔴 High |
| **Analytics** | 4 | Important | 🟡 Medium |
| **Feature Flags** | 3 | Important | 🟡 Medium |

### Missing Environment Categories
1. **API Configuration**: No centralized API endpoint management
2. **Authentication**: Missing JWT secrets and auth domains
3. **Payment Processing**: Missing Stripe configuration
4. **Monitoring**: Missing error tracking and analytics
5. **Feature Management**: No feature flag system

## Recommendations

### Immediate (This Week)
1. **Create environment templates**
   - `.env.preview.example` for preview environment
   - `.env.production.example` for production environment
   - `.env.local.example` for local development

2. **Add missing critical variables**
   - API endpoints for all applications
   - Authentication configuration
   - Basic monitoring setup

### Short Term (Next 2 Weeks)
1. **Implement environment validation**
   - Required variable checking
   - Environment-specific validation
   - Missing variable warnings

2. **Add environment documentation**
   - Variable descriptions
   - Usage examples
   - Security considerations

### Long Term (Next Month)
1. **Environment management system**
   - Centralized configuration
   - Environment-specific builds
   - Secret management integration

## Implementation Plan

### Phase 1: Environment Templates
1. **Create base templates**
   ```bash
   # .env.preview.example
   NODE_ENV=preview
   NEXT_PUBLIC_APP_ENV=preview
   
   # API Endpoints
   NEXT_PUBLIC_API_URL=https://preview-api.app-oint.com
   NEXT_PUBLIC_BUSINESS_API_URL=https://preview-business-api.app-oint.com
   NEXT_PUBLIC_ADMIN_API_URL=https://preview-admin-api.app-oint.com
   ```

2. **Add validation scripts**
   ```bash
   # scripts/validate-env.sh
   #!/bin/bash
   required_vars=("NODE_ENV" "NEXT_PUBLIC_API_URL")
   for var in "${required_vars[@]}"; do
     if [ -z "${!var}" ]; then
       echo "❌ Missing required environment variable: $var"
       exit 1
     fi
   done
   ```

### Phase 2: Environment Integration
1. **Update build scripts**
   ```json
   // package.json
   "scripts": {
     "build:preview": "env-cmd -f .env.preview next build",
     "build:production": "env-cmd -f .env.production next build"
   }
   ```

2. **Add environment checking**
   ```typescript
   // lib/env.ts
   export function validateEnvironment() {
     const required = ['NEXT_PUBLIC_API_URL', 'NEXT_PUBLIC_APP_ENV']
     for (const var of required) {
       if (!process.env[var]) {
         throw new Error(`Missing required environment variable: ${var}`)
       }
     }
   }
   ```

### Phase 3: Security & Monitoring
1. **Secret management**
   - Use Vercel secrets for sensitive data
   - Implement environment-specific secrets
   - Add secret rotation procedures

2. **Environment monitoring**
   - Environment variable validation
   - Missing variable alerts
   - Configuration drift detection

## Security Considerations

### Public vs. Private Variables
- **NEXT_PUBLIC_***: Safe to expose in browser
- **Server-only**: Keep sensitive data server-side
- **Secrets**: Use Vercel secrets or environment variables

### Environment Separation
- **Preview**: Use test/staging services
- **Production**: Use production services
- **Local**: Use local development services

### Validation Requirements
- **Required variables**: Must be present
- **Optional variables**: Can have defaults
- **Secret variables**: Must be properly secured

## Next Steps

### This Week
1. Audit all applications for environment variable usage
2. Create comprehensive environment templates
3. Add missing critical variables

### Next 2 Weeks
1. Implement environment validation
2. Update build and deployment scripts
3. Add environment documentation

### Next Month
1. Set up environment management system
2. Implement secret rotation
3. Add environment monitoring

## Notes
- **Admin panel**: Keep English-only, focus on environment config
- **Pro Groups**: No business logic changes needed
- **Priority**: API endpoints and authentication first
- **Security**: Implement proper secret management
- **Documentation**: Keep environment guides updated
