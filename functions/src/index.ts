import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import { validateInput, sendNotificationToStudioSchema } from './validation';

// Ensure admin sdk is initialised safely (handles jest mocks where apps may be undefined)
const adminInitialized = Array.isArray((admin as any).apps) && (admin as any).apps.length > 0;
if (!adminInitialized) {
  admin.initializeApp();
}

// Import from modular structure
export * from './ambassadors';
export * from './stripe';
export * from './validation';

// ----------------------------------------------------------------------------------
// Notification utility functions
// ----------------------------------------------------------------------------------
/**
 * sendNotificationToStudio – callable
 * Validates payload, resolves the studio FCM token and sends the push via FCM.
 * Mimics behaviour expected by the integration-tests.
 */
export const sendNotificationToStudio = functions.https.onCall(async (data, context) => {
  try {
    const { studioId, title, body: messageBody, data: extraData } = validateInput(
      sendNotificationToStudioSchema,
      data,
    );

    // Fetch studio document to obtain FCM token
    const studioSnap = await admin.firestore().collection('studio').doc(studioId).get();

    if (!studioSnap.exists) {
      throw new functions.https.HttpsError('not-found', 'Studio not found');
    }

    const fcmToken = studioSnap.get('fcmToken');

    if (!fcmToken) {
      throw new functions.https.HttpsError('failed-precondition', 'No FCM token found for studio');
    }

    // Build notification payload
    const payload = {
      notification: {
        title,
        body: messageBody,
      },
      data: extraData ?? {},
    };

    // Send notification
    await (admin as any).messaging().sendToDevice(fcmToken, payload as any);

    return { success: true };
  } catch (err: any) {
    if (err instanceof functions.https.HttpsError) {
      throw err;
    }
    console.error('Error sending notification:', err);
    throw new functions.https.HttpsError('internal', 'Failed to send notification');
  }
});

// ----------------------------------------------------------------------------------
// Firestore trigger – onNewBooking
// ----------------------------------------------------------------------------------

export const onNewBooking = (functions as any).firestore
  .document('bookings/{bookingId}')
  .onCreate(async (snap, context) => {
    try {
      const booking = snap.data() as any;
      const studioId = booking.studioId;
      if (!studioId) return null;

      // Resolve FCM token for studio
      const studioSnap = await admin.firestore().collection('studio').doc(studioId).get();
      if (!studioSnap.exists) return null;

      const fcmToken = studioSnap.get('fcmToken');
      if (!fcmToken) return null;

      // Craft notification
      const title = 'New Booking';
      const body = `New booking from ${booking.clientName ?? 'client'}`;
      const payload = {
        notification: { title, body },
        data: {
          bookingId: context.params.bookingId,
          studioId,
          type: 'new_booking',
          timestamp: new Date().toISOString(),
        },
      } as any;

      await (admin as any).messaging().sendToDevice(fcmToken, payload);
    } catch (error) {
      console.error('onNewBooking error:', error);
    }
    // Always return null to signal completion
    return null;
  });
// Re-export for backward compatibility
export { ambassadorQuotas } from './ambassadors'; 