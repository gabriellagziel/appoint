# 🔐 Admin Free Access System Documentation

## 📋 Overview

The Free Access System allows super admins to grant temporary or permanent free access to personal users, business accounts, and enterprise clients. This system provides granular control over billing bypasses with full audit trails.

## 🏗️ Architecture

### Data Model

#### Free Access Grants Collection
```javascript
// free_access_grants/{grantId}
{
  targetType: 'personal' | 'business' | 'enterprise',
  targetId: string,
  fieldsApplied: object,        // Snapshot of changes applied
  reason: string,               // Required reason for grant
  createdBy: adminUid,
  createdAt: timestamp,
  expiresAt?: timestamp,        // Optional expiration
  status: 'active' | 'revoked' | 'expired',
  overrideNote?: string         // Optional admin notes
}
```

#### Entity Field Extensions

**Personal Users (`users/{uid}`):**
```javascript
{
  planOverride: 'none' | 'free' | 'free_premium',
  freeUntil?: timestamp,
  premiumForced?: boolean,
  overrideNote?: string
}
```

**Business Accounts (`business_accounts/{id}`):**
```javascript
{
  planOverride: 'none' | 'free_studio' | 'free_enterprise',
  freeUntil?: timestamp,
  seatLimitOverride?: number | -1,  // -1 = unlimited
  overrideNote?: string
}
```

**Enterprise Clients (`enterprise_clients/{id}`):**
```javascript
{
  planOverride: 'none' | 'free_api',
  freeUntil?: timestamp,
  rateLimitOverride?: number | -1,  // -1 = unlimited
  featureAccessOverride?: string[] | ['all'],
  overrideNote?: string
}
```

## 🔐 Security & Permissions

### Role-Based Access

- **Super Admin**: Can create, revoke, and view all grants
- **Admin**: Can view grants but cannot create/revoke
- **Regular Users**: No access to free access management

### Firestore Security Rules

```javascript
// Only super admins can write to free_access_grants
match /free_access_grants/{grantId} {
  allow read: if isAdmin();
  allow create, update, delete: if isSuperAdmin();
}

// Only super admins can modify free access fields on entities
match /users/{userId} {
  allow write: if isSuperAdmin() || 
    !('planOverride' in request.resource.data.diff(resource.data).affectedKeys());
}
```

## 🎯 User Flows

### 1. Granting Free Access

**Flow:**
1. Super admin navigates to `/admin/free-access` or entity-specific page
2. Clicks "Grant Free Access" button
3. Fills out grant form with:
   - Target type (personal/business/enterprise)
   - Target ID
   - Duration (7d/30d/90d/permanent or custom date)
   - Type-specific settings (plan override, limits, etc.)
   - Required reason
   - Optional notes
4. System validates and creates grant
5. Entity fields are updated with override values
6. Grant is logged to audit trail

**Example Grant:**
```javascript
{
  targetType: 'personal',
  targetId: 'user123',
  fieldsApplied: {
    planOverride: 'free_premium',
    premiumForced: true,
    freeUntil: '2024-12-31T23:59:59Z'
  },
  reason: 'Customer support - billing issue resolution',
  expiresAt: '2024-12-31T23:59:59Z'
}
```

### 2. Revoking Free Access

**Flow:**
1. Super admin views active grant
2. Clicks "Revoke Access" button
3. Provides required reason for revocation
4. System marks grant as revoked
5. Entity fields are reverted to original values
6. Revocation is logged to audit trail

### 3. Automatic Expiration

**Flow:**
1. Cloud Function runs every hour
2. Finds grants where `status='active'` and `expiresAt < now`
3. Marks grants as expired
4. Reverts entity fields to original values
5. Logs expiration events

## 🛠️ Implementation Details

### Service Layer

**`freeAccessService.ts`** - Core service handling:
- `grantFreeAccess()` - Create new grants
- `revokeFreeAccess()` - Revoke active grants
- `getActiveGrants()` - Query active grants
- `getGrantHistory()` - Get grant history for target
- `expireOverdueGrants()` - Expire overdue grants

