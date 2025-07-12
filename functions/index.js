const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { validate, schemas } = require('./test/validation-schemas');

// Detect Firebase environment
const isFirebase = !!process.env.FUNCTIONS_EMULATOR || !!process.env.K_SERVICE || !!process.env.FIREBASE_CONFIG;

// Initialize Firebase Admin
admin.initializeApp();

// Initialize Express for DigitalOcean
const express = require('express');
const app = express();

const db = admin.firestore();

// Complete ambassador quotas for all 50 countries and languages
// Total global slots: 6,675 ambassadors
const ambassadorQuotas = {
  // Europe
  'PL_pl': 95,    // Poland - Polish
  'FR_fr': 142,   // France - French
  'DE_de': 133,   // Germany - German
  'ES_es': 220,   // Spain - Spanish
  'IT_it': 144,   // Italy - Italian
  'RU_ru': 111,   // Russia - Russian
  'UA_uk': 70,    // Ukraine - Ukrainian
  'RO_ro': 72,    // Romania - Romanian
  'GR_el': 66,    // Greece - Greek
  'NL_nl': 61,    // Netherlands - Dutch
  'CZ_cs': 59,    // Czech Republic - Czech
  'HU_hu': 57,    // Hungary - Hungarian
  'BG_bg': 52,    // Bulgaria - Bulgarian
  'HR_hr': 50,    // Croatia - Croatian
  'SK_sk': 48,    // Slovakia - Slovak
  'LV_lv': 42,    // Latvia - Latvian
  'LT_lt': 41,    // Lithuania - Lithuanian
  'RS_sr': 40,    // Serbia - Serbian
  'FI_fi': 49,    // Finland - Finnish
  'SE_sv': 67,    // Sweden - Swedish
  'NO_no': 44,    // Norway - Norwegian
  'DK_da': 43,    // Denmark - Danish
  'SI_sl': 39,    // Slovenia - Slovenian

  // North America
  'US_en': 345,   // United States - English
  'CA_en': 54,    // Canada - English
  'CA_fr': 46,    // Canada - French
  'MX_es': 173,   // Mexico - Spanish

  // Asia
  'JP_ja': 116,   // Japan - Japanese
  'KR_ko': 98,    // South Korea - Korean
  'CN_zh': 400,   // China - Chinese
  'IN_hi': 200,   // India - Hindi
  'IN_ta': 84,    // India - Tamil
  'IN_gu': 63,    // India - Gujarati
  'PH_tl': 103,   // Philippines - Tagalog
  'PK_ur': 125,   // Pakistan - Urdu
  'BD_bn': 122,   // Bangladesh - Bengali
  'VN_vi': 106,   // Vietnam - Vietnamese
  'TR_tr': 101,   // Turkey - Turkish
  'IR_fa': 77,    // Iran - Persian
  'TH_th': 64,    // Thailand - Thai
  'ID_id': 88,    // Indonesia - Indonesian
  'MY_ms': 60,    // Malaysia - Malay
  'LK_si': 39,    // Sri Lanka - Sinhala
  'NP_ne': 38,    // Nepal - Nepali

  // South America
  'BR_pt': 215,   // Brazil - Portuguese

  // Africa
  'NG_en': 135,   // Nigeria - English
  'NG_ha': 45,    // Nigeria - Hausa
  'ET_am': 56,    // Ethiopia - Amharic
  'KE_sw': 53,    // Kenya - Swahili
  'ZA_zu': 36,    // South Africa - Zulu
};

/**
 * Get current ambassador count for a country-language combination
 */
async function getCurrentAmbassadorCount(countryCode, languageCode) {
  try {
    const snapshot = await db
      .collection('ambassadors')
      .where('countryCode', '==', countryCode)
      .where('languageCode', '==', languageCode)
      .where('status', '==', 'active')
      .get();

    return snapshot.size;
  } catch (error) {
    console.error('Error getting ambassador count:', error);
    return 0;
  }
}

/**
 * Check if there are available slots for a country-language combination
 */
