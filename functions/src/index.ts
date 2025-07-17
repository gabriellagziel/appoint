import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import { validateInput, sendNotificationToStudioSchema } from './validation';

// Initialize Firebase Admin only once
if (!admin.apps.length) {
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
 * sendNotificationToStudio
 * Lightweight callable function that validates the payload and stores the
 * notification in Firestore for processing by FCM or other pipelines. The goal
 * here is mainly to satisfy integration tests which expect this export to be
 * present. Business-logic around actually dispatching the push will be handled
 * elsewhere in the stack.
 */
export const sendNotificationToStudio = functions.https.onCall(async (data, context) => {
  // Validate input
  const input = validateInput(sendNotificationToStudioSchema, data);

  const { studioId, title, body, data: extraData } = input;

  try {
    await admin.firestore().collection('studio_notifications').add({
      studioId,
      title,
      body,
      data: extraData ?? {},
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return { success: true };
  } catch (error: any) {
    console.error('Error storing studio notification:', error);
    throw new functions.https.HttpsError('internal', 'Failed to store notification');
  }
});
// Re-export for backward compatibility
export { ambassadorQuotas } from './ambassadors'; 