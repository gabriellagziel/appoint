import * as functions from 'firebase-functions/v1';
import * as admin from 'firebase-admin';

const db = admin.firestore();

// Complete ambassador quotas for all 50 countries and languages
// Total global slots: 6,675 ambassadors
export const ambassadorQuotas = {
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
  'CN_zh': 290,   // China - Chinese
  'IN_hi': 267,   // India - Hindi
  'IN_en': 89,    // India - English
  'JP_ja': 124,   // Japan - Japanese
  'KR_ko': 78,    // South Korea - Korean
  'ID_id': 86,    // Indonesia - Indonesian
  'TH_th': 64,    // Thailand - Thai
  'VN_vi': 68,    // Vietnam - Vietnamese
  'PH_en': 62,    // Philippines - English
  'MY_ms': 58,    // Malaysia - Malay
  'SG_en': 45,    // Singapore - English
  'TW_zh': 53,    // Taiwan - Chinese Traditional
  'HK_zh': 47,    // Hong Kong - Chinese Traditional
  'BD_bn': 71,    // Bangladesh - Bengali
  'PK_ur': 76,    // Pakistan - Urdu
  'IR_fa': 75,    // Iran - Persian
  'TR_tr': 79,    // Turkey - Turkish
  'SA_ar': 69,    // Saudi Arabia - Arabic
  'AE_ar': 48,    // UAE - Arabic
  'IL_he': 51,    // Israel - Hebrew

  // South America
  'BR_pt': 198,   // Brazil - Portuguese
  'AR_es': 92,    // Argentina - Spanish
  'CO_es': 84,    // Colombia - Spanish
  'PE_es': 73,    // Peru - Spanish
  'CL_es': 65,    // Chile - Spanish
  'VE_es': 71,    // Venezuela - Spanish
  'EC_es': 56,    // Ecuador - Spanish
  'UY_es': 48,    // Uruguay - Spanish

  // Africa
  'NG_en': 87,    // Nigeria - English
  'ZA_en': 63,    // South Africa - English
  'EG_ar': 74,    // Egypt - Arabic
  'KE_en': 55,    // Kenya - English
  'GH_en': 52,    // Ghana - English
  'ET_am': 61,    // Ethiopia - Amharic
  'TZ_sw': 49,    // Tanzania - Swahili
  'UG_en': 46,    // Uganda - English
  'ZW_en': 44,    // Zimbabwe - English
  'ZM_en': 43,    // Zambia - English
};

// Helper function to check if a country-language combination has available slots
async function hasAvailableSlots(countryCode: string, languageCode: string): Promise<boolean> {
  const key = `${countryCode}_${languageCode}`;
  const quota = ambassadorQuotas[key as keyof typeof ambassadorQuotas];
  if (!quota) return false;

  const snapshot = await db.collection('ambassadors')
    .where('countryCode', '==', countryCode)
    .where('languageCode', '==', languageCode)
    .where('status', '==', 'active')
    .get();

  return snapshot.size < quota;
}

// Helper function to check if a user is eligible for ambassadorship
async function isEligibleForAmbassadorship(userId: string, countryCode: string, languageCode: string): Promise<boolean> {
  // Check if user already has an ambassador role
  const existingAmbassador = await db.collection('ambassadors')
    .where('userId', '==', userId)
    .where('status', '==', 'active')
    .get();

  if (!existingAmbassador.empty) {
    return false;
  }

  // Add more eligibility criteria here (e.g., user stats, activity, etc.)
  // For now, we'll assume all users are eligible if they don't already have a role
  return true;
}

