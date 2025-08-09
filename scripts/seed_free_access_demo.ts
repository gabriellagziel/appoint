import * as admin from 'firebase-admin';

// Initialize Firebase Admin
if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

/**
 * Seed script for free access demo data
 * Usage: npx ts-node scripts/seed_free_access_demo.ts
 */
async function seedFreeAccessDemo() {
  console.log('🌱 Seeding free access demo data...');

  try {
    // Create demo users if they don't exist
    const demoUsers = [
      { uid: 'demo-user-1', email: 'demo1@example.com', displayName: 'Demo User 1' },
      { uid: 'demo-user-2', email: 'demo2@example.com', displayName: 'Demo User 2' },
      { uid: 'demo-user-3', email: 'demo3@example.com', displayName: 'Demo User 3' }
    ];

    for (const user of demoUsers) {
      await db.collection('users').doc(user.uid).set({
        email: user.email,
        displayName: user.displayName,
        createdAt: admin.firestore.Timestamp.now(),
        planOverride: 'none',
        premiumForced: false
      }, { merge: true });
    }

    // Create demo business accounts
    const demoBusinesses = [
      { id: 'demo-business-1', name: 'Demo Business 1', planOverride: 'none' },
      { id: 'demo-business-2', name: 'Demo Business 2', planOverride: 'none' }
    ];

    for (const business of demoBusinesses) {
      await db.collection('business_accounts').doc(business.id).set({
        name: business.name,
        createdAt: admin.firestore.Timestamp.now(),
        planOverride: business.planOverride,
        seatLimitOverride: null
      }, { merge: true });
    }

    // Create demo enterprise clients
    const demoEnterprises = [
      { id: 'demo-enterprise-1', name: 'Demo Enterprise 1', planOverride: 'none' },
      { id: 'demo-enterprise-2', name: 'Demo Enterprise 2', planOverride: 'none' }
    ];

    for (const enterprise of demoEnterprises) {
      await db.collection('enterprise_clients').doc(enterprise.id).set({
        name: enterprise.name,
        createdAt: admin.firestore.Timestamp.now(),
        planOverride: enterprise.planOverride,
        rateLimitOverride: null,
        featureAccessOverride: null
      }, { merge: true });
    }

    // Create demo free access grants
    const now = admin.firestore.Timestamp.now();
    const tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 1);
    const nextWeek = new Date();
    nextWeek.setDate(nextWeek.getDate() + 7);
    const nextMonth = new Date();
    nextMonth.setMonth(nextMonth.getMonth() + 1);

    const demoGrants = [
      // Active personal grant
      {
        targetType: 'personal',
        targetId: 'demo-user-1',
        fieldsApplied: {
          planOverride: 'free_premium',
          premiumForced: true,
          freeUntil: admin.firestore.Timestamp.fromDate(nextMonth),
          overrideNote: 'Demo grant for testing'
        },
        reason: 'Demo grant - customer support testing',
        createdBy: 'demo-admin',
        createdAt: now,
        expiresAt: admin.firestore.Timestamp.fromDate(nextMonth),
        status: 'active'
      },
      // Expiring soon personal grant
      {
        targetType: 'personal',
        targetId: 'demo-user-2',
        fieldsApplied: {
          planOverride: 'free',
          premiumForced: false,
          freeUntil: admin.firestore.Timestamp.fromDate(tomorrow),
          overrideNote: 'Expiring soon demo'
        },
        reason: 'Demo grant - expiring soon',
        createdBy: 'demo-admin',
        createdAt: now,
        expiresAt: admin.firestore.Timestamp.fromDate(tomorrow),
        status: 'active'
      },
      // Business grant
      {
        targetType: 'business',
        targetId: 'demo-business-1',
        fieldsApplied: {
          planOverride: 'free_enterprise',
          seatLimitOverride: -1,
          freeUntil: admin.firestore.Timestamp.fromDate(nextMonth),
          overrideNote: 'Demo business grant'
        },
        reason: 'Demo grant - business testing',
        createdBy: 'demo-admin',
        createdAt: now,
        expiresAt: admin.firestore.Timestamp.fromDate(nextMonth),
        status: 'active'
      },
      // Enterprise grant
      {
        targetType: 'enterprise',
        targetId: 'demo-enterprise-1',
        fieldsApplied: {
          planOverride: 'free_api',
          rateLimitOverride: -1,
          featureAccessOverride: ['all'],
          freeUntil: admin.firestore.Timestamp.fromDate(nextMonth),
          overrideNote: 'Demo enterprise grant'
        },
        reason: 'Demo grant - enterprise testing',
        createdBy: 'demo-admin',
        createdAt: now,
        expiresAt: admin.firestore.Timestamp.fromDate(nextMonth),
        status: 'active'
      },
      // Revoked grant (for history)
      {
        targetType: 'personal',
        targetId: 'demo-user-3',
        fieldsApplied: {
          planOverride: 'free_premium',
          premiumForced: true,
          freeUntil: admin.firestore.Timestamp.fromDate(nextWeek),
          overrideNote: 'Revoked demo grant'
        },
        reason: 'Demo grant - revoked for testing',
        createdBy: 'demo-admin',
        createdAt: admin.firestore.Timestamp.fromDate(new Date(Date.now() - 7 * 24 * 60 * 60 * 1000)),
        revokedAt: now,
        revokedBy: 'demo-admin',
        revokeReason: 'Demo revocation for testing',
        status: 'revoked'
      }
    ];

    for (const grant of demoGrants) {
      const grantRef = db.collection('free_access_grants').doc();
      await grantRef.set(grant);
      console.log(`✅ Created grant: ${grantRef.id} for ${grant.targetType}:${grant.targetId}`);
    }

    // Create demo system logs
    const demoLogs = [
      {
        action: 'free_access_granted',
        adminUid: 'demo-admin',
        targetType: 'personal',
        targetId: 'demo-user-1',
        details: {
          grantId: 'demo-grant-1',
          changes: { planOverride: 'free_premium' },
          reason: 'Demo grant - customer support testing',
          expiresAt: nextMonth.toISOString()
        },
        timestamp: now,
        severity: 'info'
      },
      {
        action: 'free_access_revoked',
        adminUid: 'demo-admin',
        targetType: 'personal',
        targetId: 'demo-user-3',
        details: {
          grantId: 'demo-grant-5',
          reason: 'Demo revocation for testing',
          originalChanges: { planOverride: 'free_premium' }
        },
        timestamp: now,
        severity: 'info'
      }
    ];

    for (const log of demoLogs) {
      await db.collection('system_logs').add(log);
    }

    console.log('✅ Demo data seeded successfully!');
    console.log('');
    console.log('📊 Demo Data Summary:');
    console.log('- 3 demo users (demo-user-1, demo-user-2, demo-user-3)');
    console.log('- 2 demo businesses (demo-business-1, demo-business-2)');
    console.log('- 2 demo enterprises (demo-enterprise-1, demo-enterprise-2)');
    console.log('- 5 demo grants (4 active, 1 revoked)');
    console.log('- 2 demo system logs');
    console.log('');
    console.log('🎯 Test Scenarios:');
    console.log('- Active grant: demo-user-1 (free_premium, expires in 1 month)');
    console.log('- Expiring soon: demo-user-2 (free, expires tomorrow)');
    console.log('- Business grant: demo-business-1 (free_enterprise, unlimited seats)');
    console.log('- Enterprise grant: demo-enterprise-1 (free_api, unlimited rate limit)');
    console.log('- Revoked grant: demo-user-3 (shows in history)');

  } catch (error) {
    console.error('❌ Error seeding demo data:', error);
    throw error;
  }
}

// Run the seed function
if (require.main === module) {
  seedFreeAccessDemo()
    .then(() => {
      console.log('🎉 Seed completed successfully!');
      process.exit(0);
    })
    .catch((error) => {
      console.error('💥 Seed failed:', error);
      process.exit(1);
    });
}

export { seedFreeAccessDemo };
