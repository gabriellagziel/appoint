"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.processWebhookRetries = exports.onAppointmentWrite = void 0;
const crypto_1 = __importDefault(require("crypto"));
const admin = __importStar(require("firebase-admin"));
const firestore_1 = require("firebase-functions/v2/firestore");
const scheduler_1 = require("firebase-functions/v2/scheduler");
const node_fetch_1 = __importDefault(require("node-fetch"));
if (!admin.apps.length) {
    admin.initializeApp();
}
const db = admin.firestore();
const WEBHOOK_COLLECTION = 'webhook_endpoints';
const WEBHOOK_LOGS = 'webhook_logs';
function signPayload(secret, body, timestamp) {
    return crypto_1.default.createHmac('sha256', secret).update(timestamp + '.' + body).digest('hex');
}
async function deliverWebhook(webhook, payload) {
    const body = JSON.stringify(payload);
    const timestamp = Date.now();
    const signature = signPayload(webhook.secret, body, timestamp);
    try {
        const res = await (0, node_fetch_1.default)(webhook.url, {
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
        if (!success)
            throw new Error('Non-200');
    }
    catch (err) {
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
exports.onAppointmentWrite = (0, firestore_1.onDocumentWritten)('appointments/{appointmentId}', async (event) => {
    const change = event.data;
    const context = event;
    const after = change.after.exists ? change.after.data() : null;
    const before = change.before.exists ? change.before.data() : null;
    let eventType = null;
    if (!before && after)
        eventType = 'created';
    else if (before && after)
        eventType = 'updated';
    else if (before && !after)
        eventType = 'cancelled';
    else
        return;
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
exports.processWebhookRetries = (0, scheduler_1.onSchedule)('every 5 minutes', async () => {
    const now = admin.firestore.Timestamp.now();
    const snap = await db.collection(WEBHOOK_COLLECTION).where('nextRetry', '<=', now).get();
    snap.forEach((doc) => {
        const data = doc.data();
        deliverWebhook({ id: doc.id, ...data }, { retry: true });
    });
});
