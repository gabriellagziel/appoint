# App-Oint Application Inventory

## Overview
This document catalogs all applications in the codebase with their frameworks, build commands, and configuration details.

## Applications

### 1. Flutter PWA (Personal)
- **Path**: `appoint/`
- **Framework**: Flutter Web
- **Config**: `pubspec.yaml`, `analysis_options.yaml`
- **Build**: `flutter build web`
- **L10n**: `lib/l10n/*.arb`

### 2. Next.js Marketing Site
- **Path**: `marketing/`
- **Framework**: Next.js
- **Config**: `next.config.js`, `package.json`
- **Build**: `npm run build`
- **Deploy**: Vercel

### 3. Next.js Business Portal
- **Path**: `business/`
- **Framework**: Next.js
- **Config**: `next.config.js`, `package.json`
- **Build**: `npm run build`
- **Deploy**: Vercel

### 4. Next.js Admin Panel
- **Path**: `admin/`
- **Framework**: Next.js
- **Config**: `next.config.js`, `package.json`
- **Build**: `npm run build`
- **Deploy**: Vercel
- **Note**: English-only (no translations)

### 5. Next.js Enterprise App
- **Path**: `enterprise-app/`
- **Framework**: Next.js
- **Config**: `next.config.js`, `package.json`
- **Build**: `npm run build`
- **Deploy**: Vercel

### 6. Next.js Dashboard
- **Path**: `dashboard/`
- **Framework**: Next.js
- **Config**: `next.config.js`, `package.json`
- **Build**: `npm run build`
- **Deploy**: Vercel

### 7. Cloud Functions (Backend)
- **Path**: `functions/`
- **Framework**: Node.js
- **Config**: `package.json`, `firebase.json`
- **Build**: `npm run build`
- **Deploy**: Firebase Functions

### 8. Enterprise Onboarding Portal
- **Path**: `enterprise-onboarding-portal/`
- **Framework**: Node.js/Express
- **Config**: `package.json`
- **Build**: `npm run build`
- **Deploy**: Custom

## Root Configuration
- **Package Manager**: pnpm (workspace)
- **Firebase**: `firebase.json`, `firestore.rules`
- **CI/CD**: `.github/workflows/*`
- **Analysis**: `analysis_options.yaml` (Flutter)

## Build Commands Summary
```bash
# Flutter PWA
cd appoint && flutter build web

# Next.js Apps
cd marketing && npm run build
cd business && npm run build
cd admin && npm run build
cd enterprise-app && npm run build
cd dashboard && npm run build

# Backend
cd functions && npm run build
cd enterprise-onboarding-portal && npm run build
```

## Environment Files
- `.env.local` (Next.js apps)
- `.env.example` (templates)
- Firebase configs
- Vercel configs

## Notes
- Admin panel is English-only (no i18n)
- Flutter app has comprehensive l10n support
- All Next.js apps use Vercel deployment
- Firebase backend with cloud functions
