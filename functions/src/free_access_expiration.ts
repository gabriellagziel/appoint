import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

// Initialize Firebase Admin if not already initialized
if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

// Configuration
const BATCH_SIZE = 200; // Process grants in chunks
const MAX_RETRIES = 3;
const RETRY_DELAY = 1000; // 1 second

/**
 * Cloud Function to expire overdue free access grants
 * Runs every 5 minutes via Cloud Scheduler
 */
export const expireFreeAccessGrants = functions.pubsub
  .schedule('every 5 minutes')
  .onRun(async (context) => {
    const startTime = Date.now();
    let processedCount = 0;
    let expiredCount = 0;
    let skippedCount = 0;
    let errorCount = 0;

    try {
      console.log('🕐 Starting free access grant expiration check...');
      
      const now = admin.firestore.Timestamp.now();
      
      // Find all active grants that have expired
      const expiredGrantsQuery = db
        .collection('free_access_grants')
        .where('status', '==', 'active')
        .where('expiresAt', '<', now)
        .limit(BATCH_SIZE);
      
      const expiredGrantsSnapshot = await expiredGrantsQuery.get();
      
      if (expiredGrantsSnapshot.empty) {
        console.log('✅ No expired grants found');
        await logMetrics({ processedCount, expiredCount, skippedCount, errorCount, duration: Date.now() - startTime });
        return { processedCount, expiredCount, skippedCount, errorCount };
      }
      
      console.log(`📊 Found ${expiredGrantsSnapshot.size} expired grants to process`);
      
      // Process grants in batches for better performance
      const grants = expiredGrantsSnapshot.docs;
      const batches = [];
      
      for (let i = 0; i < grants.length; i += BATCH_SIZE) {
        batches.push(grants.slice(i, i + BATCH_SIZE));
      }
      
      for (const batch of batches) {
        await processBatch(batch, now, {
          onProcessed: () => processedCount++,
          onExpired: () => expiredCount++,
          onSkipped: () => skippedCount++,
          onError: () => errorCount++
        });
      }
      
      console.log(`✅ Successfully processed ${processedCount} grants`);
      console.log(`📊 Results: ${expiredCount} expired, ${skippedCount} skipped, ${errorCount} errors`);
      
      await logMetrics({ processedCount, expiredCount, skippedCount, errorCount, duration: Date.now() - startTime });
      
      return { processedCount, expiredCount, skippedCount, errorCount };
      
    } catch (error) {
      console.error('❌ Error expiring free access grants:', error);
      errorCount++;
      await logMetrics({ processedCount, expiredCount, skippedCount, errorCount, duration: Date.now() - startTime });
      throw error;
    }
  });

/**
 * Process a batch of grants with retry logic
 */
async function processBatch(
  grants: FirebaseFirestore.QueryDocumentSnapshot[],
  now: admin.firestore.Timestamp,
  counters: {
    onProcessed: () => void;
    onExpired: () => void;
    onSkipped: () => void;
    onError: () => void;
  }
) {
  for (const doc of grants) {
    try {
      const grant = doc.data();
      counters.onProcessed();
      
      console.log(`🔄 Processing expired grant: ${doc.id} for ${grant.targetType}:${grant.targetId}`);
      
      // Check if grant is still active (idempotency)
      const currentDoc = await doc.ref.get();
      const currentData = currentDoc.data();
      
      if (!currentData || currentData.status !== 'active') {
        console.log(`⏭️ Skipping ${doc.id} - already ${currentData?.status || 'deleted'}`);
        counters.onSkipped();
        continue;
      }
      
      // Process with retry logic
      await processGrantWithRetry(doc, grant, now);
      counters.onExpired();
      
    } catch (error) {
      console.error(`❌ Error processing grant ${doc.id}:`, error);
      counters.onError();
    }
  }
}

/**
 * Process a single grant with retry logic
 */
async function processGrantWithRetry(
  doc: FirebaseFirestore.QueryDocumentSnapshot,
  grant: any,
  now: admin.firestore.Timestamp
) {
  for (let attempt = 1; attempt <= MAX_RETRIES; attempt++) {
    try {
      await db.runTransaction(async (transaction) => {
        // Re-check status in transaction
        const currentDoc = await transaction.get(doc.ref);
        const currentData = currentDoc.data();
        
        if (!currentData || currentData.status !== 'active') {
          throw new Error(`Grant ${doc.id} is no longer active (${currentData?.status || 'deleted'})`);
        }
        
        // Mark grant as expired
        transaction.update(doc.ref, {
          status: 'expired',
          expiredAt: now
        });
        
        // Revert entity changes based on target type
        const entityRef = getEntityRef(grant.targetType, grant.targetId);
        const revertFields = getRevertFields(grant.targetType, grant.fieldsApplied);
        
        transaction.update(entityRef, {
          ...revertFields,
          lastModified: now,
          modifiedBy: 'system'
        });
      });
      
      // Log the expiration
      await logExpirationEvent(grant, doc.id);
      console.log(`✅ Successfully expired grant: ${doc.id}`);
      return;
      
    } catch (error) {
      console.error(`❌ Attempt ${attempt} failed for grant ${doc.id}:`, error);
      
      if (attempt === MAX_RETRIES) {
        throw error;
      }
      
      // Wait before retry
      await new Promise(resolve => setTimeout(resolve, RETRY_DELAY * attempt));
    }
  }
}

