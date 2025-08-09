import { doc, getDoc } from 'firebase/firestore';
import { db } from '@/lib/firebase';
import { BusinessProfile, BusinessPlan } from '@/lib/types/business';

export class FeatureGatingService {
  private static instance: FeatureGatingService;
  
  public static getInstance(): FeatureGatingService {
    if (!FeatureGatingService.instance) {
      FeatureGatingService.instance = new FeatureGatingService();
    }
    return FeatureGatingService.instance;
  }

  async getBusinessProfile(businessId: string): Promise<BusinessProfile> {
    const docRef = doc(db, 'business_profiles', businessId);
    const docSnap = await getDoc(docRef);
    
    if (!docSnap.exists()) {
      throw new Error(`Business profile not found for ID: ${businessId}`);
    }
    
    return docSnap.data() as BusinessProfile;
  }

  async canUseFeature(businessId: string, featureKey: 'branding' | 'customFields' | 'appointments'): Promise<boolean> {
    try {
      const profile = await this.getBusinessProfile(businessId);
      
      switch (featureKey) {
        case 'branding':
          return profile.limits.enableBranding;
        case 'customFields':
          return profile.limits.enableCustomFields;
        case 'appointments':
          return true; // All plans support appointments, but with limits
        default:
          return false;
      }
    } catch (error) {
      console.error('Error checking feature access:', error);
      return false;
    }
  }

  async assertWithinLimits(businessId: string, kind: 'appointments' | 'staff'): Promise<void> {
    try {
      const profile = await this.getBusinessProfile(businessId);
      const usageService = await import('./usage.service').then(m => m.UsageService.getInstance());
      
      const currentMonth = new Date();
      const monthKey = usageService.getMonthlyKey(businessId, currentMonth);
      const usage = await usageService.getUsage(businessId, monthKey);
      
      let currentCount = 0;
      let maxLimit = 0;
      
      if (kind === 'appointments') {
        currentCount = usage.appointmentsCount;
        maxLimit = profile.limits.maxAppointmentsPerMonth;
      } else if (kind === 'staff') {
        currentCount = usage.staffCount;
        maxLimit = profile.limits.maxStaff;
      }
      
      if (currentCount >= maxLimit) {
        throw new Error(`${kind} limit exceeded. Current: ${currentCount}, Limit: ${maxLimit}`);
      }
    } catch (error) {
      console.error('Error checking limits:', error);
      throw error;
    }
  }

  getPlanFeatures(plan: BusinessPlan): Record<string, boolean> {
    const features = {
      branding: false,
      customFields: false,
      appointments: true,
      analytics: false,
      messaging: false,
    };

    switch (plan) {
      case 'free':
        return features;
      case 'pro':
        return {
          ...features,
          branding: true,
          customFields: true,
          analytics: true,
          messaging: true,
        };
      case 'enterprise':
        return {
          ...features,
          branding: true,
          customFields: true,
          analytics: true,
          messaging: true,
        };
      default:
        return features;
    }
  }
}

export const featureGating = FeatureGatingService.getInstance();




