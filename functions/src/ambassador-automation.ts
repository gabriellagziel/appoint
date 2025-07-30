import { scheduler, firestore, https } from 'firebase-functions/v2';
import * as admin from 'firebase-admin';
import { 
  sendPromotionNotification, 
  sendTierUpgradeNotification, 
  sendPerformanceWarningNotification, 
  sendDemotionNotification, 
  sendReferralSuccessNotification 
} from './ambassador-notifications';

const db = admin.firestore();

// Ambassador automation constants
const MINIMUM_MONTHLY_REFERRALS = 10;
const BASIC_TIER_REFERRALS = 5;
const PREMIUM_TIER_REFERRALS = 50;
const LIFETIME_TIER_REFERRALS = 1000;

export interface AmbassadorProfile {
  id: string;
  userId: string;
  countryCode: string;
  languageCode: string;
  status: 'pending' | 'approved' | 'inactive' | 'suspended';
  tier: 'basic' | 'premium' | 'lifetime';
  assignedAt: admin.firestore.Timestamp;
  lastActivityDate: admin.firestore.Timestamp;
  totalReferrals: number;
  activeReferrals: number;
  monthlyReferrals: number;
  lastMonthlyResetAt: admin.firestore.Timestamp;
  nextMonthlyReviewAt: admin.firestore.Timestamp;
  earnedRewards: AmbassadorReward[];
  shareLink?: string;
  shareCode?: string;
}

export interface AmbassadorReward {
  id: string;
  type: 'premium_features' | 'one_year_access' | 'lifetime_access';
  tier: 'basic' | 'premium' | 'lifetime';
  earnedAt: admin.firestore.Timestamp;
  expiresAt: admin.firestore.Timestamp;
  isActive: boolean;
  description?: string;
}

// Scheduled function: Daily ambassador eligibility check
export const dailyAmbassadorEligibilityCheck = scheduler.onSchedule(
  {
    schedule: '0 2 * * *', // Run at 2 AM daily
    timeZone: 'UTC'
  },
  async (event) => {
    console.log('Starting daily ambassador eligibility check...');
    
    try {
      let processedCount = 0;
      let promotedCount = 0;

      // Get all non-ambassador users who might be eligible
      const usersSnapshot = await db.collection('users')
        .where('isAdult', '==', true)
        .where('ambassadorStatus', '!=', 'approved')
        .limit(1000) // Process in batches
        .get();

      for (const userDoc of usersSnapshot.docs) {
        const userData = userDoc.data();
        const userId = userDoc.id;

        // Check referral count
        const referralCount = await getUserReferralCount(userId);
        
        if (referralCount >= BASIC_TIER_REFERRALS) {
          const promoted = await promoteToAmbassador(userId);
          if (promoted) {
            promotedCount++;
            console.log(`Promoted user ${userId} to ambassador`);
          }
        }
        
        processedCount++;
      }

      console.log(`Daily eligibility check completed: ${processedCount} users processed, ${promotedCount} promoted`);
      
      // Log results
      await db.collection('ambassador_automation_logs').add({
        type: 'daily_eligibility_check',
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        results: {
          processedCount,
          promotedCount,
        },
      });

    } catch (error) {
      console.error('Error in daily eligibility check:', error);
      throw error;
    }
  });

// Scheduled function: Monthly ambassador performance review
export const monthlyAmbassadorReview = scheduler.onSchedule(
  {
    schedule: '0 3 1 * *', // Run at 3 AM on the 1st of every month
    timeZone: 'UTC'
  },
  async (event) => {
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
        const profile = ambassadorDoc.data() as AmbassadorProfile;
        
        // Check monthly performance
        const monthlyReferrals = await getMonthlyReferralCount(profile.userId);
        
        if (monthlyReferrals < MINIMUM_MONTHLY_REFERRALS) {
          // Send warning first if it's the first time this month
          if (monthlyReferrals < 5) {
            await sendPerformanceWarningNotification(
              profile.userId, 
              profile.languageCode || 'en', 
              monthlyReferrals, 
              MINIMUM_MONTHLY_REFERRALS
            );
          }
          
          // Demote ambassador
          await demoteAmbassador(profile.userId, 'insufficient_monthly_referrals');
          demotedCount++;
          console.log(`Demoted ambassador ${profile.userId} for insufficient referrals: ${monthlyReferrals}`);
        } else {
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

    } catch (error) {
      console.error('Error in monthly ambassador review:', error);
      throw error;
    }
  });