async function hasAvailableSlots(countryCode, languageCode) {
  const key = `${countryCode}_${languageCode}`;
  const quota = ambassadorQuotas[key] || 0;
  if (quota === 0) return false;

  const currentCount = await getCurrentAmbassadorCount(countryCode, languageCode);
  return currentCount < quota;
}

/**
 * Check if a user is eligible to become an ambassador
 */
async function isUserEligible(userId) {
  try {
    const userDoc = await db.collection('users').doc(userId).get();
    if (!userDoc.exists) return false;

    const userData = userDoc.data();
    if (!userData) return false;

    // Check if user is an adult
    const isAdult = userData.isAdult === true;
    if (!isAdult) return false;

    // Check if user is not already an ambassador
    const currentRole = userData.role;
    if (currentRole === 'ambassador') return false;

    return true;
  } catch (error) {
    console.error('Error checking user eligibility:', error);
    return false;
  }
}

/**
 * Find next eligible user for ambassadorship in a specific country-language
 */
async function findNextEligibleUser(countryCode, languageCode) {
  try {
    // Query for eligible users in the specified country
    const usersSnapshot = await db
      .collection('users')
      .where('countryCode', '==', countryCode)
      .where('isAdult', '==', true)
      .where('role', '!=', 'ambassador')
      .orderBy('role')
      .orderBy('createdAt', 'asc') // First come, first served
      .limit(1)
      .get();

    if (usersSnapshot.empty) return null;

    return usersSnapshot.docs[0].id;
  } catch (error) {
    console.error('Error finding eligible user:', error);
    return null;
  }
}

/**
 * Automatically assign ambassador role to eligible user
 */
