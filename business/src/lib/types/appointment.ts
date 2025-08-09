export type AppointmentStatus = 'pending' | 'confirmed' | 'declined' | 'suggested' | 'cancelled';

export interface Appointment {
  id: string;
  businessId: string;
  customerId?: string;
  staffId?: string;
  serviceId?: string;
  startAt: string;
  endAt: string;
  status: AppointmentStatus;
  notes?: string;
  location?: string;
  createdBy: 'business' | 'user';
  createdAt: string;
  updatedAt: string;
}

export interface CreateAppointmentData {
  businessId: string;
  customerId?: string;
  staffId?: string;
  serviceId?: string;
  startAt: string;
  endAt: string;
  notes?: string;
  location?: string;
  createdBy: 'business' | 'user';
}




