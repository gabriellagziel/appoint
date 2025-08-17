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
exports.getGuestParticipants = exports.convertGuestToRegistered = exports.trackGuestAcceptance = void 0;
const admin = __importStar(require("firebase-admin"));
const functions = __importStar(require("firebase-functions"));
// Initialize Firebase Admin
admin.initializeApp();
const db = admin.firestore();
exports.trackGuestAcceptance = functions.https.onCall(async (request, context) => {
    try {
        const { appointmentId, creatorId, shareId, source, userAgent } = request.data;
        if (!appointmentId || !creatorId) {
            throw new functions.https.HttpsError('invalid-argument', 'Missing required fields: appointmentId, creatorId');
        }
        // Create guest participant record
        const guestParticipant = {
            appointmentId,
            creatorId,
            shareId: shareId || null,
            source: source || 'whatsapp_group',
            userAgent: userAgent || 'web_guest',
            acceptedAt: admin.firestore.FieldValue.serverTimestamp(),
            status: 'pending_app_install',
            isGuest: true,
        };
        const docRef = await db.collection('guest_participants').add(guestParticipant);
        // Track analytics
        await db.collection('share_conversions').add({
            shareId: shareId || 'guest_${Date.now()}',
            appointmentId,
            participantId: `guest_${docRef.id}`,
            joinedAt: admin.firestore.FieldValue.serverTimestamp(),
            source: source || 'whatsapp_group',
            isGuest: true,
        });
        // Log analytics event
        await db.collection('analytics_events').add({
            event: 'guest_invitation_accepted',
            appointmentId,
            creatorId,
            shareId,
            source,
            userAgent,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
        });
        return {
            success: true,
            guestParticipantId: docRef.id,
            message: 'Guest acceptance tracked successfully'
        };
    }
    catch (error) {
        console.error('Error tracking guest acceptance:', error);
        throw new functions.https.HttpsError('internal', 'Failed to track guest acceptance');
    }
});
exports.convertGuestToRegistered = functions.https.onCall(async (request, context) => {
    try {
        const { guestParticipantId, userId, appointmentId } = request.data;
        if (!guestParticipantId || !userId || !appointmentId) {
            throw new functions.https.HttpsError('invalid-argument', 'Missing required fields: guestParticipantId, userId, appointmentId');
        }
        // Get guest participant record
        const guestDoc = await db.collection('guest_participants')
            .doc(guestParticipantId)
            .get();
        if (!guestDoc.exists) {
            throw new functions.https.HttpsError('not-found', 'Guest participant not found');
        }
        const guestData = guestDoc.data();
        // Create regular invite for the user
        const invite = {
            appointmentId,
            inviteeId: userId,
            status: 'accepted',
            requiresInstallFallback: false,
            source: guestData.source,
            shareId: guestData.shareId,
            convertedFromGuest: true,
            originalGuestId: guestParticipantId,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
        };
        await db.collection('invites').add(invite);
        // Update guest participant status
        await guestDoc.ref.update({
            status: 'converted_to_registered',
            convertedAt: admin.firestore.FieldValue.serverTimestamp(),
            registeredUserId: userId,
        });
        // Log conversion event
        await db.collection('analytics_events').add({
            event: 'guest_converted_to_registered',
            appointmentId,
            guestParticipantId,
            userId,
            source: guestData.source,
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
        });
        return {
            success: true,
            message: 'Guest successfully converted to registered user'
        };
    }
    catch (error) {
        console.error('Error converting guest to registered:', error);
        throw new functions.https.HttpsError('internal', 'Failed to convert guest to registered user');
    }
});
exports.getGuestParticipants = functions.https.onCall(async (request, context) => {
    try {
        const { appointmentId } = request.data;
        if (!appointmentId) {
            throw new functions.https.HttpsError('invalid-argument', 'Missing required field: appointmentId');
        }
        const snapshot = await db.collection('guest_participants')
            .where('appointmentId', '==', appointmentId)
            .get();
        const guests = snapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data()
        }));
        return {
            success: true,
            guests,
            count: guests.length
        };
    }
    catch (error) {
        console.error('Error getting guest participants:', error);
        throw new functions.https.HttpsError('internal', 'Failed to get guest participants');
    }
});
/**
 * Clean up expired guest participants
 * Runs daily to remove guest records older than 30 days
 */
// Temporarily comment out the pubsub function until we can properly configure it
// export const cleanupExpiredGuests = functions.pubsub
//   .schedule('every 24 hours')
//   .onRun(async (context: any) => {
//     try {
//         const thirtyDaysAgo = new Date();
//         thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
// 
//         const snapshot = await db.collection('guest_participants')
//             .where('acceptedAt', '<', admin.firestore.Timestamp.fromDate(thirtyDaysAgo))
//             .where('status', '==', 'pending_app_install')
//             .get();
// 
//         const batch = db.batch();
//         let deletedCount = 0;
// 
//         snapshot.docs.forEach(doc => {
//             batch.delete(doc.ref);
//             deletedCount++;
//         });
// 
//         if (deletedCount > 0) {
//             await batch.commit();
//             console.log(`Cleaned up ${deletedCount} expired guest participants`);
//         }
// 
//         return { success: true, deletedCount };
//     } catch (error) {
//         console.error('Error cleaning up expired guests:', error);
//         throw error;
//     }
// }); 