// Firestore trigger: User referral tracking
export const trackUserReferral = firestore.onDocumentCreated(
  'users/{userId}',
  async (event) => {
    try {
      const userData = event.data?.data();
      if (!userData) {
        console.log('No user data found');
        return null;
      }
      
      const newUserId = event.params.userId;
      
      // Check if user was referred by an ambassador
      const referralCode = userData.referralCode;
      if (!referralCode) return null;

      // Find ambassador by share code
      const shareCodeDoc = await db.collection('ambassador_share_codes')
        .doc(referralCode)
        .get();

      if (!shareCodeDoc.exists) return null;

      const shareCodeData = shareCodeDoc.data()!;
      const ambassadorId = shareCodeData.ambassadorId;

      // Track the referral
      await trackReferralForAmbassador(ambassadorId, newUserId);
      
      console.log(`Tracked referral for ambassador ${ambassadorId}: new user ${newUserId}`);
      
    } catch (error) {
      console.error('Error tracking user referral:', error);
    }
    
    return null;
  });

// HTTPS callable: Manual ambassador promotion check
export const checkAmbassadorEligibility = https.onCall(async (request) => {
  // Verify authentication
  if (!request.auth) {
    throw new https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const userId = request.data.userId || request.auth.uid;
  
  try {
    const referralCount = await getUserReferralCount(userId);
    const isEligible = referralCount >= BASIC_TIER_REFERRALS;
    
    let canPromote = false;
    if (isEligible) {
      const userDoc = await db.collection('users').doc(userId).get();
      const userData = userDoc.data();
      
      canPromote = !!(userData && 
                   userData.isAdult === true && 
                   userData.ambassadorStatus !== 'approved');
    }

    return {
      isEligible,
      canPromote,
      referralCount,
      minimumRequired: BASIC_TIER_REFERRALS,
    };
    
  } catch (error) {
    console.error('Error checking ambassador eligibility:', error);
    throw new https.HttpsError('internal', 'Failed to check eligibility');
  }
});

// HTTPS callable: Get ambassador dashboard data
export const getAmbassadorDashboard = https.onCall(async (request) => {
  // Verify authentication
  if (!request.auth) {
    throw new https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const userId = request.auth.uid;
  
  try {
    // Get ambassador profile
    const profileDoc = await db.collection('ambassador_profiles').doc(userId).get();
    if (!profileDoc.exists) {
      throw new https.HttpsError('not-found', 'Ambassador profile not found');
    }

    const profile = profileDoc.data() as AmbassadorProfile;
    
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
    
    return {
      profile,
      recentReferrals: referrals,
      activeRewards,
      nextTierProgress,
      monthlyProgress: {
        current: profile.monthlyReferrals,
        required: MINIMUM_MONTHLY_REFERRALS,
      },
    };
    
  } catch (error) {
    console.error('Error getting ambassador dashboard:', error);
    throw new https.HttpsError('internal', 'Failed to get dashboard data');
  }
});

// Helper functions
async function promoteToAmbassador(userId: string): Promise<boolean> {
  try {
    const userDoc = await db.collection('users').doc(userId).get();
    if (!userDoc.exists) return false;

    const userData = userDoc.data()!;
    const countryCode = userData.countryCode;
    const languageCode = userData.preferredLanguage;

    if (!countryCode || !languageCode) return false;

    // Check quota availability (simplified)
    const hasSlots = await checkQuotaAvailability(countryCode, languageCode);
    if (!hasSlots) return false;

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

      // Create ambassador profile
      const ambassadorProfile: Partial<AmbassadorProfile> = {
        id: userId,
        userId: userId,
        countryCode: countryCode,
        languageCode: languageCode,
        status: 'approved',
        tier: 'basic',
        assignedAt: now,
        lastActivityDate: now,
        totalReferrals: await getUserReferralCount(userId),
        activeReferrals: await getUserReferralCount(userId),
        monthlyReferrals: 0,
        lastMonthlyResetAt: now,
        nextMonthlyReviewAt: admin.firestore.Timestamp.fromDate(nextMonth),
        earnedRewards: [],
      };

      transaction.set(db.collection('ambassador_profiles').doc(userId), ambassadorProfile);
    });

    // Generate share link and award basic tier reward
    await generateShareLink(userId);
    await awardTierReward(userId, 'basic');
    
    // Send promotion notification
    await sendPromotionNotification(userId, languageCode, 'basic');

    return true;
  } catch (error) {
    console.error('Error promoting to ambassador:', error);
    return false;
  }
}

