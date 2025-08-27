'use client';

import { ReactNode } from 'react';

interface ChoiceCardProps {
  emoji: string;
  title: string;
  subtitle?: string;
  onClick: () => void;
  className?: string;
  disabled?: boolean;
}

export default function ChoiceCard({ 
  emoji, 
  title, 
  subtitle, 
  onClick, 
  className = '',
  disabled = false 
}: ChoiceCardProps) {
  return (
    <button
      onClick={onClick}
      disabled={disabled}
      className={`
        w-full rounded-2xl border-2 border-gray-200 p-4 text-left hover:shadow-md 
        transition-all duration-200 hover:border-blue-300 hover:bg-blue-50
        focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500
        disabled:opacity-50 disabled:cursor-not-allowed disabled:hover:shadow-none
        disabled:hover:border-gray-200 disabled:hover:bg-transparent
        ${className}
      `}
    >
      <div className="text-3xl mb-3">{emoji}</div>
      <div className="font-semibold text-gray-900 text-base mb-1">{title}</div>
      {subtitle && (
        <div className="text-sm text-gray-600">{subtitle}</div>
      )}
    </button>
  );
}

