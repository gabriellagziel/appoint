// businessApi.ts
import express from 'express';
import * as admin from 'firebase-admin';
import { onRequest } from 'firebase-functions/v2/https';
import { onSchedule } from 'firebase-functions/v2/scheduler';
import { sendApiKeyEmail, sendWelcomeEmail } from './emailService';
import { auditLogMiddleware } from './middleware/auditLogger';
import { ipWhitelistMiddleware } from './middleware/ipWhitelist';
import { rateLimitMiddleware } from './middleware/rateLimiter';

// Initialize Firebase Admin if not already initialised
if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

const BUSINESS_COLLECTION = 'business_accounts';
const USAGE_COLLECTION = 'usage_logs';
const APPOINTMENTS_COLLECTION = 'appointments';
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
 *  - companyName: string (required)
 *  - website: string (required)
 *  - address: string (required)
 *  - vat: string (optional)
 *  - registration: string (optional)
 *  - country: string (required)
 *  - currency: string (required)
 *  - billingEmail: string (required)
 *  - rep: string (optional)
 *  - taxId: string (optional)
 *  - firstName: string (required)
 *  - lastName: string (required)
 *  - email: string (required)
 *  - phone: string (optional)
 *  - usage: string (optional)
 *  - intent: string (required)
 *  - industry: string (optional)
 *  - size: string (optional)
 *  - tos: boolean (required)
 *  - marketing: boolean (optional)
 *
 * Returns: { id, apiKey, quota, status }
 */
