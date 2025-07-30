import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import fetch from 'node-fetch';
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

/**
 * Enterprise Webhooks: Subscribe to real-time events
 */
export const subscribeWebhook = functions.https.onCall(async (data, context) => {
  try {
    const { businessId, url, events, secret } = data;
    
    if (!context.auth?.uid) {
      throw new functions.https.HttpsError('unauthenticated', 'Authentication required');
    }

    // Validate URL
    try {
      new URL(url);
    } catch {
      throw new functions.https.HttpsError('invalid-argument', 'Invalid webhook URL');
    }

    // Validate events
    const validEvents = ['appointment.created', 'appointment.cancelled', 'appointment.updated', 'payment.succeeded', 'payment.failed', 'quota.exceeded'];
    const invalidEvents = events.filter((event: string) => !validEvents.includes(event));
    if (invalidEvents.length > 0) {
      throw new functions.https.HttpsError('invalid-argument', `Invalid events: ${invalidEvents.join(', ')}`);
    }

    // Store webhook subscription
    const webhookData = {
      businessId,
      url,
      events,
      secret: secret || null,
      status: 'active',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      lastDelivery: null,
      failureCount: 0
    };

    const webhookRef = await db.collection('webhook_subscriptions').add(webhookData);

    return { 
      success: true, 
      webhookId: webhookRef.id,
      events: validEvents
    };
  } catch (error) {
    console.error('Subscribe webhook error:', error);
    throw new functions.https.HttpsError('internal', 'Failed to subscribe webhook');
  }
});

/**
 * Enterprise Webhooks: Unsubscribe from events
 */
export const unsubscribeWebhook = functions.https.onCall(async (data, context) => {
  try {
    const { webhookId } = data;
    
    if (!context.auth?.uid) {
      throw new functions.https.HttpsError('unauthenticated', 'Authentication required');
    }

    await db.collection('webhook_subscriptions').doc(webhookId).update({
      status: 'inactive',
      deletedAt: admin.firestore.FieldValue.serverTimestamp()
    });

    return { success: true };
  } catch (error) {
    console.error('Unsubscribe webhook error:', error);
    throw new functions.https.HttpsError('internal', 'Failed to unsubscribe webhook');
  }
});

/**
 * Enhanced webhook delivery with retry logic
 */
async function deliverWebhook(webhookData: any, eventType: string, payload: any) {
  const maxRetries = 3;
  const retryDelays = [1000, 5000, 15000]; // 1s, 5s, 15s
  
  for (let attempt = 0; attempt < maxRetries; attempt++) {
    try {
      const webhookPayload = {
        id: generateWebhookId(),
        event: eventType,
        created: Math.floor(Date.now() / 1000),
        data: payload
      };

      // Create signature if secret is provided
      let signature = null;
      if (webhookData.secret) {
        const crypto = require('crypto');
        signature = crypto
          .createHmac('sha256', webhookData.secret)
          .update(JSON.stringify(webhookPayload))
          .digest('hex');
      }

      const headers: any = {
        'Content-Type': 'application/json',
        'User-Agent': 'App-Oint-Webhooks/1.0',
        'X-App-Oint-Event': eventType,
        'X-App-Oint-Delivery': webhookPayload.id
      };

      if (signature) {
        headers['X-App-Oint-Signature'] = `sha256=${signature}`;
      }

      const response = await fetch(webhookData.url, {
        method: 'POST',
        headers,
        body: JSON.stringify(webhookPayload),
        signal: AbortSignal.timeout(10000) // 10 second timeout
      });

      if (response.ok) {
        // Success - update webhook status
        await db.collection('webhook_subscriptions').doc(webhookData.id).update({
          lastDelivery: admin.firestore.FieldValue.serverTimestamp(),
          failureCount: 0
        });
        
        // Log successful delivery
        await db.collection('webhook_deliveries').add({
          webhookId: webhookData.id,
          businessId: webhookData.businessId,
          event: eventType,
          status: 'success',
          attempt: attempt + 1,
          responseStatus: response.status,
          deliveredAt: admin.firestore.FieldValue.serverTimestamp()
        });
        
        return;
      } else {
        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
      }
    } catch (error) {
      console.error(`Webhook delivery attempt ${attempt + 1} failed:`, error);
      
      if (attempt === maxRetries - 1) {
        // Final failure - update failure count
        await db.collection('webhook_subscriptions').doc(webhookData.id).update({
          failureCount: admin.firestore.FieldValue.increment(1)
        });

        // Log failed delivery
        await db.collection('webhook_deliveries').add({
          webhookId: webhookData.id,
          businessId: webhookData.businessId,
          event: eventType,
          status: 'failed',
          attempt: attempt + 1,
          error: (error as Error).message,
          failedAt: admin.firestore.FieldValue.serverTimestamp()
        });

        // Disable webhook after 10 consecutive failures
        const webhookDoc = await db.collection('webhook_subscriptions').doc(webhookData.id).get();
        if (webhookDoc.exists && webhookDoc.data()?.failureCount >= 10) {
          await db.collection('webhook_subscriptions').doc(webhookData.id).update({
            status: 'disabled',
            disabledAt: admin.firestore.FieldValue.serverTimestamp(),
            disabledReason: 'consecutive_failures'
          });
        }
      } else {
        // Wait before retry
        await new Promise(resolve => setTimeout(resolve, retryDelays[attempt]));
      }
    }
  }
}

