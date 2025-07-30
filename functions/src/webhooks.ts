import * as functions from 'firebase-functions/v1';
import * as admin from 'firebase-admin';
import fetch from 'node-fetch';
import { onDocumentWritten } from 'firebase-functions/v2/firestore';
import crypto from 'crypto';

if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

const WEBHOOK_COLLECTION = 'webhook_endpoints';
const WEBHOOK_LOGS = 'webhook_logs';

function signPayload(secret: string, body: string, timestamp: number) {
  return crypto.createHmac('sha256', secret).update(timestamp + '.' + body).digest('hex');
}

async function deliverWebhook(webhook: any, payload: any) {
  const body = JSON.stringify(payload);
  const timestamp = Date.now();
  const signature = signPayload(webhook.secret, body, timestamp);

  try {
    const res = await fetch(webhook.url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-Signature': signature,
        'X-Timestamp': timestamp.toString(),
      },
      body,
    });

    const success = res.ok;
    await db.collection(WEBHOOK_LOGS).add({
      businessId: webhook.businessId,
      webhookId: webhook.id,
      status: res.status,
      success,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    if (!success) throw new Error('Non-200');
  } catch (err) {
    console.error('Webhook delivery failed', err);
    // enqueue retry
    const nextAttempt = (webhook.retryCount || 0) + 1;
    if (nextAttempt <= 3) {
      await db.collection(WEBHOOK_COLLECTION).doc(webhook.id).update({
        retryCount: nextAttempt,
        nextRetry: admin.firestore.Timestamp.fromMillis(Date.now() + nextAttempt * 60000), // exponential backoff 1,2,3 mins
      });
    }
  }
}

/**
 * Firestore trigger when appointments created/updated/cancelled.
 * For demo, listen to collection 'appointments'.
 */
export const onAppointmentWrite = onDocumentWritten('appointments/{appointmentId}', async (event: any) => {
    const change = event.data;
    const context = event;
    const after = change.after.exists ? change.after.data() : null;
    const before = change.before.exists ? change.before.data() : null;

    let eventType: 'created' | 'updated' | 'cancelled' | null = null;
    if (!before && after) eventType = 'created';
    else if (before && after) eventType = 'updated';
    else if (before && !after) eventType = 'cancelled';
    else return;

    const businessId = (after || before).businessId;
    const hooksSnap = await db.collection(WEBHOOK_COLLECTION).where('businessId', '==', businessId).where('active', '==', true).get();

    const payload = {
      event: `appointment_${eventType}`,
      data: after || before,
    };

    hooksSnap.forEach((doc) => deliverWebhook({ id: doc.id, ...doc.data() }, payload));
  });

/**
 * Pub/Sub scheduled function processes retries.
 */
export const processWebhookRetries = functions.scheduler.onSchedule('every 5 minutes', async () => {
    const now = admin.firestore.Timestamp.now();
    const snap = await db.collection(WEBHOOK_COLLECTION).where('nextRetry', '<=', now).get();
    snap.forEach((doc) => {
      const data = doc.data();
      deliverWebhook({ id: doc.id, ...data }, { retry: true });
    });
  });