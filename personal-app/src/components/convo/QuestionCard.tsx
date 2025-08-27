'use client';

import { ReactNode } from 'react';

interface QuestionCardProps {
  title: string;
  subtitle?: string;
  children: ReactNode;
  className?: string;
}

export default function QuestionCard({ title, subtitle, children, className = '' }: QuestionCardProps) {
  return (
    <section className={`space-y-4 ${className}`}>
      <div className="space-y-2">
        <h2 className="text-xl font-semibold text-gray-900">{title}</h2>
        {subtitle && (
          <p className="text-gray-600 text-base">{subtitle}</p>
        )}
      </div>
      <div className="space-y-3">
        {children}
      </div>
    </section>
  );
}

