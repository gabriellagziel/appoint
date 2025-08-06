import { db } from '@/lib/firebase';
import {
  addDoc,
  collection,
  deleteDoc,
  doc,
  getDoc,
  getDocs,
  orderBy,
  query,
  Timestamp,
  updateDoc,
  where
} from 'firebase/firestore';

export interface Appointment {
  id: string;
  customerName: string;
  customerEmail: string;
  customerPhone: string;
  service: string;
  date: string;
  time: string;
  duration: number; // in minutes
  status: 'pending' | 'confirmed' | 'cancelled';
  notes?: string;
  businessId: string;
  createdAt: Timestamp;
  updatedAt: Timestamp;
}

export interface CreateAppointmentData {
  customerName: string;
  customerEmail: string;
  customerPhone: string;
  service: string;
  date: string;
  time: string;
  duration: number;
  notes?: string;
  businessId: string;
}

export interface UpdateAppointmentData {
  customerName?: string;
  customerEmail?: string;
  customerPhone?: string;
  service?: string;
  date?: string;
  time?: string;
  duration?: number;
  status?: 'pending' | 'confirmed' | 'cancelled';
  notes?: string;
}

const COLLECTION_NAME = 'appointments';

/**
 * Get all appointments for a business
 */
export const getAppointments = async (businessId: string): Promise<Appointment[]> => {
  try {
    const q = query(
      collection(db, COLLECTION_NAME),
      where('businessId', '==', businessId),
      orderBy('date', 'desc')
    );

    const querySnapshot = await getDocs(q);
    const appointments: Appointment[] = [];

    querySnapshot.forEach((doc) => {
      appointments.push({
        id: doc.id,
        ...doc.data()
      } as Appointment);
    });

    return appointments;
  } catch (error) {
    console.error('Error fetching appointments:', error);
    throw new Error('Failed to fetch appointments');
  }
};

/**
 * Get a single appointment by ID
 */
export const getAppointment = async (appointmentId: string): Promise<Appointment | null> => {
  try {
    const docRef = doc(db, COLLECTION_NAME, appointmentId);
    const docSnap = await getDoc(docRef);

    if (docSnap.exists()) {
      return {
        id: docSnap.id,
        ...docSnap.data()
      } as Appointment;
    }

    return null;
  } catch (error) {
    console.error('Error fetching appointment:', error);
    throw new Error('Failed to fetch appointment');
  }
};

/**
 * Create a new appointment
 */
export const createAppointment = async (data: CreateAppointmentData): Promise<string> => {
  try {
    const appointmentData = {
      ...data,
      status: 'pending' as const,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now()
    };

    const docRef = await addDoc(collection(db, COLLECTION_NAME), appointmentData);
    return docRef.id;
  } catch (error) {
    console.error('Error creating appointment:', error);
    throw new Error('Failed to create appointment');
  }
};

/**
 * Update an existing appointment
 */
export const updateAppointment = async (
  appointmentId: string,
  data: UpdateAppointmentData
): Promise<void> => {
  try {
    const docRef = doc(db, COLLECTION_NAME, appointmentId);
    await updateDoc(docRef, {
      ...data,
      updatedAt: Timestamp.now()
    });
  } catch (error) {
    console.error('Error updating appointment:', error);
    throw new Error('Failed to update appointment');
  }
};

/**
 * Delete an appointment
 */
export const deleteAppointment = async (appointmentId: string): Promise<void> => {
  try {
    const docRef = doc(db, COLLECTION_NAME, appointmentId);
    await deleteDoc(docRef);
  } catch (error) {
    console.error('Error deleting appointment:', error);
    throw new Error('Failed to delete appointment');
  }
};

/**
 * Update appointment status
 */
export const updateAppointmentStatus = async (
  appointmentId: string,
  status: 'pending' | 'confirmed' | 'cancelled'
): Promise<void> => {
  try {
    const docRef = doc(db, COLLECTION_NAME, appointmentId);
    await updateDoc(docRef, {
      status,
      updatedAt: Timestamp.now()
    });
  } catch (error) {
    console.error('Error updating appointment status:', error);
    throw new Error('Failed to update appointment status');
  }
}; 