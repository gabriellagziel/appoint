// businessApi.ts
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import express from 'express';

// Initialize Firebase Admin if not already initialised
if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

const B2B_API_KEYS_COLLECTION = 'b2bApiKeys';
const USAGE_COLLECTION = 'usage_logs';
const INVOICES_COLLECTION = 'invoices';

/**
 * Utility: generate secure random API key (UUID v4 via crypto)
 */
function generateApiKey(): string {
  // Node 18 has crypto.randomUUID()
  return (global as any).crypto?.randomUUID?.() || require('crypto').randomBytes(32).toString('hex');
}

/**
 * HTTPS Cloud Function: Self-service business registration.
 * Endpoint: /registerBusiness (deployed root) – proxied by front-end /business/register form.
 *
 * Body JSON:
 *  - name: string
 *  - email: string
 *  - industry: string
 *
 * Returns: { id, apiKey, quota }
 */
export const registerBusiness = functions.https.onRequest(async (req, res) => {
  // Simple CORS (allow any origin) – adjust in production
  res.set('Access-Control-Allow-Origin', '*');
  res.set('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.set('Access-Control-Allow-Headers', 'Content-Type, X-Requested-With');

  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }

  if (req.method !== 'POST') {
    res.status(405).json({ error: 'Method not allowed' });
    return;
  }

  try {
    const { name, email, industry } = req.body || {};

    if (!name || !email) {
      res.status(400).json({ error: 'Missing required fields: name, email' });
      return;
    }

    const apiKey = generateApiKey();
    const docRef = db.collection(B2B_API_KEYS_COLLECTION).doc();
    const data = {
      businessId: docRef.id,
      name,
      email,
      industry: industry || null,
      apiKey,
      quotaRemaining: 1000,
      mapUsageCount: 0,
      status: 'active',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      lastUsedAt: null,
    };

    await docRef.set(data);

    res.status(201).json({ 
      id: docRef.id, 
      apiKey, 
      quota: data.quotaRemaining,
      mapUsageRate: 0.007 // €0.007 per map call
    });
  } catch (err) {
    console.error('registerBusiness error:', err);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

/**
 * Generate API key for existing business
 */
export const generateBusinessApiKey = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  try {
    const businessId = context.auth.uid;
    const apiKey = generateApiKey();
    
    // Create or update API key record
    await db.collection(B2B_API_KEYS_COLLECTION).doc(businessId).set({
      businessId,
      apiKey,
      quotaRemaining: 1000,
      mapUsageCount: 0,
      status: 'active',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      lastUsedAt: null,
    }, { merge: true });

    return { apiKey };
  } catch (err) {
    console.error('generateBusinessApiKey error:', err);
    throw new functions.https.HttpsError('internal', 'Failed to generate API key');
  }
});

/**
 * Record API usage and charge for map calls
 */
export const recordApiUsage = functions.https.onCall(async (data, context) => {
  try {
    const { apiKey, endpoint } = data;

    if (!apiKey || !endpoint) {
      throw new functions.https.HttpsError('invalid-argument', 'Missing apiKey or endpoint');
    }

    // Find business by API key
    const businessSnap = await db
      .collection(B2B_API_KEYS_COLLECTION)
      .where('apiKey', '==', apiKey)
      .limit(1)
      .get();

    if (businessSnap.empty) {
      throw new functions.https.HttpsError('not-found', 'Invalid API key');
    }

    const businessDoc = businessSnap.docs[0];
    const businessData = businessDoc.data();

    if (businessData.status === 'suspended') {
      throw new functions.https.HttpsError('permission-denied', 'API key suspended');
    }

    const isMapEndpoint = endpoint.includes('/map') || endpoint.includes('/getMap');
    
    // Log usage
    await db.collection(USAGE_COLLECTION).add({
      businessId: businessDoc.id,
      apiKey,
      endpoint,
      isMapCall: isMapEndpoint,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      ip: context.rawRequest?.ip || null,
    });

    // Update usage counters
    const updateData: any = {
      lastUsedAt: admin.firestore.FieldValue.serverTimestamp(),
      quotaRemaining: admin.firestore.FieldValue.increment(-1),
    };

    if (isMapEndpoint) {
      updateData.mapUsageCount = admin.firestore.FieldValue.increment(1);
    }

    await businessDoc.ref.update(updateData);

    return { success: true, isMapCall: isMapEndpoint };
  } catch (err) {
    console.error('recordApiUsage error:', err);
    if (err instanceof functions.https.HttpsError) {
      throw err;
    }
    throw new functions.https.HttpsError('internal', 'Failed to record usage');
  }
});

/**
 * Generate monthly invoice for map usage
 */
export const generateMonthlyInvoice = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  try {
    const businessId = context.auth.uid;
    const currentDate = new Date();
    const previousMonth = new Date(currentDate.getFullYear(), currentDate.getMonth() - 1, 1);
    const currentMonth = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1);

    // Get map usage for previous month
    const usageSnap = await db
      .collection(USAGE_COLLECTION)
      .where('businessId', '==', businessId)
      .where('isMapCall', '==', true)
      .where('timestamp', '>=', previousMonth)
      .where('timestamp', '<', currentMonth)
      .get();

    const mapCallCount = usageSnap.size;
    const costPerCall = 0.007; // €0.007
    const totalAmount = mapCallCount * costPerCall;

    if (totalAmount === 0) {
      return { message: 'No map usage to invoice' };
    }

    // Create invoice
    const invoiceId = `${businessId}-${previousMonth.getFullYear()}-${(previousMonth.getMonth() + 1).toString().padStart(2, '0')}`;
    
    await db.collection(INVOICES_COLLECTION).doc(invoiceId).set({
      id: invoiceId,
      businessId,
      type: 'map_usage',
      periodStart: previousMonth,
      periodEnd: currentMonth,
      mapCallCount,
      costPerCall,
      totalAmount,
      currency: 'EUR',
      status: 'pending',
      dueDate: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000), // 7 days from now
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return { 
      invoiceId, 
      mapCallCount, 
      totalAmount,
      dueDate: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000)
    };
  } catch (err) {
    console.error('generateMonthlyInvoice error:', err);
    throw new functions.https.HttpsError('internal', 'Failed to generate invoice');
  }
});

