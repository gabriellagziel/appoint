import { collection, query, where, orderBy, limit, getDocs, addDoc, updateDoc, deleteDoc, doc } from 'firebase/firestore';
import { db } from './firebase';

export interface Appointment {
  id: string;
  businessId: string;
  customerId: string;
  customerName: string;
  date: string;
  time: string;
  service: string;
  status: 'pending' | 'confirmed' | 'cancelled';
  notes?: string;
  createdAt: Date;
  updatedAt: Date;
}

export const getAppointments = async (businessId: string): Promise<Appointment[]> => {
  try {
    const q = query(
      collection(db, 'bookings'),
      where('businessId', '==', businessId),
      orderBy('date', 'desc'),
      limit(50)
    );
    
    const querySnapshot = await getDocs(q);
    return querySnapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data(),
      createdAt: doc.data().createdAt?.toDate() || new Date(),
      updatedAt: doc.data().updatedAt?.toDate() || new Date(),
    })) as Appointment[];
  } catch (error) {
    console.error('Error fetching appointments:', error);
    return [];
  }
};

export const createAppointment = async (appointment: Omit<Appointment, 'id' | 'createdAt' | 'updatedAt'>): Promise<string> => {
  try {
    const docRef = await addDoc(collection(db, 'bookings'), {
      ...appointment,
      createdAt: new Date(),
      updatedAt: new Date(),
    });
    return docRef.id;
  } catch (error) {
    console.error('Error creating appointment:', error);
    throw error;
  }
};

export const updateAppointment = async (id: string, updates: Partial<Appointment>): Promise<void> => {
  try {
    await updateDoc(doc(db, 'bookings', id), {
      ...updates,
      updatedAt: new Date(),
    });
  } catch (error) {
    console.error('Error updating appointment:', error);
    throw error;
  }
};

export const deleteAppointment = async (id: string): Promise<void> => {
  try {
    await deleteDoc(doc(db, 'bookings', id));
  } catch (error) {
    console.error('Error deleting appointment:', error);
    throw error;
  }
};

export const getAppointmentStats = async (businessId: string) => {
  try {
    const appointments = await getAppointments(businessId);
    const now = new Date();
    const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
    
    const monthlyAppointments = appointments.filter(apt => 
      new Date(apt.date) >= startOfMonth
    );
    
    const confirmedAppointments = appointments.filter(apt => 
      apt.status === 'confirmed'
    );
    
    const pendingAppointments = appointments.filter(apt => 
      apt.status === 'pending'
    );
    
    return {
      totalAppointments: appointments.length,
      monthlyAppointments: monthlyAppointments.length,
      confirmedAppointments: confirmedAppointments.length,
      pendingAppointments: pendingAppointments.length,
      cancelledAppointments: appointments.length - confirmedAppointments.length - pendingAppointments.length,
    };
  } catch (error) {
    console.error('Error getting appointment stats:', error);
    return {
      totalAppointments: 0,
      monthlyAppointments: 0,
      confirmedAppointments: 0,
      pendingAppointments: 0,
      cancelledAppointments: 0,
    };
  }
};