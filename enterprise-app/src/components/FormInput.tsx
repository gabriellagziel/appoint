"use client";

import React from "react";
import clsx from "clsx";

interface FormInputProps {
  label: string;
  icon?: React.ComponentType<{ className?: string }>;
  type?: string;
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  error?: string;
  required?: boolean;
}

export default function FormInput({ label, icon: Icon, type = "text", value, onChange, placeholder, error, required }: FormInputProps) {
  return (
    <div className="space-y-2">
      <label className="block text-sm font-medium text-neutral-200">
        {label}
      </label>
      <div className="relative">
        {Icon && (
          <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
            <Icon className="h-5 w-5 text-neutral-400" />
          </div>
        )}
        <input
          type={type}
          value={value}
          onChange={(e) => onChange(e.target.value)}
          className={clsx(
            "block w-full rounded-lg bg-neutral-900 text-neutral-100 placeholder-neutral-500",
            "border border-neutral-700 focus:ring-2 focus:ring-primary-600 focus:border-primary-600 transition-colors",
            Icon ? "pl-10 pr-3 py-2.5" : "px-3 py-2.5",
            error && "border-danger focus:ring-danger"
          )}
          placeholder={placeholder}
          aria-invalid={!!error}
          aria-describedby={error ? `${label}-error` : undefined}
          required={required}
        />
        {error && (
          <p id={`${label}-error`} className="mt-1 text-sm text-danger">
            {error}
          </p>
        )}
      </div>
    </div>
  );
}