export const registerBusiness = onRequest(async (req, res) => {
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
    const {
      companyName,
      website,
      address,
      vat,
      registration,
      country,
      currency,
      billingEmail,
      rep,
      taxId,
      firstName,
      lastName,
      email,
      phone,
      usage,
      intent,
      industry,
      size,
      tos,
      marketing
    } = req.body || {};

    // Validate required fields
    const requiredFields = ['companyName', 'website', 'address', 'country', 'currency', 'billingEmail', 'firstName', 'lastName', 'email', 'intent', 'tos'];
    const missingFields = requiredFields.filter(field => !req.body[field]);

    if (missingFields.length > 0) {
      res.status(400).json({
        error: 'Missing required fields',
        missingFields
      });
      return;
    }

    // Validate terms of service acceptance
    if (!tos) {
      res.status(400).json({ error: 'Terms of Service must be accepted' });
      return;
    }

    const apiKey = generateApiKey();
    const docRef = db.collection(BUSINESS_COLLECTION).doc();

    const businessData = {
      // Company Information
      companyName,
      website,
      address,
      vat: vat || null,
      registration: registration || null,
      country,
      currency,
      billingEmail,
      legalRepresentative: rep || null,
      taxId: taxId || null,

      // Contact Information
      firstName,
      lastName,
      email,
      phone: phone || null,

      // Business Context
      expectedUsage: usage || null,
      useCase: intent,
      industry: industry || null,
      companySize: size || null,

      // Legal & Marketing
      termsAccepted: tos,
      marketingConsent: marketing || false,

      // API & System Data
      apiKey,
      monthlyQuota: 1000, // Default quota
      usageThisMonth: 0,
      status: 'pending', // Will be approved by admin
      ipWhitelistEnabled: false,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    await docRef.set(businessData);

    // Log the registration for admin review
    console.log(`New business registration: ${companyName} (${email}) - ID: ${docRef.id}`);

    // Send welcome email immediately
    try {
      await sendWelcomeEmail({
        companyName,
        contactName: `${firstName} ${lastName}`,
        email,
        plan: 'Enterprise',
        dashboardUrl: 'https://api.app-oint.com/dashboard'
      });
    } catch (emailError) {
      console.error('Failed to send welcome email:', emailError);
      // Don't fail the registration if email fails
    }

    // For immediate activation (demo/testing), send API key email
    // In production, this would be triggered by admin approval
    if (process.env.NODE_ENV === 'development' || process.env.AUTO_APPROVE === 'true') {
      try {
        await sendApiKeyEmail({
          companyName,
          contactName: `${firstName} ${lastName}`,
          email,
          apiKey,
          businessId: docRef.id,
          monthlyQuota: businessData.monthlyQuota,
          dashboardUrl: 'https://api.app-oint.com/dashboard'
        });
      } catch (emailError) {
        console.error('Failed to send API key email:', emailError);
        // Don't fail the registration if email fails
      }
    }

    res.status(201).json({
      success: true,
      id: docRef.id,
      apiKey,
      quota: businessData.monthlyQuota,
      status: businessData.status,
      message: process.env.NODE_ENV === 'development' || process.env.AUTO_APPROVE === 'true'
        ? 'Registration successful! Check your email for API access details.'
        : 'Registration submitted successfully. You will receive API access within 24 hours.'
    });
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
      todayStart.setUTCHours(0, 0, 0, 0);
      const todayEnd = new Date();
      todayEnd.setUTCHours(23, 59, 59, 999);
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

// Apply enterprise middleware
businessApiApp.use(ipWhitelistMiddleware);
businessApiApp.use(rateLimitMiddleware());
businessApiApp.use(auditLogMiddleware);

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

// Endpoint: Create Appointment (REAL implementation)
businessApiApp.post('/appointments/create', async (req, res) => {
  const businessId = (req as any).businessId as string;
  const businessData = (req as any).businessData;
  try {
    const { customerName, customerEmail, start, duration, description, location } = req.body;

    // Validate required fields
    if (!customerName || !start || !duration) {
      res.status(400).json({ error: 'Missing required fields: customerName, start, duration' });
      return;
    }

    // Validate date
    const startDate = new Date(start);
    if (isNaN(startDate.getTime())) {
      res.status(400).json({ error: 'Invalid start date format' });
      return;
    }

    // Calculate end time
    const endDate = new Date(startDate.getTime() + duration * 60000);

    // Create appointment document
    const appointmentData = {
      businessId,
      customerName,
      customerEmail: customerEmail || null,
      start: startDate,
      end: endDate,
      duration,
      description: description || null,
      location: location || null,
      status: 'confirmed',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    const appointmentRef = await db.collection(APPOINTMENTS_COLLECTION).add(appointmentData);

    // Increment usage counter atomically
    await db
      .collection(BUSINESS_COLLECTION)
      .doc(businessId)
      .update({
        usageThisMonth: admin.firestore.FieldValue.increment(1),
        lastUsedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

    await logUsage({ businessId, endpoint: 'appointments/create', ip: req.ip, success: true, latencyMs: Date.now() - (req as any)._startTime });

    res.status(201).json({
      appointmentId: appointmentRef.id,
      status: 'confirmed',
      start: startDate.toISOString(),
      end: endDate.toISOString(),
      customerName,
      duration
    });
  } catch (err) {
    console.error('create appointment error:', err);
    await logUsage({ businessId, endpoint: 'appointments/create', ip: req.ip, success: false, latencyMs: Date.now() - (req as any)._startTime });
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Endpoint: Cancel Appointment (REAL implementation)
businessApiApp.post('/appointments/cancel', async (req, res) => {
  const businessId = (req as any).businessId as string;
  try {
    const { appointmentId } = req.body;
    if (!appointmentId) {
      res.status(400).json({ error: 'Missing appointmentId' });
      return;
    }

    // Get appointment and verify ownership
    const appointmentRef = db.collection(APPOINTMENTS_COLLECTION).doc(appointmentId);
    const appointmentSnap = await appointmentRef.get();

    if (!appointmentSnap.exists) {
      res.status(404).json({ error: 'Appointment not found' });
      return;
    }

    const appointmentData = appointmentSnap.data();
    if (appointmentData?.businessId !== businessId) {
      res.status(403).json({ error: 'Access denied' });
      return;
    }

    // Update appointment status
    await appointmentRef.update({
      status: 'cancelled',
      cancelledAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    // Increment usage counter
    await db
      .collection(BUSINESS_COLLECTION)
      .doc(businessId)
      .update({ usageThisMonth: admin.firestore.FieldValue.increment(1) });

    await logUsage({ businessId, endpoint: 'appointments/cancel', ip: req.ip, success: true, latencyMs: Date.now() - (req as any)._startTime });

    res.status(200).json({
      cancelled: true,
      appointmentId,
      status: 'cancelled',
      cancelledAt: new Date().toISOString()
    });
  } catch (err) {
    console.error('cancel appointment error:', err);
    await logUsage({ businessId, endpoint: 'appointments/cancel', ip: req.ip, success: false, latencyMs: Date.now() - (req as any)._startTime });
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Endpoint: List Appointments (REAL implementation)
businessApiApp.get('/appointments', async (req, res) => {
  const businessId = (req as any).businessId as string;
  try {
    const { start, end, status, limit = 50 } = req.query;

    // Build query
    let query = db.collection(APPOINTMENTS_COLLECTION).where('businessId', '==', businessId);

    // Add date filters
    if (start) {
      const startDate = new Date(start as string);
      query = query.where('start', '>=', startDate);
    }
    if (end) {
      const endDate = new Date(end as string);
      query = query.where('start', '<=', endDate);
    }

    // Add status filter
    if (status) {
      query = query.where('status', '==', status);
    }

    // Add limit
    query = query.limit(parseInt(limit as string));

    const snapshot = await query.orderBy('start', 'desc').get();

    const appointments = snapshot.docs.map(doc => ({
      appointmentId: doc.id,
      ...doc.data(),
      start: doc.data().start.toDate().toISOString(),
      end: doc.data().end.toDate().toISOString(),
      createdAt: doc.data().createdAt?.toDate().toISOString(),
      updatedAt: doc.data().updatedAt?.toDate().toISOString(),
    }));

    // Increment usage counter
    await db
      .collection(BUSINESS_COLLECTION)
      .doc(businessId)
      .update({ usageThisMonth: admin.firestore.FieldValue.increment(1) });

    await logUsage({ businessId, endpoint: 'appointments', ip: req.ip, success: true, latencyMs: Date.now() - (req as any)._startTime });

    res.status(200).json({
      appointments,
      count: appointments.length,
      hasMore: appointments.length === parseInt(limit as string)
    });
  } catch (err) {
    console.error('list appointments error:', err);
    await logUsage({ businessId, endpoint: 'appointments', ip: req.ip, success: false, latencyMs: Date.now() - (req as any)._startTime });
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Endpoint: Get Usage Statistics
businessApiApp.get('/usage', async (req, res) => {
  const businessId = (req as any).businessId as string;
  try {
    const { month, year } = req.query;

    const currentDate = new Date();
    const targetMonth = month ? parseInt(month as string) : currentDate.getMonth() + 1;
    const targetYear = year ? parseInt(year as string) : currentDate.getFullYear();

    const startOfMonth = new Date(targetYear, targetMonth - 1, 1);
    const endOfMonth = new Date(targetYear, targetMonth, 0, 23, 59, 59, 999);

    // Get usage logs for the month
    const usageSnap = await db
      .collection(USAGE_COLLECTION)
      .where('businessId', '==', businessId)
      .where('timestamp', '>=', startOfMonth)
      .where('timestamp', '<=', endOfMonth)
      .get();

    // Get business data for quota info
    const businessSnap = await db.collection(BUSINESS_COLLECTION).doc(businessId).get();
    const businessData = businessSnap.data();

    // Calculate usage by endpoint
    const endpointUsage: { [key: string]: number } = {};
    let totalCalls = 0;
    let successfulCalls = 0;

    usageSnap.forEach(doc => {
      const data = doc.data();
      const endpoint = data.endpoint;
      endpointUsage[endpoint] = (endpointUsage[endpoint] || 0) + 1;
      totalCalls++;
      if (data.success) successfulCalls++;
    });

    // Increment usage counter
    await db
      .collection(BUSINESS_COLLECTION)
      .doc(businessId)
      .update({ usageThisMonth: admin.firestore.FieldValue.increment(1) });

    await logUsage({ businessId, endpoint: 'usage', ip: req.ip, success: true, latencyMs: Date.now() - (req as any)._startTime });

    res.status(200).json({
      month: targetMonth,
      year: targetYear,
      totalCalls,
      successfulCalls,
      successRate: totalCalls > 0 ? (successfulCalls / totalCalls) * 100 : 0,
      quota: businessData?.monthlyQuota || 0,
      remaining: Math.max(0, (businessData?.monthlyQuota || 0) - totalCalls),
      endpoints: endpointUsage
    });
  } catch (err) {
    console.error('get usage error:', err);
    await logUsage({ businessId, endpoint: 'usage', ip: req.ip, success: false, latencyMs: Date.now() - (req as any)._startTime });
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Endpoint: Get Invoice History
businessApiApp.get('/invoices', async (req, res) => {
  const businessId = (req as any).businessId as string;
  try {
    const { limit = 10, status } = req.query;

    let query = db.collection(INVOICES_COLLECTION).where('businessId', '==', businessId);

    if (status) {
      query = query.where('status', '==', status);
    }

    const invoicesSnap = await query
      .orderBy('createdAt', 'desc')
      .limit(parseInt(limit as string))
      .get();

    const invoices = invoicesSnap.docs.map(doc => ({
      invoiceId: doc.id,
      ...doc.data(),
      createdAt: doc.data().createdAt?.toDate().toISOString(),
      dueDate: doc.data().dueDate?.toDate().toISOString(),
    }));

    // Increment usage counter
    await db
      .collection(BUSINESS_COLLECTION)
      .doc(businessId)
      .update({ usageThisMonth: admin.firestore.FieldValue.increment(1) });

    await logUsage({ businessId, endpoint: 'invoices', ip: req.ip, success: true, latencyMs: Date.now() - (req as any)._startTime });

    res.status(200).json({
      invoices,
      count: invoices.length,
      hasMore: invoices.length === parseInt(limit as string)
    });
  } catch (err) {
    console.error('get invoices error:', err);
    await logUsage({ businessId, endpoint: 'invoices', ip: req.ip, success: false, latencyMs: Date.now() - (req as any)._startTime });
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Endpoint: Get Account Information
businessApiApp.get('/account', async (req, res) => {
  const businessId = (req as any).businessId as string;
  try {
    const businessSnap = await db.collection(BUSINESS_COLLECTION).doc(businessId).get();
    const businessData = businessSnap.data();

    if (!businessData) {
      res.status(404).json({ error: 'Account not found' });
      return;
    }

    // Increment usage counter
    await db
      .collection(BUSINESS_COLLECTION)
      .doc(businessId)
      .update({ usageThisMonth: admin.firestore.FieldValue.increment(1) });

    await logUsage({ businessId, endpoint: 'account', ip: req.ip, success: true, latencyMs: Date.now() - (req as any)._startTime });

    res.status(200).json({
      id: businessId,
      name: businessData.name,
      email: businessData.email,
      industry: businessData.industry,
      status: businessData.status,
      monthlyQuota: businessData.monthlyQuota,
      usageThisMonth: businessData.usageThisMonth,
      ipWhitelistEnabled: businessData.ipWhitelistEnabled || false,
      createdAt: businessData.createdAt?.toDate().toISOString(),
      lastUsedAt: businessData.lastUsedAt?.toDate().toISOString(),
    });
  } catch (err) {
    console.error('get account error:', err);
    await logUsage({ businessId, endpoint: 'account', ip: req.ip, success: false, latencyMs: Date.now() - (req as any)._startTime });
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Endpoint: Update Account Settings
businessApiApp.put('/account', async (req, res) => {
  const businessId = (req as any).businessId as string;
  try {
    const { name, email, industry, ipWhitelistEnabled } = req.body;

    const updateData: any = {
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    if (name !== undefined) updateData.name = name;
    if (email !== undefined) updateData.email = email;
    if (industry !== undefined) updateData.industry = industry;
    if (ipWhitelistEnabled !== undefined) updateData.ipWhitelistEnabled = ipWhitelistEnabled;

    await db.collection(BUSINESS_COLLECTION).doc(businessId).update(updateData);

    // Increment usage counter
    await db
      .collection(BUSINESS_COLLECTION)
      .doc(businessId)
      .update({ usageThisMonth: admin.firestore.FieldValue.increment(1) });

    await logUsage({ businessId, endpoint: 'account', ip: req.ip, success: true, latencyMs: Date.now() - (req as any)._startTime });

    res.status(200).json({
      message: 'Account updated successfully',
      updatedFields: Object.keys(updateData).filter(key => key !== 'updatedAt')
    });
  } catch (err) {
    console.error('update account error:', err);
    await logUsage({ businessId, endpoint: 'account', ip: req.ip, success: false, latencyMs: Date.now() - (req as any)._startTime });
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Wrap express app as cloud function
export const businessApi = onRequest(businessApiApp);

/**
 * Scheduled function: Reset monthly quotas & trigger billing every 1st day of month.
 * Runs at 00:00 on day-1 UTC.
 */
export const resetMonthlyQuotas = onSchedule('0 0 1 * *', async () => {
  const snapshot = await db.collection(BUSINESS_COLLECTION).get();

  const batch = db.batch();
  snapshot.docs.forEach((doc) => {
    batch.update(doc.ref, { usageThisMonth: 0 });
  });

  await batch.commit();
  console.log('Monthly quotas reset');

  // Trigger billing for all active businesses
  const activeBusinesses = await db
    .collection(BUSINESS_COLLECTION)
    .where('status', '==', 'active')
    .get();

  for (const doc of activeBusinesses.docs) {
    const businessData = doc.data();
    if (businessData.usageThisMonth > 0) {
      // Import and call billing function
      const { generateMonthlyInvoice } = await import('./billingEngine');
      try {
        await generateMonthlyInvoice(doc.id, businessData);
      } catch (error) {
        console.error(`Failed to generate invoice for business ${doc.id}:`, error);
      }
    }
  }
});

// Export functions for testing
export const generateBusinessApiKey = generateApiKey;
export const recordApiUsage = logUsage;

// Export billing functions (these will be implemented in billingEngine.ts)
export const generateMonthlyInvoice = async (businessId: string, businessData: any) => {
  // This will be implemented in billingEngine.ts
  console.log('Generating monthly invoice for business:', businessId);
};

export const checkOverdueInvoices = async () => {
  // This will be implemented in billingEngine.ts
  console.log('Checking overdue invoices');
};