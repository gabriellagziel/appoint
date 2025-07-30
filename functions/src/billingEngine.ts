import * as functions from 'firebase-functions';
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

function generateInvoicePDF({
  businessName,
  businessId,
  apiKey,
  usage,
  amount,
  dueDate,
}: {
  businessName: string;
  businessId: string;
  apiKey: string;
  usage: number;
  amount: number;
  dueDate: Date;
}): Promise<Buffer> {
  return new Promise((resolve, reject) => {
    const doc = new PDFDocument();
    const chunks: Buffer[] = [];
    doc.on('data', (chunk) => chunks.push(chunk as Buffer));
    doc.on('end', () => resolve(Buffer.concat(chunks)));
    doc.on('error', reject);

    doc.fontSize(20).text('App-Oint API Invoice', { align: 'center' });
    doc.moveDown();

    doc.fontSize(12).text(`Business: ${businessName}`);
    doc.text(`Business ID: ${businessId}`);
    doc.text(`API Key: ${apiKey}`);
    doc.text(`Usage (this month): ${usage} calls`);
    doc.text(`Amount due: €${amount.toFixed(2)}`);
    doc.text(`Due date: ${dueDate.toDateString()}`);

    doc.moveDown();
    doc.text('Bank Transfer IBAN: DE00 0000 0000 0000 0000 00');
    doc.text('Or pay via Stripe: https://pay.stripe.com/link');

    doc.end();
  });
}

async function sendInvoiceEmail({
  to,
  pdfBuffer,
  filename,
}: {
  to: string;
  pdfBuffer: Buffer;
  filename: string;
}) {
  // In production, configure SMTP credentials in env.
  const transporter = nodemailer.createTransport({
    host: process.env.SMTP_HOST || 'localhost',
    port: Number(process.env.SMTP_PORT) || 1025,
    secure: false,
  });

  await transporter.sendMail({
    from: 'billing@app-oint.com',
    to,
    subject: 'Your App-Oint API Invoice',
    text: 'Please find attached the invoice for your API usage.',
    attachments: [
      {
        filename,
        content: pdfBuffer,
      },
    ],
  });
}

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
      await invoiceRef.update({ status: 'paid', paidAt: admin.firestore.FieldValue.serverTimestamp() });

      const invoiceSnap = await invoiceRef.get();
      const { businessId } = invoiceSnap.data() || {};
      if (businessId) {
        await db.collection(BUSINESS_COLLECTION).doc(businessId).update({ status: 'active' });
      }
    }

    res.json({ success: true });
  } catch (err) {
    console.error('importBankPayments error', err);
    res.status(500).json({ error: 'Failed to import' });
  }
});