import * as functions from 'firebase-functions/v1';
import * as admin from 'firebase-admin';
import PDFDocument from 'pdfkit';
import * as nodemailer from 'nodemailer';
import { parse } from 'csv-parse/sync';

if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();
const storage = admin.storage().bucket();

const BUSINESS_COLLECTION = 'business_accounts';
const BUSINESS_SUBSCRIPTIONS_COLLECTION = 'business_subscriptions';
const INVOICE_COLLECTION = 'invoices';

interface PricingModel {
  pricingModel: 'per_call' | 'flat' | 'tiered';
  baseRate?: number; // per-call
  monthlyFlat?: number | null;
  tier?: {
    free: number;
    rate: number;
  };
}

// Map usage constants
const MAP_OVERAGE_RATE = 0.01; // €0.01 per extra load
const MAP_SYSTEM_COST = 0.007; // €0.007 per map load

function calculateAmount(usage: number, pricing: PricingModel): number {
  switch (pricing.pricingModel) {
    case 'flat':
      return pricing.monthlyFlat || 0;
    case 'per_call':
      return (pricing.baseRate || 0) * usage;
    case 'tiered': {
      const free = pricing.tier?.free || 0;
      const tierRate = pricing.tier?.rate || 0;
      const billable = Math.max(0, usage - free);
      return billable * tierRate;
    }
    default:
      return 0;
  }
}

function calculateMapOverage(usage: number, limit: number): { overageCount: number; overageAmount: number } {
  if (limit <= 0 || usage <= limit) {
    return { overageCount: 0, overageAmount: 0 };
  }
  
  const overageCount = usage - limit;
  const overageAmount = overageCount * MAP_OVERAGE_RATE;
  
  return { overageCount, overageAmount };
}

function generateInvoicePDF({
  businessName,
  businessId,
  apiKey,
  usage,
  amount,
  dueDate,
  isOverageInvoice = false,
  mapOverageDetails,
}: {
  businessName: string;
  businessId: string;
  apiKey: string;
  usage: number;
  amount: number;
  dueDate: Date;
  isOverageInvoice?: boolean;
  mapOverageDetails?: {
    overageCount: number;
    overageAmount: number;
    totalUsage: number;
    limit: number;
  };
}): Promise<Buffer> {
  return new Promise((resolve, reject) => {
    const doc = new PDFDocument();
    const chunks: Buffer[] = [];
    doc.on('data', (chunk) => chunks.push(chunk as Buffer));
    doc.on('end', () => resolve(Buffer.concat(chunks)));
    doc.on('error', reject);

    // Header
    doc.fontSize(20).text('App-Oint Invoice', { align: 'center' });
    doc.moveDown();

    // Business details
    doc.fontSize(12).text(`Business: ${businessName}`);
    doc.text(`Business ID: ${businessId}`);
    
    if (isOverageInvoice && mapOverageDetails) {
      // Map overage invoice
      doc.moveDown();
      doc.fontSize(16).text('Map Usage Overage Invoice', { underline: true });
      doc.moveDown();
      
      doc.fontSize(12).text(`Total map loads this period: ${mapOverageDetails.totalUsage}`);
      doc.text(`Plan limit: ${mapOverageDetails.limit} loads`);
      doc.text(`Overage: ${mapOverageDetails.overageCount} loads`);
      doc.text(`Rate per overage load: €${MAP_OVERAGE_RATE.toFixed(3)}`);
      doc.moveDown();
      doc.text(`Overage amount: €${mapOverageDetails.overageAmount.toFixed(2)}`, { 
        fontSize: 14, 
        continued: false 
      });
    } else {
      // Regular API usage invoice
      doc.text(`API Key: ${apiKey}`);
      doc.text(`Usage (this month): ${usage} calls`);
    }
    
    doc.moveDown();
    doc.fontSize(14).text(`Total amount due: €${amount.toFixed(2)}`, { 
      fontSize: 16, 
      underline: true 
    });
    doc.text(`Due date: ${dueDate.toDateString()}`);

    doc.moveDown();
    doc.fontSize(12).text('Payment Methods:');
    doc.text('Bank Transfer IBAN: DE00 0000 0000 0000 0000 00');
    doc.text('Or pay via Stripe: https://pay.stripe.com/link');

    doc.end();
  });
}

