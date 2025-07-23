// businessApi.ts
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import express from 'express';

// Initialize Firebase Admin if not already initialised
if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

const BUSINESS_COLLECTION = 'business_accounts';
const USAGE_COLLECTION = 'usage_logs';
const APPOINTMENTS_COLLECTION = 'appointments';

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
      scopes: ['appointments:read', 'appointments:write', 'billing:read'], // Default scopes
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      icsToken: generateApiKey(), // Generate ICS token on registration
    };

    await docRef.set(data);

    res.status(201).json({ id: docRef.id, apiKey, quota: data.monthlyQuota, scopes: data.scopes });
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

// Rate limiting middleware - burst protection
const rateLimitMap = new Map<string, { count: number; lastReset: number }>();
const RATE_LIMIT_WINDOW = 60000; // 1 minute
const RATE_LIMIT_MAX = 60; // 60 requests per minute

function checkRateLimit(apiKey: string): boolean {
  const now = Date.now();
  const record = rateLimitMap.get(apiKey);
  
  if (!record || now - record.lastReset > RATE_LIMIT_WINDOW) {
    rateLimitMap.set(apiKey, { count: 1, lastReset: now });
    return true;
  }
  
  if (record.count >= RATE_LIMIT_MAX) {
    return false;
  }
  
  record.count++;
  return true;
}

