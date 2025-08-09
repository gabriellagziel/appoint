'use client';

import { BusinessPlan } from '@/lib/types/business';
import Link from 'next/link';

interface UpgradePromptProps {
  currentPlan: BusinessPlan;
  missingFeature: string;
  onClose?: () => void;
}

export default function UpgradePrompt({ currentPlan, missingFeature, onClose }: UpgradePromptProps) {
  const getUpgradeMessage = () => {
    switch (missingFeature) {
      case 'appointments':
        return 'You have reached your appointment limit for this month.';
      case 'staff':
        return 'You have reached your staff member limit.';
      case 'branding':
        return 'Custom branding is available on Pro and Enterprise plans.';
      case 'customFields':
        return 'Custom fields are available on Pro and Enterprise plans.';
      default:
        return `This feature requires an upgrade from your current ${currentPlan} plan.`;
    }
  };

  const getPlanRecommendation = () => {
    if (currentPlan === 'free') {
      return 'Pro';
    } else if (currentPlan === 'pro') {
      return 'Enterprise';
    }
    return 'Enterprise';
  };

  return (
    <div className="bg-gradient-to-r from-blue-50 to-indigo-50 border border-blue-200 rounded-lg p-6 mb-6">
      <div className="flex items-start justify-between">
        <div className="flex-1">
          <div className="flex items-center mb-2">
            <div className="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center mr-3">
              <svg className="w-4 h-4 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </div>
            <h3 className="text-lg font-semibold text-gray-900">Upgrade Required</h3>
          </div>
          
          <p className="text-gray-700 mb-4">
            {getUpgradeMessage()}
          </p>
          
          <div className="flex flex-col sm:flex-row gap-3">
            <Link
              href="/dashboard/billing"
              className="inline-flex items-center px-4 py-2 bg-blue-600 text-white text-sm font-medium rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-colors"
            >
              Upgrade to {getPlanRecommendation()}
            </Link>
            
            {onClose && (
              <button
                onClick={onClose}
                className="inline-flex items-center px-4 py-2 border border-gray-300 text-gray-700 text-sm font-medium rounded-md hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-colors"
              >
                Dismiss
              </button>
            )}
          </div>
        </div>
        
        <button
          onClick={onClose}
          className="ml-4 text-gray-400 hover:text-gray-600 transition-colors"
          aria-label="Close upgrade prompt"
        >
          <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
      </div>
    </div>
  );
}
