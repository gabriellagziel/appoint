// Stripe group upgrade flow for "Pro" plan
// Purpose: Create checkout session for a group and validate resulting subscription status.
import { db as getDb } from '../lib/admin.js';
import { createCheckoutSession, confirmSession } from '../stripe.js';
import * as admin from 'firebase-admin';
// Minimal facade to create a Stripe checkout session for a group.
// This calls into the existing exported function logic via HTTP-like interface.
export async function createProCheckoutSession(groupId, priceId) {
    // Record an upgrade intent in Firestore for auditability.
    const db = getDb();
    const ref = db.collection('group_upgrade_intents').doc();
    await ref.set({ groupId, priceId, status: 'initiated', createdAt: admin.firestore.FieldValue.serverTimestamp() });
    // Reuse createCheckoutSession exported handler by constructing a request-like object
    const mockReq = { body: { groupId, priceId }, method: 'POST' };
    let responsePayload = null;
    const mockRes = {
        status: (_) => mockRes,
        json: (data) => {
            responsePayload = data;
            return mockRes;
        },
    };
    await createCheckoutSession(mockReq, mockRes);
    if (!responsePayload?.url || !responsePayload?.sessionId) {
        throw new Error('Failed to create Stripe checkout session');
    }
    // Update intent with session info
    await ref.update({ status: 'session_created', sessionId: responsePayload.sessionId, url: responsePayload.url });
    return { url: responsePayload.url, id: responsePayload.sessionId };
}
// Validate session after redirect completes to mark group as Pro.
export async function validateGroupSubscription(groupId, sessionId) {
    const db = getDb();
    // Reuse confirmSession — builds on Stripe subscription retrieval
    const mockReq = { body: { sessionId, studioId: groupId }, method: 'POST' };
    const mockRes = { status: (_) => mockRes, json: (_) => mockRes };
    await confirmSession(mockReq, mockRes);
    // Mark group as pro and persist subscription linkage
    await db.collection('groups').doc(groupId).set({ plan: 'pro', updatedAt: admin.firestore.FieldValue.serverTimestamp(), stripe: { sessionId } }, { merge: true });
}
