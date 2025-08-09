'use client';

import { useEffect, useState } from 'react';
import { useParams } from 'next/navigation';

interface BusinessInfo {
  id: string;
  name: string;
  timezone: string;
  publicServices: string[];
  branding: any;
}

interface AvailabilitySlot {
  staffId: string;
  startTime: string;
  endTime: string;
  duration: number;
}

interface OpenCall {
  id: string;
  startISO: string;
  endISO: string;
  staffId?: string;
}

export default function PublicBookingPage() {
  const params = useParams();
  const businessId = params.businessId as string;
  
  const [business, setBusiness] = useState<BusinessInfo | null>(null);
  const [selectedDate, setSelectedDate] = useState<string>('');
  const [availability, setAvailability] = useState<AvailabilitySlot[]>([]);
  const [openCalls, setOpenCalls] = useState<OpenCall[]>([]);
  const [loading, setLoading] = useState(true);
  const [booking, setBooking] = useState(false);
  const [customerInfo, setCustomerInfo] = useState({
    name: '',
    email: '',
    phone: ''
  });

  useEffect(() => {
    loadBusinessInfo();
    loadOpenCalls();
  }, [businessId]);

  const loadBusinessInfo = async () => {
    try {
      const response = await fetch(`/api/public/business/${businessId}`);
      if (response.ok) {
        const data = await response.json();
        setBusiness(data);
        setSelectedDate(new Date().toISOString().split('T')[0]);
      } else {
        console.error('Failed to load business info');
      }
    } catch (error) {
      console.error('Error loading business info:', error);
    } finally {
      setLoading(false);
    }
  };

  const loadOpenCalls = async () => {
    try {
      const response = await fetch(`/api/open-calls/${businessId}`);
      if (response.ok) {
        const data = await response.json();
        setOpenCalls(data.openCalls || []);
      }
    } catch (error) {
      console.error('Error loading open calls:', error);
    }
  };

  const loadAvailability = async (date: string) => {
    try {
      const response = await fetch(`/api/public/business/${businessId}/availability?date=${date}`);
      if (response.ok) {
        const data = await response.json();
        setAvailability(data.slots || []);
      }
    } catch (error) {
      console.error('Error loading availability:', error);
    }
  };

  const handleDateChange = (date: string) => {
    setSelectedDate(date);
    loadAvailability(date);
  };

  const handleBooking = async (slot: AvailabilitySlot) => {
    if (!customerInfo.name || !customerInfo.email) {
      alert('Please fill in your name and email');
      return;
    }

    setBooking(true);
    try {
      const response = await fetch('/api/public/book', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          businessId,
          slot: {
            startISO: slot.startTime,
            endISO: slot.endTime
          },
          staffId: slot.staffId,
          customer: customerInfo,
          notes: ''
        }),
      });

      if (response.ok) {
        const result = await response.json();
        alert(`Booking successful! Your meeting ID is: ${result.meetingId}`);
        // Reload availability to reflect the booking
        loadAvailability(selectedDate);
      } else {
        const error = await response.json();
        alert(`Booking failed: ${error.error}`);
      }
    } catch (error) {
      console.error('Error booking appointment:', error);
      alert('Booking failed. Please try again.');
    } finally {
      setBooking(false);
    }
  };

  const formatTime = (isoString: string) => {
    return new Date(isoString).toLocaleTimeString('en-US', {
      hour: 'numeric',
      minute: '2-digit',
      hour12: true
    });
  };

  const isOpenCallActive = (openCall: OpenCall) => {
    const now = new Date();
    const start = new Date(openCall.startISO);
    const end = new Date(openCall.endISO);
    return now >= start && now <= end;
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  if (!business) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <h1 className="text-2xl font-bold text-gray-900 mb-4">Business Not Found</h1>
          <p className="text-gray-600">This business is not available for public booking.</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="max-w-4xl mx-auto px-4 py-8">
        {/* Header */}
        <div className="bg-white rounded-lg shadow p-6 mb-6">
          <h1 className="text-3xl font-bold text-gray-900 mb-2">{business.name}</h1>
          <p className="text-gray-600">Book your appointment online</p>
        </div>

        {/* Open Calls Banner */}
        {openCalls.some(isOpenCallActive) && (
          <div className="bg-green-50 border border-green-200 rounded-lg p-4 mb-6">
            <div className="flex items-center">
              <div className="flex-shrink-0">
                <svg className="w-5 h-5 text-green-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
              </div>
              <div className="ml-3">
                <h3 className="text-sm font-medium text-green-800">Available Now!</h3>
                <p className="text-sm text-green-700 mt-1">
                  This business has immediate availability. Book now for instant confirmation.
                </p>
              </div>
            </div>
          </div>
        )}

        {/* Customer Info */}
        <div className="bg-white rounded-lg shadow p-6 mb-6">
          <h2 className="text-lg font-semibold text-gray-900 mb-4">Your Information</h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Name</label>
              <input
                type="text"
                value={customerInfo.name}
                onChange={(e) => setCustomerInfo(prev => ({ ...prev, name: e.target.value }))}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="Your name"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Email</label>
              <input
                type="email"
                value={customerInfo.email}
                onChange={(e) => setCustomerInfo(prev => ({ ...prev, email: e.target.value }))}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="your@email.com"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Phone (Optional)</label>
              <input
                type="tel"
                value={customerInfo.phone}
                onChange={(e) => setCustomerInfo(prev => ({ ...prev, phone: e.target.value }))}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="(555) 123-4567"
              />
            </div>
          </div>
        </div>

        {/* Date Selection */}
        <div className="bg-white rounded-lg shadow p-6 mb-6">
          <h2 className="text-lg font-semibold text-gray-900 mb-4">Select Date</h2>
          <input
            type="date"
            value={selectedDate}
            onChange={(e) => handleDateChange(e.target.value)}
            min={new Date().toISOString().split('T')[0]}
            className="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            aria-label="Select appointment date"
          />
        </div>

        {/* Availability */}
        {selectedDate && (
          <div className="bg-white rounded-lg shadow p-6">
            <h2 className="text-lg font-semibold text-gray-900 mb-4">
              Available Times for {new Date(selectedDate).toLocaleDateString()}
            </h2>
            
            {availability.length === 0 ? (
              <div className="text-center py-8">
                <p className="text-gray-500">No available times for this date.</p>
                <p className="text-sm text-gray-400 mt-2">Try selecting a different date.</p>
              </div>
            ) : (
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                {availability.map((slot, index) => (
                  <button
                    key={index}
                    onClick={() => handleBooking(slot)}
                    disabled={booking}
                    className="p-4 border border-gray-200 rounded-lg hover:border-blue-300 hover:bg-blue-50 transition-colors text-left"
                  >
                    <div className="font-medium text-gray-900">
                      {formatTime(slot.startTime)} - {formatTime(slot.endTime)}
                    </div>
                    <div className="text-sm text-gray-600">
                      {slot.duration} minutes
                    </div>
                  </button>
                ))}
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  );
}
