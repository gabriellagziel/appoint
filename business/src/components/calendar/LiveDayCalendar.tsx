'use client';

import { useEffect, useState, useRef } from 'react';
import { collection, query, where, orderBy, onSnapshot } from 'firebase/firestore';
import { db } from '@/lib/firebase';
import { Appointment } from '@/lib/types/appointment';
import CreateAppointmentModal from './CreateAppointmentModal';

interface LiveDayCalendarProps {
  businessId: string;
  date: Date;
}

interface TimeSlot {
  time: string;
  appointments: Appointment[];
}

export default function LiveDayCalendar({ businessId, date }: LiveDayCalendarProps) {
  const [appointments, setAppointments] = useState<Appointment[]>([]);
  const [loading, setLoading] = useState(true);
  const [showCreateModal, setShowCreateModal] = useState(false);
  const [selectedTimeSlot, setSelectedTimeSlot] = useState<string>('');
  const containerRef = useRef<HTMLDivElement>(null);

  // Generate time slots from 8 AM to 8 PM
  const timeSlots: TimeSlot[] = Array.from({ length: 13 }, (_, i) => {
    const hour = i + 8;
    const time = `${hour.toString().padStart(2, '0')}:00`;
    return {
      time,
      appointments: [],
    };
  });

  useEffect(() => {
    if (!businessId) return;

    // Create date range for the selected day
    const startOfDay = new Date(date);
    startOfDay.setHours(0, 0, 0, 0);
    
    const endOfDay = new Date(date);
    endOfDay.setHours(23, 59, 59, 999);

    const startAtStr = startOfDay.toISOString();
    const endAtStr = endOfDay.toISOString();

    // Query appointments for the day
    const appointmentsQuery = query(
      collection(db, 'appointments'),
      where('businessId', '==', businessId),
      where('startAt', '>=', startAtStr),
      where('startAt', '<=', endAtStr),
      orderBy('startAt', 'asc')
    );

    const unsubscribe = onSnapshot(appointmentsQuery, (snapshot) => {
      const appointmentsData: Appointment[] = [];
      snapshot.forEach((doc) => {
        appointmentsData.push({ id: doc.id, ...doc.data() } as Appointment);
      });
      
      setAppointments(appointmentsData);
      setLoading(false);
    }, (error) => {
      console.error('Error fetching appointments:', error);
      setLoading(false);
    });

    return () => unsubscribe();
  }, [businessId, date]);

  // Auto-scroll to current time
  useEffect(() => {
    if (!loading && containerRef.current) {
      const now = new Date();
      const currentHour = now.getHours();
      const currentMinute = now.getMinutes();
      
      // Find the closest time slot
      const currentTimeIndex = Math.max(0, currentHour - 8);
      const scrollElement = containerRef.current.children[currentTimeIndex] as HTMLElement;
      
      if (scrollElement) {
        scrollElement.scrollIntoView({ 
          behavior: 'smooth', 
          block: 'center' 
        });
      }
    }
  }, [loading]);

  // Group appointments by time slot
  const timeSlotsWithAppointments = timeSlots.map(slot => ({
    ...slot,
    appointments: appointments.filter(apt => {
      const aptHour = new Date(apt.startAt).getHours();
      return aptHour === parseInt(slot.time.split(':')[0]);
    })
  }));

  const handleTimeSlotClick = (time: string) => {
    setSelectedTimeSlot(time);
    setShowCreateModal(true);
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'confirmed': return 'bg-green-100 text-green-800';
      case 'pending': return 'bg-yellow-100 text-yellow-800';
      case 'cancelled': return 'bg-red-100 text-red-800';
      default: return 'bg-gray-100 text-gray-800';
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  return (
    <div className="bg-white rounded-lg shadow">
      <div className="p-4 border-b border-gray-200">
        <h2 className="text-lg font-semibold text-gray-900">
          {date.toLocaleDateString('en-US', { 
            weekday: 'long', 
            year: 'numeric', 
            month: 'long', 
            day: 'numeric' 
          })}
        </h2>
      </div>
      
      <div 
        ref={containerRef}
        className="max-h-96 overflow-y-auto"
      >
        {timeSlotsWithAppointments.map((slot, index) => (
          <div 
            key={slot.time}
            className="border-b border-gray-100 hover:bg-gray-50 transition-colors cursor-pointer"
            onClick={() => handleTimeSlotClick(slot.time)}
          >
            <div className="flex items-start p-4">
              <div className="w-16 text-sm font-medium text-gray-500">
                {slot.time}
              </div>
              
              <div className="flex-1 ml-4">
                {slot.appointments.length > 0 ? (
                  slot.appointments.map((appointment) => (
                    <div 
                      key={appointment.id}
                      className="mb-2 p-3 bg-blue-50 rounded-lg border border-blue-200"
                    >
                      <div className="flex items-center justify-between">
                        <div>
                          <h4 className="font-medium text-gray-900">
                            {appointment.customerId || 'Unnamed Customer'}
                          </h4>
                          <p className="text-sm text-gray-600">
                            {appointment.notes || 'No notes'}
                          </p>
                        </div>
                        <span className={`px-2 py-1 text-xs font-medium rounded-full ${getStatusColor(appointment.status)}`}>
                          {appointment.status}
                        </span>
                      </div>
                    </div>
                  ))
                ) : (
                  <div className="text-sm text-gray-400 italic">
                    Click to add appointment
                  </div>
                )}
              </div>
            </div>
          </div>
        ))}
      </div>

      {showCreateModal && (
        <CreateAppointmentModal
          businessId={businessId}
          selectedTime={selectedTimeSlot}
          date={date}
          onClose={() => setShowCreateModal(false)}
        />
      )}
    </div>
  );
}




