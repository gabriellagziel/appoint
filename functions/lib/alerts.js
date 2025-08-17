import * as admin from 'firebase-admin';
import { onSchedule } from 'firebase-functions/v2/scheduler';
import fetch from 'node-fetch';
if (!admin.apps.length) {
    admin.initializeApp();
}
const db = admin.firestore();
const BUSINESS_COLLECTION = 'business_accounts';
const USAGE_COLLECTION = 'usage_logs';
const INVOICE_COLLECTION = 'invoices';
const SLACK_URL = process.env.SLACK_ALERTS_URL;
function sendAlert(message) {
    if (SLACK_URL) {
        return fetch(SLACK_URL, { method: 'POST', body: JSON.stringify({ text: message }), headers: { 'Content-Type': 'application/json' } });
    }
    console.log('ALERT:', message);
}
export const hourlyAlerts = onSchedule('every 60 minutes', async (event) => {
    const now = admin.firestore.Timestamp.now();
    // Quota near limit
    const bizSnap = await db.collection(BUSINESS_COLLECTION).get();
    for (const doc of bizSnap.docs) {
        const data = doc.data();
        if (data.monthlyQuota && data.usageThisMonth >= data.monthlyQuota * 0.9 && !data.quotaAlertSent) {
            await sendAlert(`Business ${data.name} is over 90% of quota.`);
            await doc.ref.update({ quotaAlertSent: true });
        }
    }
    // Overdue invoices
    const overdueSnap = await db.collection(INVOICE_COLLECTION).where('status', '==', 'pending').where('dueDate', '<=', new Date()).get();
    overdueSnap.forEach((d) => sendAlert(`Invoice ${d.id} is overdue.`));
});
