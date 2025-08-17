import { parse } from 'csv-parse/sync';
import * as admin from 'firebase-admin';
import { onCall, onRequest } from 'firebase-functions/v2/https';
import { onSchedule } from 'firebase-functions/v2/scheduler';
import * as nodemailer from 'nodemailer';
import PDFDocument from 'pdfkit';
if (!admin.apps.length) {
    admin.initializeApp();
}
const db = admin.firestore();
const storage = admin.storage().bucket();
const BUSINESS_COLLECTION = 'business_accounts';
const BUSINESS_SUBSCRIPTIONS_COLLECTION = 'business_subscriptions';
const INVOICE_COLLECTION = 'invoices';
const USAGE_COLLECTION = 'usage_logs'; // Added missing constant
// Map usage constants
const MAP_OVERAGE_RATE = 0.01; // €0.01 per extra load
const MAP_SYSTEM_COST = 0.007; // €0.007 per map load
function calculateAmount(usage, pricing) {
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
function calculateMapOverage(usage, limit) {
    if (limit <= 0 || usage <= limit) {
        return { overageCount: 0, overageAmount: 0 };
    }
    const overageCount = usage - limit;
    const overageAmount = overageCount * MAP_OVERAGE_RATE;
    return { overageCount, overageAmount };
}
function generateInvoicePDF({ businessName, businessId, apiKey, usage, amount, dueDate, isOverageInvoice = false, mapOverageDetails, }) {
    return new Promise((resolve, reject) => {
        const doc = new PDFDocument();
        const chunks = [];
        doc.on('data', (chunk) => chunks.push(chunk));
        doc.on('end', () => resolve(Buffer.concat(chunks)));
        doc.on('error', reject);
        // Header
        doc.fontSize(20).text('App-Oint Invoice', 50, 50, { align: 'center' });
        doc.moveDown();
        // Business details
        doc.fontSize(12).text(`Business: ${businessName}`, 50, 80);
        doc.text(`Business ID: ${businessId}`, 50, 100);
        if (isOverageInvoice && mapOverageDetails) {
            // Map overage invoice
            doc.moveDown();
            doc.fontSize(16).text('Map Usage Overage Invoice', 50, 130, { underline: true });
            doc.moveDown();
            doc.fontSize(12).text(`Total map loads this period: ${mapOverageDetails.totalUsage}`, 50, 160);
            doc.text(`Plan limit: ${mapOverageDetails.limit} loads`, 50, 180);
            doc.text(`Overage: ${mapOverageDetails.overageCount} loads`, 50, 200);
            doc.text(`Rate per overage load: €${MAP_OVERAGE_RATE.toFixed(3)}`, 50, 220);
            doc.moveDown();
            doc.fontSize(14).text(`Overage amount: €${mapOverageDetails.overageAmount.toFixed(2)}`, 50, 250);
        }
        else {
            // Regular API usage invoice
            doc.text(`API Key: ${apiKey}`, 50, 160);
            doc.text(`Usage (this month): ${usage} calls`, 50, 180);
        }
        doc.moveDown();
        doc.fontSize(16).text(`Total amount due: €${amount.toFixed(2)}`, 50, 280, { underline: true });
        doc.text(`Due date: ${dueDate.toDateString()}`, 50, 300);
        doc.moveDown();
        doc.fontSize(12).text('Payment Methods:', 50, 330);
        doc.text('Bank Transfer IBAN: DE00 0000 0000 0000 0000 00', 50, 350);
        doc.text('Or pay via Stripe: https://pay.stripe.com/link', 50, 370);
        doc.end();
    });
}
async function sendInvoiceEmail({ to, pdfBuffer, filename, isOverageInvoice = false, }) {
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
/**
 * Generate monthly invoice for a business
 */
export async function generateMonthlyInvoice(businessId, businessData) {
    try {
        const now = new Date();
        const year = now.getFullYear();
        const month = now.getMonth() + 1;
        // Get usage for the month
        const startOfMonth = new Date(year, month - 1, 1);
        const endOfMonth = new Date(year, month, 0, 23, 59, 59, 999);
        const usageSnap = await db
            .collection(USAGE_COLLECTION)
            .where('businessId', '==', businessId)
            .where('timestamp', '>=', startOfMonth)
            .where('timestamp', '<=', endOfMonth)
            .get();
        const totalUsage = usageSnap.size;
        if (totalUsage === 0) {
            console.log(`No usage for business ${businessId} in ${month}/${year}`);
            return;
        }
        // Calculate amount based on pricing model
        const pricingModel = businessData.pricingModel || 'per_call';
        const amount = calculateAmount(totalUsage, {
            pricingModel,
            baseRate: businessData.baseRate || 0.01,
            monthlyFlat: businessData.monthlyFlat,
            tier: businessData.tier
        });
        // Generate invoice PDF
        const pdfBuffer = await generateInvoicePDF({
            businessName: businessData.name,
            businessId,
            apiKey: businessData.apiKey,
            usage: totalUsage,
            amount,
            dueDate: new Date(year, month, 15), // Due on 15th of next month
        });
        // Upload to storage
        const filename = `invoice-${year}-${month.toString().padStart(2, '0')}.pdf`;
        const filePath = `invoices/${businessId}/${filename}`;
        const file = storage.file(filePath);
        await file.save(pdfBuffer, { contentType: 'application/pdf' });
        // Create invoice record
        const invoiceRef = await db.collection(INVOICE_COLLECTION).add({
            businessId,
            businessName: businessData.name,
            month,
            year,
            usage: totalUsage,
            amount,
            status: 'pending',
            dueDate: new Date(year, month, 15),
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
            filePath,
            pricingModel,
            baseRate: businessData.baseRate || 0.01,
        });
        // Send invoice email
        await sendInvoiceEmail({
            to: businessData.email,
            pdfBuffer,
            filename: `invoice-${invoiceRef.id}.pdf`,
        });
        console.log(`Invoice generated for business ${businessId}: ${invoiceRef.id}`);
        return invoiceRef.id;
    }
    catch (error) {
        console.error(`Error generating invoice for business ${businessId}:`, error);
        throw error;
    }
}
// Monthly billing job for API usage (existing)
export const monthlyBillingJob = onSchedule('15 0 1 * *', async () => {
    const year = new Date().getUTCFullYear();
    const month = new Date().getUTCMonth(); // previous month? Actually runs first day for previous month compute
    const billingPeriodStart = new Date(Date.UTC(year, month - 1, 1));
    const billingPeriodEnd = new Date(Date.UTC(year, month, 0, 23, 59, 59)); // last day prev month
    const businessesSnap = await db.collection(BUSINESS_COLLECTION).where('status', '==', 'active').get();
    for (const doc of businessesSnap.docs) {
        const businessData = doc.data();
        // Fetch usage logs for period
        const usageSnap = await db
            .collection('usage_logs')
            .where('businessId', '==', doc.id)
            .where('timestamp', '>=', billingPeriodStart)
            .where('timestamp', '<=', billingPeriodEnd)
            .get();
        const usage = usageSnap.size;
        const pricing = businessData.pricing || {
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
export const monthlyMapOverageBilling = onSchedule('30 0 1 * *', async () => {
    const year = new Date().getUTCFullYear();
    const month = new Date().getUTCMonth();
    // Get all active business subscriptions with map overage
    const subscriptionsSnap = await db.collection(BUSINESS_SUBSCRIPTIONS_COLLECTION)
        .where('status', '==', 'active')
        .where('mapOverageThisPeriod', '>', 0)
        .get();
    for (const doc of subscriptionsSnap.docs) {
        const subscriptionData = doc.data();
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
        }
        catch (error) {
            console.error(`Error processing overage for subscription ${doc.id}:`, error);
        }
    }
    console.log('Monthly map overage billing completed');
});
// Helper function to get map limit for plan
function getMapLimitForPlan(plan) {
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
export const generateMapOverageInvoice = onCall(async (request) => {
    const userId = request.auth?.uid;
    if (!userId) {
        throw new Error('User must be authenticated');
    }
    try {
        // Get user's subscription
        const subscriptionDoc = await db.collection(BUSINESS_SUBSCRIPTIONS_COLLECTION)
            .where('businessId', '==', userId)
            .where('status', '==', 'active')
            .limit(1)
            .get();
        if (subscriptionDoc.empty) {
            throw new Error('No active subscription found');
        }
        const subscriptionData = subscriptionDoc.docs[0].data();
        if (subscriptionData.mapOverageThisPeriod <= 0) {
            throw new Error('No map overage to invoice');
        }
        // Get business profile
        const businessDoc = await db.collection('business_profiles').doc(userId).get();
        const businessData = businessDoc.exists ? businessDoc.data() : null;
        if (!businessData) {
            throw new Error('Business profile not found');
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
    }
    catch (error) {
        console.error('Error generating map overage invoice:', error);
        throw new Error('Failed to generate overage invoice');
    }
});
/**
 * HTTPS function to import CSV of paid invoices (bank transfers).
 * Expects multipart form or raw CSV string in body.
 */
export const importBankPayments = onRequest(async (req, res) => {
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
    }
    catch (err) {
        console.error('importBankPayments error', err);
        res.status(500).json({ error: 'Failed to import' });
    }
});
// Reset map usage for all subscriptions at billing period start (helper function)
export const resetMapUsageForNewPeriod = onCall(async (request) => {
    // This should be called by Stripe webhooks when subscription periods update
    const { subscriptionId } = request.data;
    if (!subscriptionId) {
        throw new Error('Subscription ID required');
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
    }
    catch (error) {
        console.error('Error resetting map usage:', error);
        throw new Error('Failed to reset map usage');
    }
});
