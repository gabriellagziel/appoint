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
Object.defineProperty(exports, "__esModule", { value: true });
exports.createProCheckoutSession = createProCheckoutSession;
exports.validateGroupSubscription = validateGroupSubscription;
// Stripe group upgrade flow for "Pro" plan
// Purpose: Create checkout session for a group and validate resulting subscription status.
const admin_js_1 = require("../lib/admin.js");
const stripe_js_1 = require("../stripe.js");
const admin = __importStar(require("firebase-admin"));
// Minimal facade to create a Stripe checkout session for a group.
// This calls into the existing exported function logic via HTTP-like interface.
async function createProCheckoutSession(groupId, priceId) {
    // Record an upgrade intent in Firestore for auditability.
    const db = (0, admin_js_1.db)();
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
    await stripe_js_1.createCheckoutSession(mockReq, mockRes);
    if (!responsePayload?.url || !responsePayload?.sessionId) {
        throw new Error('Failed to create Stripe checkout session');
    }
    // Update intent with session info
    await ref.update({ status: 'session_created', sessionId: responsePayload.sessionId, url: responsePayload.url });
    return { url: responsePayload.url, id: responsePayload.sessionId };
}
// Validate session after redirect completes to mark group as Pro.
async function validateGroupSubscription(groupId, sessionId) {
    const db = (0, admin_js_1.db)();
    // Reuse confirmSession — builds on Stripe subscription retrieval
    const mockReq = { body: { sessionId, studioId: groupId }, method: 'POST' };
    const mockRes = { status: (_) => mockRes, json: (_) => mockRes };
    await stripe_js_1.confirmSession(mockReq, mockRes);
    // Mark group as pro and persist subscription linkage
    await db.collection('groups').doc(groupId).set({ plan: 'pro', updatedAt: admin.firestore.FieldValue.serverTimestamp(), stripe: { sessionId } }, { merge: true });
}
