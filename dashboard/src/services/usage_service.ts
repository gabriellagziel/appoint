import { db } from '@/lib/firebase';
import {
    doc,
    getDoc,
    increment,
    setDoc,
    updateDoc
} from 'firebase/firestore';
import { getPlan } from './pricing_service';
import { getBusinessSubscription } from './subscription_service';

export interface UsageData {
    businessId: string;
    meetingsCreated: number;
    mapLoads: number;
    customersAdded: number;
    staffMembers: number;
    brandingUsed: number;
    analyticsUsed: number;
    reportsGenerated: number;
    lastUpdated: Date;
}

export interface UsageLimit {
    exceeded: boolean;
    message?: string;
    current: number;
    limit: number;
    percentage: number;
}

const COLLECTION_NAME = 'usage';

/**
 * Get usage data for a business
 */
export const getUsageData = async (businessId: string): Promise<UsageData | null> => {
    try {
        const docRef = doc(db, COLLECTION_NAME, businessId);
        const docSnap = await getDoc(docRef);

        if (docSnap.exists()) {
            return {
                businessId,
                ...docSnap.data()
            } as UsageData;
        }

        // Create initial usage data if doesn't exist
        const initialUsage: UsageData = {
            businessId,
            meetingsCreated: 0,
            mapLoads: 0,
            customersAdded: 0,
            staffMembers: 0,
            brandingUsed: 0,
            analyticsUsed: 0,
            reportsGenerated: 0,
            lastUpdated: new Date()
        };

        await setDoc(docRef, initialUsage);
        return initialUsage;
    } catch (error) {
        console.error('Error fetching usage data:', error);
        throw new Error('Failed to fetch usage data');
    }
};

/**
 * Increment usage counter
 */
export const incrementUsage = async (
    businessId: string,
    usageType: keyof Omit<UsageData, 'businessId' | 'lastUpdated'>
): Promise<void> => {
    try {
        const docRef = doc(db, COLLECTION_NAME, businessId);
        await updateDoc(docRef, {
            [usageType]: increment(1),
            lastUpdated: new Date()
        });
    } catch (error) {
        console.error('Error incrementing usage:', error);
        throw new Error('Failed to increment usage');
    }
};

/**
 * Check if usage limit is exceeded
 */
export const checkUsageLimit = async (
    businessId: string,
    usageType: 'meetingsCreated' | 'mapLoads' | 'customersAdded' | 'staffMembers'
): Promise<UsageLimit> => {
    try {
        const [usageData, subscription] = await Promise.all([
            getUsageData(businessId),
            getBusinessSubscription(businessId)
        ]);

        if (!usageData || !subscription) {
            return {
                exceeded: false,
                current: 0,
                limit: 0,
                percentage: 0
            };
        }

        const plan = await getPlan(subscription.planId);
        if (!plan) {
            return {
                exceeded: false,
                current: usageData[usageType],
                limit: 0,
                percentage: 0
            };
        }

        const current = usageData[usageType];
        let limit = 0;

        switch (usageType) {
            case 'meetingsCreated':
                limit = plan.meetingLimit === 'unlimited' ? Infinity : plan.meetingLimit;
                break;
            case 'mapLoads':
                limit = plan.mapLimit;
                break;
            case 'customersAdded':
                limit = plan.maxCustomers;
                break;
            case 'staffMembers':
                limit = plan.maxTeamMembers;
                break;
        }

        const exceeded = limit !== Infinity && current >= limit;
        const percentage = limit !== Infinity ? (current / limit) * 100 : 0;

        let message: string | undefined;
        if (exceeded) {
            switch (usageType) {
                case 'meetingsCreated':
                    message = `Meeting limit exceeded. Upgrade to continue.`;
                    break;
                case 'mapLoads':
                    message = `Map load limit exceeded. Upgrade to continue.`;
                    break;
                case 'customersAdded':
                    message = `Customer limit exceeded. Upgrade to continue.`;
                    break;
                case 'staffMembers':
                    message = `Team member limit exceeded. Upgrade to continue.`;
                    break;
            }
        }

        return {
            exceeded,
            message,
            current,
            limit,
            percentage
        };
    } catch (error) {
        console.error('Error checking usage limit:', error);
        throw new Error('Failed to check usage limit');
    }
};

/**
 * Check if feature is available based on plan
 */
export const checkFeatureAvailability = async (
    businessId: string,
    feature: 'branding' | 'analytics' | 'reports' | 'teamManagement'
): Promise<{ available: boolean; message?: string }> => {
    try {
        const subscription = await getBusinessSubscription(businessId);
        if (!subscription) {
            return { available: false, message: 'No active subscription' };
        }

        const plan = await getPlan(subscription.planId);
        if (!plan) {
            return { available: false, message: 'Plan not found' };
        }

        switch (feature) {
            case 'branding':
                return {
                    available: plan.isBrandingEnabled,
                    message: plan.isBrandingEnabled ? undefined : 'Branding requires Professional plan or higher'
                };
            case 'analytics':
                return {
                    available: plan.isAnalyticsEnabled,
                    message: plan.isAnalyticsEnabled ? undefined : 'Analytics requires Professional plan or higher'
                };
            case 'reports':
                return {
                    available: plan.isAdvancedReportsEnabled,
                    message: plan.isAdvancedReportsEnabled ? undefined : 'Advanced reports require Enterprise plan'
                };
            case 'teamManagement':
                return {
                    available: plan.isTeamManagementEnabled,
                    message: plan.isTeamManagementEnabled ? undefined : 'Team management requires Professional plan or higher'
                };
            default:
                return { available: false, message: 'Feature not available' };
        }
    } catch (error) {
        console.error('Error checking feature availability:', error);
        throw new Error('Failed to check feature availability');
    }
};

/**
 * Get usage summary for dashboard
 */
export const getUsageSummary = async (businessId: string): Promise<{
    usage: UsageData;
    limits: {
        meetings: UsageLimit;
        maps: UsageLimit;
        customers: UsageLimit;
        staff: UsageLimit;
    };
}> => {
    try {
        const [usageData, meetingsLimit, mapsLimit, customersLimit, staffLimit] = await Promise.all([
            getUsageData(businessId),
            checkUsageLimit(businessId, 'meetingsCreated'),
            checkUsageLimit(businessId, 'mapLoads'),
            checkUsageLimit(businessId, 'customersAdded'),
            checkUsageLimit(businessId, 'staffMembers')
        ]);

        return {
            usage: usageData!,
            limits: {
                meetings: meetingsLimit,
                maps: mapsLimit,
                customers: customersLimit,
                staff: staffLimit
            }
        };
    } catch (error) {
        console.error('Error getting usage summary:', error);
        throw new Error('Failed to get usage summary');
    }
}; 