// Helper function to assign ambassador role
async function assignAmbassadorRole(userId: string, countryCode: string, languageCode: string): Promise<boolean> {
  try {
    const key = `${countryCode}_${languageCode}`;
    const quota = ambassadorQuotas[key as keyof typeof ambassadorQuotas];
    
    if (!quota) {
      console.log(`No quota defined for ${countryCode}_${languageCode}`);
      return false;
    }

    // Check eligibility
    const isEligible = await isEligibleForAmbassadorship(userId, countryCode, languageCode);
    if (!isEligible) {
      console.log(`User ${userId} is not eligible for ambassadorship`);
      return false;
    }

    // Check available slots
    const hasSlots = await hasAvailableSlots(countryCode, languageCode);
    if (!hasSlots) {
      console.log(`No available ambassador slots for ${countryCode}_${languageCode}`);
      return false;
    }

    // Use transaction to ensure consistency
    await db.runTransaction(async (transaction) => {
      // Double-check slot availability within transaction
      const currentSnapshot = await transaction.get(
        db.collection('ambassadors')
          .where('countryCode', '==', countryCode)
          .where('languageCode', '==', languageCode)
          .where('status', '==', 'active')
      );

      const currentCount = currentSnapshot.size;
      if (currentCount >= quota) {
        throw new Error(`No available slots for ${countryCode}_${languageCode}`);
      }

      // Update user document with ambassador role
      const userRef = db.collection('users').doc(userId);
      transaction.update(userRef, {
        isAmbassador: true,
        ambassadorCountry: countryCode,
        ambassadorLanguage: languageCode,
        ambassadorStatus: 'active',
        ambassadorAssignedAt: admin.firestore.FieldValue.serverTimestamp(),
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

// Auto-assign ambassadors for all available slots
async function autoAssignAvailableSlots(): Promise<number> {
  let assignedCount = 0;

  for (const [key, quota] of Object.entries(ambassadorQuotas)) {
    const parts = key.split('_');
    const countryCode = parts[0];
    const languageCode = parts[1];

    // Check if there are available slots
    const hasSlots = await hasAvailableSlots(countryCode, languageCode);
    if (!hasSlots) continue;

    // Find eligible users for this country-language combination
    const eligibleUsers = await db.collection('users')
      .where('countryCode', '==', countryCode)
      .where('preferredLanguage', '==', languageCode)
      .where('isAmbassador', '==', false)
      .limit(quota)
      .get();

    for (const userDoc of eligibleUsers.docs) {
      const userId = userDoc.id;
      const success = await assignAmbassadorRole(userId, countryCode, languageCode);
      if (success) {
        assignedCount++;
      }
    }
  }

  return assignedCount;
}

// HTTPS callable functions
export const autoAssignAmbassadors = functions.https.onRequest(async (req, res) => {
  try {
    const assignedCount = await autoAssignAvailableSlots();
    res.json({ success: true, assignedCount });
  } catch (error) {
    console.error('Error in autoAssignAmbassadors:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

export const getQuotaStats = functions.https.onRequest(async (req, res) => {
  try {
    const stats = {};
    
    for (const [key, quota] of Object.entries(ambassadorQuotas)) {
      const parts = key.split('_');
      const countryCode = parts[0];
      const languageCode = parts[1];

      const snapshot = await db.collection('ambassadors')
        .where('countryCode', '==', countryCode)
        .where('languageCode', '==', languageCode)
        .where('status', '==', 'active')
        .get();

      stats[key] = {
        quota: quota,
        assigned: snapshot.size,
        available: quota - snapshot.size,
      };
    }

    res.json(stats);
  } catch (error) {
    console.error('Error in getQuotaStats:', error);
    res.status(500).json({ error: error.message });
  }
});

export const assignAmbassador = functions.https.onRequest(async (req, res) => {
  try {
    const { userId, countryCode, languageCode } = req.body;

    if (!userId || !countryCode || !languageCode) {
      res.status(400).json({ error: 'Missing required parameters' });
      return;
    }

    const success = await assignAmbassadorRole(userId, countryCode, languageCode);
    
    if (success) {
      res.json({ success: true, message: 'Ambassador assigned successfully' });
    } else {
      res.status(400).json({ success: false, error: 'Failed to assign ambassador' });
    }
  } catch (error) {
    console.error('Error in assignAmbassador:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Scheduled functions
export const scheduledAutoAssign = functions.pubsub.schedule('every 1 hours').onRun(async (context) => {
  const assignedCount = await autoAssignAvailableSlots();
  console.log(`Scheduled auto-assignment completed. Assigned ${assignedCount} ambassadors.`);
  return null;
});

export const dailyQuotaReport = functions.pubsub.schedule('every 24 hours').onRun(async (context) => {
  // Generate daily report
  const reportData = {};
  
  for (const [key, quota] of Object.entries(ambassadorQuotas)) {
    const parts = key.split('_');
    const countryCode = parts[0];
    const languageCode = parts[1];

    const snapshot = await db.collection('ambassadors')
      .where('countryCode', '==', countryCode)
      .where('languageCode', '==', languageCode)
      .where('status', '==', 'active')
      .get();

    reportData[key] = {
      quota: quota,
      assigned: snapshot.size,
      available: quota - snapshot.size,
    };
  }

  // Store the report
  await db.collection('daily_quota_reports').add({
    reportData: reportData,
    generatedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  console.log('Daily quota report generated and stored.');
  return null;
});

// Firestore triggers
export const checkAmbassadorEligibility = functions.firestore
  .document('users/{userId}')
  .onUpdate(async (change, context) => {
    try {
      const userId = context.params.userId;
      const newValue = change.after.data();
      const previousValue = change.before.data();

      // Check if user became eligible for ambassadorship
      if (newValue.isAmbassador === false && previousValue.isAmbassador === false) {
        const countryCode = newValue.countryCode;
        const languageCode = newValue.preferredLanguage;

        if (countryCode && languageCode) {
          const hasSlots = await hasAvailableSlots(countryCode, languageCode);
          const isEligible = await isEligibleForAmbassadorship(userId, countryCode, languageCode);

          if (hasSlots && isEligible) {
            await assignAmbassadorRole(userId, countryCode, languageCode);
          }
        }
      }

      return null;
    } catch (error) {
      console.error('Error in checkAmbassadorEligibility:', error);
      return null;
    }
  });

export const handleAmbassadorRemoval = functions.firestore
  .document('users/{userId}')
  .onUpdate(async (change, context) => {
    try {
      const userId = context.params.userId;
      const newValue = change.after.data();
      const previousValue = change.before.data();

      // Check if user was removed from ambassador role
      if (previousValue.isAmbassador === true && newValue.isAmbassador === false) {
        const countryCode = previousValue.ambassadorCountry;
        const languageCode = previousValue.ambassadorLanguage;

        if (countryCode && languageCode) {
          // Update ambassador status to inactive
          await db.collection('ambassadors').doc(userId).update({
            status: 'inactive',
            removedAt: admin.firestore.FieldValue.serverTimestamp(),
          });

          // Log the slot being freed
          await db.collection('ambassador_removals').add({
            ambassadorId: userId,
            countryCode: countryCode,
            languageCode: languageCode,
            removedAt: admin.firestore.FieldValue.serverTimestamp(),
            reason: 'status_change_to_inactive',
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