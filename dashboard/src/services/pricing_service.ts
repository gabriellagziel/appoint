import { 
  collection, 
  doc, 
  getDocs, 
  getDoc, 
  query, 
  where,
  orderBy 
} from 'firebase/firestore';
import { db } from '@/lib/firebase';

export interface Plan {
  id: string;
  name: string;
  price: number;
  currency: string;
  billingCycle: 'monthly' | 'yearly';
  features: string[];
  mapLimit: number;
  meetingLimit: number | 'unlimited';
  isBrandingEnabled: boolean;
  isPrioritySupport: boolean;
  isAnalyticsEnabled: boolean;
  isCustomDomainEnabled: boolean;
  isTeamManagementEnabled: boolean;
  isAdvancedReportsEnabled: boolean;
  maxTeamMembers: number;
  maxCustomers: number;
  isPopular?: boolean;
  description?: string;
}

export interface Subscription {
  id: string;
  businessId: string;
  planId: string;
  status: 'active' | 'expired' | 'cancelled' | 'pending';
  startDate: Date;
  endDate: Date;
  currentPeriodStart: Date;
  currentPeriodEnd: Date;
  cancelAtPeriodEnd: boolean;
  usage: {
    meetingsCount: number;
    mapLoadCount: number;
    customersCount: number;
    teamMembersCount: number;
  };
  createdAt: Date;
  updatedAt: Date;
}

const COLLECTION_NAME = 'plans';

/**
 * Get all available plans
 */
export const getPlans = async (): Promise<Plan[]> => {
  try {
    const q = query(
      collection(db, COLLECTION_NAME),
      orderBy('price', 'asc')
    );
    
    const querySnapshot = await getDocs(q);
    const plans: Plan[] = [];
    
    querySnapshot.forEach((doc) => {
      plans.push({
        id: doc.id,
        ...doc.data()
      } as Plan);
    });
    
    return plans;
  } catch (error) {
    console.error('Error fetching plans:', error);
    throw new Error('Failed to fetch plans');
  }
};

/**
 * Get a single plan by ID
 */
export const getPlan = async (planId: string): Promise<Plan | null> => {
  try {
    const docRef = doc(db, COLLECTION_NAME, planId);
    const docSnap = await getDoc(docRef);
    
    if (docSnap.exists()) {
      return {
        id: docSnap.id,
        ...docSnap.data()
      } as Plan;
    }
    
    return null;
  } catch (error) {
    console.error('Error fetching plan:', error);
    throw new Error('Failed to fetch plan');
  }
};

/**
 * Get default free plan
 */
export const getFreePlan = (): Plan => {
  return {
    id: 'free',
    name: 'Free',
    price: 0,
    currency: 'USD',
    billingCycle: 'monthly',
    features: [
      'Up to 5 meetings per month',
      'Basic customer management',
      'Standard support'
    ],
    mapLimit: 50,
    meetingLimit: 5,
    isBrandingEnabled: false,
    isPrioritySupport: false,
    isAnalyticsEnabled: false,
    isCustomDomainEnabled: false,
    isTeamManagementEnabled: false,
    isAdvancedReportsEnabled: false,
    maxTeamMembers: 1,
    maxCustomers: 100,
    description: 'Perfect for small businesses getting started'
  };
};

/**
 * Check if user can access feature based on plan
 */
export const canAccessFeature = (
  subscription: Subscription | null,
  feature: keyof Plan
): boolean => {
  if (!subscription || subscription.status !== 'active') {
    return false;
  }

  // For now, return true for active subscriptions
  // In the future, implement feature-specific checks
  return true;
};

/**
 * Check if user has exceeded usage limits
 */
export const checkUsageLimits = (
  subscription: Subscription | null,
  plan: Plan | null
): { exceeded: boolean; message?: string } => {
  if (!subscription || !plan) {
    return { exceeded: true, message: 'No active subscription' };
  }

  if (subscription.status !== 'active') {
    return { exceeded: true, message: 'Subscription is not active' };
  }

  // Check meeting limit
  if (plan.meetingLimit !== 'unlimited' && 
      subscription.usage.meetingsCount >= plan.meetingLimit) {
    return { 
      exceeded: true, 
      message: `Meeting limit exceeded. Upgrade to continue.` 
    };
  }

  // Check map load limit
  if (subscription.usage.mapLoadCount >= plan.mapLimit) {
    return { 
      exceeded: true, 
      message: `Map load limit exceeded. Upgrade to continue.` 
    };
  }

  // Check team members limit
  if (subscription.usage.teamMembersCount >= plan.maxTeamMembers) {
    return { 
      exceeded: true, 
      message: `Team members limit exceeded. Upgrade to continue.` 
    };
  }

  // Check customers limit
  if (subscription.usage.customersCount >= plan.maxCustomers) {
    return { 
      exceeded: true, 
      message: `Customers limit exceeded. Upgrade to continue.` 
    };
  }

  return { exceeded: false };
}; 