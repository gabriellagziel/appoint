import { doc, getDoc, setDoc, increment, runTransaction } from 'firebase/firestore';
import { db } from '@/lib/firebase';
import { UsageCounter } from '@/lib/types/business';

export class UsageService {
  private static instance: UsageService;
  
  public static getInstance(): UsageService {
    if (!UsageService.instance) {
      UsageService.instance = new UsageService();
    }
    return UsageService.instance;
  }

  getMonthlyKey(businessId: string, date: Date = new Date()): string {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    return `${businessId}_${year}${month}`;
  }

  async getUsage(businessId: string, monthKey: string): Promise<UsageCounter> {
    const docRef = doc(db, 'usage_counters', monthKey);
    const docSnap = await getDoc(docRef);
    
    if (!docSnap.exists()) {
      // Create default usage counter
      const defaultUsage: UsageCounter = {
        appointmentsCount: 0,
        staffCount: 0,
        monthKey,
        businessId,
      };
      await setDoc(docRef, defaultUsage);
      return defaultUsage;
    }
    
    return docSnap.data() as UsageCounter;
  }

  async incAppointments(businessId: string): Promise<void> {
    const monthKey = this.getMonthlyKey(businessId);
    const docRef = doc(db, 'usage_counters', monthKey);
    
    await runTransaction(db, async (transaction) => {
      const docSnap = await transaction.get(docRef);
      
      if (!docSnap.exists()) {
        // Create new usage counter
        transaction.set(docRef, {
          appointmentsCount: 1,
          staffCount: 0,
          monthKey,
          businessId,
        });
      } else {
        // Increment existing counter
        transaction.update(docRef, {
          appointmentsCount: increment(1),
        });
      }
    });
  }

  async incStaff(businessId: string): Promise<void> {
    const monthKey = this.getMonthlyKey(businessId);
    const docRef = doc(db, 'usage_counters', monthKey);
    
    await runTransaction(db, async (transaction) => {
      const docSnap = await transaction.get(docRef);
      
      if (!docSnap.exists()) {
        // Create new usage counter
        transaction.set(docRef, {
          appointmentsCount: 0,
          staffCount: 1,
          monthKey,
          businessId,
        });
      } else {
        // Increment existing counter
        transaction.update(docRef, {
          staffCount: increment(1),
        });
      }
    });
  }

  async getCurrentUsage(businessId: string): Promise<UsageCounter> {
    const monthKey = this.getMonthlyKey(businessId);
    return this.getUsage(businessId, monthKey);
  }
}

export const usageService = UsageService.getInstance();




