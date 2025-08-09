'use client';

import { useState } from 'react';
import { doc, addDoc, collection, serverTimestamp } from 'firebase/firestore';
import { db } from '@/lib/firebase';
import { CreateAppointmentData } from '@/lib/types/appointment';
import { featureGating } from '@/services/featureGating.service';
import { usageService } from '@/services/usage.service';
import UpgradePrompt from '@/components/billing/UpgradePrompt';

interface CreateAppointmentModalProps {
  businessId: string;
  selectedTime: string;
  date: Date;
  onClose: () => void;
}

export default function CreateAppointmentModal({ 
  businessId, 
  selectedTime, 
  date, 
  onClose 
}: CreateAppointmentModalProps) {
  const [formData, setFormData] = useState({
    customerId: '',
    staffId: '',
    serviceId: '',
    notes: '',
    location: '',
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [showUpgradePrompt, setShowUpgradePrompt] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);

    try {
      // Check plan limits before creating appointment
      await featureGating.assertWithinLimits(businessId, 'appointments');
      
      // Parse selected time
      const [hours, minutes] = selectedTime.split(':').map(Number);
      const startAt = new Date(date);
      startAt.setHours(hours, minutes, 0, 0);
      
      const endAt = new Date(startAt);
      endAt.setHours(hours + 1, minutes, 0, 0); // Default 1 hour duration

      const appointmentData: CreateAppointmentData = {
        businessId,
        customerId: formData.customerId || undefined,
        staffId: formData.staffId || undefined,
        serviceId: formData.serviceId || undefined,
        startAt: startAt.toISOString(),
        endAt: endAt.toISOString(),
        notes: formData.notes || undefined,
        location: formData.location || undefined,
        createdBy: 'business',
      };

      // Create appointment
      const docRef = await addDoc(collection(db, 'appointments'), {
        ...appointmentData,
        status: 'pending',
        createdAt: serverTimestamp(),
        updatedAt: serverTimestamp(),
      });

      // Increment usage counter
      await usageService.incAppointments(businessId);

      onClose();
    } catch (error: any) {
      console.error('Error creating appointment:', error);
      
      if (error.message.includes('limit exceeded')) {
        setShowUpgradePrompt(true);
      } else {
        setError(error.message || 'Failed to create appointment');
      }
    } finally {
      setLoading(false);
    }
  };

  const handleInputChange = (field: string, value: string) => {
    setFormData(prev => ({
      ...prev,
      [field]: value,
    }));
  };

  if (showUpgradePrompt) {
    return (
      <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
        <div className="bg-white rounded-lg p-6 max-w-md w-full mx-4">
          <UpgradePrompt
            currentPlan="free"
            missingFeature="appointments"
            onClose={() => {
              setShowUpgradePrompt(false);
              onClose();
            }}
          />
        </div>
      </div>
    );
  }

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div className="bg-white rounded-lg p-6 max-w-md w-full mx-4 max-h-[90vh] overflow-y-auto">
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-lg font-semibold text-gray-900">
            Create Appointment
          </h2>
          <button
            onClick={onClose}
            className="text-gray-400 hover:text-gray-600 transition-colors"
            aria-label="Close modal"
          >
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Time
            </label>
            <input
              type="text"
              value={selectedTime}
              disabled
              className="w-full px-3 py-2 border border-gray-300 rounded-md bg-gray-50 text-gray-500"
              aria-label="Selected appointment time"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Customer ID (Optional)
            </label>
            <input
              type="text"
              value={formData.customerId}
              onChange={(e) => handleInputChange('customerId', e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              placeholder="Enter customer ID"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Staff ID (Optional)
            </label>
            <input
              type="text"
              value={formData.staffId}
              onChange={(e) => handleInputChange('staffId', e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              placeholder="Enter staff ID"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Service ID (Optional)
            </label>
            <input
              type="text"
              value={formData.serviceId}
              onChange={(e) => handleInputChange('serviceId', e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              placeholder="Enter service ID"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Notes (Optional)
            </label>
            <textarea
              value={formData.notes}
              onChange={(e) => handleInputChange('notes', e.target.value)}
              rows={3}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              placeholder="Enter appointment notes"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Location (Optional)
            </label>
            <input
              type="text"
              value={formData.location}
              onChange={(e) => handleInputChange('location', e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              placeholder="Enter location"
            />
          </div>

          {error && (
            <div className="text-red-600 text-sm bg-red-50 p-3 rounded-md">
              {error}
            </div>
          )}

          <div className="flex gap-3 pt-4">
            <button
              type="button"
              onClick={onClose}
              className="flex-1 px-4 py-2 border border-gray-300 text-gray-700 rounded-md hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              Cancel
            </button>
            <button
              type="submit"
              disabled={loading}
              className="flex-1 px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 disabled:opacity-50"
            >
              {loading ? 'Creating...' : 'Create Appointment'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