async function demoteAmbassador(userId: string, reason: string): Promise<void> {
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
      const profile = profileDoc.data()!;
      await sendDemotionNotification(userId, profile.languageCode || 'en', reason);
    }
    
  } catch (error) {
    console.error('Error demoting ambassador:', error);
  }
}

async function trackReferralForAmbassador(ambassadorId: string, referredUserId: string): Promise<void> {
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
    });

    // Check for tier upgrade
    await checkAndUpgradeTier(ambassadorId);
    
    // Send referral success notification
    const ambassadorDoc = await db.collection('ambassador_profiles').doc(ambassadorId).get();
    const referredUserDoc = await db.collection('users').doc(referredUserId).get();
    
    if (ambassadorDoc.exists && referredUserDoc.exists) {
      const ambassador = ambassadorDoc.data()!;
      const referredUser = referredUserDoc.data()!;
      const referredUserName = referredUser.displayName || referredUser.email || 'New User';
      const totalReferrals = ambassador.totalReferrals + 1; // +1 because this is the new referral
      
      await sendReferralSuccessNotification(
        ambassadorId,
        ambassador.languageCode || 'en',
        referredUserName,
        totalReferrals
      );
    }
    
  } catch (error) {
    console.error('Error tracking referral:', error);
  }
}

async function generateShareLink(userId: string): Promise<void> {
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
  } catch (error) {
    console.error('Error generating share link:', error);
  }
}

async function awardTierReward(userId: string, tier: 'basic' | 'premium' | 'lifetime'): Promise<void> {
  try {
    const now = admin.firestore.Timestamp.now();
    let rewardType: 'premium_features' | 'one_year_access' | 'lifetime_access';
    let expiresAt: admin.firestore.Timestamp;

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
    
  } catch (error) {
    console.error('Error awarding tier reward:', error);
  }
}

// Utility functions
function generateUniqueCode(userId: string): string {
  const timestamp = Date.now();
  const userHash = Math.abs(userId.split('').reduce((a, b) => a + b.charCodeAt(0), 0));
  return `${userHash.toString().substring(0, 4)}${timestamp.toString().substring(8)}`;
}

function getRewardDescription(type: string): string {
  switch (type) {
    case 'premium_features':
      return 'Premium Features Unlocked';
    case 'one_year_access':
      return '1 Year Full Access';
    case 'lifetime_access':
      return 'Lifetime Access';
    default:
      return 'Ambassador Reward';
  }
}

function calculateNextTierProgress(totalReferrals: number, currentTier: string) {
  let nextTierRequirement: number;
  let nextTierName: string;

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

async function getUserReferralCount(userId: string): Promise<number> {
  const snapshot = await db.collection('ambassador_referrals')
    .where('ambassadorId', '==', userId)
    .where('isActive', '==', true)
    .count()
    .get();
  return snapshot.data().count;
}

async function getMonthlyReferralCount(userId: string): Promise<number> {
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

async function checkQuotaAvailability(countryCode: string, languageCode: string): Promise<boolean> {
  // Simplified quota check - implement full logic based on ambassador quotas
  return true;
}

async function updateAmbassadorActivity(userId: string, monthlyReferrals: number): Promise<void> {
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

async function checkAndUpgradeTier(userId: string): Promise<boolean> {
  try {
    const totalReferrals = await getUserReferralCount(userId);
    const profileDoc = await db.collection('ambassador_profiles').doc(userId).get();
    
    if (!profileDoc.exists) return false;
    
    const profile = profileDoc.data() as AmbassadorProfile;
    let newTier = profile.tier;

    // Determine new tier
    if (totalReferrals >= LIFETIME_TIER_REFERRALS && profile.tier !== 'lifetime') {
      newTier = 'lifetime';
    } else if (totalReferrals >= PREMIUM_TIER_REFERRALS && profile.tier === 'basic') {
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
      await sendTierUpgradeNotification(
        userId,
        profile.languageCode || 'en',
        profile.tier,
        newTier,
        totalReferrals
      );
      
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
  } catch (error) {
    console.error('Error checking tier upgrade:', error);
    return false;
  }
}

async function revokeActiveRewards(userId: string): Promise<void> {
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