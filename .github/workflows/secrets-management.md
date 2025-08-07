# Secrets Management Guide

This document outlines all the secrets required for the CI/CD pipeline to function properly.

## Required GitHub Secrets

### Firebase Configuration
- `FIREBASE_TOKEN` - Firebase CLI token for deployment
- `FIREBASE_API_KEY` - Firebase API key
- `FIREBASE_AUTH_DOMAIN` - Firebase auth domain
- `FIREBASE_PROJECT_ID` - Firebase project ID
- `FIREBASE_STORAGE_BUCKET` - Firebase storage bucket
- `FIREBASE_MESSAGING_SENDER_ID` - Firebase messaging sender ID
- `FIREBASE_APP_ID` - Firebase app ID

### Apple Developer Account
- `IOS_P12_CERTIFICATE` - Base64 encoded iOS certificate
- `IOS_P12_PASSWORD` - iOS certificate password
- `APPLE_ISSUER_ID` - Apple issuer ID
- `APPLE_API_KEY_ID` - Apple API key ID
- `APPLE_API_PRIVATE_KEY` - Apple API private key

### Android Developer Account
- `ANDROID_KEYSTORE_BASE64` - Base64 encoded Android keystore
- `ANDROID_KEYSTORE_PASSWORD` - Android keystore password
- `ANDROID_KEY_ALIAS` - Android key alias
- `ANDROID_KEY_PASSWORD` - Android key password
- `PLAY_STORE_JSON_KEY` - Google Play Store service account JSON

### DigitalOcean Configuration
- `DIGITALOCEAN_ACCESS_TOKEN` - DigitalOcean API token
- `DIGITALOCEAN_APP_ID` - DigitalOcean App Platform app ID

### Stripe Configuration
- `STRIPE_PUBLISHABLE_KEY` - Stripe publishable key
- `STRIPE_SECRET_KEY` - Stripe secret key
- `STRIPE_WEBHOOK_SECRET` - Stripe webhook secret

### Analytics and Monitoring
- `SENTRY_DSN` - Sentry DSN for crash reporting
- `MIXPANEL_TOKEN` - Mixpanel token for analytics

### Notifications
- `SLACK_WEBHOOK_URL` - Slack webhook URL for notifications
- `DISCORD_WEBHOOK` - Discord webhook URL for notifications

### Google Services
- `GOOGLE_CLIENT_ID` - Google OAuth client ID
- `GOOGLE_CLIENT_SECRET` - Google OAuth client secret

## Environment-Specific Configuration

### Production Environment
```bash
ENVIRONMENT=production
DEBUG=false
LOG_LEVEL=info
API_BASE_URL=https://api.appoint.com
```

### Staging Environment
```bash
ENVIRONMENT=staging
DEBUG=true
LOG_LEVEL=debug
API_BASE_URL=https://staging-api.appoint.com
```

### Development Environment
```bash
ENVIRONMENT=development
DEBUG=true
LOG_LEVEL=debug
API_BASE_URL=http://localhost:3000
```

## Secret Rotation Schedule

- **Firebase Token**: Every 90 days
- **Apple Certificates**: Every 12 months
- **Android Keystore**: Every 12 months
- **Play Store Key**: Every 90 days
- **DigitalOcean Token**: Every 90 days
- **Stripe Keys**: Every 12 months
- **Analytics Tokens**: Every 12 months

## Security Best Practices

1. **Never commit secrets to version control**
2. **Use environment-specific secrets**
3. **Rotate secrets regularly**
4. **Limit secret access to necessary workflows**
5. **Monitor secret usage**
6. **Use least privilege principle**

## Secret Setup Instructions

### Firebase Setup
1. Install Firebase CLI: `npm install -g firebase-tools`
2. Login: `firebase login`
3. Generate token: `firebase login:ci`
4. Add token to GitHub secrets

### Apple Developer Setup
1. Create App Store Connect API key
2. Download certificate and convert to base64
3. Add all required secrets to GitHub

### Android Developer Setup
1. Generate keystore for app signing
2. Convert keystore to base64
3. Create Google Play Console service account
4. Add all required secrets to GitHub

### DigitalOcean Setup
1. Create API token in DigitalOcean console
2. Get App Platform app ID
3. Add secrets to GitHub

## Troubleshooting

### Common Issues
1. **Firebase deployment fails**: Check FIREBASE_TOKEN validity
2. **iOS build fails**: Verify certificate and provisioning profile
3. **Android build fails**: Check keystore and signing configuration
4. **DigitalOcean deployment fails**: Verify API token and app ID

### Debug Commands
```bash
# Test Firebase connection
firebase projects:list --token $FIREBASE_TOKEN

# Test Apple API connection
xcrun altool --list-providers -u $APPLE_ID -p $APPLE_APP_SPECIFIC_PASSWORD

# Test DigitalOcean connection
doctl auth init --access-token $DIGITALOCEAN_ACCESS_TOKEN
doctl apps list
```

## Emergency Procedures

### Secret Compromise
1. Immediately rotate the compromised secret
2. Update all environments
3. Monitor for unauthorized access
4. Document the incident

### Rollback Procedure
1. Revert to previous deployment
2. Update secrets if necessary
3. Redeploy with corrected configuration
4. Verify functionality

## Contact Information

For secret-related issues, contact:
- **DevOps Team**: devops@appoint.com
- **Security Team**: security@appoint.com
- **Emergency Contact**: +1-555-0123