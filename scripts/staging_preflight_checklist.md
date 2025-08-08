# 🚀 Staging Preflight & Postflight Checklist

## 🔧 Preflight (2 mins)

### Authentication Setup
- [ ] **Auth domains**: Add your staging URL + localhost in Firebase Auth
  - Go to: Authentication → Settings → Authorized domains
  - Add: `your-staging-project-id.web.app`
  - Add: `your-staging-project-id.firebaseapp.com`
  - Add: `localhost` (for local testing)

### Hosting Configuration
- [ ] **Hosting rewrites**: SPA fallback to `/index.html` (avoid 404 on deep links)
- [ ] **Service worker**: Confirm `flutter build web` outputs updated `flutter_service_worker.js`
- [ ] **Bump version**: Update service worker version so clients don't cache old JS
- [ ] **Env flags**: Set `USE_MOCK_AUTH=false` for staging if you used that locally

### Security Rules
- [ ] **Rules deployment**: Confirm you deployed the latest `firestore.rules`
- [ ] **Adult bypass**: Verify rules include adult bypass logic
- [ ] **Child approval gates**: Confirm child approval requirements are enforced
- [ ] **Test rules**: Run `firebase deploy --only firestore:rules --dry-run`

### App Check (Optional)
- [ ] **Web key**: Create reCAPTCHA v3 key for web
- [ ] **Configuration**: Wire App Check behind a feature flag
- [ ] **Domain setup**: Add staging domain to App Check

## 🧪 Postflight (5 mins)

### Smoke Tests (Staging URL)

#### ✅ Adult Test (18+)
- [ ] Login as `adult_18`
- [ ] Create virtual session with "Mature Shooter"
- [ ] Create physical session with "Mature Shooter"
- [ ] **Expected**: No prompts, sessions created immediately

#### 🔴 Child Test (10)
- [ ] Login as `child_10`
- [ ] Try to create session with "Mature Shooter"
- [ ] **Expected**: Blocked, virtual link locked until parent approval
- [ ] Verify game shows "🔴 Restricted" badge

#### 🟡 Teen Test (15)
- [ ] Login as `teen_15`
- [ ] Try to create session with "Mature Shooter"
- [ ] **Expected**: Needs parent approval, shows "🟡 Needs Approval"
- [ ] Toggle `parentApproved: true` in Firestore Console
- [ ] Confirm session becomes joinable

### Analytics Verification
- [ ] **Events arrive**: Check Firebase Console → Analytics for:
  - `playtime_session_create_attempt`
  - `playtime_parent_approval`
  - `playtime_age_restriction_violation`
  - `playtime_safety_flag`

### Security Testing
- [ ] **Rules enforcement**: Try writing an underage session via DevTools → **DENIED**
- [ ] **Unauthorized access**: Test without authentication → **DENIED**
- [ ] **Cross-user access**: Try accessing other user's data → **DENIED**

## 🚨 Monitoring & Rollback

### Rollback Procedures
```bash
# Re-deploy previous rules (if you keep versions)
firebase deploy --only firestore:rules --project $STAGING_PROJECT_ID --force

# Roll back hosting to last release
firebase hosting:channel:deploy live --project $STAGING_PROJECT_ID

# Emergency rollback (if needed)
firebase hosting:revert --project $STAGING_PROJECT_ID
```

### Health Checks
- [ ] **Uptime**: Staging URL responds correctly
- [ ] **Authentication**: Sign-in flow works
- [ ] **Database**: Firestore reads/writes function
- [ ] **Analytics**: Events are being logged

## 🎯 Success Criteria

### ✅ All Smoke Tests Pass
- [ ] Adult can create any session without restrictions
- [ ] Child is blocked from inappropriate games
- [ ] Teen needs parent approval for restricted games
- [ ] Parent approval workflow functions correctly

### ✅ Security Rules Enforced
- [ ] Age-based restrictions working
- [ ] Parent approval required for minors
- [ ] Unauthorized access blocked
- [ ] Cross-user data access prevented

### ✅ Analytics Tracking
- [ ] Custom events logging correctly
- [ ] User interactions tracked
- [ ] Error events captured
- [ ] Performance metrics available

## 🚀 Nice-to-Haves (Soon, Not Now)

### CI/CD Enhancements
- [ ] **CI staging deploy on tag**: `v*-staging` triggers deployment
- [ ] **Automated seeding**: Include data seeding in CI pipeline
- [ ] **Health checks**: Automated post-deployment validation

