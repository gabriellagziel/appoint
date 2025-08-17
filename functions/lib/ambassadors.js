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
exports.revokeAmbassadorReward = exports.awardAmbassadorReward = exports.getAmbassadorRewards = exports.flagAmbassador = exports.getAmbassadorPerformance = exports.updateAmbassadorSettings = exports.getAmbassadorDetails = exports.exportAmbassadorsToCSV = exports.getAmbassadorFraudLogs = exports.getAmbassadorTierUpgradeLogs = exports.getAmbassadorAutomationLogs = exports.sendAmbassadorMassMessage = exports.demoteAmbassador = exports.promoteAmbassadorTier = exports.getAmbassadorStats = exports.reviewAmbassadorFlag = exports.getAmbassadorFlags = exports.getPendingAmbassadors = exports.getAmbassadors = exports.handleAmbassadorRemoval = exports.checkAmbassadorEligibility = exports.dailyQuotaReport = exports.scheduledAutoAssign = exports.assignAmbassador = exports.getQuotaStats = exports.autoAssignAmbassadors = exports.ambassadorQuotas = void 0;
const admin = __importStar(require("firebase-admin"));
const firestore_1 = require("firebase-functions/v2/firestore");
const https_1 = require("firebase-functions/v2/https");
const scheduler_1 = require("firebase-functions/v2/scheduler");
const https_2 = require("firebase-functions/v2/https");
const db = admin.firestore();
// Complete ambassador quotas for all 50 countries and languages
// Total global slots: 6,675 ambassadors
exports.ambassadorQuotas = {
    // Europe
    'PL_pl': 95, // Poland - Polish
    'FR_fr': 142, // France - French
    'DE_de': 133, // Germany - German
    'ES_es': 220, // Spain - Spanish
    'IT_it': 144, // Italy - Italian
    'RU_ru': 111, // Russia - Russian
    'UA_uk': 70, // Ukraine - Ukrainian
    'RO_ro': 72, // Romania - Romanian
    'GR_el': 66, // Greece - Greek
    'NL_nl': 61, // Netherlands - Dutch
    'CZ_cs': 59, // Czech Republic - Czech
    'HU_hu': 57, // Hungary - Hungarian
    'BG_bg': 52, // Bulgaria - Bulgarian
    'HR_hr': 50, // Croatia - Croatian
    'SK_sk': 48, // Slovakia - Slovak
    'LV_lv': 42, // Latvia - Latvian
    'LT_lt': 41, // Lithuania - Lithuanian
    'RS_sr': 40, // Serbia - Serbian
    'FI_fi': 49, // Finland - Finnish
    'SE_sv': 67, // Sweden - Swedish
    'NO_no': 44, // Norway - Norwegian
    'DK_da': 43, // Denmark - Danish
    'SI_sl': 39, // Slovenia - Slovenian
    // North America
    'US_en': 345, // United States - English
    'CA_en': 54, // Canada - English
    'CA_fr': 46, // Canada - French
    'MX_es': 173, // Mexico - Spanish
    // Asia
    'CN_zh': 290, // China - Chinese
    'IN_hi': 267, // India - Hindi
    'IN_en': 89, // India - English
    'JP_ja': 124, // Japan - Japanese
    'KR_ko': 78, // South Korea - Korean
    'ID_id': 86, // Indonesia - Indonesian
    'TH_th': 64, // Thailand - Thai
    'VN_vi': 68, // Vietnam - Vietnamese
    'PH_en': 62, // Philippines - English
    'MY_ms': 58, // Malaysia - Malay
    'SG_en': 45, // Singapore - English
    'TW_zh': 53, // Taiwan - Chinese Traditional
    'HK_zh': 47, // Hong Kong - Chinese Traditional
    'BD_bn': 71, // Bangladesh - Bengali
    'PK_ur': 76, // Pakistan - Urdu
    'IR_fa': 75, // Iran - Persian
    'TR_tr': 79, // Turkey - Turkish
    'SA_ar': 69, // Saudi Arabia - Arabic
    'AE_ar': 48, // UAE - Arabic
    'IL_he': 51, // Israel - Hebrew
    // South America
    'BR_pt': 198, // Brazil - Portuguese
    'AR_es': 92, // Argentina - Spanish
    'CO_es': 84, // Colombia - Spanish
    'PE_es': 73, // Peru - Spanish
    'CL_es': 65, // Chile - Spanish
    'VE_es': 71, // Venezuela - Spanish
    'EC_es': 56, // Ecuador - Spanish
    'UY_es': 48, // Uruguay - Spanish
    // Africa
    'NG_en': 87, // Nigeria - English
    'ZA_en': 63, // South Africa - English
    'EG_ar': 74, // Egypt - Arabic
    'KE_en': 55, // Kenya - English
    'GH_en': 52, // Ghana - English
    'ET_am': 61, // Ethiopia - Amharic
    'TZ_sw': 49, // Tanzania - Swahili
    'UG_en': 46, // Uganda - English
    'ZW_en': 44, // Zimbabwe - English
    'ZM_en': 43, // Zambia - English
};
// Helper function to check if a country-language combination has available slots
async function hasAvailableSlots(countryCode, languageCode) {
    const key = `${countryCode}_${languageCode}`;
    const quota = exports.ambassadorQuotas[key];
    if (!quota)
        return false;
    const snapshot = await db.collection('ambassadors')
        .where('countryCode', '==', countryCode)
        .where('languageCode', '==', languageCode)
        .where('status', '==', 'active')
        .get();
    return snapshot.size < quota;
}
// Helper function to check if a user is eligible for ambassadorship
async function isEligibleForAmbassadorship(userId, countryCode, languageCode) {
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
async function assignAmbassadorRole(userId, countryCode, languageCode) {
    try {
        const key = `${countryCode}_${languageCode}`;
        const quota = exports.ambassadorQuotas[key];
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
            const currentSnapshot = await transaction.get(db.collection('ambassadors')
                .where('countryCode', '==', countryCode)
                .where('languageCode', '==', languageCode)
                .where('status', '==', 'active'));
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
    }
    catch (error) {
        console.error('Error assigning ambassador:', error);
        return false;
    }
}
// Auto-assign ambassadors for all available slots
async function autoAssignAvailableSlots() {
    let assignedCount = 0;
    for (const [key, quota] of Object.entries(exports.ambassadorQuotas)) {
        const parts = key.split('_');
        const countryCode = parts[0];
        const languageCode = parts[1];
        // Check if there are available slots
        const hasSlots = await hasAvailableSlots(countryCode, languageCode);
        if (!hasSlots)
            continue;
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
exports.autoAssignAmbassadors = (0, https_1.onRequest)(async (req, res) => {
    try {
        const assignedCount = await autoAssignAvailableSlots();
        res.json({ success: true, assignedCount });
    }
    catch (error) {
        console.error('Error in autoAssignAmbassadors:', error);
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : String(error) });
    }
});
exports.getQuotaStats = (0, https_1.onRequest)(async (req, res) => {
    try {
        const stats = {};
        for (const [key, quota] of Object.entries(exports.ambassadorQuotas)) {
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
    }
    catch (error) {
        console.error('Error in getQuotaStats:', error);
        res.status(500).json({ error: error instanceof Error ? error.message : String(error) });
    }
});
exports.assignAmbassador = (0, https_1.onRequest)(async (req, res) => {
    try {
        const { userId, countryCode, languageCode } = req.body;
        if (!userId || !countryCode || !languageCode) {
            res.status(400).json({ error: 'Missing required parameters' });
            return;
        }
        const success = await assignAmbassadorRole(userId, countryCode, languageCode);
        if (success) {
            res.json({ success: true, message: 'Ambassador assigned successfully' });
        }
        else {
            res.status(400).json({ success: false, error: 'Failed to assign ambassador' });
        }
    }
    catch (error) {
        console.error('Error in assignAmbassador:', error);
        res.status(500).json({ success: false, error: error instanceof Error ? error.message : String(error) });
    }
});
// Scheduled functions
exports.scheduledAutoAssign = (0, scheduler_1.onSchedule)('every 1 hours', async (event) => {
    const assignedCount = await autoAssignAvailableSlots();
    console.log(`Scheduled auto-assignment completed. Assigned ${assignedCount} ambassadors.`);
    return;
});
exports.dailyQuotaReport = (0, scheduler_1.onSchedule)('every 24 hours', async (event) => {
    // Generate daily report
    const reportData = {};
    for (const [key, quota] of Object.entries(exports.ambassadorQuotas)) {
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
    return;
});
// Firestore triggers
exports.checkAmbassadorEligibility = (0, firestore_1.onDocumentUpdated)('users/{userId}', async (event) => {
    try {
        const userId = event.params.userId;
        const newValue = event.data?.after?.data();
        const previousValue = event.data?.before?.data();
        // Check if user became eligible for ambassadorship
        if (newValue && previousValue && newValue.isAmbassador === false && previousValue.isAmbassador === false) {
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
        return;
    }
    catch (error) {
        console.error('Error in checkAmbassadorEligibility:', error);
        return;
    }
});
exports.handleAmbassadorRemoval = (0, firestore_1.onDocumentUpdated)('users/{userId}', async (event) => {
    try {
        const userId = event.params.userId;
        const newValue = event.data?.after?.data();
        const previousValue = event.data?.before?.data();
        // Check if user was removed from ambassador role
        if (newValue && previousValue && previousValue.isAmbassador === true && newValue.isAmbassador === false) {
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
        return;
    }
    catch (error) {
        console.error('Error in handleAmbassadorRemoval:', error);
        return;
    }
});
// Get all ambassadors with filters
exports.getAmbassadors = (0, https_2.onCall)(async (request) => {
    if (!request.auth) {
        throw new https_2.HttpsError('unauthenticated', 'User must be authenticated');
    }
    try {
        const { filters } = request.data;
        let query = db.collection('ambassador_profiles');
        if (filters?.status && filters.status !== 'all') {
            query = query.where('status', '==', filters.status);
        }
        if (filters?.tier && filters.tier !== 'all') {
            query = query.where('tier', '==', filters.tier);
        }
        if (filters?.country && filters.country !== 'all') {
            query = query.where('countryCode', '==', filters.country);
        }
        if (filters?.language && filters.language !== 'all') {
            query = query.where('languageCode', '==', filters.language);
        }
        const snapshot = await query.get();
        const ambassadors = [];
        for (const doc of snapshot.docs) {
            const data = doc.data();
            // Get user details
            const userDoc = await db.collection('users').doc(data.userId).get();
            const userData = userDoc.exists ? userDoc.data() : {};
            ambassadors.push({
                id: doc.id,
                userId: data.userId,
                name: userData.displayName || userData.email || 'Unknown',
                email: userData.email || '',
                country: data.countryCode,
                language: data.languageCode,
                status: data.status,
                tier: data.tier,
                referrals: data.totalReferrals || 0,
                monthlyReferrals: data.monthlyReferrals || 0,
                totalReferrals: data.totalReferrals || 0,
                joinedAt: data.assignedAt?.toDate?.()?.toISOString() || data.assignedAt,
                shareCode: data.shareCode,
                rejectionReason: data.rejectionReason,
            });
        }
        return ambassadors;
    }
    catch (error) {
        console.error('Error getting ambassadors:', error);
        throw new https_2.HttpsError('internal', 'Failed to get ambassadors');
    }
});
// Get pending ambassadors
exports.getPendingAmbassadors = (0, https_2.onCall)(async (request) => {
    if (!request.auth) {
        throw new https_2.HttpsError('unauthenticated', 'User must be authenticated');
    }
    try {
        const snapshot = await db.collection('ambassador_pending').get();
        const pendingAmbassadors = [];
        for (const doc of snapshot.docs) {
            const data = doc.data();
            // Get user details
            const userDoc = await db.collection('users').doc(data.userId).get();
            const userData = userDoc.exists ? userDoc.data() : {};
            pendingAmbassadors.push({
                userId: data.userId,
                name: userData.displayName || userData.email || 'Unknown',
                email: userData.email || '',
                country: data.countryCode,
                language: data.languageCode,
                referralCount: data.referralCount || 0,
                pendingSince: data.pendingSince?.toDate?.()?.toISOString() || data.pendingSince,
            });
        }
        return pendingAmbassadors;
    }
    catch (error) {
        console.error('Error getting pending ambassadors:', error);
        throw new https_2.HttpsError('internal', 'Failed to get pending ambassadors');
    }
});
// Get ambassador flags
exports.getAmbassadorFlags = (0, https_2.onCall)(async (request) => {
    if (!request.auth) {
        throw new https_2.HttpsError('unauthenticated', 'User must be authenticated');
    }
    try {
        const snapshot = await db.collection('ambassador_flags').get();
        const flags = [];
        for (const doc of snapshot.docs) {
            const data = doc.data();
            flags.push({
                userId: data.userId,
                flagType: data.flagType,
                reason: data.reason,
                flaggedAt: data.flaggedAt?.toDate?.()?.toISOString() || data.flaggedAt,
                reviewed: data.reviewed || false,
                reviewedBy: data.reviewedBy,
                reviewedAt: data.reviewedAt?.toDate?.()?.toISOString() || data.reviewedAt,
            });
        }
        return flags;
    }
    catch (error) {
        console.error('Error getting ambassador flags:', error);
        throw new https_2.HttpsError('internal', 'Failed to get ambassador flags');
    }
});
// Review ambassador flag
exports.reviewAmbassadorFlag = (0, https_2.onCall)(async (request) => {
    if (!request.auth) {
        throw new https_2.HttpsError('unauthenticated', 'User must be authenticated');
    }
    try {
        const { userId, reviewedBy } = request.data;
        if (!userId || !reviewedBy) {
            throw new https_2.HttpsError('invalid-argument', 'User ID and reviewer are required');
        }
        const now = admin.firestore.Timestamp.now();
        await db.collection('ambassador_flags')
            .where('userId', '==', userId)
            .where('reviewed', '==', false)
            .get()
            .then(snapshot => {
            const batch = db.batch();
            snapshot.docs.forEach(doc => {
                batch.update(doc.ref, {
                    reviewed: true,
                    reviewedBy: reviewedBy,
                    reviewedAt: now,
                });
            });
            return batch.commit();
        });
        return { success: true, message: 'Flag reviewed successfully' };
    }
    catch (error) {
        console.error('Error reviewing ambassador flag:', error);
        throw new https_2.HttpsError('internal', 'Failed to review flag');
    }
});
// Get ambassador statistics
exports.getAmbassadorStats = (0, https_2.onCall)(async (request) => {
    if (!request.auth) {
        throw new https_2.HttpsError('unauthenticated', 'User must be authenticated');
    }
    try {
        const [ambassadorsSnapshot, pendingSnapshot] = await Promise.all([
            db.collection('ambassador_profiles').get(),
            db.collection('ambassador_pending').get(),
        ]);
        const ambassadors = ambassadorsSnapshot.docs.map(doc => doc.data());
        const pending = pendingSnapshot.docs.map(doc => doc.data());
        const totalAmbassadors = ambassadors.length;
        const activeAmbassadors = ambassadors.filter(a => a.status === 'approved').length;
        const pendingAmbassadors = pending.length;
        const totalReferrals = ambassadors.reduce((sum, a) => sum + (a.totalReferrals || 0), 0);
        const monthlyReferrals = ambassadors.reduce((sum, a) => sum + (a.monthlyReferrals || 0), 0);
        const averageReferrals = totalAmbassadors > 0 ? totalReferrals / totalAmbassadors : 0;
        const tierDistribution = {
            basic: ambassadors.filter(a => a.tier === 'basic').length,
            premium: ambassadors.filter(a => a.tier === 'premium').length,
            lifetime: ambassadors.filter(a => a.tier === 'lifetime').length,
        };
        return {
            totalAmbassadors,
            activeAmbassadors,
            pendingAmbassadors,
            totalReferrals,
            monthlyReferrals,
            averageReferrals: Math.round(averageReferrals * 100) / 100,
            tierDistribution,
        };
    }
    catch (error) {
        console.error('Error getting ambassador stats:', error);
        throw new https_2.HttpsError('internal', 'Failed to get ambassador stats');
    }
});
// Promote ambassador tier
exports.promoteAmbassadorTier = (0, https_2.onCall)(async (request) => {
    if (!request.auth) {
        throw new https_2.HttpsError('unauthenticated', 'User must be authenticated');
    }
    try {
        const { userId, newTier } = request.data;
        if (!userId || !newTier) {
            throw new https_2.HttpsError('invalid-argument', 'User ID and new tier are required');
        }
        const validTiers = ['basic', 'premium', 'lifetime'];
        if (!validTiers.includes(newTier)) {
            throw new https_2.HttpsError('invalid-argument', 'Invalid tier');
        }
        await db.collection('ambassador_profiles').doc(userId).update({
            tier: newTier,
            tierChangedAt: admin.firestore.FieldValue.serverTimestamp(),
            lastActivityDate: admin.firestore.FieldValue.serverTimestamp(),
        });
        // Log tier upgrade
        await db.collection('ambassador_tier_upgrades').add({
            ambassadorId: userId,
            previousTier: 'manual_promotion',
            newTier: newTier,
            upgradedAt: admin.firestore.FieldValue.serverTimestamp(),
            upgradedBy: request.auth.uid,
            reason: 'Manual promotion by admin',
        });
        return { success: true, message: `Ambassador promoted to ${newTier} tier` };
    }
    catch (error) {
        console.error('Error promoting ambassador tier:', error);
        throw new https_2.HttpsError('internal', 'Failed to promote ambassador tier');
    }
});
// Demote ambassador
exports.demoteAmbassador = (0, https_2.onCall)(async (request) => {
    if (!request.auth) {
        throw new https_2.HttpsError('unauthenticated', 'User must be authenticated');
    }
    try {
        const { userId, reason } = request.data;
        if (!userId || !reason) {
            throw new https_2.HttpsError('invalid-argument', 'User ID and reason are required');
        }
        const now = admin.firestore.Timestamp.now();
        await db.runTransaction(async (transaction) => {
            // Update user status
            transaction.update(db.collection('users').doc(userId), {
                ambassadorStatus: 'inactive',
                role: 'client',
                ambassadorRemovedAt: now,
                updatedAt: now,
            });
            // Update ambassador profile
            transaction.update(db.collection('ambassador_profiles').doc(userId), {
                status: 'inactive',
                statusChangedAt: now,
                lastActivityDate: now,
            });
            // Log demotion
            transaction.set(db.collection('ambassador_demotions').doc(), {
                ambassadorId: userId,
                reason: reason,
                demotedAt: now,
                demotedBy: request.auth.uid,
            });
        });
        return { success: true, message: 'Ambassador demoted successfully' };
    }
    catch (error) {
        console.error('Error demoting ambassador:', error);
        throw new https_2.HttpsError('internal', 'Failed to demote ambassador');
    }
});
// Send mass message to ambassadors
exports.sendAmbassadorMassMessage = (0, https_2.onCall)(async (request) => {
    if (!request.auth) {
        throw new https_2.HttpsError('unauthenticated', 'User must be authenticated');
    }
    try {
        const { message, filters } = request.data;
        if (!message) {
            throw new https_2.HttpsError('invalid-argument', 'Message is required');
        }
        let query = db.collection('ambassador_profiles').where('status', '==', 'approved');
        if (filters?.tier && filters.tier !== 'all') {
            query = query.where('tier', '==', filters.tier);
        }
        if (filters?.country && filters.country !== 'all') {
            query = query.where('countryCode', '==', filters.country);
        }
        const snapshot = await query.get();
        const userIds = snapshot.docs.map(doc => doc.data().userId);
        // Create notifications for all ambassadors
        const batch = db.batch();
        userIds.forEach(userId => {
            const notificationRef = db.collection('notifications').doc();
            batch.set(notificationRef, {
                userId: userId,
                type: 'admin_message',
                title: 'Admin Message',
                body: message,
                createdAt: admin.firestore.FieldValue.serverTimestamp(),
                read: false,
            });
        });
        await batch.commit();
        return {
            success: true,
            message: `Message sent to ${userIds.length} ambassadors`
        };
    }
    catch (error) {
        console.error('Error sending mass message:', error);
        throw new https_2.HttpsError('internal', 'Failed to send mass message');
    }
});
// Get automation logs
exports.getAmbassadorAutomationLogs = (0, https_2.onCall)(async (request) => {
    if (!request.auth) {
        throw new https_2.HttpsError('unauthenticated', 'User must be authenticated');
    }
    try {
        const { limit = 100 } = request.data;
        const snapshot = await db.collection('ambassador_automation_logs')
            .orderBy('timestamp', 'desc')
            .limit(limit)
            .get();
        return snapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data(),
            timestamp: doc.data().timestamp?.toDate?.()?.toISOString() || doc.data().timestamp,
        }));
    }
    catch (error) {
        console.error('Error getting automation logs:', error);
        throw new https_2.HttpsError('internal', 'Failed to get automation logs');
    }
});
// Get tier upgrade logs
exports.getAmbassadorTierUpgradeLogs = (0, https_2.onCall)(async (request) => {
    if (!request.auth) {
        throw new https_2.HttpsError('unauthenticated', 'User must be authenticated');
    }
    try {
        const { limit = 100 } = request.data;
        const snapshot = await db.collection('ambassador_tier_upgrades')
            .orderBy('upgradedAt', 'desc')
            .limit(limit)
            .get();
        return snapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data(),
            upgradedAt: doc.data().upgradedAt?.toDate?.()?.toISOString() || doc.data().upgradedAt,
        }));
    }
    catch (error) {
        console.error('Error getting tier upgrade logs:', error);
        throw new https_2.HttpsError('internal', 'Failed to get tier upgrade logs');
    }
});
// Get fraud logs
exports.getAmbassadorFraudLogs = (0, https_2.onCall)(async (request) => {
    if (!request.auth) {
        throw new https_2.HttpsError('unauthenticated', 'User must be authenticated');
    }
    try {
        const { limit = 100 } = request.data;
        const snapshot = await db.collection('ambassador_flags')
            .orderBy('flaggedAt', 'desc')
            .limit(limit)
            .get();
        return snapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data(),
            flaggedAt: doc.data().flaggedAt?.toDate?.()?.toISOString() || doc.data().flaggedAt,
            reviewedAt: doc.data().reviewedAt?.toDate?.()?.toISOString() || doc.data().reviewedAt,
        }));
    }
    catch (error) {
        console.error('Error getting fraud logs:', error);
        throw new https_2.HttpsError('internal', 'Failed to get fraud logs');
    }
});
// Export ambassadors to CSV
exports.exportAmbassadorsToCSV = (0, https_2.onCall)(async (request) => {
    if (!request.auth) {
        throw new https_2.HttpsError('unauthenticated', 'User must be authenticated');
    }
    try {
        const { filters } = request.data;
        let query = db.collection('ambassador_profiles');
        if (filters?.status && filters.status !== 'all') {
            query = query.where('status', '==', filters.status);
        }
        if (filters?.tier && filters.tier !== 'all') {
            query = query.where('tier', '==', filters.tier);
        }
        if (filters?.country && filters.country !== 'all') {
            query = query.where('countryCode', '==', filters.country);
        }
        if (filters?.language && filters.language !== 'all') {
            query = query.where('languageCode', '==', filters.language);
        }
        const snapshot = await query.get();
        const ambassadors = [];
        for (const doc of snapshot.docs) {
            const data = doc.data();
            // Get user details
            const userDoc = await db.collection('users').doc(data.userId).get();
            const userData = userDoc.exists ? userDoc.data() : {};
            ambassadors.push({
                name: userData.displayName || userData.email || 'Unknown',
                email: userData.email || '',
                country: data.countryCode,
                language: data.languageCode,
                status: data.status,
                tier: data.tier,
                totalReferrals: data.totalReferrals || 0,
                monthlyReferrals: data.monthlyReferrals || 0,
                joinedAt: data.assignedAt?.toDate?.()?.toISOString() || data.assignedAt,
                shareCode: data.shareCode,
            });
        }
        // Convert to CSV
        const headers = ['Name', 'Email', 'Country', 'Language', 'Status', 'Tier', 'Total Referrals', 'Monthly Referrals', 'Joined At', 'Share Code'];
        const csvRows = [headers.join(',')];
        ambassadors.forEach(ambassador => {
            const row = [
                ambassador.name,
                ambassador.email,
                ambassador.country,
                ambassador.language,
                ambassador.status,
                ambassador.tier,
                ambassador.totalReferrals,
                ambassador.monthlyReferrals,
                ambassador.joinedAt,
                ambassador.shareCode || '',
            ].map(field => `"${field}"`).join(',');
            csvRows.push(row);
        });
        return csvRows.join('\n');
    }
    catch (error) {
        console.error('Error exporting ambassadors:', error);
        throw new https_2.HttpsError('internal', 'Failed to export ambassadors');
    }
});
// Get ambassador details
exports.getAmbassadorDetails = (0, https_2.onCall)(async (request) => {
    if (!request.auth) {
        throw new https_2.HttpsError('unauthenticated', 'User must be authenticated');
    }
    try {
        const { userId } = request.data;
        if (!userId) {
            throw new https_2.HttpsError('invalid-argument', 'User ID is required');
        }
        const [profileDoc, userDoc] = await Promise.all([
            db.collection('ambassador_profiles').doc(userId).get(),
            db.collection('users').doc(userId).get(),
        ]);
        if (!profileDoc.exists) {
            throw new https_2.HttpsError('not-found', 'Ambassador profile not found');
        }
        const profile = profileDoc.data();
        const userData = userDoc.exists ? userDoc.data() : {};
        return {
            ...profile,
            name: userData.displayName || userData.email || 'Unknown',
            email: userData.email || '',
        };
    }
    catch (error) {
        console.error('Error getting ambassador details:', error);
        throw new https_2.HttpsError('internal', 'Failed to get ambassador details');
    }
});
// Update ambassador settings
exports.updateAmbassadorSettings = (0, https_2.onCall)(async (request) => {
    if (!request.auth) {
        throw new https_2.HttpsError('unauthenticated', 'User must be authenticated');
    }
    try {
        const { userId, settings } = request.data;
        if (!userId || !settings) {
            throw new https_2.HttpsError('invalid-argument', 'User ID and settings are required');
        }
        const updateData = {
            lastActivityDate: admin.firestore.FieldValue.serverTimestamp(),
        };
        if (settings.status) {
            updateData.status = settings.status;
            updateData.statusChangedAt = admin.firestore.FieldValue.serverTimestamp();
        }
        if (settings.tier) {
            updateData.tier = settings.tier;
            updateData.tierChangedAt = admin.firestore.FieldValue.serverTimestamp();
        }
        await db.collection('ambassador_profiles').doc(userId).update(updateData);
        return { success: true, message: 'Ambassador settings updated successfully' };
    }
    catch (error) {
        console.error('Error updating ambassador settings:', error);
        throw new https_2.HttpsError('internal', 'Failed to update ambassador settings');
    }
});
// Get ambassador performance
exports.getAmbassadorPerformance = (0, https_2.onCall)(async (request) => {
    if (!request.auth) {
        throw new https_2.HttpsError('unauthenticated', 'User must be authenticated');
    }
    try {
        const { userId } = request.data;
        if (!userId) {
            throw new https_2.HttpsError('invalid-argument', 'User ID is required');
        }
        const [profileDoc, referralsSnapshot] = await Promise.all([
            db.collection('ambassador_profiles').doc(userId).get(),
            db.collection('ambassador_referrals')
                .where('ambassadorId', '==', userId)
                .where('isActive', '==', true)
                .get(),
        ]);
        if (!profileDoc.exists) {
            throw new https_2.HttpsError('not-found', 'Ambassador profile not found');
        }
        const profile = profileDoc.data();
        const referrals = referralsSnapshot.docs.map(doc => doc.data());
        // Calculate performance metrics
        const totalReferrals = referrals.length;
        const monthlyReferrals = profile.monthlyReferrals || 0;
        const conversionRate = totalReferrals > 0 ? (monthlyReferrals / totalReferrals) * 100 : 0;
        const averageReferralsPerMonth = totalReferrals > 0 ? totalReferrals / 12 : 0;
        // Calculate tier progress
        const currentTier = profile.tier;
        let required = 0;
        switch (currentTier) {
            case 'basic':
                required = 50; // Premium tier
                break;
            case 'premium':
                required = 1000; // Lifetime tier
                break;
            default:
                required = 0;
        }
        const tierProgress = {
            current: totalReferrals,
            required: required,
            progress: required > 0 ? Math.min((totalReferrals / required) * 100, 100) : 100,
        };
        return {
            totalReferrals,
            monthlyReferrals,
            conversionRate: Math.round(conversionRate * 100) / 100,
            averageReferralsPerMonth: Math.round(averageReferralsPerMonth * 100) / 100,
            tierProgress,
        };
    }
    catch (error) {
        console.error('Error getting ambassador performance:', error);
        throw new https_2.HttpsError('internal', 'Failed to get ambassador performance');
    }
});
// Flag ambassador for review
exports.flagAmbassador = (0, https_2.onCall)(async (request) => {
    if (!request.auth) {
        throw new https_2.HttpsError('unauthenticated', 'User must be authenticated');
    }
    try {
        const { userId, flagType, reason } = request.data;
        if (!userId || !flagType || !reason) {
            throw new https_2.HttpsError('invalid-argument', 'User ID, flag type, and reason are required');
        }
        const now = admin.firestore.Timestamp.now();
        await db.collection('ambassador_flags').add({
            userId: userId,
            flagType: flagType,
            reason: reason,
            flaggedAt: now,
            reviewed: false,
            flaggedBy: request.auth.uid,
        });
        return { success: true, message: 'Ambassador flagged for review' };
    }
    catch (error) {
        console.error('Error flagging ambassador:', error);
        throw new https_2.HttpsError('internal', 'Failed to flag ambassador');
    }
});
// Get ambassador rewards
exports.getAmbassadorRewards = (0, https_2.onCall)(async (request) => {
    if (!request.auth) {
        throw new https_2.HttpsError('unauthenticated', 'User must be authenticated');
    }
    try {
        const { userId } = request.data;
        if (!userId) {
            throw new https_2.HttpsError('invalid-argument', 'User ID is required');
        }
        const snapshot = await db.collection('ambassador_rewards')
            .where('ambassadorId', '==', userId)
            .orderBy('earnedAt', 'desc')
            .get();
        return snapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data(),
            earnedAt: doc.data().earnedAt?.toDate?.()?.toISOString() || doc.data().earnedAt,
            expiresAt: doc.data().expiresAt?.toDate?.()?.toISOString() || doc.data().expiresAt,
        }));
    }
    catch (error) {
        console.error('Error getting ambassador rewards:', error);
        throw new https_2.HttpsError('internal', 'Failed to get ambassador rewards');
    }
});
// Award reward to ambassador
exports.awardAmbassadorReward = (0, https_2.onCall)(async (request) => {
    if (!request.auth) {
        throw new https_2.HttpsError('unauthenticated', 'User must be authenticated');
    }
    try {
        const { userId, rewardType, description } = request.data;
        if (!userId || !rewardType) {
            throw new https_2.HttpsError('invalid-argument', 'User ID and reward type are required');
        }
        const now = admin.firestore.Timestamp.now();
        const rewardId = `${userId}_${rewardType}_${Date.now()}`;
        await db.collection('ambassador_rewards').doc(rewardId).set({
            id: rewardId,
            ambassadorId: userId,
            type: rewardType,
            tier: 'basic',
            earnedAt: now,
            expiresAt: admin.firestore.Timestamp.fromDate(new Date(2099, 11, 31)),
            isActive: true,
            description: description || `Manual reward: ${rewardType}`,
            awardedBy: request.auth.uid,
        });
        return { success: true, message: 'Reward awarded successfully' };
    }
    catch (error) {
        console.error('Error awarding reward:', error);
        throw new https_2.HttpsError('internal', 'Failed to award reward');
    }
});
// Revoke ambassador reward
exports.revokeAmbassadorReward = (0, https_2.onCall)(async (request) => {
    if (!request.auth) {
        throw new https_2.HttpsError('unauthenticated', 'User must be authenticated');
    }
    try {
        const { userId, rewardId } = request.data;
        if (!userId || !rewardId) {
            throw new https_2.HttpsError('invalid-argument', 'User ID and reward ID are required');
        }
        await db.collection('ambassador_rewards').doc(rewardId).update({
            isActive: false,
            revokedAt: admin.firestore.FieldValue.serverTimestamp(),
            revokedBy: request.auth.uid,
        });
        return { success: true, message: 'Reward revoked successfully' };
    }
    catch (error) {
        console.error('Error revoking reward:', error);
        throw new https_2.HttpsError('internal', 'Failed to revoke reward');
    }
});
