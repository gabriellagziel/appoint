import { 
  collection, 
  doc, 
  getDocs, 
  getDoc, 
  addDoc, 
  updateDoc, 
  deleteDoc, 
  query, 
  where,
  Timestamp 
} from 'firebase/firestore';
import { db } from '@/lib/firebase';
import { Subscription } from './pricing_service';

const COLLECTION_NAME = 'subscriptions';

/**
 * Get subscription for a business
 */
export const getBusinessSubscription = async (businessId: string): Promise<Subscription | null> => {
  try {
    const q = query(
      collection(db, COLLECTION_NAME),
      where('businessId', '==', businessId)
    );
    
    const querySnapshot = await getDocs(q);
    
    if (querySnapshot.empty) {
      return null;
    }
    
    // Get the most recent subscription
    const doc = querySnapshot.docs[0];
    return {
      id: doc.id,
      ...doc.data()
    } as Subscription;
  } catch (error) {
    console.error('Error fetching subscription:', error);
    throw new Error('Failed to fetch subscription');
  }
};

/**
 * Create a new subscription
 */
export const createSubscription = async (
  businessId: string,
  planId: string,
  billingCycle: 'monthly' | 'yearly' = 'monthly'
): Promise<string> => {
  try {
    const now = new Date();
    const endDate = new Date(now);
    
    // Set end date based on billing cycle
    if (billingCycle === 'yearly') {
      endDate.setFullYear(endDate.getFullYear() + 1);
    } else {
      endDate.setMonth(endDate.getMonth() + 1);
    }
    
    const subscriptionData = {
      businessId,
      planId,
      status: 'active' as const,
      startDate: now,
      endDate,
      currentPeriodStart: now,
      currentPeriodEnd: endDate,
      cancelAtPeriodEnd: false,
      usage: {
        meetingsCount: 0,
        mapLoadCount: 0,
        customersCount: 0,
        teamMembersCount: 0
      },
      createdAt: now,
      updatedAt: now
    };
    
    const docRef = await addDoc(collection(db, COLLECTION_NAME), subscriptionData);
    return docRef.id;
  } catch (error) {
    console.error('Error creating subscription:', error);
    throw new Error('Failed to create subscription');
  }
};

/**
 * Update subscription
 */
export const updateSubscription = async (
  subscriptionId: string,
  data: Partial<Subscription>
): Promise<void> => {
  try {
    const docRef = doc(db, COLLECTION_NAME, subscriptionId);
    await updateDoc(docRef, {
      ...data,
      updatedAt: new Date()
    });
  } catch (error) {
    console.error('Error updating subscription:', error);
    throw new Error('Failed to update subscription');
  }
};

/**
 * Cancel subscription
 */
export const cancelSubscription = async (subscriptionId: string): Promise<void> => {
  try {
    const docRef = doc(db, COLLECTION_NAME, subscriptionId);
    await updateDoc(docRef, {
      status: 'cancelled',
      cancelAtPeriodEnd: true,
      updatedAt: new Date()
    });
  } catch (error) {
    console.error('Error cancelling subscription:', error);
    throw new Error('Failed to cancel subscription');
  }
};

/**
 * Reactivate subscription
 */
export const reactivateSubscription = async (subscriptionId: string): Promise<void> => {
  try {
    const docRef = doc(db, COLLECTION_NAME, subscriptionId);
    await updateDoc(docRef, {
      status: 'active',
      cancelAtPeriodEnd: false,
      updatedAt: new Date()
    });
  } catch (error) {
    console.error('Error reactivating subscription:', error);
    throw new Error('Failed to reactivate subscription');
  }
};

/**
 * Update usage statistics
 */
export const updateUsage = async (
  subscriptionId: string,
  usageType: 'meetingsCount' | 'mapLoadCount' | 'customersCount' | 'teamMembersCount',
  increment: number = 1
): Promise<void> => {
  try {
    const docRef = doc(db, COLLECTION_NAME, subscriptionId);
    const docSnap = await getDoc(docRef);
    
    if (docSnap.exists()) {
      const currentData = docSnap.data();
      const currentUsage = currentData.usage || {
        meetingsCount: 0,
        mapLoadCount: 0,
        customersCount: 0,
        teamMembersCount: 0
      };
      
      await updateDoc(docRef, {
        [`usage.${usageType}`]: currentUsage[usageType] + increment,
        updatedAt: new Date()
      });
    }
  } catch (error) {
    console.error('Error updating usage:', error);
    throw new Error('Failed to update usage');
  }
};

/**
 * Check if subscription is active
 */
export const isSubscriptionActive = (subscription: Subscription | null): boolean => {
  if (!subscription) {
    return false;
  }
  
  return subscription.status === 'active' && 
         new Date() <= new Date(subscription.endDate);
};

/**
 * Get subscription status
 */
export const getSubscriptionStatus = (subscription: Subscription | null): string => {
  if (!subscription) {
    return 'No subscription';
  }
  
  if (subscription.status === 'active' && isSubscriptionActive(subscription)) {
    return 'Active';
  }
  
  if (subscription.status === 'active' && !isSubscriptionActive(subscription)) {
    return 'Expired';
  }
  
  return subscription.status.charAt(0).toUpperCase() + subscription.status.slice(1);
};

/**
 * Get days until subscription expires
 */
export const getDaysUntilExpiry = (subscription: Subscription | null): number => {
  if (!subscription || !isSubscriptionActive(subscription)) {
    return 0;
  }
  
  const now = new Date();
  const endDate = new Date(subscription.endDate);
  const diffTime = endDate.getTime() - now.getTime();
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
  
  return Math.max(0, diffDays);
}; 