function generateWebhookId(): string {
  return 'wh_' + Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
}

/**
 * Enhanced Firestore trigger for appointment events
 */
export const onAppointmentChange = functions.firestore
  .document('appointments/{appointmentId}')
  .onWrite(async (change, context) => {
    const appointmentId = context.params.appointmentId;
    const before = change.before.data();
    const after = change.after.data();

    let eventType: string | null = null;
    let payload: any = null;

    if (!before && after) {
      // New appointment created
      eventType = 'appointment.created';
      payload = {
        appointment: {
          id: appointmentId,
          businessId: after.businessId,
          customerName: after.customerName,
          customerEmail: after.customerEmail,
          start: after.start?.toDate?.()?.toISOString() || after.start,
          end: after.end?.toDate?.()?.toISOString() || after.end,
          duration: after.duration,
          status: after.status,
          createdAt: after.createdAt?.toDate?.()?.toISOString() || after.createdAt
        }
      };
    } else if (before && after) {
      // Appointment updated
      if (before.status !== after.status) {
        if (after.status === 'cancelled') {
          eventType = 'appointment.cancelled';
        } else {
          eventType = 'appointment.updated';
        }
        payload = {
          appointment: {
            id: appointmentId,
            businessId: after.businessId,
            customerName: after.customerName,
            start: after.start?.toDate?.()?.toISOString() || after.start,
            end: after.end?.toDate?.()?.toISOString() || after.end,
            status: after.status,
            previousStatus: before.status,
            updatedAt: admin.firestore.FieldValue.serverTimestamp()
          }
        };
      }
    }

    if (eventType && payload) {
      // Find active webhook subscriptions for this business and event
      const webhooksSnap = await db
        .collection('webhook_subscriptions')
        .where('businessId', '==', payload.appointment.businessId)
        .where('status', '==', 'active')
        .where('events', 'array-contains', eventType)
        .get();

      // Deliver webhooks in parallel
      const deliveryPromises = webhooksSnap.docs.map(doc => {
        const webhookData = { id: doc.id, ...doc.data() };
        return deliverWebhook(webhookData, eventType, payload);
      });

      await Promise.allSettled(deliveryPromises);
    }
  });

/**
 * Webhook endpoint for testing
 */
export const webhookTest = functions.https.onRequest(async (req, res) => {
  res.set('Access-Control-Allow-Origin', '*');
  res.set('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.set('Access-Control-Allow-Headers', 'Content-Type, X-App-Oint-Signature, X-App-Oint-Event');

  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }

  if (req.method !== 'POST') {
    res.status(405).json({ error: 'Method not allowed' });
    return;
  }

  // Echo back the webhook payload for testing
  console.log('Webhook test received:', {
    headers: req.headers,
    body: req.body
  });

  res.status(200).json({ 
    received: true,
    event: req.headers['x-app-oint-event'],
    timestamp: new Date().toISOString()
  });
});

/**
 * Pub/Sub scheduled function processes retries.
 */
export const processWebhookRetries = functions.pubsub
  .schedule('every 5 minutes')
  .onRun(async () => {
    const now = admin.firestore.Timestamp.now();
    const snap = await db.collection(WEBHOOK_COLLECTION).where('nextRetry', '<=', now).get();
    snap.forEach((doc) => {
      const data = doc.data();
      deliverWebhook({ id: doc.id, ...data }, { retry: true });
    });
  });