async function sendInvoiceEmail({
  to,
  pdfBuffer,
  filename,
  isOverageInvoice = false,
}: {
  to: string;
  pdfBuffer: Buffer;
  filename: string;
  isOverageInvoice?: boolean;
}) {
  // In production, configure SMTP credentials in env.
  const transporter = nodemailer.createTransport({
    host: process.env.SMTP_HOST || 'localhost',
    port: Number(process.env.SMTP_PORT) || 1025,
    secure: false,
  });

  const subject = isOverageInvoice 
    ? 'App-Oint Map Usage Overage Invoice' 
    : 'Your App-Oint API Invoice';
  
  const text = isOverageInvoice
    ? 'Your map usage has exceeded your plan limits. Please find attached the overage invoice.'
    : 'Please find attached the invoice for your API usage.';

  await transporter.sendMail({
    from: 'billing@app-oint.com',
    to,
    subject,
    text,
    attachments: [
      {
        filename,
        content: pdfBuffer,
      },
    ],
  });
}

// Monthly billing job for API usage (existing)
export const monthlyBillingJob = functions.pubsub
  .schedule('15 0 1 * *') // 00:15 on first day UTC
  .timeZone('UTC')
  .onRun(async () => {
    const year = new Date().getUTCFullYear();
    const month = new Date().getUTCMonth(); // previous month? Actually runs first day for previous month compute
    const billingPeriodStart = new Date(Date.UTC(year, month - 1, 1));
    const billingPeriodEnd = new Date(Date.UTC(year, month, 0, 23, 59, 59)); // last day prev month

    const businessesSnap = await db.collection(BUSINESS_COLLECTION).where('status', '==', 'active').get();

    for (const doc of businessesSnap.docs) {
      const businessData = doc.data() as any;

      // Fetch usage logs for period
      const usageSnap = await db
        .collection('usage_logs')
        .where('businessId', '==', doc.id)
        .where('timestamp', '>=', billingPeriodStart)
        .where('timestamp', '<=', billingPeriodEnd)
        .get();
      const usage = usageSnap.size;

      const pricing: PricingModel = businessData.pricing || {
        pricingModel: 'per_call',
        baseRate: 0.01,
      };

      const amount = calculateAmount(usage, pricing);

      const dueDate = new Date(Date.UTC(year, month, 15));

      const pdfBuffer = await generateInvoicePDF({
        businessName: businessData.name,
        businessId: doc.id,
        apiKey: businessData.apiKey,
        usage,
        amount,
        dueDate,
      });

      const filePath = `invoices/${doc.id}/${year}-${month.toString().padStart(2, '0')}.pdf`;
      const file = storage.file(filePath);
      await file.save(pdfBuffer, { contentType: 'application/pdf' });

      const [url] = await file.getSignedUrl({ action: 'read', expires: '03-01-2500' });

      // Create invoice record
      const invoiceRef = await db.collection(INVOICE_COLLECTION).add({
        businessId: doc.id,
        amount,
        usage,
        pricing,
        periodStart: billingPeriodStart,
        periodEnd: billingPeriodEnd,
        dueDate,
        pdfUrl: url,
        status: 'pending',
        type: 'api_usage',
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      // Send email
      await sendInvoiceEmail({
        to: businessData.email,
        pdfBuffer,
        filename: `invoice-${invoiceRef.id}.pdf`,
      });

      console.log(`Invoice sent to ${businessData.email}`);
    }

    console.log('Monthly billing job completed');
  });

// Monthly map overage billing job (NEW)
export const monthlyMapOverageBilling = functions.pubsub
  .schedule('30 0 1 * *') // 00:30 on first day UTC - after main billing
  .timeZone('UTC')
  .onRun(async () => {
    const year = new Date().getUTCFullYear();
    const month = new Date().getUTCMonth();

    // Get all active business subscriptions with map overage
    const subscriptionsSnap = await db.collection(BUSINESS_SUBSCRIPTIONS_COLLECTION)
      .where('status', '==', 'active')
      .where('mapOverageThisPeriod', '>', 0)
      .get();

    for (const doc of subscriptionsSnap.docs) {
      const subscriptionData = doc.data() as any;
      
      try {
        // Get business profile
        const businessDoc = await db.collection('business_profiles').doc(subscriptionData.businessId).get();
        const businessData = businessDoc.exists ? businessDoc.data() : null;
        
        if (!businessData) {
          console.warn(`No business profile found for subscription: ${doc.id}`);
          continue;
        }

        const mapOverageDetails = {
          overageCount: Math.round(subscriptionData.mapOverageThisPeriod / MAP_OVERAGE_RATE),
          overageAmount: subscriptionData.mapOverageThisPeriod,
          totalUsage: subscriptionData.mapUsageCurrentPeriod,
          limit: getMapLimitForPlan(subscriptionData.plan),
        };

        const dueDate = new Date();
        dueDate.setDate(dueDate.getDate() + 15); // 15 days from now

        // Generate overage invoice PDF
        const pdfBuffer = await generateInvoicePDF({
          businessName: businessData.name || 'Business User',
          businessId: subscriptionData.businessId,
          apiKey: '', // Not applicable for map usage
          usage: 0, // Not applicable for map overage
          amount: subscriptionData.mapOverageThisPeriod,
          dueDate,
          isOverageInvoice: true,
          mapOverageDetails,
        });

        // Save PDF to storage
        const filePath = `invoices/${subscriptionData.businessId}/map-overage-${year}-${month.toString().padStart(2, '0')}.pdf`;
        const file = storage.file(filePath);
        await file.save(pdfBuffer, { contentType: 'application/pdf' });

        const [url] = await file.getSignedUrl({ action: 'read', expires: '03-01-2500' });

        // Create overage invoice record
        const invoiceRef = await db.collection(INVOICE_COLLECTION).add({
          businessId: subscriptionData.businessId,
          subscriptionId: doc.id,
          amount: subscriptionData.mapOverageThisPeriod,
          type: 'map_overage',
          description: 'Map usage overage charges',
          mapOverageAmount: subscriptionData.mapOverageThisPeriod,
          mapOverageCount: mapOverageDetails.overageCount,
          mapTotalUsage: mapOverageDetails.totalUsage,
          mapLimit: mapOverageDetails.limit,
          periodStart: subscriptionData.currentPeriodStart,
          periodEnd: subscriptionData.currentPeriodEnd,
          dueDate,
          pdfUrl: url,
          status: 'pending',
          currency: 'EUR',
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        // Send overage invoice email
        await sendInvoiceEmail({
          to: businessData.email || subscriptionData.email,
          pdfBuffer,
          filename: `map-overage-invoice-${invoiceRef.id}.pdf`,
          isOverageInvoice: true,
        });

        console.log(`Map overage invoice sent to business: ${subscriptionData.businessId}`);

      } catch (error) {
        console.error(`Error processing overage for subscription ${doc.id}:`, error);
      }
    }

    console.log('Monthly map overage billing completed');
  });

// Helper function to get map limit for plan
function getMapLimitForPlan(plan: string): number {
  switch (plan?.toLowerCase()) {
    case 'starter':
      return 0;
    case 'professional':
      return 200;
    case 'businessplus':
    case 'business_plus':
      return 500;
    default:
      return 0;
  }
}

// Function to manually trigger overage invoice generation (for testing)
export const generateMapOverageInvoice = functions.https.onCall(async (data, context) => {
  const userId = context.auth?.uid;
  
  if (!userId) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  try {
    // Get user's subscription
    const subscriptionDoc = await db.collection(BUSINESS_SUBSCRIPTIONS_COLLECTION)
      .where('businessId', '==', userId)
      .where('status', '==', 'active')
      .limit(1)
      .get();

    if (subscriptionDoc.empty) {
      throw new functions.https.HttpsError('not-found', 'No active subscription found');
    }

    const subscriptionData = subscriptionDoc.docs[0].data();
    
    if (subscriptionData.mapOverageThisPeriod <= 0) {
      throw new functions.https.HttpsError('failed-precondition', 'No map overage to invoice');
    }

    // Get business profile
    const businessDoc = await db.collection('business_profiles').doc(userId).get();
    const businessData = businessDoc.exists ? businessDoc.data() : null;

    if (!businessData) {
      throw new functions.https.HttpsError('not-found', 'Business profile not found');
    }

    const mapOverageDetails = {
      overageCount: Math.round(subscriptionData.mapOverageThisPeriod / MAP_OVERAGE_RATE),
      overageAmount: subscriptionData.mapOverageThisPeriod,
      totalUsage: subscriptionData.mapUsageCurrentPeriod,
      limit: getMapLimitForPlan(subscriptionData.plan),
    };

    const dueDate = new Date();
    dueDate.setDate(dueDate.getDate() + 15);

    // Create invoice record
    const invoiceRef = await db.collection(INVOICE_COLLECTION).add({
      businessId: userId,
      subscriptionId: subscriptionDoc.docs[0].id,
      amount: subscriptionData.mapOverageThisPeriod,
      type: 'map_overage',
      description: 'Map usage overage charges',
      mapOverageAmount: subscriptionData.mapOverageThisPeriod,
      mapOverageCount: mapOverageDetails.overageCount,
      mapTotalUsage: mapOverageDetails.totalUsage,
      mapLimit: mapOverageDetails.limit,
      periodStart: subscriptionData.currentPeriodStart,
      periodEnd: subscriptionData.currentPeriodEnd,
      dueDate,
      status: 'pending',
      currency: 'EUR',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return { 
      success: true, 
      invoiceId: invoiceRef.id,
      amount: subscriptionData.mapOverageThisPeriod,
      overageCount: mapOverageDetails.overageCount,
    };

  } catch (error) {
    console.error('Error generating map overage invoice:', error);
    throw new functions.https.HttpsError('internal', 'Failed to generate overage invoice');
  }
});

/**
 * HTTPS function to import CSV of paid invoices (bank transfers).
 * Expects multipart form or raw CSV string in body.
 */
export const importBankPayments = functions.https.onRequest(async (req, res) => {
  if (req.method !== 'POST') {
    res.status(405).json({ error: 'Only POST allowed' });
    return;
  }

  try {
    const csvData = typeof req.body === 'string' ? req.body : req.body.csv;
    const records = parse(csvData, { columns: true });
    // CSV columns: invoiceId, amountPaid

    for (const row of records) {
      const invoiceRef = db.collection(INVOICE_COLLECTION).doc(row.invoiceId);
      await invoiceRef.update({ 
        status: 'paid', 
        paidAt: admin.firestore.FieldValue.serverTimestamp() 
      });

      const invoiceSnap = await invoiceRef.get();
      const invoiceData = invoiceSnap.data();
      
      if (invoiceData?.businessId) {
        // If it's a map overage invoice, reset the overage amount
        if (invoiceData.type === 'map_overage') {
          await db.collection(BUSINESS_SUBSCRIPTIONS_COLLECTION)
            .doc(invoiceData.subscriptionId)
            .update({ 
              mapOverageThisPeriod: 0.0,
              updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            });
        }
        
        // Reactivate business if it was suspended
        await db.collection(BUSINESS_COLLECTION).doc(invoiceData.businessId).update({ 
          status: 'active' 
        });
      }
    }

    res.json({ success: true });
  } catch (err) {
    console.error('importBankPayments error', err);
    res.status(500).json({ error: 'Failed to import' });
  }
});

// Reset map usage for all subscriptions at billing period start (helper function)
export const resetMapUsageForNewPeriod = functions.https.onCall(async (data, context) => {
  // This should be called by Stripe webhooks when subscription periods update
  const { subscriptionId } = data;
  
  if (!subscriptionId) {
    throw new functions.https.HttpsError('invalid-argument', 'Subscription ID required');
  }

  try {
    await db.collection(BUSINESS_SUBSCRIPTIONS_COLLECTION)
      .where('stripeSubscriptionId', '==', subscriptionId)
      .get()
      .then(snapshot => {
        const batch = db.batch();
        snapshot.docs.forEach(doc => {
          batch.update(doc.ref, {
            mapUsageCurrentPeriod: 0,
            mapOverageThisPeriod: 0.0,
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          });
        });
        return batch.commit();
      });

    return { success: true };
  } catch (error) {
    console.error('Error resetting map usage:', error);
    throw new functions.https.HttpsError('internal', 'Failed to reset map usage');
  }
});