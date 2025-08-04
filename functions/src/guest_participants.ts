import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

// Initialize Firebase Admin
admin.initializeApp();

const db = admin.firestore();

/**
 * Track guest participant acceptance
 * Triggered when a guest accepts an invitation via web
 */
export const trackGuestAcceptance = functions.https.onCall(async (data, context) => {
    try {
        const { appointmentId, creatorId, shareId, source, userAgent } = data;

        if (!appointmentId || !creatorId) {
            throw new functions.https.HttpsError(
                'invalid-argument',
                'Missing required fields: appointmentId, creatorId'
            );
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
    } catch (error) {
        console.error('Error tracking guest acceptance:', error);
        throw new functions.https.HttpsError(
            'internal',
            'Failed to track guest acceptance'
        );
    }
});

/**
 * Convert guest participant to registered user
 * Triggered when a guest installs the app and completes registration
 */
export const convertGuestToRegistered = functions.https.onCall(async (data, context) => {
    try {
        const { guestParticipantId, userId, appointmentId } = data;

        if (!guestParticipantId || !userId || !appointmentId) {
            throw new functions.https.HttpsError(
                'invalid-argument',
                'Missing required fields: guestParticipantId, userId, appointmentId'
            );
        }

        // Get guest participant record
        const guestDoc = await db.collection('guest_participants')
            .doc(guestParticipantId)
            .get();

        if (!guestDoc.exists) {
            throw new functions.https.HttpsError(
                'not-found',
                'Guest participant not found'
            );
        }

        const guestData = guestDoc.data()!;

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
    } catch (error) {
        console.error('Error converting guest to registered:', error);
        throw new functions.https.HttpsError(
            'internal',
            'Failed to convert guest to registered user'
        );
    }
});

/**
 * Get guest participants for an appointment
 */
export const getGuestParticipants = functions.https.onCall(async (data, context) => {
    try {
        const { appointmentId } = data;

        if (!appointmentId) {
            throw new functions.https.HttpsError(
                'invalid-argument',
                'Missing required field: appointmentId'
            );
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
    } catch (error) {
        console.error('Error getting guest participants:', error);
        throw new functions.https.HttpsError(
            'internal',
            'Failed to get guest participants'
        );
    }
});

/**
 * Clean up expired guest participants
 * Runs daily to remove guest records older than 30 days
 */
export const cleanupExpiredGuests = functions.pubsub.schedule('every 24 hours').onRun(async (context) => {
    try {
        const thirtyDaysAgo = new Date();
        thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

        const snapshot = await db.collection('guest_participants')
            .where('acceptedAt', '<', admin.firestore.Timestamp.fromDate(thirtyDaysAgo))
            .where('status', '==', 'pending_app_install')
            .get();

        const batch = db.batch();
        let deletedCount = 0;

        snapshot.docs.forEach(doc => {
            batch.delete(doc.ref);
            deletedCount++;
        });

        if (deletedCount > 0) {
            await batch.commit();
            console.log(`Cleaned up ${deletedCount} expired guest participants`);
        }

        return { success: true, deletedCount };
    } catch (error) {
        console.error('Error cleaning up expired guests:', error);
        throw error;
    }
}); 