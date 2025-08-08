# 🔐 Firebase Prep Checklist for Staging

## Authentication Setup

### 1. Authorized Domains
- [ ] Add your staging host to **Authorized domains** in Firebase Console
  - Go to: Authentication → Settings → Authorized domains
  - Add: `your-staging-project-id.web.app`
  - Add: `your-staging-project-id.firebaseapp.com`
  - Add: `localhost` (for local testing)

### 2. Sign-in Methods
- [ ] Enable **Google sign-in** in Authentication → Sign-in method
- [ ] Configure OAuth consent screen if needed
- [ ] Test sign-in flow in staging environment

### 3. App Check (Optional but Recommended)
- [ ] Set up **reCAPTCHA v3** for web
  - Go to: Project Settings → App Check
  - Enable reCAPTCHA v3
  - Add your staging domain
- [ ] Update `firebase_options.dart` with App Check configuration

## Firestore Security Rules

### 1. Verify Latest Rules
- [ ] Confirm `firestore.rules` contains latest age-based restrictions
- [ ] Deploy rules: `firebase deploy --only firestore:rules`
- [ ] Test rules in Firebase Console → Firestore → Rules

### 2. Rules Validation
```bash
# Test rules locally first
firebase emulators:start --only firestore
# Then test your rules in the emulator UI
```

## Project Configuration

### 1. Environment Variables
- [ ] Set `STAGING_PROJECT_ID` environment variable
- [ ] Configure Firebase CLI: `firebase use $STAGING_PROJECT_ID`
- [ ] Verify project selection: `firebase projects:list`

### 2. Service Account (if needed for seeding)
- [ ] Generate service account key in Project Settings → Service accounts
- [ ] Download JSON key for automated seeding scripts
- [ ] Store securely (don't commit to repo)

## Pre-Deployment Checklist

### 1. Firebase CLI
- [ ] `firebase --version` (should be 14.2.1+)
- [ ] `firebase login` (if not already logged in)
- [ ] `firebase projects:list` (verify access)

### 2. Project Permissions
- [ ] Verify you have **Owner** or **Editor** permissions
- [ ] Check billing is enabled (if needed)
- [ ] Confirm Firestore is enabled

### 3. Security Rules Test
```bash
# Test rules deployment
firebase deploy --only firestore:rules --dry-run
```

## Post-Deployment Verification

### 1. Authentication Flow
- [ ] Test sign-in with Google
- [ ] Verify user creation in Firestore
- [ ] Check user age data is stored correctly

### 2. Firestore Access
- [ ] Verify rules allow read/write for authenticated users
- [ ] Test age-based restrictions work
- [ ] Confirm parent approval workflows function

### 3. Analytics Setup
- [ ] Enable Google Analytics for Firebase
- [ ] Verify custom events are logging
- [ ] Check Firebase Console → Analytics

## Troubleshooting

### Common Issues
- **Auth domain not authorized**: Add domain to authorized domains list
- **Rules deployment fails**: Check syntax in `firestore.rules`
- **App Check errors**: Disable temporarily for testing
- **Permission denied**: Verify project permissions

### Quick Fixes
```bash
# Reset Firebase CLI
firebase logout
firebase login

# Clear cache
firebase use --clear
firebase use $STAGING_PROJECT_ID

# Force deploy rules
firebase deploy --only firestore:rules --force
```

## Security Notes

### 1. Staging vs Production
- [ ] Use separate Firebase projects for staging/production
- [ ] Different service accounts for each environment
- [ ] Staging can have relaxed rules for testing

### 2. Data Privacy
- [ ] Use test data only in staging
- [ ] No real user data in staging environment
- [ ] Clear staging data periodically

### 3. Access Control
- [ ] Limit staging access to development team
- [ ] Use Firebase Auth for user management
- [ ] Monitor usage in Firebase Console

## Ready for Deployment

Once all items are checked:
- [ ] Firebase project configured
- [ ] Authentication working
- [ ] Firestore rules deployed
- [ ] Test data ready
- [ ] Team has access

**Status: READY FOR STAGING DEPLOYMENT** 🚀
