'use client';

import { ReactNode } from 'react';

interface SummaryCardProps {
  title: string;
  children: ReactNode;
  className?: string;
}

export default function SummaryCard({ title, children, className = '' }: SummaryCardProps) {
  return (
    <div className={`rounded-2xl border-2 border-gray-200 bg-gray-50 p-4 ${className}`}>
      <h3 className="font-semibold text-gray-900 mb-3 text-lg">{title}</h3>
      <div className="space-y-2 text-sm">
        {children}
      </div>
    </div>
  );
}

interface SummaryRowProps {
  label: string;
  value: string | ReactNode;
  className?: string;
}

export function SummaryRow({ label, value, className = '' }: SummaryRowProps) {
  return (
    <div className={`flex justify-between items-center py-1 ${className}`}>
      <span className="text-gray-600 font-medium">{label}:</span>
      <span className="text-gray-900 font-semibold">{value}</span>
    </div>
  );
}



