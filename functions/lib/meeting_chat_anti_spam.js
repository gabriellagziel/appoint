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
exports.trackChatAnalytics = exports.cleanupRateLimits = exports.validateChatMessage = void 0;
const functions = __importStar(require("firebase-functions"));
const admin = __importStar(require("firebase-admin"));
// Initialize Firebase Admin
if (!admin.apps.length) {
    admin.initializeApp();
}
const db = admin.firestore();
// Rate limiting: max 10 messages per minute per user
const RATE_LIMIT = {
    maxMessages: 10,
    timeWindow: 60 * 1000, // 1 minute in milliseconds
};
// Simple profanity filter
const PROFANITY_WORDS = [
    'spam', 'test', 'demo', // Add more as needed
];
exports.validateChatMessage = functions.firestore
    .document('meetings/{meetingId}/chat/{messageId}')
    .onCreate(async (snap, context) => {
    const message = snap.data();
    const { meetingId } = context.params;
    const { senderId } = message;
    console.log(`Validating chat message from ${senderId} in meeting ${meetingId}`);
    try {
        // Check rate limiting
        const rateLimitKey = `chat_rate_limit:${meetingId}:${senderId}`;
        const rateLimitRef = db.collection('rate_limits').doc(rateLimitKey);
        const rateLimitDoc = await rateLimitRef.get();
        const now = admin.firestore.Timestamp.now();
        if (rateLimitDoc.exists) {
            const rateLimitData = rateLimitDoc.data();
            const timeDiff = now.toMillis() - rateLimitData.lastMessage.toMillis();
            if (timeDiff < RATE_LIMIT.timeWindow && rateLimitData.messageCount >= RATE_LIMIT.maxMessages) {
                console.log(`Rate limit exceeded for user ${senderId}`);
                await snap.ref.delete();
                return;
            }
            // Update rate limit
            await rateLimitRef.set({
                messageCount: rateLimitData.messageCount + 1,
                lastMessage: now,
                updatedAt: now,
            });
        }
        else {
            // First message from this user
            await rateLimitRef.set({
                messageCount: 1,
                lastMessage: now,
                createdAt: now,
                updatedAt: now,
            });
        }
        // Check for profanity
        const messageText = message.text.toLowerCase();
        const hasProfanity = PROFANITY_WORDS.some(word => messageText.includes(word.toLowerCase()));
        if (hasProfanity) {
            console.log(`Profanity detected in message from ${senderId}`);
            await snap.ref.delete();
            return;
        }
        // Check message length
        if (message.text.length > 2000) {
            console.log(`Message too long from ${senderId}`);
            await snap.ref.delete();
            return;
        }
        // Check for empty messages
        if (!message.text.trim()) {
            console.log(`Empty message from ${senderId}`);
            await snap.ref.delete();
            return;
        }
        console.log(`Message validation passed for ${senderId}`);
        // Update message with validation timestamp
        await snap.ref.update({
            validatedAt: now,
            validationStatus: 'approved',
        });
    }
    catch (error) {
        console.error('Error validating chat message:', error);
        // Don't delete the message on validation errors
        // Let it through but log the error
    }
});
// Cleanup old rate limit records (runs every hour)
exports.cleanupRateLimits = functions.pubsub
    .schedule('every 1 hours')
    .onRun(async (context) => {
    const oneHourAgo = admin.firestore.Timestamp.fromMillis(Date.now() - 60 * 60 * 1000);
    const rateLimitsRef = db.collection('rate_limits');
    const oldRecords = await rateLimitsRef
        .where('updatedAt', '<', oneHourAgo)
        .get();
    const batch = db.batch();
    oldRecords.docs.forEach(doc => {
        batch.delete(doc.ref);
    });
    await batch.commit();
    console.log(`Cleaned up ${oldRecords.size} old rate limit records`);
});
// Analytics function for tracking chat activity
exports.trackChatAnalytics = functions.firestore
    .document('meetings/{meetingId}/chat/{messageId}')
    .onCreate(async (snap, context) => {
    const message = snap.data();
    const { meetingId } = context.params;
    // Track message analytics
    await db.collection('analytics').add({
        event: 'MESSAGE_SENT',
        meetingId,
        senderId: message.senderId,
        messageLength: message.text.length,
        timestamp: admin.firestore.Timestamp.now(),
        platform: 'web', // or 'mobile' if needed
    });
    console.log(`Tracked message analytics for meeting ${meetingId}`);
});
