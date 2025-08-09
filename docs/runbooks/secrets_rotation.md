# Secrets Rotation Runbook

## Overview

This document outlines the procedures for rotating secrets used in the Share-in-Groups feature, particularly guest token HMAC keys.

## Secrets to Rotate

### 1. Guest Token HMAC Secret

**Location**: Firebase Remote Config / Environment Variables
**Key**: `guest_token_secret`
**Purpose**: Signing guest tokens for secure meeting access

## Rotation Schedule

- **Primary Secret**: Rotate every 90 days
- **Emergency Rotation**: Immediately if compromised
- **Testing**: Rotate in staging every 30 days

## Pre-Rotation Checklist

- [ ] Backup current secret value
- [ ] Generate new secret using secure random generator
- [ ] Test new secret in staging environment
- [ ] Prepare rollback plan
- [ ] Notify team of maintenance window

## Rotation Procedure

### Step 1: Generate New Secret

```bash
# Generate new HMAC secret
openssl rand -base64 32
# Output: <new-secret-value>
```

### Step 2: Update Firebase Remote Config

```bash
# Set new secret in Firebase Remote Config
firebase functions:config:set share.hmac_key="<new-secret-value>"

# Or update via Firebase Console:
# 1. Go to Firebase Console > Remote Config
# 2. Add parameter: guest_token_secret
# 3. Set value to new secret
# 4. Publish changes
```

### Step 3: Update Environment Variables (if used)

```bash
# For deployment environments
export GUEST_TOKEN_SECRET="<new-secret-value>"

# For CI/CD pipelines
# Update secret in GitHub Secrets or similar
```

### Step 4: Verify Rotation

1. **Test in Staging**:
   ```bash
   # Create test guest token
   curl -X POST https://staging.app-oint.com/api/guest-tokens \
     -H "Content-Type: application/json" \
     -d '{"meetingId": "test-meeting-123"}'
   ```

2. **Validate Token**:
   ```bash
   # Validate the created token
   curl -X GET https://staging.app-oint.com/api/guest-tokens/validate \
     -H "Content-Type: application/json" \
     -d '{"token": "<token-from-step-1>", "meetingId": "test-meeting-123"}'
   ```

### Step 5: Production Deployment

1. **Deploy to Production**:
   ```bash
   # Deploy with new secret
   firebase deploy --only functions
   ```

2. **Monitor for Issues**:
   - Check error rates in Firebase Console
   - Monitor guest token validation failures
   - Watch for authentication errors

## Post-Rotation Tasks

### Step 6: Cleanup

1. **Remove Old Secret**:
   ```bash
   # Remove old secret from environment
   unset GUEST_TOKEN_SECRET_OLD
   ```

2. **Update Documentation**:
   - Update this runbook with new rotation date
   - Update team calendar for next rotation

### Step 7: Verification

- [ ] All guest tokens created with new secret work
- [ ] Old tokens still work (if within expiry window)
- [ ] No authentication errors in logs
- [ ] Analytics show normal guest token creation rates

## Emergency Rotation

### If Secret is Compromised

1. **Immediate Actions**:
   ```bash
   # Revoke all active guest tokens
   firebase functions:call revokeAllGuestTokens
   
   # Update secret immediately
   firebase functions:config:set share.hmac_key="<emergency-secret>"
   ```

2. **Notify Users**:
   - Send in-app notification about re-authentication
   - Update status page if needed
   - Contact affected users directly

3. **Investigation**:
   - Review access logs
   - Identify compromise source
   - Update security procedures

## Monitoring

### Key Metrics to Watch

- **Guest Token Creation Rate**: Should remain stable
- **Guest Token Validation Failures**: Should not spike
- **Authentication Errors**: Should not increase
- **User Complaints**: Monitor support tickets

### Alerts

- **High Token Validation Failures**: > 5% failure rate
- **Zero Token Creation**: No tokens created in 1 hour
- **Authentication Errors**: > 10 errors per minute

## Rollback Procedure

If rotation causes issues:

1. **Immediate Rollback**:
   ```bash
   # Restore previous secret
   firebase functions:config:set share.hmac_key="<previous-secret>"
   
   # Redeploy functions
   firebase deploy --only functions
   ```

2. **Investigation**:
   - Identify why new secret failed
   - Test in staging before next attempt
   - Update rotation procedure if needed

## Security Best Practices

1. **Secret Generation**:
   - Use cryptographically secure random generator
   - Minimum 32 bytes for HMAC secrets
   - Never reuse secrets

2. **Secret Storage**:
   - Use Firebase Remote Config for dynamic secrets
   - Use environment variables for static secrets
   - Never commit secrets to version control

3. **Access Control**:
   - Limit access to secret management
   - Audit secret access regularly
   - Use least privilege principle

4. **Monitoring**:
   - Monitor secret usage patterns
   - Alert on unusual access patterns
   - Log all secret operations

## Contact Information

- **Primary Contact**: DevOps Team
- **Secondary Contact**: Security Team
- **Emergency Contact**: On-call Engineer

## Related Documents

- [Firebase Remote Config Documentation](https://firebase.google.com/docs/remote-config)
- [Security Best Practices](../security/best-practices.md)
- [Incident Response Plan](../incident-response.md)


