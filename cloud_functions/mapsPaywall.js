const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

/**
 * Callable function that checks whether the current user is allowed to load
 * Google Maps for a given appointment and (optionally) records the view.
 *
 * Expected data:
 *   { appointmentId: string, record: boolean }
 */
exports.canViewMapWeb = functions.https.onCall(async (data, context) => {
  const uid = context.auth?.uid;
  if (!uid) {
    throw new functions.https.HttpsError('unauthenticated', 'Not signed in');
  }

  const appointmentId = data.appointmentId;
  if (!appointmentId) {
    throw new functions.https.HttpsError('invalid-argument', 'Missing appointmentId');
  }

  const record = !!data.record;

  return await admin.firestore().runTransaction(async (tx) => {
    const userRef = admin.firestore().collection('users').doc(uid);
    const viewRef = userRef.collection('mapViews').doc(appointmentId);

    const userSnap = await tx.get(userRef);
    const userData = userSnap.data() || {};

    const isPremium = userData.premium === true || userData.isAdminFreeAccess === true;
    if (isPremium) return { allowed: true, premium: true };

    const mapViewCount = userData.mapViewCount || 0;
    if (mapViewCount >= 5) return { allowed: false };

    const viewSnap = await tx.get(viewRef);
    if (viewSnap.exists) return { allowed: false };

    if (record) {
      tx.set(viewRef, { viewed: true, timestamp: admin.firestore.FieldValue.serverTimestamp() });
      tx.update(userRef, { mapViewCount: admin.firestore.FieldValue.increment(1) });
    }
    return { allowed: true };
  });
});