export interface StaffAvailability {
  id: string;            // staffId
  businessId: string;
  // weekly pattern: 0=Sun ... 6=Sat
  weekly: Array<{ 
    dow: number; 
    ranges: Array<{ start: string; end: string }> 
  }>;
  // exceptions by ISO date
  exceptions?: Record<string, { 
    closed?: boolean; 
    ranges?: Array<{start: string; end: string}> 
  }>;
  tz: string; // e.g., "Europe/Rome"
}

export interface AvailabilitySlot {
  staffId: string;
  startISO: string;
  endISO: string;
}

export interface DayAvailability {
  staffId: string;
  slots: AvailabilitySlot[];
}

export interface OpenCall {
  id: string;
  businessId: string;
  staffId?: string;
  startISO: string;
  endISO: string;
  status: 'open' | 'booked' | 'expired';
  createdAt: string;
}






