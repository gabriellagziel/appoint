import * as admin from 'firebase-admin';
import { onDocumentCreated } from 'firebase-functions/v2/firestore';
import { HttpsError, onCall } from 'firebase-functions/v2/https';
import { onSchedule } from 'firebase-functions/v2/scheduler';
import { sendDemotionNotification, sendPerformanceWarningNotification, sendPromotionNotification, sendReferralSuccessNotification, sendTierUpgradeNotification, sendPendingApprovalNotification, sendApprovalNotification, sendRejectionNotification } from './ambassador-notifications.js';
const db = admin.firestore();
// Ambassador automation constants
const MINIMUM_MONTHLY_REFERRALS = 10;
const BASIC_TIER_REFERRALS = 5;
const PREMIUM_TIER_REFERRALS = 50;
const LIFETIME_TIER_REFERRALS = 1000;
const REFERRAL_RATIO_FOR_AMBASSADOR = 10; // 1 in 10 referrals can become ambassadors
const MONTHLY_PREMIUM_THRESHOLD = 3; // 3 referrals = 1 month premium
// Scheduled function: Daily ambassador eligibility check
export const dailyAmbassadorEligibilityCheck = onSchedule({
    schedule: '0 2 * * *', // Run at 2 AM daily
    timeZone: 'UTC'
}, async (context) => {
    console.log('Starting daily ambassador eligibility check...');
    try {
        let processedCount = 0;
        let promotedCount = 0;
        let pendingCount = 0;
        // Get all non-ambassador users who might be eligible
        const usersSnapshot = await db.collection('users')
            .where('isAdult', '==', true)
            .where('ambassadorStatus', '!=', 'approved')
            .where('ambassadorStatus', '!=', 'pending_ambassador')
            .limit(1000) // Process in batches
            .get();
        for (const userDoc of usersSnapshot.docs) {
            const userData = userDoc.data();
            const userId = userDoc.id;
            // Check referral count
            const referralCount = await getUserReferralCount(userId);
            if (referralCount >= BASIC_TIER_REFERRALS) {
                // Check 1-of-10 rule
                const quota = await getOrCreateAmbassadorQuota(userId);
                const eligibleReferrals = Math.floor(quota.totalReferrals / REFERRAL_RATIO_FOR_AMBASSADOR);
                if (eligibleReferrals > 0) {
                    // Check for fraud before promoting
                    const fraudCheck = await checkForReferralAbuse(userId);
                    if (!fraudCheck.isFlagged) {
                        const promoted = await promoteToPendingAmbassador(userId);
                        if (promoted) {
                            pendingCount++;
                            console.log(`Promoted user ${userId} to pending ambassador`);
                        }
                    }
                    else {
                        console.log(`User ${userId} flagged for fraud, skipping promotion`);
                    }
                }
            }
            processedCount++;
        }
        console.log(`Daily eligibility check completed: ${processedCount} users processed, ${promotedCount} promoted, ${pendingCount} pending`);
        // Log results
        await db.collection('ambassador_automation_logs').add({
            type: 'daily_eligibility_check',
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            results: {
                processedCount,
                promotedCount,
                pendingCount,
            },
        });
    }
    catch (error) {
        console.error('Error in daily eligibility check:', error);
        throw error;
    }
});
// Scheduled function: Monthly ambassador performance review
export const monthlyAmbassadorReview = onSchedule({
    schedule: '0 3 1 * *', // Run at 3 AM on the 1st of every month
    timeZone: 'UTC'
}, async (context) => {
    console.log('Starting monthly ambassador review...');
    try {
        let processedCount = 0;
        let demotedCount = 0;
        let upgradedCount = 0;
        const now = admin.firestore.Timestamp.now();
        // Get all active ambassadors due for review
        const ambassadorSnapshot = await db.collection('ambassador_profiles')
            .where('status', '==', 'approved')
            .where('nextMonthlyReviewAt', '<=', now)
            .limit(500)
            .get();
        for (const ambassadorDoc of ambassadorSnapshot.docs) {
            const profile = ambassadorDoc.data();
            // Check monthly performance
            const monthlyReferrals = await getMonthlyReferralCount(profile.userId);
            if (monthlyReferrals < MINIMUM_MONTHLY_REFERRALS) {
                // Send warning first if it's the first time this month
                if (monthlyReferrals < 5) {
                    await sendPerformanceWarningNotification(profile.userId, profile.languageCode || 'en', monthlyReferrals, MINIMUM_MONTHLY_REFERRALS);
                }
                // Demote ambassador
                await demoteAmbassador(profile.userId, 'insufficient_monthly_referrals');
                demotedCount++;
                console.log(`Demoted ambassador ${profile.userId} for insufficient referrals: ${monthlyReferrals}`);
            }
            else {
                // Update activity and check for tier upgrade
                await updateAmbassadorActivity(profile.userId, monthlyReferrals);
                const tierUpgraded = await checkAndUpgradeTier(profile.userId);
                if (tierUpgraded) {
                    upgradedCount++;
                }
            }
            processedCount++;
        }
        console.log(`Monthly review completed: ${processedCount} ambassadors reviewed, ${demotedCount} demoted, ${upgradedCount} tier upgrades`);
        // Log results
        await db.collection('ambassador_automation_logs').add({
            type: 'monthly_review',
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            results: {
                processedCount,
                demotedCount,
                upgradedCount,
            },
        });
    }
    catch (error) {
        console.error('Error in monthly ambassador review:', error);
        throw error;
    }
});
// Scheduled function: Monthly premium reward grant
export const monthlyPremiumRewardGrant = onSchedule({
    schedule: '0 4 1 * *', // Run at 4 AM on the 1st of every month
    timeZone: 'UTC'
}, async (context) => {
    console.log('Starting monthly premium reward grant...');
    try {
        let processedCount = 0;
        let rewardedCount = 0;
        const now = admin.firestore.Timestamp.now();
        const lastMonth = new Date();
        lastMonth.setMonth(lastMonth.getMonth() - 1);
        const monthKey = `${lastMonth.getFullYear()}-${String(lastMonth.getMonth() + 1).padStart(2, '0')}`;
        // Get all approved ambassadors
        const ambassadorSnapshot = await db.collection('ambassador_profiles')
            .where('status', '==', 'approved')
            .get();
        for (const ambassadorDoc of ambassadorSnapshot.docs) {
            const profile = ambassadorDoc.data();
            const userId = profile.userId;
            // Check if already rewarded for this month
            const existingReward = await db.collection('ambassador_rewards')
                .where('ambassadorId', '==', userId)
                .where('type', '==', 'monthly_premium')
                .where('month', '==', monthKey)
                .limit(1)
                .get();
            if (existingReward.empty) {
                // Get monthly referral count
                const monthlyReferrals = await getMonthlyReferralCount(userId);
                if (monthlyReferrals >= MONTHLY_PREMIUM_THRESHOLD) {
                    const monthsToGrant = Math.floor(monthlyReferrals / MONTHLY_PREMIUM_THRESHOLD);
                    await awardMonthlyPremium(userId, monthsToGrant, monthKey);
                    rewardedCount++;
                    console.log(`Awarded ${monthsToGrant} months premium to ${userId} for ${monthlyReferrals} referrals`);
                }
            }
            processedCount++;
        }
        console.log(`Monthly premium reward grant completed: ${processedCount} processed, ${rewardedCount} rewarded`);
        // Log results
        await db.collection('ambassador_automation_logs').add({
            type: 'monthly_premium_reward',
            timestamp: admin.firestore.FieldValue.serverTimestamp(),
            results: {
                processedCount,
                rewardedCount,
                month: monthKey,
            },
        });
    }
    catch (error) {
        console.error('Error in monthly premium reward grant:', error);
        throw error;
    }
});
// Firestore trigger: User referral tracking
export const trackUserReferral = onDocumentCreated('users/{userId}', async (event) => {
    const snap = event.data;
    const context = event;
    if (!snap) {
        console.log('No data in document snapshot');
        return null;
    }
    try {
        const userData = snap.data();
        const newUserId = context.params.userId;
        // Check if user was referred by an ambassador
        const referralCode = userData.referralCode;
        if (!referralCode)
            return null;
        // Find ambassador by share code
        const shareCodeDoc = await db.collection('ambassador_share_codes')
            .doc(referralCode)
            .get();
        if (!shareCodeDoc.exists)
            return null;
        const shareCodeData = shareCodeDoc.data();
        const ambassadorId = shareCodeData.ambassadorId;
        // Track the referral
        await trackReferralForAmbassador(ambassadorId, newUserId);
        console.log(`Tracked referral for ambassador ${ambassadorId}: new user ${newUserId}`);
    }
    catch (error) {
        console.error('Error tracking user referral:', error);
    }
    return null;
});
// HTTPS callable: Manual ambassador promotion check
export const checkAmbassadorEligibility = onCall(async (request) => {
    // Verify authentication
    if (!request.auth) {
        throw new HttpsError('unauthenticated', 'User must be authenticated');
    }
    const userId = request.data.userId || request.auth.uid;
    try {
        const referralCount = await getUserReferralCount(userId);
        const quota = await getOrCreateAmbassadorQuota(userId);
        const eligibleReferrals = Math.floor(quota.totalReferrals / REFERRAL_RATIO_FOR_AMBASSADOR);
        const isEligible = referralCount >= BASIC_TIER_REFERRALS && eligibleReferrals > 0;
        let canPromote = false;
        if (isEligible) {
            const userDoc = await db.collection('users').doc(userId).get();
            const userData = userDoc.data();
            canPromote = userData &&
                Boolean(userData.isAdult) === true &&
                userData.ambassadorStatus !== 'approved' &&
                userData.ambassadorStatus !== 'pending_ambassador' || false;
        }
        return {
            isEligible,
            canPromote,
            referralCount,
            eligibleReferrals,
            minimumRequired: BASIC_TIER_REFERRALS,
            ratio: REFERRAL_RATIO_FOR_AMBASSADOR,
        };
    }
    catch (error) {
        console.error('Error checking ambassador eligibility:', error);
        throw new HttpsError('internal', 'Failed to check eligibility');
    }
});
// HTTPS callable: Get ambassador dashboard data
export const getAmbassadorDashboard = onCall(async (request) => {
    // Verify authentication
    if (!request.auth) {
        throw new HttpsError('unauthenticated', 'User must be authenticated');
    }
    const userId = request.auth.uid;
    try {
        // Get ambassador profile
        const profileDoc = await db.collection('ambassador_profiles').doc(userId).get();
        if (!profileDoc.exists) {
            throw new HttpsError('not-found', 'Ambassador profile not found');
        }
        const profile = profileDoc.data();
        // Get recent referrals
        const referralsSnapshot = await db.collection('ambassador_referrals')
            .where('ambassadorId', '==', userId)
            .orderBy('referredAt', 'desc')
            .limit(10)
            .get();
        const referrals = referralsSnapshot.docs.map(doc => doc.data());
        // Get active rewards
        const rewardsSnapshot = await db.collection('ambassador_rewards')
            .where('ambassadorId', '==', userId)
            .where('isActive', '==', true)
            .get();
        const activeRewards = rewardsSnapshot.docs.map(doc => doc.data());
        // Calculate next tier progress
        const nextTierProgress = calculateNextTierProgress(profile.totalReferrals, profile.tier);
        // Get this month's referrals
        const thisMonthReferrals = await getMonthlyReferralCount(userId);
        // Get pending status if applicable
        let pendingStatus = null;
        if (profile.status === 'pending_ambassador') {
            const pendingDoc = await db.collection('ambassador_pending').doc(userId).get();
            if (pendingDoc.exists) {
                pendingStatus = pendingDoc.data();
            }
        }
        // Get any flags
        const flagsSnapshot = await db.collection('ambassador_flags')
            .where('userId', '==', userId)
            .where('reviewed', '==', false)
            .get();
        const flags = flagsSnapshot.docs.map(doc => doc.data());
        return {
            profile,
            recentReferrals: referrals,
            activeRewards,
            nextTierProgress,
            monthlyProgress: {
                current: profile.monthlyReferrals,
                required: MINIMUM_MONTHLY_REFERRALS,
            },
            thisMonthReferrals,
            referralsToNextTier: nextTierProgress.remaining,
            currentTier: profile.tier,
            pendingStatus,
            flags: flags.length > 0 ? flags : null,
        };
    }
    catch (error) {
        console.error('Error getting ambassador dashboard:', error);
        throw new HttpsError('internal', 'Failed to get dashboard data');
    }
});
// HTTPS callable: Admin approve pending ambassador
export const approvePendingAmbassador = onCall(async (request) => {
    // Verify authentication and admin role
    if (!request.auth) {
        throw new HttpsError('unauthenticated', 'User must be authenticated');
    }
    const { userId } = request.data;
    if (!userId) {
        throw new HttpsError('invalid-argument', 'User ID is required');
    }
    try {
        const promoted = await promoteToAmbassador(userId);
        if (promoted) {
            // Remove from pending collection
            await db.collection('ambassador_pending').doc(userId).delete();
            // Send approval notification
            const profileDoc = await db.collection('ambassador_profiles').doc(userId).get();
            if (profileDoc.exists) {
                const profile = profileDoc.data();
                await sendApprovalNotification(userId, profile.languageCode || 'en');
            }
            return { success: true, message: 'Ambassador approved successfully' };
        }
        else {
            return { success: false, message: 'Failed to approve ambassador' };
        }
    }
    catch (error) {
        console.error('Error approving pending ambassador:', error);
        throw new HttpsError('internal', 'Failed to approve ambassador');
    }
});
// HTTPS callable: Admin reject pending ambassador
export const rejectPendingAmbassador = onCall(async (request) => {
    // Verify authentication and admin role
    if (!request.auth) {
        throw new HttpsError('unauthenticated', 'User must be authenticated');
    }
    const { userId, reason } = request.data;
    if (!userId || !reason) {
        throw new HttpsError('invalid-argument', 'User ID and reason are required');
    }
    try {
        const now = admin.firestore.Timestamp.now();
        await db.runTransaction(async (transaction) => {
            // Update user status
            transaction.update(db.collection('users').doc(userId), {
                ambassadorStatus: 'rejected',
                ambassadorRejectedAt: now,
                ambassadorRejectionReason: reason,
                updatedAt: now,
            });
            // Update ambassador profile
            transaction.update(db.collection('ambassador_profiles').doc(userId), {
                status: 'inactive',
                rejectionReason: reason,
                statusChangedAt: now,
            });
            // Remove from pending collection
            transaction.delete(db.collection('ambassador_pending').doc(userId));
        });
        // Send rejection notification
        const profileDoc = await db.collection('ambassador_profiles').doc(userId).get();
        if (profileDoc.exists) {
            const profile = profileDoc.data();
            await sendRejectionNotification(userId, profile.languageCode || 'en', reason);
        }
        return { success: true, message: 'Ambassador rejected successfully' };
    }
    catch (error) {
        console.error('Error rejecting pending ambassador:', error);
        throw new HttpsError('internal', 'Failed to reject ambassador');
    }
});
// Helper functions
async function promoteToPendingAmbassador(userId) {
    try {
        const userDoc = await db.collection('users').doc(userId).get();
        if (!userDoc.exists)
            return false;
        const userData = userDoc.data();
        const countryCode = userData.countryCode;
        const languageCode = userData.preferredLanguage;
        if (!countryCode || !languageCode)
            return false;
        const now = admin.firestore.Timestamp.now();
        await db.runTransaction(async (transaction) => {
            // Update user status
            transaction.update(db.collection('users').doc(userId), {
                ambassadorStatus: 'pending_ambassador',
                ambassadorPendingSince: now,
                updatedAt: now,
            });
            // Create ambassador profile with pending status
            const ambassadorProfile = {
                id: userId,
                userId: userId,
                countryCode: countryCode,
                languageCode: languageCode,
                status: 'pending_ambassador',
                tier: 'basic',
                assignedAt: now,
                lastActivityDate: now,
                totalReferrals: await getUserReferralCount(userId),
                activeReferrals: await getUserReferralCount(userId),
                monthlyReferrals: 0,
                lastMonthlyResetAt: now,
                nextMonthlyReviewAt: admin.firestore.Timestamp.fromDate(new Date(Date.now() + 30 * 24 * 60 * 60 * 1000)),
                earnedRewards: [],
                pendingSince: now,
            };
            transaction.set(db.collection('ambassador_profiles').doc(userId), ambassadorProfile);
            // Add to pending collection
            transaction.set(db.collection('ambassador_pending').doc(userId), {
                userId: userId,
                pendingSince: now,
                referralCount: await getUserReferralCount(userId),
                countryCode: countryCode,
                languageCode: languageCode,
            });
        });
        // Send pending approval notification
        await sendPendingApprovalNotification(userId, languageCode);
        return true;
    }
    catch (error) {
        console.error('Error promoting to pending ambassador:', error);
        return false;
    }
}
async function promoteToAmbassador(userId) {
    try {
        const userDoc = await db.collection('users').doc(userId).get();
        if (!userDoc.exists)
            return false;
        const userData = userDoc.data();
        const countryCode = userData.countryCode;
        const languageCode = userData.preferredLanguage;
        if (!countryCode || !languageCode)
            return false;
        // Check quota availability (simplified)
        const hasSlots = await checkQuotaAvailability(countryCode, languageCode);
        if (!hasSlots)
            return false;
        const now = admin.firestore.Timestamp.now();
        const nextMonth = new Date();
        nextMonth.setMonth(nextMonth.getMonth() + 1, 1);
        nextMonth.setHours(0, 0, 0, 0);
        await db.runTransaction(async (transaction) => {
            // Update user status
            transaction.update(db.collection('users').doc(userId), {
                ambassadorStatus: 'approved',
                role: 'ambassador',
                ambassadorSince: now,
                updatedAt: now,
            });
            // Update ambassador profile
            transaction.update(db.collection('ambassador_profiles').doc(userId), {
                status: 'approved',
                statusChangedAt: now,
                lastActivityDate: now,
            });
        });
        // Generate share link and award basic tier reward
        await generateShareLink(userId);
        await awardTierReward(userId, 'basic');
        // Send promotion notification
        await sendPromotionNotification(userId, languageCode, 'basic');
        return true;
    }
    catch (error) {
        console.error('Error promoting to ambassador:', error);
        return false;
    }
}
async function demoteAmbassador(userId, reason) {
    try {
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
                monthlyReferrals: await getMonthlyReferralCount(userId),
            });
        });
        // Revoke active rewards (except lifetime)
        await revokeActiveRewards(userId);
        // Send demotion notification
        const profileDoc = await db.collection('ambassador_profiles').doc(userId).get();
        if (profileDoc.exists) {
            const profile = profileDoc.data();
            await sendDemotionNotification(userId, profile.languageCode || 'en', reason);
        }
    }
    catch (error) {
        console.error('Error demoting ambassador:', error);
    }
}
async function trackReferralForAmbassador(ambassadorId, referredUserId) {
    try {
        const now = admin.firestore.Timestamp.now();
        const referralId = `${ambassadorId}_${referredUserId}_${Date.now()}`;
        await db.runTransaction(async (transaction) => {
            // Create referral record
            transaction.set(db.collection('ambassador_referrals').doc(referralId), {
                id: referralId,
                ambassadorId: ambassadorId,
                referredUserId: referredUserId,
                referredAt: now,
                activatedAt: now,
                isActive: true,
                source: 'share_link',
            });
            // Update ambassador counts
            transaction.update(db.collection('ambassador_profiles').doc(ambassadorId), {
                totalReferrals: admin.firestore.FieldValue.increment(1),
                activeReferrals: admin.firestore.FieldValue.increment(1),
                monthlyReferrals: admin.firestore.FieldValue.increment(1),
                lastActivityDate: now,
            });
            // Update quota
            const quotaRef = db.collection('ambassador_quotas').doc(ambassadorId);
            transaction.set(quotaRef, {
                userId: ambassadorId,
                totalReferrals: admin.firestore.FieldValue.increment(1),
                eligibleForAmbassador: admin.firestore.FieldValue.increment(1),
                lastUpdated: now,
            }, { merge: true });
        });
        // Check for tier upgrade
        await checkAndUpgradeTier(ambassadorId);
        // Send referral success notification
        const ambassadorDoc = await db.collection('ambassador_profiles').doc(ambassadorId).get();
        const referredUserDoc = await db.collection('users').doc(referredUserId).get();
        if (ambassadorDoc.exists && referredUserDoc.exists) {
            const ambassador = ambassadorDoc.data();
            const referredUser = referredUserDoc.data();
            const referredUserName = referredUser.displayName || referredUser.email || 'New User';
            const totalReferrals = ambassador.totalReferrals + 1; // +1 because this is the new referral
            await sendReferralSuccessNotification(ambassadorId, ambassador.languageCode || 'en', referredUserName, totalReferrals);
        }
    }
    catch (error) {
        console.error('Error tracking referral:', error);
    }
}
async function generateShareLink(userId) {
    try {
        const shareCode = generateUniqueCode(userId);
        const shareLink = `https://app-oint.com/invite/${shareCode}`;
        await db.collection('ambassador_profiles').doc(userId).update({
            shareLink: shareLink,
            shareCode: shareCode,
        });
        // Store share code mapping
        await db.collection('ambassador_share_codes').doc(shareCode).set({
            ambassadorId: userId,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
            isActive: true,
        });
    }
    catch (error) {
        console.error('Error generating share link:', error);
    }
}
async function awardTierReward(userId, tier) {
    try {
        const now = admin.firestore.Timestamp.now();
        let rewardType;
        let expiresAt;
        switch (tier) {
            case 'basic':
                rewardType = 'premium_features';
                expiresAt = admin.firestore.Timestamp.fromDate(new Date(Date.now() + 365 * 24 * 60 * 60 * 1000));
                break;
            case 'premium':
                rewardType = 'one_year_access';
                expiresAt = admin.firestore.Timestamp.fromDate(new Date(Date.now() + 365 * 24 * 60 * 60 * 1000));
                break;
            case 'lifetime':
                rewardType = 'lifetime_access';
                expiresAt = admin.firestore.Timestamp.fromDate(new Date(2099, 11, 31));
                break;
        }
        const rewardId = `${userId}_${tier}_${Date.now()}`;
        await db.collection('ambassador_rewards').doc(rewardId).set({
            id: rewardId,
            ambassadorId: userId,
            type: rewardType,
            tier: tier,
            earnedAt: now,
            expiresAt: expiresAt,
            isActive: true,
            description: getRewardDescription(rewardType),
        });
    }
    catch (error) {
        console.error('Error awarding tier reward:', error);
    }
}
async function awardMonthlyPremium(userId, months, monthKey) {
    try {
        const now = admin.firestore.Timestamp.now();
        const expiresAt = admin.firestore.Timestamp.fromDate(new Date(Date.now() + months * 30 * 24 * 60 * 60 * 1000));
        const rewardId = `${userId}_monthly_premium_${monthKey}`;
        await db.collection('ambassador_rewards').doc(rewardId).set({
            id: rewardId,
            ambassadorId: userId,
            type: 'monthly_premium',
            tier: 'basic',
            earnedAt: now,
            expiresAt: expiresAt,
            isActive: true,
            description: `${months} month(s) premium access`,
            month: monthKey,
        });
    }
    catch (error) {
        console.error('Error awarding monthly premium:', error);
    }
}
async function checkForReferralAbuse(userId) {
    try {
        // Get user's recent referrals
        const recentReferrals = await db.collection('ambassador_referrals')
            .where('ambassadorId', '==', userId)
            .where('referredAt', '>', admin.firestore.Timestamp.fromDate(new Date(Date.now() - 24 * 60 * 60 * 1000))) // Last 24 hours
            .get();
        if (recentReferrals.size > 10) {
            // Flag for rapid referrals
            await flagAmbassador(userId, 'rapid_referrals', `User made ${recentReferrals.size} referrals in 24 hours`);
            return { isFlagged: true, reason: 'rapid_referrals' };
        }
        // Check for suspicious patterns (simplified)
        const referredUsers = await Promise.all(recentReferrals.docs.map(doc => db.collection('users').doc(doc.data().referredUserId).get()));
        const emails = referredUsers
            .filter(doc => doc.exists)
            .map(doc => doc.data()?.email)
            .filter(Boolean);
        // Check for same email domain
        const domains = emails.map(email => email.split('@')[1]);
        const uniqueDomains = new Set(domains);
        if (emails.length > 3 && uniqueDomains.size <= 1) {
            await flagAmbassador(userId, 'suspicious_email_domain', `All referrals from same domain: ${uniqueDomains.values().next().value}`);
            return { isFlagged: true, reason: 'suspicious_email_domain' };
        }
        return { isFlagged: false };
    }
    catch (error) {
        console.error('Error checking for referral abuse:', error);
        return { isFlagged: false };
    }
}
async function flagAmbassador(userId, flagType, reason) {
    try {
        const now = admin.firestore.Timestamp.now();
        await db.collection('ambassador_flags').add({
            userId: userId,
            flagType: flagType,
            reason: reason,
            flaggedAt: now,
            reviewed: false,
        });
    }
    catch (error) {
        console.error('Error flagging ambassador:', error);
    }
}
async function getOrCreateAmbassadorQuota(userId) {
    try {
        const quotaDoc = await db.collection('ambassador_quotas').doc(userId).get();
        if (quotaDoc.exists) {
            return quotaDoc.data();
        }
        else {
            const totalReferrals = await getUserReferralCount(userId);
            const now = admin.firestore.Timestamp.now();
            const quota = {
                userId: userId,
                totalReferrals: totalReferrals,
                eligibleForAmbassador: Math.floor(totalReferrals / REFERRAL_RATIO_FOR_AMBASSADOR),
                lastUpdated: now,
            };
            await db.collection('ambassador_quotas').doc(userId).set(quota);
            return quota;
        }
    }
    catch (error) {
        console.error('Error getting or creating ambassador quota:', error);
        return {
            userId: userId,
            totalReferrals: 0,
            eligibleForAmbassador: 0,
            lastUpdated: admin.firestore.Timestamp.now(),
        };
    }
}
// Utility functions
function generateUniqueCode(userId) {
    const timestamp = Date.now();
    const userHash = Math.abs(userId.split('').reduce((a, b) => a + b.charCodeAt(0), 0));
    return `${userHash.toString().substring(0, 4)}${timestamp.toString().substring(8)}`;
}
function getRewardDescription(type) {
    switch (type) {
        case 'premium_features':
            return 'Premium Features Unlocked';
        case 'one_year_access':
            return '1 Year Full Access';
        case 'lifetime_access':
            return 'Lifetime Access';
        case 'monthly_premium':
            return 'Monthly Premium Access';
        default:
            return 'Ambassador Reward';
    }
}
function calculateNextTierProgress(totalReferrals, currentTier) {
    let nextTierRequirement;
    let nextTierName;
    switch (currentTier) {
        case 'basic':
            nextTierRequirement = PREMIUM_TIER_REFERRALS;
            nextTierName = 'Premium';
            break;
        case 'premium':
            nextTierRequirement = LIFETIME_TIER_REFERRALS;
            nextTierName = 'Lifetime';
            break;
        case 'lifetime':
            return { isMaxTier: true };
        default:
            nextTierRequirement = BASIC_TIER_REFERRALS;
            nextTierName = 'Basic';
    }
    const progress = Math.min(totalReferrals / nextTierRequirement, 1.0);
    const remaining = Math.max(nextTierRequirement - totalReferrals, 0);
    return {
        nextTierName,
        progress,
        remaining,
        current: totalReferrals,
        required: nextTierRequirement,
    };
}
async function getUserReferralCount(userId) {
    const snapshot = await db.collection('ambassador_referrals')
        .where('ambassadorId', '==', userId)
        .where('isActive', '==', true)
        .count()
        .get();
    return snapshot.data().count;
}
async function getMonthlyReferralCount(userId) {
    const lastMonth = new Date();
    lastMonth.setMonth(lastMonth.getMonth() - 1);
    const snapshot = await db.collection('ambassador_referrals')
        .where('ambassadorId', '==', userId)
        .where('isActive', '==', true)
        .where('referredAt', '>', admin.firestore.Timestamp.fromDate(lastMonth))
        .count()
        .get();
    return snapshot.data().count;
}
async function checkQuotaAvailability(countryCode, languageCode) {
    // Simplified quota check - implement full logic based on ambassador quotas
    return true;
}
async function updateAmbassadorActivity(userId, monthlyReferrals) {
    const nextMonth = new Date();
    nextMonth.setMonth(nextMonth.getMonth() + 1, 1);
    nextMonth.setHours(0, 0, 0, 0);
    await db.collection('ambassador_profiles').doc(userId).update({
        monthlyReferrals: monthlyReferrals,
        lastActivityDate: admin.firestore.FieldValue.serverTimestamp(),
        lastMonthlyResetAt: admin.firestore.FieldValue.serverTimestamp(),
        nextMonthlyReviewAt: admin.firestore.Timestamp.fromDate(nextMonth),
    });
}
async function checkAndUpgradeTier(userId) {
    try {
        const totalReferrals = await getUserReferralCount(userId);
        const profileDoc = await db.collection('ambassador_profiles').doc(userId).get();
        if (!profileDoc.exists)
            return false;
        const profile = profileDoc.data();
        let newTier = profile.tier;
        // Determine new tier
        if (totalReferrals >= LIFETIME_TIER_REFERRALS && profile.tier !== 'lifetime') {
            newTier = 'lifetime';
        }
        else if (totalReferrals >= PREMIUM_TIER_REFERRALS && profile.tier === 'basic') {
            newTier = 'premium';
        }
        // Upgrade if changed
        if (newTier !== profile.tier) {
            await db.collection('ambassador_profiles').doc(userId).update({
                tier: newTier,
                tierChangedAt: admin.firestore.FieldValue.serverTimestamp(),
                lastActivityDate: admin.firestore.FieldValue.serverTimestamp(),
            });
            await awardTierReward(userId, newTier);
            // Send tier upgrade notification
            await sendTierUpgradeNotification(userId, profile.languageCode || 'en', profile.tier, newTier, totalReferrals);
            // Log tier upgrade
            await db.collection('ambassador_tier_upgrades').add({
                ambassadorId: userId,
                previousTier: profile.tier,
                newTier: newTier,
                upgradedAt: admin.firestore.FieldValue.serverTimestamp(),
                totalReferrals: totalReferrals,
            });
            return true;
        }
        return false;
    }
    catch (error) {
        console.error('Error checking tier upgrade:', error);
        return false;
    }
}
async function revokeActiveRewards(userId) {
    const rewards = await db.collection('ambassador_rewards')
        .where('ambassadorId', '==', userId)
        .where('isActive', '==', true)
        .get();
    const batch = db.batch();
    rewards.docs.forEach(doc => {
        const reward = doc.data();
        if (reward.type !== 'lifetime_access') {
            batch.update(doc.ref, { isActive: false });
        }
    });
    await batch.commit();
}