### UI Components

**`GrantForm.tsx`** - Comprehensive grant creation form with:
- Target type selection
- Duration presets and custom dates
- Type-specific field configuration
- Validation and error handling

**`GrantHistory.tsx`** - Grant history display with:
- Status indicators and badges
- Detailed grant information
- Audit trail integration

### Pages

**`/admin/free-access`** - Main hub showing:
- All active grants with filtering
- Statistics and metrics
- Bulk management capabilities

**`/admin/users/[id]/free-access`** - Personal user management
**`/admin/business/[id]/free-access`** - Business account management  
**`/admin/api/[id]/free-access`** - Enterprise client management

## 🔄 Integration Points

### Billing System Integration

The free access system integrates with the billing system by:

1. **Plan Resolution**: When checking user entitlements, the system checks for active free access grants
2. **Feature Gates**: Premium features check for `premiumForced` or valid `planOverride`
3. **Rate Limiting**: API rate limits respect `rateLimitOverride` values
4. **Seat Limits**: Business seat limits respect `seatLimitOverride` values

### Example Entitlement Check:
```javascript
async function getUserEntitlements(userId: string) {
  const user = await getUser(userId);
  const activeGrant = await freeAccessService.getActiveGrant('personal', userId);
  
  if (activeGrant && activeGrant.status === 'active') {
    // Apply free access overrides
    return {
      isPremium: activeGrant.fieldsApplied.premiumForced || 
                 activeGrant.fieldsApplied.planOverride === 'free_premium',
      planType: activeGrant.fieldsApplied.planOverride,
      // ... other entitlements
    };
  }
  
  // Return normal billing-based entitlements
  return getBillingEntitlements(user);
}
```

## 📊 Monitoring & Analytics

### Key Metrics

- **Active Grants**: Total number of active free access grants
- **Grant Types**: Distribution by target type (personal/business/enterprise)
- **Expiring Soon**: Grants expiring in next 7 days
- **Grant Duration**: Average grant duration and distribution
- **Revocation Rate**: Percentage of grants revoked vs expired

### Audit Trail

Every action is logged to `system_logs`:
- `free_access_granted` - New grants created
- `free_access_revoked` - Grants manually revoked
- `free_access_expired` - Grants automatically expired

## 🚨 Rollback Procedures

### Emergency Grant Revocation

**Manual Revocation:**
1. Navigate to `/admin/free-access`
2. Find the grant in the table
3. Click "Revoke" and provide reason
4. System immediately reverts entity fields

**Bulk Revocation (Emergency):**
```javascript
// Direct Firestore query for emergency situations
const grants = await db.collection('free_access_grants')
  .where('status', '==', 'active')
  .where('targetType', '==', 'personal')
  .get();

for (const doc of grants.docs) {
  await freeAccessService.revokeFreeAccess('emergency', doc.id, {
    reason: 'Emergency rollback - system issue'
  });
}
```

### Data Recovery

**Restore Grant:**
```javascript
// Re-create a revoked grant
await freeAccessService.grantFreeAccess(adminUid, {
  targetType: 'personal',
  targetId: 'user123',
  changes: { planOverride: 'free_premium' },
  reason: 'Restored after system issue'
});
```

### Emergency Expiration

**Force Expire All:**
```javascript
// Cloud Function to force expire all grants
export const emergencyExpireAll = functions.https.onRequest(async (req, res) => {
  const grants = await db.collection('free_access_grants')
    .where('status', '==', 'active')
    .get();
    
  const batch = db.batch();
  grants.docs.forEach(doc => {
    batch.update(doc.ref, { status: 'expired', expiredAt: admin.firestore.Timestamp.now() });
  });
  
  await batch.commit();
  res.json({ expired: grants.size });
});
```

## 🧪 Testing

### Unit Tests