### Feature Flags
- [ ] **PLAYTIME_PUBLIC_EVENTS**: Off by default
- [ ] **USE_MOCK_AUTH**: Configurable for different environments
- [ ] **ENABLE_APP_CHECK**: Toggle App Check functionality

### Compliance Features
- [ ] **GDPR/COPPA consent**: Show consent copy for minors on first launch
- [ ] **Staging banner**: Clear indication this is staging environment
- [ ] **Data retention**: Clear staging data periodically

## 🎉 Ready for Production

Once all preflight and postflight checks pass:
- [ ] All smoke tests successful
- [ ] Analytics events logging
- [ ] Security rules enforced
- [ ] Performance acceptable
- [ ] Rollback procedures tested

**Status: READY FOR PRODUCTION DEPLOYMENT** 🚀

## 🔧 Preflight (2 mins)

### Authentication Setup
- [ ] **Auth domains**: Add your staging URL + localhost in Firebase Auth
  - Go to: Authentication → Settings → Authorized domains
  - Add: `your-staging-project-id.web.app`
  - Add: `your-staging-project-id.firebaseapp.com`
  - Add: `localhost` (for local testing)

### Hosting Configuration
- [ ] **Hosting rewrites**: SPA fallback to `/index.html` (avoid 404 on deep links)
  ```json
  {
    "hosting": {
      "public": "build/web",
      "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
      "rewrites": [
        {
          "source": "**",
          "destination": "/index.html"
        }
      ]
    }
  }
  ```

### Build Configuration
- [ ] **Service worker**: Confirm `flutter build web` outputs updated `flutter_service_worker.js`
- [ ] **Bump version**: Update service worker version so clients don't cache old JS
- [ ] **Env flags**: Set `USE_MOCK_AUTH=false` for staging if you used that locally

### Security Rules
- [ ] **Rules deployment**: Confirm you deployed the latest `firestore.rules`
- [ ] **Adult bypass**: Verify rules include adult bypass logic
- [ ] **Child approval gates**: Confirm child approval requirements are enforced
- [ ] **Test rules**: Run `firebase deploy --only firestore:rules --dry-run`

### App Check (Optional)
- [ ] **Web key**: Create reCAPTCHA v3 key for web
- [ ] **Configuration**: Wire App Check behind a feature flag
- [ ] **Domain setup**: Add staging domain to App Check

## 🧪 Postflight (5 mins)

### Smoke Tests (Staging URL)

#### ✅ Adult Test (18+)
- [ ] Login as `adult_18`
- [ ] Create virtual session with "Mature Shooter"
- [ ] Create physical session with "Mature Shooter"
- [ ] **Expected**: No prompts, sessions created immediately

#### 🔴 Child Test (10)
- [ ] Login as `child_10`
- [ ] Try to create session with "Mature Shooter"
- [ ] **Expected**: Blocked, virtual link locked until parent approval
- [ ] Verify game shows "🔴 Restricted" badge

#### 🟡 Teen Test (15)
- [ ] Login as `teen_15`
- [ ] Try to create session with "Mature Shooter"
- [ ] **Expected**: Needs parent approval, shows "🟡 Needs Approval"
- [ ] Toggle `parentApproved: true` in Firestore Console
- [ ] Confirm session becomes joinable

### Analytics Verification
- [ ] **Events arrive**: Check Firebase Console → Analytics for:
  - `playtime_session_create_attempt`
  - `playtime_parent_approval`
  - `playtime_age_restriction_violation`
  - `playtime_safety_flag`

### Security Testing
- [ ] **Rules enforcement**: Try writing an underage session via DevTools → **DENIED**
- [ ] **Unauthorized access**: Test without authentication → **DENIED**
- [ ] **Cross-user access**: Try accessing other user's data → **DENIED**

### Performance Checks
- [ ] **Page load time**: < 3 seconds on staging
- [ ] **Service worker**: Caching working correctly
- [ ] **Deep links**: Direct URLs work without 404s
- [ ] **Mobile responsive**: Test on mobile browser

## 🚨 Monitoring & Rollback

### Crash/Logs Setup
- [ ] **Console log drain**: Add quick console log monitoring
- [ ] **Error tracking**: Set up Sentry/GA4 (optional)
- [ ] **Auth errors**: Monitor for authentication failures
- [ ] **Rules errors**: Watch for Firestore permission denied

