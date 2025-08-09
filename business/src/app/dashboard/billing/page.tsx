'use client';

import { useAuth } from '@/contexts/AuthContext';
import { useEffect, useState } from 'react';
import { featureGating } from '@/services/featureGating.service';
import { usageService } from '@/services/usage.service';
import { BusinessProfile, BusinessPlan } from '@/lib/types/business';
import UpgradePrompt from '@/components/billing/UpgradePrompt';

export default function BillingPage() {
  const { user } = useAuth();
  const [businessProfile, setBusinessProfile] = useState<BusinessProfile | null>(null);
  const [usage, setUsage] = useState<any>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const loadData = async () => {
      if (user?.uid) {
        try {
          const profile = await featureGating.getBusinessProfile(user.uid);
          const usageData = await usageService.getCurrentUsage(user.uid);
          
          setBusinessProfile(profile);
          setUsage(usageData);
        } catch (error) {
          console.error('Error loading billing data:', error);
        } finally {
          setLoading(false);
        }
      }
    };

    loadData();
  }, [user]);

  const plans = [
    {
      name: 'Free',
      price: '$0',
      features: [
        '5 appointments per month',
        '1 staff member',
        'Basic analytics',
        'Email support',
      ],
      current: businessProfile?.plan === 'free',
    },
    {
      name: 'Pro',
      price: '$29',
      features: [
        '50 appointments per month',
        '5 staff members',
        'Custom branding',
        'Advanced analytics',
        'Priority support',
      ],
      current: businessProfile?.plan === 'pro',
    },
    {
      name: 'Enterprise',
      price: '$99',
      features: [
        'Unlimited appointments',
        'Unlimited staff',
        'Custom branding',
        'Advanced analytics',
        'API access',
        'Dedicated support',
      ],
      current: businessProfile?.plan === 'enterprise',
    },
  ];

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900">Billing & Plans</h1>
          <p className="text-gray-600 mt-2">
            Manage your subscription and billing information
          </p>
        </div>

        {/* Current Plan */}
        {businessProfile && (
          <div className="bg-white rounded-lg shadow p-6 mb-8">
            <h2 className="text-xl font-semibold text-gray-900 mb-4">Current Plan</h2>
            <div className="flex items-center justify-between">
              <div>
                <h3 className="text-lg font-medium text-gray-900">
                  {businessProfile.plan.charAt(0).toUpperCase() + businessProfile.plan.slice(1)} Plan
                </h3>
                <p className="text-gray-600">
                  {businessProfile.limits.maxAppointmentsPerMonth} appointments per month
                </p>
              </div>
              <div className="text-right">
                <p className="text-2xl font-bold text-gray-900">
                  {businessProfile.plan === 'free' ? '$0' : businessProfile.plan === 'pro' ? '$29' : '$99'}
                </p>
                <p className="text-sm text-gray-500">per month</p>
              </div>
            </div>
          </div>
        )}

        {/* Usage Stats */}
        {usage && (
          <div className="bg-white rounded-lg shadow p-6 mb-8">
            <h2 className="text-xl font-semibold text-gray-900 mb-4">Usage This Month</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <h3 className="text-sm font-medium text-gray-600">Appointments</h3>
                <p className="text-2xl font-bold text-gray-900">
                  {usage.appointmentsCount} / {businessProfile?.limits.maxAppointmentsPerMonth}
                </p>
                <div className="w-full bg-gray-200 rounded-full h-2 mt-2">
                  <div 
                    className="bg-blue-600 h-2 rounded-full transition-all duration-300"
                    style={{ 
                      width: `${Math.min((usage.appointmentsCount / (businessProfile?.limits.maxAppointmentsPerMonth || 1)) * 100, 100)}%` 
                    }}
                  ></div>
                </div>
              </div>
              <div>
                <h3 className="text-sm font-medium text-gray-600">Staff Members</h3>
                <p className="text-2xl font-bold text-gray-900">
                  {usage.staffCount} / {businessProfile?.limits.maxStaff}
                </p>
                <div className="w-full bg-gray-200 rounded-full h-2 mt-2">
                  <div 
                    className="bg-green-600 h-2 rounded-full transition-all duration-300"
                    style={{ 
                      width: `${Math.min((usage.staffCount / (businessProfile?.limits.maxStaff || 1)) * 100, 100)}%` 
                    }}
                  ></div>
                </div>
              </div>
            </div>
          </div>
        )}

        {/* Plan Comparison */}
        <div className="bg-white rounded-lg shadow p-6">
          <h2 className="text-xl font-semibold text-gray-900 mb-6">Available Plans</h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {plans.map((plan) => (
              <div
                key={plan.name}
                className={`border rounded-lg p-6 ${
                  plan.current
                    ? 'border-blue-500 bg-blue-50'
                    : 'border-gray-200 hover:border-gray-300'
                }`}
              >
                <div className="text-center">
                  <h3 className="text-lg font-semibold text-gray-900">{plan.name}</h3>
                  <p className="text-3xl font-bold text-gray-900 mt-2">{plan.price}</p>
                  <p className="text-sm text-gray-500">per month</p>
                </div>
                
                <ul className="mt-6 space-y-3">
                  {plan.features.map((feature, index) => (
                    <li key={index} className="flex items-center">
                      <svg className="w-5 h-5 text-green-500 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
                      </svg>
                      <span className="text-sm text-gray-600">{feature}</span>
                    </li>
                  ))}
                </ul>
                
                <div className="mt-6">
                  {plan.current ? (
                    <button
                      disabled
                      className="w-full px-4 py-2 bg-gray-300 text-gray-500 rounded-md cursor-not-allowed"
                    >
                      Current Plan
                    </button>
                  ) : (
                    <button className="w-full px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors">
                      Upgrade to {plan.name}
                    </button>
                  )}
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}