async function assignAmbassador(userId, countryCode, languageCode) {
  try {
    // Check if user is eligible
    const isEligible = await isUserEligible(userId);
    if (!isEligible) {
      console.log(`User ${userId} is not eligible for ambassadorship`);
      return false;
    }

    // Check if there are available slots
    const hasSlots = await hasAvailableSlots(countryCode, languageCode);
    if (!hasSlots) {
      console.log(`No available ambassador slots for ${countryCode}_${languageCode}`);
      return false;
    }

    // Use a transaction to ensure atomicity
    await db.runTransaction(async (transaction) => {
      // Double-check availability within transaction
      const currentCount = await getCurrentAmbassadorCount(countryCode, languageCode);
      const key = `${countryCode}_${languageCode}`;
      const quota = ambassadorQuotas[key] || 0;

      if (currentCount >= quota) {
        throw new Error('Quota exceeded during transaction');
      }

      // Update user role
      const userRef = db.collection('users').doc(userId);
      transaction.update(userRef, {
        role: 'ambassador',
        ambassadorSince: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      // Create ambassador record
      const ambassadorRef = db.collection('ambassadors').doc(userId);
      transaction.set(ambassadorRef, {
        userId: userId,
        countryCode: countryCode,
        languageCode: languageCode,
        status: 'active',
        assignedAt: admin.firestore.FieldValue.serverTimestamp(),
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        referrals: 0,
        totalEarnings: 0,
      });

      // Log the assignment
      const logRef = db.collection('ambassador_assignments').doc();
      transaction.set(logRef, {
        userId: userId,
        countryCode: countryCode,
        languageCode: languageCode,
        assignedAt: admin.firestore.FieldValue.serverTimestamp(),
        quotaBefore: currentCount,
        quotaAfter: currentCount + 1,
        totalQuota: quota,
      });
    });

    console.log(`Successfully assigned ambassador role to user ${userId} for ${countryCode}_${languageCode}`);
    return true;
  } catch (error) {
    console.error('Error assigning ambassador:', error);
    return false;
  }
}

/**
 * Auto-assign ambassadors for all available slots
 * This function can be called manually or scheduled
 */
async function autoAssignAvailableSlots() {
  let assignedCount = 0;

  for (const [key, quota] of Object.entries(ambassadorQuotas)) {
    const parts = key.split('_');
    const countryCode = parts[0];
    const languageCode = parts[1];

    // Check if there are available slots
    const hasSlots = await hasAvailableSlots(countryCode, languageCode);
    if (!hasSlots) continue;

    // Find eligible user
    const eligibleUserId = await findNextEligibleUser(countryCode, languageCode);
    if (!eligibleUserId) continue;

    // Assign ambassador role
    const success = await assignAmbassador(eligibleUserId, countryCode, languageCode);

    if (success) {
      assignedCount++;
    }
  }

  return assignedCount;
}

/**
 * Get quota statistics for all countries and languages
 */
async function getQuotaStatistics() {
  const stats = {};

  for (const [key, quota] of Object.entries(ambassadorQuotas)) {
    const parts = key.split('_');
    const countryCode = parts[0];
    const languageCode = parts[1];

    const currentCount = await getCurrentAmbassadorCount(countryCode, languageCode);
    const availableSlots = quota - currentCount;

    stats[key] = {
      countryCode: countryCode,
      languageCode: languageCode,
      quota: quota,
      currentCount: currentCount,
      availableSlots: availableSlots,
      utilizationPercentage: Math.round((currentCount / quota) * 100),
    };
  }

  return stats;
}

/**
 * Get total global statistics
 */
async function getGlobalStatistics() {
  const totalQuota = Object.values(ambassadorQuotas).reduce((sum, quota) => sum + quota, 0);
  let totalCurrent = 0;

  for (const [key] of Object.entries(ambassadorQuotas)) {
    const parts = key.split('_');
    const currentCount = await getCurrentAmbassadorCount(parts[0], parts[1]);
    totalCurrent += currentCount;
  }

  return {
    totalQuota: totalQuota,
    totalCurrent: totalCurrent,
    totalAvailable: totalQuota - totalCurrent,
    globalUtilizationPercentage: Math.round((totalCurrent / totalQuota) * 100),
  };
}

// HTTP Functions

/**
 * Manual trigger for auto-assigning ambassadors
 */
exports.autoAssignAmbassadors = functions.https.onRequest(async (req, res) => {
  try {
    const assignedCount = await autoAssignAvailableSlots();
    res.json({
      success: true,
      assignedCount: assignedCount,
      message: `Successfully assigned ${assignedCount} ambassadors`
    });
  } catch (error) {
    console.error('Error in autoAssignAmbassadors:', error);
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

/**
 * Get quota statistics
 */
exports.getQuotaStats = functions.https.onRequest(async (req, res) => {
  try {
    const stats = await getQuotaStatistics();
    const globalStats = await getGlobalStatistics();

    res.json({
      success: true,
      globalStats: globalStats,
      countryStats: stats
    });
  } catch (error) {
    console.error('Error in getQuotaStats:', error);
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

/**
 * Manually assign ambassador to specific user
 */
exports.assignAmbassador = functions.https.onRequest(async (req, res) => {
  try {
    // Validate input data
    const validatedData = validate(schemas.assignAmbassador, req.body);
    const { userId, countryCode, languageCode } = validatedData;

    const success = await assignAmbassador(userId, countryCode, languageCode);

    res.json({
      success: success,
      message: success ? 'Ambassador assigned successfully' : 'Failed to assign ambassador'
    });
  } catch (error) {
    console.error('Error in assignAmbassador:', error);

    // Handle validation errors
    if (error.code === 'invalid-argument') {
      res.status(400).json({
        success: false,
        error: error.message,
        field: error.details?.field
      });
    } else {
      res.status(500).json({
        success: false,
        error: error.message
      });
    }
  }
});

// Scheduled Functions

/**
 * Scheduled function to auto-assign ambassadors every hour
 */
if (isFirebase && functions.pubsub && typeof functions.pubsub.schedule === 'function') {
  exports.scheduledAutoAssign = functions.pubsub.schedule('every 1 hours').onRun(async (context) => {
    try {
      const assignedCount = await autoAssignAvailableSlots();
      console.log(`Scheduled auto-assignment completed. Assigned ${assignedCount} ambassadors.`);
      return null;
    } catch (error) {
      console.error('Error in scheduled auto-assignment:', error);
      return null;
    }
  });

  /**
   * Daily quota statistics report
   */
  exports.dailyQuotaReport = functions.pubsub.schedule('every 24 hours').onRun(async (context) => {
    try {
      const globalStats = await getGlobalStatistics();
      const stats = await getQuotaStatistics();

      // Store daily report
      await db.collection('quota_reports').add({
        date: admin.firestore.FieldValue.serverTimestamp(),
        globalStats: globalStats,
        countryStats: stats,
        reportType: 'daily'
      });

      console.log('Daily quota report generated and stored.');
      return null;
    } catch (error) {
      console.error('Error generating daily quota report:', error);
      return null;
    }
  });
} else {
  console.log('Skipping Pub/Sub schedules in non-Firebase environment');
}

// Firestore Triggers

/**
 * Trigger when a user document is created/updated to check for ambassador eligibility
 */
if (isFirebase && functions.firestore && typeof functions.firestore.document === 'function') {
  exports.checkAmbassadorEligibility = functions.firestore
    .document('users/{userId}')
    .onWrite(async (change, context) => {
      try {
        const userId = context.params.userId;
        const newData = change.after.data();
        const previousData = change.before.data();

        // Only proceed if this is a new user or if relevant fields changed
        if (!newData) return null;

        const isNewUser = !previousData;
        const roleChanged = isNewUser || previousData.role !== newData.role;
        const adultStatusChanged = isNewUser || previousData.isAdult !== newData.isAdult;

        if (!roleChanged && !adultStatusChanged) return null;

        // Check if user is now eligible for ambassadorship
        const isEligible = await isUserEligible(userId);
        if (!isEligible) return null;

        // Get user's country and language
        const countryCode = newData.countryCode;
        const languageCode = newData.languageCode;

        if (!countryCode || !languageCode) return null;

        // Check if there are available slots
        const hasSlots = await hasAvailableSlots(countryCode, languageCode);
        if (!hasSlots) return null;

        // Auto-assign ambassador role
        await assignAmbassador(userId, countryCode, languageCode);

        return null;
      } catch (error) {
        console.error('Error in checkAmbassadorEligibility:', error);
        return null;
      }
    });

  /**
   * Trigger when an ambassador becomes inactive to free up slot
   */
  exports.handleAmbassadorRemoval = functions.firestore
    .document('ambassadors/{ambassadorId}')
    .onUpdate(async (change, context) => {
      try {
        const ambassadorId = context.params.ambassadorId;
        const newData = change.after.data();
        const previousData = change.before.data();

        // Check if ambassador status changed to inactive
        if (previousData.status === 'active' && newData.status === 'inactive') {
          const countryCode = newData.countryCode;
          const languageCode = newData.languageCode;

          if (countryCode && languageCode) {
            // Log the slot being freed
            await db.collection('ambassador_removals').add({
              ambassadorId: ambassadorId,
              countryCode: countryCode,
              languageCode: languageCode,
              removedAt: admin.firestore.FieldValue.serverTimestamp(),
              reason: 'status_change_to_inactive'
            });

            console.log(`Ambassador slot freed for ${countryCode}_${languageCode}`);
          }
        }

        return null;
      } catch (error) {
        console.error('Error in handleAmbassadorRemoval:', error);
        return null;
      }
    });
} else {
  console.log('Skipping Firestore triggers in non-Firebase environment');
}

// Export the quota data for reference
exports.ambassadorQuotas = ambassadorQuotas;

// Express routes for DigitalOcean
app.get('/', (req, res) => {
  res.json({
    message: 'APP-OINT API is running!',
    status: 'active',
    timestamp: new Date().toISOString()
  });
});

app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    timestamp: new Date().toISOString()
  });
});

// Export Express app for DigitalOcean
if (!isFirebase) {
  const PORT = process.env.PORT || 8080;
  app.listen(PORT, () => {
    console.log(`Server listening on port ${PORT}`);
  });
}

// Export for Firebase Functions
exports.app = functions.https.onRequest(app); 