/**
 * Scheduled function: Check for overdue invoices and suspend API keys
 */
export const checkOverdueInvoices = functions.pubsub
  .schedule('0 0 * * *') // Daily at midnight UTC
  .timeZone('UTC')
  .onRun(async () => {
    try {
      const overdueDate = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000);
      
      const overdueInvoices = await db
        .collection(INVOICES_COLLECTION)
        .where('status', '==', 'pending')
        .where('dueDate', '<', overdueDate)
        .get();

      const batch = db.batch();
      
      for (const invoice of overdueInvoices.docs) {
        const invoiceData = invoice.data();
        
        // Suspend API key
        const businessApiKeyRef = db.collection(B2B_API_KEYS_COLLECTION).doc(invoiceData.businessId);
        batch.update(businessApiKeyRef, {
          status: 'suspended',
          suspendedAt: admin.firestore.FieldValue.serverTimestamp(),
          suspensionReason: `Overdue invoice: ${invoice.id}`,
        });

        // Update invoice status
        batch.update(invoice.ref, {
          status: 'overdue',
          suspendedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
      console.log(`Suspended ${overdueInvoices.size} API keys for overdue invoices`);
    } catch (err) {
      console.error('checkOverdueInvoices error:', err);
    }
  });

/**
 * Express application for Business API endpoints under /api/business/
 */
const businessApiApp = express();

// Body parser
businessApiApp.use(express.json());

// Middleware: Validate API key & quota
businessApiApp.use(async (req, res, next) => {
  try {
    const apiKey = (req.headers['x-api-key'] || req.headers['api-key']) as string | undefined;

    if (!apiKey) {
      res.status(401).json({ error: 'API key missing' });
      return;
    }

    // Query Firestore for business account
    const snap = await db
      .collection(B2B_API_KEYS_COLLECTION)
      .where('apiKey', '==', apiKey)
      .limit(1)
      .get();

    if (snap.empty) {
      res.status(401).json({ error: 'Invalid API key' });
      return;
    }

    const businessDoc = snap.docs[0];
    const businessData = businessDoc.data() as any;

    if (businessData.status === 'suspended') {
      res.status(402).json({ 
        error: 'Payment Required',
        message: 'API key suspended due to overdue payment. Please contact billing.',
        suspensionReason: businessData.suspensionReason
      });
      return;
    }

    if (businessData.quotaRemaining <= 0) {
      res.status(429).json({ error: 'Monthly quota exceeded' });
      return;
    }

    // Attach business info to request
    (req as any).businessId = businessDoc.id;
    (req as any).businessData = businessData;
    (req as any).apiKey = apiKey;

    // Continue
    next();
  } catch (err) {
    console.error('API auth middleware error:', err);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// After body parser
businessApiApp.use((req, _res, next) => {
  (req as any)._startTime = Date.now();
  next();
});

/** Helper: make usage log */
async function logUsage({
  businessId,
  apiKey,
  endpoint,
  ip,
  success,
  latencyMs,
  isMapCall = false,
}: {
  businessId: string;
  apiKey: string;
  endpoint: string;
  ip: string | undefined;
  success: boolean;
  latencyMs?: number;
  isMapCall?: boolean;
}) {
  try {
    const logData: any = {
      businessId,
      apiKey,
      endpoint,
      ip: ip || null,
      success,
      isMapCall,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    };
    if (latencyMs !== undefined) logData.latencyMs = latencyMs;
    await db.collection(USAGE_COLLECTION).add(logData);

    // Update usage counters
    const updateData: any = {
      lastUsedAt: admin.firestore.FieldValue.serverTimestamp(),
      quotaRemaining: admin.firestore.FieldValue.increment(-1),
    };

    if (isMapCall) {
      updateData.mapUsageCount = admin.firestore.FieldValue.increment(1);
    }

    await db.collection(B2B_API_KEYS_COLLECTION).doc(businessId).update(updateData);
  } catch (err) {
    console.error('logUsage error:', err);
  }
}

// Endpoint: Get Map Data (charged per use)
businessApiApp.get('/getMap', async (req, res) => {
  const businessId = (req as any).businessId as string;
  const apiKey = (req as any).apiKey as string;
  try {
    // TODO: integrate with actual map service
    const mapData = {
      locations: [
        { lat: 32.0853, lng: 34.7818, name: 'Tel Aviv' },
        { lat: 31.7683, lng: 35.2137, name: 'Jerusalem' },
      ],
      region: 'Israel',
      timestamp: new Date().toISOString(),
    };

    await logUsage({ 
      businessId, 
      apiKey,
      endpoint: 'getMap', 
      ip: req.ip, 
      success: true, 
      latencyMs: Date.now() - (req as any)._startTime,
      isMapCall: true
    });

    res.status(200).json({ 
      data: mapData,
      billing: {
        charged: true,
        amount: 0.007,
        currency: 'EUR'
      }
    });
  } catch (err) {
    console.error('getMap error:', err);
    await logUsage({ 
      businessId, 
      apiKey,
      endpoint: 'getMap', 
      ip: req.ip, 
      success: false, 
      latencyMs: Date.now() - (req as any)._startTime,
      isMapCall: true
    });
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Endpoint: Create Appointment (included in quota)
businessApiApp.post('/appointments/create', async (req, res) => {
  const businessId = (req as any).businessId as string;
  const apiKey = (req as any).apiKey as string;
  try {
    // TODO: integrate with core appointment creation logic
    // For now, respond with success and fake appointmentId
    const appointmentId = generateApiKey();

    await logUsage({ 
      businessId, 
      apiKey,
      endpoint: 'appointments/create', 
      ip: req.ip, 
      success: true, 
      latencyMs: Date.now() - (req as any)._startTime 
    });

    res.status(200).json({ appointmentId });
  } catch (err) {
    console.error('create appointment error:', err);
    await logUsage({ 
      businessId, 
      apiKey,
      endpoint: 'appointments/create', 
      ip: req.ip, 
      success: false, 
      latencyMs: Date.now() - (req as any)._startTime 
    });
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Endpoint: Cancel Appointment (included in quota)
businessApiApp.post('/appointments/cancel', async (req, res) => {
  const businessId = (req as any).businessId as string;
  const apiKey = (req as any).apiKey as string;
  try {
    const { appointmentId } = req.body;
    if (!appointmentId) {
      res.status(400).json({ error: 'Missing appointmentId' });
      return;
    }

    // TODO: integrate with core appointment cancellation logic

    await logUsage({ 
      businessId, 
      apiKey,
      endpoint: 'appointments/cancel', 
      ip: req.ip, 
      success: true, 
      latencyMs: Date.now() - (req as any)._startTime 
    });

    res.status(200).json({ cancelled: true, appointmentId });
  } catch (err) {
    console.error('cancel appointment error:', err);
    await logUsage({ 
      businessId, 
      apiKey,
      endpoint: 'appointments/cancel', 
      ip: req.ip, 
      success: false, 
      latencyMs: Date.now() - (req as any)._startTime 
    });
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Endpoint: Get Usage Statistics
businessApiApp.get('/usage/stats', async (req, res) => {
  const businessId = (req as any).businessId as string;
  const apiKey = (req as any).apiKey as string;
  try {
    const businessData = (req as any).businessData;
    const currentMonth = new Date();
    currentMonth.setDate(1);
    currentMonth.setHours(0, 0, 0, 0);

    // Get current month usage
    const usageSnap = await db
      .collection(USAGE_COLLECTION)
      .where('businessId', '==', businessId)
      .where('timestamp', '>=', currentMonth)
      .get();

    const totalCalls = usageSnap.size;
    const mapCalls = usageSnap.docs.filter(doc => doc.data().isMapCall).length;
    const mapCharges = mapCalls * 0.007;

    await logUsage({ 
      businessId, 
      apiKey,
      endpoint: 'usage/stats', 
      ip: req.ip, 
      success: true, 
      latencyMs: Date.now() - (req as any)._startTime 
    });

    res.status(200).json({
      quotaRemaining: businessData.quotaRemaining,
      totalCallsThisMonth: totalCalls,
      mapCallsThisMonth: mapCalls,
      mapChargesThisMonth: mapCharges,
      currency: 'EUR',
    });
  } catch (err) {
    console.error('usage stats error:', err);
    await logUsage({ 
      businessId, 
      apiKey,
      endpoint: 'usage/stats', 
      ip: req.ip, 
      success: false, 
      latencyMs: Date.now() - (req as any)._startTime 
    });
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Wrap express app as cloud function
export const businessApi = functions.https.onRequest(businessApiApp);

/**
 * Scheduled function: Reset monthly quotas every 1st day of month.
 * Runs at 00:00 on day-1 UTC.
 */
export const resetMonthlyQuotas = functions.pubsub
  .schedule('0 0 1 * *')
  .timeZone('UTC')
  .onRun(async () => {
    const snapshot = await db.collection(B2B_API_KEYS_COLLECTION).get();

    const batch = db.batch();
    snapshot.docs.forEach((doc) => {
      batch.update(doc.ref, { quotaRemaining: 1000 });
    });

    await batch.commit();
    console.log('Monthly quotas reset for', snapshot.size, 'businesses');
  });