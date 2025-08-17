# Vercel Monorepo Map

## App-Oint Next.js Applications

This document maps the monorepo structure to Vercel deployment configuration for each web application.

## App Configurations

### 1. Marketing App
- **Root Directory**: `marketing/`
- **Framework**: Next.js
- **Build Command**: `npm run build`
- **Install Command**: `npm ci`
- **Output Directory**: `.vercel/output`
- **Required Environment Variables (Preview)**:
  - `NEXT_PUBLIC_API_URL` - API endpoint for preview environment
  - `NEXT_PUBLIC_APP_ENV` - Set to "preview"
  - `SENTRY_DSN` - Optional: Sentry error tracking
- **Required Environment Variables (Production)**:
  - `NEXT_PUBLIC_API_URL` - Production API endpoint
  - `NEXT_PUBLIC_APP_ENV` - Set to "production"
  - `SENTRY_DSN` - Sentry error tracking

### 2. Business App
- **Root Directory**: `business/`
- **Framework**: Next.js
- **Build Command**: `npm run build`
- **Install Command**: `npm ci`
- **Output Directory**: `.vercel/output`
- **Required Environment Variables (Preview)**:
  - `NEXT_PUBLIC_API_URL` - API endpoint for preview environment
  - `NEXT_PUBLIC_APP_ENV` - Set to "preview"
  - `REDACTED_TOKEN` - Stripe test key
- **Required Environment Variables (Production)**:
  - `NEXT_PUBLIC_API_URL` - Production API endpoint
  - `NEXT_PUBLIC_APP_ENV` - Set to "production"
  - `REDACTED_TOKEN` - Stripe live key

### 3. Admin App
- **Root Directory**: `admin/`
- **Framework**: Next.js
- **Build Command**: `npm run build`
- **Install Command**: `npm ci`
- **Output Directory**: `.vercel/output`
- **Required Environment Variables (Preview)**:
  - `NEXT_PUBLIC_API_URL` - API endpoint for preview environment
  - `NEXT_PUBLIC_APP_ENV` - Set to "preview"
  - `NEXT_PUBLIC_ADMIN_API_KEY` - Admin API key for preview
- **Required Environment Variables (Production)**:
  - `NEXT_PUBLIC_API_URL` - Production API endpoint
  - `NEXT_PUBLIC_APP_ENV` - Set to "production"
  - `NEXT_PUBLIC_ADMIN_API_KEY` - Admin API key for production

### 4. Dashboard App
- **Root Directory**: `dashboard/`
- **Framework**: Next.js
- **Build Command**: `npm run build`
- **Install Command**: `npm ci`
- **Output Directory**: `.vercel/output`
- **Required Environment Variables (Preview)**:
  - `NEXT_PUBLIC_API_URL` - API endpoint for preview environment
  - `NEXT_PUBLIC_APP_ENV` - Set to "preview"
  - `NEXT_PUBLIC_METRICS_ENDPOINT` - Metrics collection endpoint
- **Required Environment Variables (Production)**:
  - `NEXT_PUBLIC_API_URL` - Production API endpoint
  - `NEXT_PUBLIC_APP_ENV` - Set to "production"
  - `NEXT_PUBLIC_METRICS_ENDPOINT` - Metrics collection endpoint

### 5. Enterprise App
- **Root Directory**: `enterprise-app/`
- **Framework**: Next.js
- **Build Command**: `npm run build`
- **Install Command**: `npm ci`
- **Output Directory**: `.vercel/output`
- **Required Environment Variables (Preview)**:
  - `NEXT_PUBLIC_API_URL` - API endpoint for preview environment
  - `NEXT_PUBLIC_APP_ENV` - Set to "preview"
  - `NEXT_PUBLIC_ENTERPRISE_API_KEY` - Enterprise API key for preview
- **Required Environment Variables (Production)**:
  - `NEXT_PUBLIC_API_URL` - Production API endpoint
  - `NEXT_PUBLIC_APP_ENV` - Set to "production"
  - `NEXT_PUBLIC_ENTERPRISE_API_KEY` - Enterprise API key for production

### 6. Enterprise Onboarding Portal
- **Root Directory**: `enterprise-onboarding-portal/`
- **Framework**: Next.js
- **Build Command**: `npm run build`
- **Install Command**: `npm ci`
- **Output Directory**: `.vercel/output`
- **Required Environment Variables (Preview)**:
  - `NEXT_PUBLIC_API_URL` - API endpoint for preview environment
  - `NEXT_PUBLIC_APP_ENV` - Set to "preview"
  - `NEXT_PUBLIC_ENTERPRISE_API_KEY` - Enterprise API key for preview
- **Required Environment Variables (Production)**:
  - `NEXT_PUBLIC_API_URL` - Production API endpoint
  - `NEXT_PUBLIC_APP_ENV` - Set to "production"
  - `NEXT_PUBLIC_ENTERPRISE_API_KEY` - Enterprise API key for production

## Monorepo Setup

### Vercel Configuration Files
Each app should have a `.vercel/project.json` file in its root directory:

```json
{
  "projectId": "your-project-id",
  "orgId": "your-org-id",
  "settings": {
    "framework": "nextjs",
    "buildCommand": "npm run build",
    "outputDirectory": ".vercel/output",
    "installCommand": "npm ci"
  }
}
```

### Path-Based Deployments
Vercel automatically detects which app to build based on the changed files:

- Changes to `marketing/**` → Deploy marketing app
- Changes to `business/**` → Deploy business app
- Changes to `admin/**` → Deploy admin app
- Changes to `dashboard/**` → Deploy dashboard app
- Changes to `enterprise-app/**` → Deploy enterprise app
- Changes to `enterprise-onboarding-portal/**` → Deploy enterprise portal

### Shared Dependencies
Common dependencies are managed at the monorepo root level. Each app should have its own `package.json` with app-specific dependencies.

## Environment Variable Management

### Preview Deployments
Preview deployments automatically get environment variables prefixed with `NEXT_PUBLIC_` from the Vercel project settings.

### Production Deployments
Production deployments use production environment variables configured in Vercel project settings.

## TODO Items for Human Configuration

- [ ] Set up Vercel projects for each app
- [ ] Configure root directory for each project
- [ ] Set environment variables for preview and production
- [ ] Test preview deployments for each app
- [ ] Verify production deployments work correctly
- [ ] Set up custom domains if required
- [ ] Configure branch protection rules for production deployments

---

*Last updated: August 17, 2025*  
*Generated by CI stabilization script*
