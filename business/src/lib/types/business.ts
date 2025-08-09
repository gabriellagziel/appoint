export type BusinessPlan = 'free' | 'pro' | 'enterprise';

export interface BusinessLimits {
  maxAppointmentsPerMonth: number;
  maxStaff: number;
  enableBranding: boolean;
  enableCustomFields: boolean;
}

export interface BusinessProfile {
  id: string;
  name: string;
  plan: BusinessPlan;
  limits: BusinessLimits;
  publicBookingEnabled: boolean;
  publicServices: string[];
  timezone?: string;
  createdAt: string;
  updatedAt: string;
}

export interface UsageCounter {
  appointmentsCount: number;
  staffCount: number;
  monthKey: string;
  businessId: string;
}