### Rollback Procedures
```bash
# Re-deploy previous rules (if you keep versions)
firebase deploy --only firestore:rules --project $STAGING_PROJECT_ID --force

# Roll back hosting to last release
firebase hosting:channel:deploy live --project $STAGING_PROJECT_ID

# Emergency rollback (if needed)
firebase hosting:revert --project $STAGING_PROJECT_ID
```

### Health Checks
- [ ] **Uptime**: Staging URL responds correctly
- [ ] **Authentication**: Sign-in flow works
- [ ] **Database**: Firestore reads/writes function
- [ ] **Analytics**: Events are being logged

## 🎯 Success Criteria

### ✅ All Smoke Tests Pass
- [ ] Adult can create any session without restrictions
- [ ] Child is blocked from inappropriate games
- [ ] Teen needs parent approval for restricted games
- [ ] Parent approval workflow functions correctly

### ✅ Security Rules Enforced
- [ ] Age-based restrictions working
- [ ] Parent approval required for minors
- [ ] Unauthorized access blocked
- [ ] Cross-user data access prevented

### ✅ Analytics Tracking
- [ ] Custom events logging correctly
- [ ] User interactions tracked
- [ ] Error events captured
- [ ] Performance metrics available

### ✅ UI/UX Working
- [ ] Badges show correct status (🟢/🟡/🔴)
- [ ] Clear messaging explains restrictions
- [ ] Approval flow is intuitive
- [ ] Mobile responsive design

## 🚀 Nice-to-Haves (Soon, Not Now)

### CI/CD Enhancements
- [ ] **CI staging deploy on tag**: `v*-staging` triggers deployment
- [ ] **Automated seeding**: Include data seeding in CI pipeline
- [ ] **Health checks**: Automated post-deployment validation

### Feature Flags
- [ ] **PLAYTIME_PUBLIC_EVENTS**: Off by default
- [ ] **USE_MOCK_AUTH**: Configurable for different environments
- [ ] **ENABLE_APP_CHECK**: Toggle App Check functionality

### Compliance Features
- [ ] **GDPR/COPPA consent**: Show consent copy for minors on first launch
- [ ] **Staging banner**: Clear indication this is staging environment
- [ ] **Data retention**: Clear staging data periodically

## 📞 Quick Commands

### Preflight Commands
```bash
# Check Firebase CLI
firebase --version

# Verify project access
firebase projects:list

# Test rules deployment
firebase deploy --only firestore:rules --dry-run

# Build for staging
flutter build web --release
```

### Postflight Commands
```bash
# Check hosting deployment
firebase hosting:channel:list

# View analytics events
firebase analytics:events:list

# Test rules locally
firebase emulators:start --only firestore
```

### Emergency Commands
```bash
# Quick rollback
firebase hosting:revert

# Force rules deployment
firebase deploy --only firestore:rules --force

# Clear cache
firebase hosting:clear
```

## 🎉 Ready for Production

Once all preflight and postflight checks pass:
- [ ] All smoke tests successful
- [ ] Analytics events logging
- [ ] Security rules enforced
- [ ] Performance acceptable
- [ ] Rollback procedures tested

**Status: READY FOR PRODUCTION DEPLOYMENT** 🚀
## 🧪 Quick Smoke Test Checklist
### ✅ Adult Test (18+)
- [ ] Login as adult_18
- [ ] Create virtual + physical with 'Mature Shooter'
- [ ] Expected: No prompts, session created immediately

### 🔴 Child Test (10)
- [ ] Login as child_10
- [ ] Try to create session with 'Mature Shooter'
- [ ] Expected: Blocked, virtual link locked until parent approval

### 🟡 Teen Test (15)
- [ ] Login as teen_15
- [ ] Try to create session with 'Mature Shooter'
- [ ] Expected: Needs parent approval
- [ ] Toggle parentApproved: true in Firestore
- [ ] Confirm session becomes joinable
## 🔧 Preflight Commands
```bash
# Check Firebase CLI
firebase --version

# Verify project access
firebase projects:list

# Test rules deployment
firebase deploy --only firestore:rules --dry-run

# Build for staging
flutter build web --release
```
## 🎉 Ready for Production

Once all preflight and postflight checks pass:
- [ ] All smoke tests successful
- [ ] Analytics events logging
- [ ] Security rules enforced
- [ ] Performance acceptable
- [ ] Rollback procedures tested

**Status: READY FOR PRODUCTION DEPLOYMENT** 🚀