/**
 * Get entity reference based on target type
 */
function getEntityRef(targetType: string, targetId: string) {
  switch (targetType) {
    case 'personal':
      return db.collection('users').doc(targetId);
    case 'business':
      return db.collection('business_accounts').doc(targetId);
    case 'enterprise':
      return db.collection('enterprise_clients').doc(targetId);
    default:
      throw new Error(`Invalid target type: ${targetType}`);
  }
}

/**
 * Get revert fields for each entity type
 */
function getRevertFields(targetType: string, fieldsApplied: Record<string, any>): Record<string, any> {
  const revertFields: Record<string, any> = {};

  switch (targetType) {
    case 'personal':
      if ('planOverride' in fieldsApplied) revertFields.planOverride = 'none';
      if ('freeUntil' in fieldsApplied) revertFields.freeUntil = null;
      if ('premiumForced' in fieldsApplied) revertFields.premiumForced = false;
      if ('overrideNote' in fieldsApplied) revertFields.overrideNote = null;
      break;

    case 'business':
      if ('planOverride' in fieldsApplied) revertFields.planOverride = 'none';
      if ('freeUntil' in fieldsApplied) revertFields.freeUntil = null;
      if ('seatLimitOverride' in fieldsApplied) revertFields.seatLimitOverride = null;
      if ('overrideNote' in fieldsApplied) revertFields.overrideNote = null;
      break;

    case 'enterprise':
      if ('planOverride' in fieldsApplied) revertFields.planOverride = 'none';
      if ('freeUntil' in fieldsApplied) revertFields.freeUntil = null;
      if ('rateLimitOverride' in fieldsApplied) revertFields.rateLimitOverride = null;
      if ('featureAccessOverride' in fieldsApplied) revertFields.featureAccessOverride = null;
      if ('overrideNote' in fieldsApplied) revertFields.overrideNote = null;
      break;
  }

  return revertFields;
}

/**
 * Log expiration event to system logs
 */
async function logExpirationEvent(grant: any, grantId: string) {
  try {
    await db.collection('system_logs').add({
      action: 'free_access_expired',
      adminUid: 'system',
      targetType: grant.targetType,
      targetId: grant.targetId,
      details: {
        grantId,
        originalChanges: grant.fieldsApplied,
        reason: grant.reason,
        expiredAt: admin.firestore.Timestamp.now()
      },
      timestamp: admin.firestore.Timestamp.now(),
      severity: 'info'
    });
  } catch (error) {
    console.error('Failed to log expiration event:', error);
  }
}

/**
 * Log metrics for monitoring
 */
async function logMetrics(metrics: {
  processedCount: number;
  expiredCount: number;
  skippedCount: number;
  errorCount: number;
  duration: number;
}) {
  try {
    await db.collection('system_metrics').add({
      metricName: 'free_access_expiration',
      timestamp: admin.firestore.Timestamp.now(),
      data: metrics
    });
  } catch (error) {
    console.error('Failed to log metrics:', error);
  }
}

/**
 * Manual trigger function for testing
 */
export const manualExpireGrants = functions.https.onRequest(async (req, res) => {
  try {
    // Check if caller is authorized (add your auth logic here)
    const result = await expireFreeAccessGrants.run();
    res.json({ success: true, result });
  } catch (error) {
    console.error('Manual expiration failed:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

/**
 * Health check function for monitoring
 */
export const freeAccessHealthCheck = functions.https.onRequest(async (req, res) => {
  try {
    const now = admin.firestore.Timestamp.now();
    
    // Check for backlog
    const backlogQuery = db
      .collection('free_access_grants')
      .where('status', '==', 'active')
      .where('expiresAt', '<', now);
    
    const backlogSnapshot = await backlogQuery.get();
    const backlogCount = backlogSnapshot.size;
    
    // Check last run metrics
    const metricsQuery = db
      .collection('system_metrics')
      .where('metricName', '==', 'free_access_expiration')
      .orderBy('timestamp', 'desc')
      .limit(1);
    
    const metricsSnapshot = await metricsQuery.get();
    const lastRun = metricsSnapshot.docs[0]?.data();
    
    const health = {
      backlogCount,
      lastRun,
      isHealthy: backlogCount < 1000, // Alert if backlog > 1000
      timestamp: now.toDate().toISOString()
    };
    
    res.json(health);
  } catch (error) {
    console.error('Health check failed:', error);
    res.status(500).json({ error: error.message });
  }
});
