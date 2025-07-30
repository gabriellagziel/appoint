// businessApi.ts
import * as functions from 'firebase-functions/v1';
import * as admin from 'firebase-admin';
import express from 'express';

// Initialize Firebase Admin if not already initialised
if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

const BUSINESS_COLLECTION = 'business_accounts';
const USAGE_COLLECTION = 'usage_logs';

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
    const docRef = db.collection(BUSINESS_COLLECTION).doc();
    const data = {
      name,
      email,
      industry: industry || null,
      apiKey,
      monthlyQuota: 1000,
      usageThisMonth: 0,
      status: 'active',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    await docRef.set(data);

    res.status(201).json({ id: docRef.id, apiKey, quota: data.monthlyQuota });
  } catch (err) {
    console.error('registerBusiness error:', err);
    res.status(500).json({ error: 'Internal Server Error' });
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
      .collection(BUSINESS_COLLECTION)
      .where('apiKey', '==', apiKey)
      .limit(1)
      .get();

    if (snap.empty) {
      res.status(401).json({ error: 'Invalid API key' });
      return;
    }

    const businessDoc = snap.docs[0];
    const businessData = businessDoc.data() as any;

    if (businessData.status === 'blocked') {
      res.status(402).json({ error: 'Payment Required' });
      return;
    }

    if (businessData.status === 'limited') {
      // Allow up to 5 calls per day – naive; count from usage_logs for today
      const todayStart = new Date();
      todayStart.setUTCHours(0,0,0,0);
      const todayEnd = new Date();
      todayEnd.setUTCHours(23,59,59,999);
      const todayUsageSnap = await db
        .collection(USAGE_COLLECTION)
        .where('businessId', '==', businessDoc.id)
        .where('timestamp', '>=', todayStart)
        .where('timestamp', '<=', todayEnd)
        .get();
      if (todayUsageSnap.size >= 5) {
        res.status(429).json({ error: 'Daily limit exceeded' });
        return;
      }
    }

    if (businessData.status !== 'active') {
      res.status(403).json({ error: 'API key suspended' });
      return;
    }

    if (businessData.usageThisMonth >= businessData.monthlyQuota) {
      res.status(429).json({ error: 'Monthly quota exceeded' });
      return;
    }

    // Attach business info to request
    (req as any).businessId = businessDoc.id;
    (req as any).businessData = businessData;

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
  endpoint,
  ip,
  success,
  latencyMs,
}: {
  businessId: string;
  endpoint: string;
  ip: string | undefined;
  success: boolean;
  latencyMs?: number;
}) {
  try {
    const logData: any = {
      businessId,
      endpoint,
      ip: ip || null,
      success,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    };
    if (latencyMs !== undefined) logData.latencyMs = latencyMs;
    await db.collection(USAGE_COLLECTION).add(logData);
  } catch (err) {
    console.error('logUsage error:', err);
  }
}

// Endpoint: Create Appointment (dummy implementation)
businessApiApp.post('/appointments/create', async (req, res) => {
  const businessId = (req as any).businessId as string;
  const businessData = (req as any).businessData;
  try {
    // TODO: integrate with core appointment creation logic
    // For now, respond with success and fake appointmentId
    const appointmentId = generateApiKey();

    // Increment usage counter atomically
    await db
      .collection(BUSINESS_COLLECTION)
      .doc(businessId)
      .update({
        usageThisMonth: admin.firestore.FieldValue.increment(1),
        lastUsedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

    await logUsage({ businessId, endpoint: 'appointments/create', ip: req.ip, success: true, latencyMs: Date.now() - (req as any)._startTime });

    res.status(200).json({ appointmentId });
  } catch (err) {
    console.error('create appointment error:', err);
    await logUsage({ businessId, endpoint: 'appointments/create', ip: req.ip, success: false, latencyMs: Date.now() - (req as any)._startTime });
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Endpoint: Cancel Appointment (dummy implementation)
businessApiApp.post('/appointments/cancel', async (req, res) => {
  const businessId = (req as any).businessId as string;
  try {
    const { appointmentId } = req.body;
    if (!appointmentId) {
      res.status(400).json({ error: 'Missing appointmentId' });
      return;
    }

    // TODO: integrate with core appointment cancellation logic

    // Increment usage counter
    await db
      .collection(BUSINESS_COLLECTION)
      .doc(businessId)
      .update({ usageThisMonth: admin.firestore.FieldValue.increment(1) });

    await logUsage({ businessId, endpoint: 'appointments/cancel', ip: req.ip, success: true, latencyMs: Date.now() - (req as any)._startTime });

    res.status(200).json({ cancelled: true, appointmentId });
  } catch (err) {
    console.error('cancel appointment error:', err);
    await logUsage({ businessId, endpoint: 'appointments/cancel', ip: req.ip, success: false, latencyMs: Date.now() - (req as any)._startTime });
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Wrap express app as cloud function
export const businessApi = functions.https.onRequest(businessApiApp);

/**
 * Scheduled function: Reset monthly quotas & trigger billing every 1st day of month.
 * Runs at 00:00 on day-1 UTC.
 */
export const resetMonthlyQuotas = functions.scheduler.onSchedule('0 0 1 * *', async () => {
    const snapshot = await db.collection(BUSINESS_COLLECTION).get();

    const batch = db.batch();
    snapshot.docs.forEach((doc) => {
      batch.update(doc.ref, { usageThisMonth: 0 });
    });

    await batch.commit();
    console.log('Monthly quotas reset');

    // TODO: implement billing logic (Stripe invoices or manual PDFs)
  });