// Middleware: Validate API key & quota with scope checking
businessApiApp.use(async (req, res, next) => {
  try {
    const apiKey = (req.headers['x-api-key'] || req.headers['api-key']) as string | undefined;

    if (!apiKey) {
      res.status(401).json({ error: 'API key missing' });
      return;
    }

    // Rate limiting check
    if (!checkRateLimit(apiKey)) {
      res.status(429).json({ error: 'Rate limit exceeded' });
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

    if (businessData.status === 'suspended') {
      res.status(403).json({ error: 'API key suspended' });
      return;
    }

    if (businessData.status !== 'active' && businessData.status !== 'limited') {
      res.status(403).json({ error: 'API key suspended' });
      return;
    }

    if (businessData.usageThisMonth >= businessData.monthlyQuota) {
      // Auto-transition to limited status when quota exceeded
      await db.collection(BUSINESS_COLLECTION).doc(businessDoc.id).update({
        status: 'limited',
        quotaExceededAt: admin.firestore.FieldValue.serverTimestamp()
      });
      res.status(429).json({ error: 'Monthly quota exceeded - account limited to 5 calls/day' });
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

// Helper: Check scope permission
function hasScope(businessData: any, requiredScope: string): boolean {
  return businessData.scopes && businessData.scopes.includes(requiredScope);
}

// Endpoint: Create Appointment (REAL IMPLEMENTATION)
businessApiApp.post('/appointments/create', async (req, res) => {
  const businessId = (req as any).businessId as string;
  const businessData = (req as any).businessData;
  
  try {
    // Check scope permission
    if (!hasScope(businessData, 'appointments:write')) {
      res.status(403).json({ error: 'Insufficient permissions - appointments:write required' });
      return;
    }

    const { customerName, customerEmail, start, duration, description, location } = req.body;

    // Validate required fields
    if (!customerName || !start || !duration) {
      res.status(400).json({ error: 'Missing required fields: customerName, start, duration' });
      return;
    }

    // Parse and validate start time
    const startDate = new Date(start);
    if (isNaN(startDate.getTime())) {
      res.status(400).json({ error: 'Invalid start time format' });
      return;
    }

    // Calculate end time
    const endDate = new Date(startDate.getTime() + (duration * 60000));

    // Create appointment document
    const appointmentData = {
      businessId,
      customerName,
      customerEmail: customerEmail || null,
      start: startDate,
      end: endDate,
      duration,
      description: description || '',
      location: location || '',
      status: 'confirmed',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      createdVia: 'enterprise_api',
      apiKeyUsed: businessData.apiKey.substring(0, 8) + '...' // Log partial key for tracking
    };

    const appointmentRef = await db.collection(APPOINTMENTS_COLLECTION).add(appointmentData);
    const appointmentId = appointmentRef.id;

    // Increment usage counter atomically
    await db
      .collection(BUSINESS_COLLECTION)
      .doc(businessId)
      .update({
        usageThisMonth: admin.firestore.FieldValue.increment(1),
        lastUsedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

    await logUsage({ 
      businessId, 
      endpoint: 'appointments/create', 
      ip: req.ip, 
      success: true, 
      latencyMs: Date.now() - (req as any)._startTime 
    });

    // Return real appointment data
    res.status(201).json({ 
      appointmentId,
      status: 'confirmed',
      start: startDate.toISOString(),
      end: endDate.toISOString(),
      customerName,
      duration
    });
  } catch (err) {
    console.error('create appointment error:', err);
    await logUsage({ 
      businessId, 
      endpoint: 'appointments/create', 
      ip: req.ip, 
      success: false, 
      latencyMs: Date.now() - (req as any)._startTime 
    });
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Endpoint: Cancel Appointment (REAL IMPLEMENTATION)
businessApiApp.post('/appointments/cancel', async (req, res) => {
  const businessId = (req as any).businessId as string;
  const businessData = (req as any).businessData;
  
  try {
    // Check scope permission
    if (!hasScope(businessData, 'appointments:write')) {
      res.status(403).json({ error: 'Insufficient permissions - appointments:write required' });
      return;
    }

    const { appointmentId } = req.body;
    if (!appointmentId) {
      res.status(400).json({ error: 'Missing appointmentId' });
      return;
    }

    // Verify appointment exists and belongs to this business
    const appointmentDoc = await db.collection(APPOINTMENTS_COLLECTION).doc(appointmentId).get();
    
    if (!appointmentDoc.exists) {
      res.status(404).json({ error: 'Appointment not found' });
      return;
    }

    const appointmentData = appointmentDoc.data();
    if (appointmentData?.businessId !== businessId) {
      res.status(403).json({ error: 'Appointment does not belong to this business' });
      return;
    }

    if (appointmentData?.status === 'cancelled') {
      res.status(400).json({ error: 'Appointment already cancelled' });
      return;
    }

    // Update appointment status to cancelled
    await db.collection(APPOINTMENTS_COLLECTION).doc(appointmentId).update({
      status: 'cancelled',
      cancelledAt: admin.firestore.FieldValue.serverTimestamp(),
      cancelledVia: 'enterprise_api'
    });

    // Increment usage counter
    await db
      .collection(BUSINESS_COLLECTION)
      .doc(businessId)
      .update({ 
        usageThisMonth: admin.firestore.FieldValue.increment(1),
        lastUsedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

    await logUsage({ 
      businessId, 
      endpoint: 'appointments/cancel', 
      ip: req.ip, 
      success: true, 
      latencyMs: Date.now() - (req as any)._startTime 
    });

    res.status(200).json({ 
      cancelled: true, 
      appointmentId,
      status: 'cancelled',
      cancelledAt: new Date().toISOString()
    });
  } catch (err) {
    console.error('cancel appointment error:', err);
    await logUsage({ 
      businessId, 
      endpoint: 'appointments/cancel', 
      ip: req.ip, 
      success: false, 
      latencyMs: Date.now() - (req as any)._startTime 
    });
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Endpoint: List Appointments
businessApiApp.get('/appointments', async (req, res) => {
  const businessId = (req as any).businessId as string;
  const businessData = (req as any).businessData;
  
  try {
    // Check scope permission
    if (!hasScope(businessData, 'appointments:read')) {
      res.status(403).json({ error: 'Insufficient permissions - appointments:read required' });
      return;
    }

    const { start, end, status, limit = 50 } = req.query as any;
    let query = db.collection(APPOINTMENTS_COLLECTION).where('businessId', '==', businessId);

    // Add filters
    if (start) {
      query = query.where('start', '>=', new Date(start));
    }
    if (end) {
      query = query.where('start', '<=', new Date(end));
    }
    if (status) {
      query = query.where('status', '==', status);
    }

    const snapshot = await query.limit(parseInt(limit)).get();
    const appointments = snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data(),
      start: doc.data().start?.toDate?.()?.toISOString() || doc.data().start,
      end: doc.data().end?.toDate?.()?.toISOString() || doc.data().end,
      createdAt: doc.data().createdAt?.toDate?.()?.toISOString() || doc.data().createdAt
    }));

    // Increment usage counter
    await db.collection(BUSINESS_COLLECTION).doc(businessId).update({
      usageThisMonth: admin.firestore.FieldValue.increment(1),
      lastUsedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    await logUsage({ 
      businessId, 
      endpoint: 'appointments/list', 
      ip: req.ip, 
      success: true, 
      latencyMs: Date.now() - (req as any)._startTime 
    });

    res.status(200).json({ 
      appointments,
      count: appointments.length,
      hasMore: snapshot.size === parseInt(limit)
    });
  } catch (err) {
    console.error('list appointments error:', err);
    await logUsage({ 
      businessId, 
      endpoint: 'appointments/list', 
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
 * Scheduled function: Reset monthly quotas & trigger billing every 1st day of month.
 * Runs at 00:00 on day-1 UTC.
 */
export const resetMonthlyQuotas = functions.pubsub
  .schedule('0 0 1 * *')
  .timeZone('UTC')
  .onRun(async () => {
    console.log('Starting monthly quota reset and billing...');
    
    const snapshot = await db.collection(BUSINESS_COLLECTION).get();
    const batch = db.batch();
    
    // Process each business account
    for (const doc of snapshot.docs) {
      const businessData = doc.data();
      const businessId = doc.id;
      
      // Generate invoice for overage if applicable
      if (businessData.usageThisMonth > businessData.monthlyQuota) {
        const overage = businessData.usageThisMonth - businessData.monthlyQuota;
        const overageAmount = overage * 0.01; // $0.01 per overage call
        
        try {
          // Create Stripe invoice (placeholder - integrate with actual Stripe)
          console.log(`Creating invoice for business ${businessId}: $${overageAmount} for ${overage} overage calls`);
          
          // Log invoice creation
          await db.collection('invoices').add({
            businessId,
            amount: overageAmount,
            currency: 'usd',
            description: `Overage charges for ${overage} API calls`,
            period: new Date().toISOString().substring(0, 7), // YYYY-MM
            status: 'pending',
            createdAt: admin.firestore.FieldValue.serverTimestamp()
          });
        } catch (err) {
          console.error(`Failed to create invoice for business ${businessId}:`, err);
        }
      }
      
      // Reset usage counters and update status
      const updates: any = { 
        usageThisMonth: 0,
        quotaAlertSent: false,
        lastResetAt: admin.firestore.FieldValue.serverTimestamp()
      };
      
      // Status transitions based on payment history
      if (businessData.status === 'limited') {
        // Check if they have outstanding invoices
        const outstandingInvoices = await db
          .collection('invoices')
          .where('businessId', '==', businessId)
          .where('status', '==', 'pending')
          .get();
          
        if (outstandingInvoices.size > 0) {
          updates.status = 'blocked'; // Block until payment
        } else {
          updates.status = 'active'; // Restore to active
        }
      }
      
      batch.update(doc.ref, updates);
    }

    await batch.commit();
    console.log('Monthly quotas reset and billing processed');
  });