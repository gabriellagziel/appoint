import { collection, query, where, getDocs, doc, getDoc } from 'firebase/firestore';
import { db } from '@/lib/firebase';
import { StaffAvailability, DayAvailability } from '@/lib/types/availability';
import { expandWeeklyToDay, getDayWindow, subtractAppointments } from '@/lib/time';

export class AvailabilityService {
  private static instance: AvailabilityService;
  
  public static getInstance(): AvailabilityService {
    if (!AvailabilityService.instance) {
      AvailabilityService.instance = new AvailabilityService();
    }
    return AvailabilityService.instance;
  }

  async getAvailabilityForDay(
    businessId: string, 
    dateISO: string
  ): Promise<DayAvailability[]> {
    try {
      // 1. Load staff for business
      const staffQuery = query(
        collection(db, 'staff'),
        where('businessId', '==', businessId)
      );
      const staffSnapshot = await getDocs(staffQuery);
      const staffIds = staffSnapshot.docs.map(doc => doc.id);
      
      if (staffIds.length === 0) {
        return [];
      }
      
      // 2. Load appointments for the day
      const date = new Date(dateISO);
      const { startISO, endISO } = getDayWindow(date, 'UTC');
      
      const appointmentsQuery = query(
        collection(db, 'appointments'),
        where('businessId', '==', businessId),
        where('startAt', '>=', startISO),
        where('startAt', '<=', endISO)
      );
      const appointmentsSnapshot = await getDocs(appointmentsQuery);
      const appointments = appointmentsSnapshot.docs.map(doc => ({
        startAt: doc.data().startAt,
        endAt: doc.data().endAt
      }));
      
      // 3. Load availability for each staff member
      const availabilityPromises = staffIds.map(async (staffId) => {
        const availabilityDoc = await getDoc(doc(db, 'staff_availability', staffId));
        
        if (!availabilityDoc.exists()) {
          return null;
        }
        
        const availability = availabilityDoc.data() as StaffAvailability;
        
        // 4. Expand weekly pattern to day slots
        const daySlots = expandWeeklyToDay(availability, date);
        
        // 5. Subtract existing appointments
        const freeSlots = subtractAppointments(daySlots, appointments);
        
        return {
          staffId,
          slots: freeSlots.map(slot => ({
            staffId,
            startISO: slot.startISO,
            endISO: slot.endISO
          }))
        };
      });
      
      const results = await Promise.all(availabilityPromises);
      return results.filter(result => result !== null) as DayAvailability[];
      
    } catch (error) {
      console.error('Error getting availability:', error);
      return [];
    }
  }

  async findNextFreeSlot(
    businessId: string, 
    serviceId?: string
  ): Promise<{staffId: string; startISO: string; endISO: string} | null> {
    try {
      // Look for free slots in the next 7 days
      const today = new Date();
      
      for (let i = 0; i < 7; i++) {
        const date = new Date(today);
        date.setDate(today.getDate() + i);
        const dateISO = date.toISOString().split('T')[0];
        
        const availability = await this.getAvailabilityForDay(businessId, dateISO);
        
        for (const staffAvailability of availability) {
          for (const slot of staffAvailability.slots) {
            const slotStart = new Date(slot.startISO);
            if (slotStart > new Date()) {
              return {
                staffId: slot.staffId,
                startISO: slot.startISO,
                endISO: slot.endISO
              };
            }
          }
        }
      }
      
      return null;
    } catch (error) {
      console.error('Error finding next free slot:', error);
      return null;
    }
  }

  async getOpenCalls(businessId: string): Promise<any[]> {
    try {
      const openCallsQuery = query(
        collection(db, 'open_calls'),
        where('businessId', '==', businessId),
        where('status', '==', 'open')
      );
      
      const snapshot = await getDocs(openCallsQuery);
      return snapshot.docs.map(doc => ({
        id: doc.id,
        ...doc.data()
      }));
    } catch (error) {
      console.error('Error getting open calls:', error);
      return [];
    }
  }
}

export const availabilityService = AvailabilityService.getInstance();






