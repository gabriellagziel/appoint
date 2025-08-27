'use client';

import { ReactNode, useState } from 'react';
import { ChevronLeft, ChevronRight } from 'lucide-react';

interface FlowStep {
  id: string;
  title: string;
  subtitle?: string;
  content: ReactNode;
  canGoBack?: boolean;
  canGoNext?: boolean;
  onNext?: () => void;
  onBack?: () => void;
}

interface ConversationalFlowProps {
  steps: FlowStep[];
  onComplete?: () => void;
  className?: string;
}

export default function ConversationalFlow({ steps, onComplete, className = '' }: ConversationalFlowProps) {
  const [currentStep, setCurrentStep] = useState(0);
  const step = steps[currentStep];

  const goToNext = () => {
    if (step.onNext) {
      step.onNext();
    }
    if (currentStep < steps.length - 1) {
      setCurrentStep(currentStep + 1);
    } else if (onComplete) {
      onComplete();
    }
  };

  const goToPrevious = () => {
    if (step.onBack) {
      step.onBack();
    }
    if (currentStep > 0) {
      setCurrentStep(currentStep - 1);
    }
  };

  const canGoNext = step.canGoNext !== false;
  const canGoBack = step.canGoBack !== false && currentStep > 0;

  return (
    <div className={`space-y-6 ${className}`}>
      {/* Progress indicator */}
      <div className="flex items-center justify-between">
        <div className="text-sm text-gray-500">
          Step {currentStep + 1} of {steps.length}
        </div>
        <div className="flex space-x-1">
          {steps.map((_, index) => (
            <div
              key={index}
              className={`w-2 h-2 rounded-full ${
                index === currentStep ? 'bg-blue-500' : 'bg-gray-300'
              }`}
            />
          ))}
        </div>
      </div>

      {/* Current step content */}
      <div className="space-y-4">
        <div className="space-y-2">
          <h2 className="text-2xl font-semibold text-gray-900">{step.title}</h2>
          {step.subtitle && (
            <p className="text-gray-600 text-lg">{step.subtitle}</p>
          )}
        </div>
        
        <div className="space-y-4">
          {step.content}
        </div>
      </div>

      {/* Navigation */}
      <div className="flex justify-between pt-4">
        <button
          onClick={goToPrevious}
          disabled={!canGoBack}
          className={`
            flex items-center space-x-2 px-4 py-2 rounded-xl border-2
            transition-colors duration-200
            ${canGoBack 
              ? 'border-gray-300 text-gray-700 hover:bg-gray-50 hover:border-gray-400' 
              : 'border-gray-200 text-gray-400 cursor-not-allowed'
            }
          `}
        >
          <ChevronLeft className="w-4 h-4" />
          <span>Back</span>
        </button>

        <button
          onClick={goToNext}
          disabled={!canGoNext}
          className={`
            flex items-center space-x-2 px-6 py-2 rounded-xl bg-blue-600 text-white
            transition-colors duration-200
            ${canGoNext 
              ? 'hover:bg-blue-700 focus:ring-2 focus:ring-blue-500 focus:ring-offset-2' 
              : 'bg-gray-400 cursor-not-allowed'
            }
          `}
        >
          <span>{currentStep === steps.length - 1 ? 'Complete' : 'Next'}</span>
          <ChevronRight className="w-4 h-4" />
        </button>
      </div>
    </div>
  );
}

