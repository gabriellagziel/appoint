import { StaffAvailability } from './types/availability';

export function iso(date: Date): string {
  return date.toISOString();
}

export function toBusinessTZ(date: Date, tz: string): Date {
  // For MVP, we'll use UTC and handle timezone conversion later
  // In production, use a library like date-fns-tz
  return date;
}

export function getDayWindow(date: Date, tz: string): { startISO: string; endISO: string } {
  const start = new Date(date);
  start.setHours(0, 0, 0, 0);
  
  const end = new Date(date);
  end.setHours(23, 59, 59, 999);
  
  return {
    startISO: start.toISOString(),
    endISO: end.toISOString()
  };
}

export function expandWeeklyToDay(
  availability: StaffAvailability, 
  date: Date
): Array<{startISO: string; endISO: string}> {
  const dayOfWeek = date.getDay(); // 0 = Sunday, 6 = Saturday
  const dateISO = date.toISOString().split('T')[0]; // YYYY-MM-DD
  
  // Check for exceptions first
  if (availability.exceptions?.[dateISO]) {
    const exception = availability.exceptions[dateISO];
    if (exception.closed) {
      return [];
    }
    if (exception.ranges) {
      return exception.ranges.map(range => ({
        startISO: `${dateISO}T${range.start}:00.000Z`,
        endISO: `${dateISO}T${range.end}:00.000Z`
      }));
    }
  }
  
  // Use weekly pattern
  const dayPattern = availability.weekly.find(w => w.dow === dayOfWeek);
  if (!dayPattern) {
    return [];
  }
  
  return dayPattern.ranges.map(range => ({
    startISO: `${dateISO}T${range.start}:00.000Z`,
    endISO: `${dateISO}T${range.end}:00.000Z`
  }));
}

export function isOverlapping(
  slot1: { startISO: string; endISO: string },
  slot2: { startISO: string; endISO: string }
): boolean {
  const start1 = new Date(slot1.startISO);
  const end1 = new Date(slot1.endISO);
  const start2 = new Date(slot2.startISO);
  const end2 = new Date(slot2.endISO);
  
  return start1 < end2 && start2 < end1;
}

export function subtractAppointments(
  availabilitySlots: Array<{startISO: string; endISO: string}>,
  appointments: Array<{startAt: string; endAt: string}>
): Array<{startISO: string; endISO: string}> {
  let result = [...availabilitySlots];
  
  for (const appointment of appointments) {
    const newResult: Array<{startISO: string; endISO: string}> = [];
    
    for (const slot of result) {
      const appointmentSlot = { startISO: appointment.startAt, endISO: appointment.endAt }; if (!isOverlapping(slot, appointmentSlot)) {
        newResult.push(slot);
        continue;
      }
      
      // Split slot around appointment
      const slotStart = new Date(slot.startISO);
      const slotEnd = new Date(slot.endISO);
      const apptStart = new Date(appointment.startAt);
      const apptEnd = new Date(appointment.endAt);
      
      // Before appointment
      if (slotStart < apptStart) {
        newResult.push({
          startISO: slot.startISO,
          endISO: apptStart.toISOString()
        });
      }
      
      // After appointment
      if (slotEnd > apptEnd) {
        newResult.push({
          startISO: apptEnd.toISOString(),
          endISO: slot.endISO
        });
      }
    }
    
    result = newResult;
  }
  
  return result;
}