```javascript
describe('FreeAccessService', () => {
  test('should grant free access to personal user', async () => {
    const grantId = await freeAccessService.grantFreeAccess(adminUid, {
      targetType: 'personal',
      targetId: 'test-user',
      changes: { planOverride: 'free_premium' },
      reason: 'Test grant'
    });
    
    expect(grantId).toBeDefined();
    
    const user = await getUser('test-user');
    expect(user.planOverride).toBe('free_premium');
  });
});
```

### Integration Tests

```javascript
describe('Free Access Integration', () => {
  test('should bypass billing for granted user', async () => {
    // Grant free access
    await grantFreeAccess('test-user');
    
    // Verify billing bypass
    const entitlements = await getUserEntitlements('test-user');
    expect(entitlements.isPremium).toBe(true);
    
    // Revoke access
    await revokeFreeAccess('test-user');
    
    // Verify billing restored
    const entitlementsAfter = await getUserEntitlements('test-user');
    expect(entitlementsAfter.isPremium).toBe(false);
  });
});
```

### E2E Tests

```javascript
describe('Free Access E2E', () => {
  test('complete grant workflow', async () => {
    // Login as super admin
    await loginAsSuperAdmin();
    
    // Navigate to free access page
    await page.goto('/admin/free-access');
    
    // Create new grant
    await page.click('[data-testid="grant-free-access"]');
    await page.fill('[data-testid="target-id"]', 'test-user');
    await page.selectOption('[data-testid="target-type"]', 'personal');
    await page.fill('[data-testid="reason"]', 'E2E test');
    await page.click('[data-testid="submit-grant"]');
    
    // Verify grant created
    await expect(page.locator('[data-testid="grant-status"]')).toContainText('ACTIVE');
  });
});
```

## 🔧 Configuration

### Environment Variables

```bash
# Required for Cloud Functions
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_PRIVATE_KEY=your-private-key
FIREBASE_CLIENT_EMAIL=your-client-email

# Optional: Customize expiration check frequency
FREE_ACCESS_EXPIRATION_INTERVAL=every 1 hours
```

### Firestore Indexes

Required indexes for efficient queries:
```javascript
// free_access_grants collection
- status + createdAt (DESC)
- targetType + targetId + status + createdAt (DESC)
- status + expiresAt (ASC)
- targetType + status + createdAt (DESC)
```

## 🚀 Deployment Checklist

### Pre-Deployment

- [ ] Firestore rules updated with free access permissions
- [ ] Firestore indexes created for free_access_grants
- [ ] Cloud Function deployed for expiration handling
- [ ] Admin UI components built and tested
- [ ] Super admin roles configured in Firebase Auth

### Post-Deployment

- [ ] Test grant creation for each target type
- [ ] Test grant revocation and field reversion
- [ ] Test automatic expiration via Cloud Function
- [ ] Verify audit logging is working
- [ ] Test billing integration with free access overrides
- [ ] Monitor system logs for any errors

### Production Monitoring

- [ ] Set up alerts for grant expiration failures
- [ ] Monitor grant creation patterns for abuse
- [ ] Track grant duration and revocation rates
- [ ] Set up dashboards for free access metrics

## 📞 Support & Troubleshooting

### Common Issues

**Grant not applying:**
1. Check if user has super admin permissions
2. Verify Firestore rules allow the operation
3. Check system logs for errors
4. Verify target entity exists

**Expiration not working:**
1. Check Cloud Function logs
2. Verify Firestore indexes are created
3. Check if function is deployed and scheduled
4. Verify grant has valid expiresAt timestamp

**UI not loading:**
1. Check browser console for errors
2. Verify Firebase configuration
3. Check authentication state
4. Verify component imports

### Emergency Contacts

- **System Admin**: For emergency rollbacks
- **Firebase Admin**: For Firestore rule changes
- **Cloud Function Admin**: For expiration function issues

---

**Last Updated**: December 2024  
**Version**: 1.0.0  
**Maintainer**: Admin Team
