import { LucideIcon } from 'lucide-react';
import React from 'react';

interface FormInputProps {
  label?: string;
  error?: string;
  icon?: LucideIcon;
  helperText?: string;
  required?: boolean;
  onChange?: (value: string) => void;
  value?: string;
  type?: string;
  placeholder?: string;
  className?: string;
  id?: string;
  disabled?: boolean;
}

const FormInput: React.FC<FormInputProps> = ({
  label,
  error,
  icon: Icon,
  helperText,
  required = false,
  className = '',
  id,
  onChange,
  value,
  type = 'text',
  placeholder,
  disabled,
  ...props
}) => {
  const inputId = id || `input-${Math.random().toString(36).substr(2, 9)}`;

  const baseClasses = 'w-full px-3 py-2 border rounded-lg transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-offset-0';
  const stateClasses = error
    ? 'border-error-300 focus:border-error-500 focus:ring-error-500'
    : 'border-neutral-300 focus:border-primary-500 focus:ring-primary-500';
  const iconClasses = Icon ? 'pl-10' : '';

  const classes = `${baseClasses} ${stateClasses} ${iconClasses} ${className}`;

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (onChange) {
      onChange(e.target.value);
    }
  };

  return (
    <div className="space-y-2">
      {label && (
        <label htmlFor={inputId} className="block text-sm font-medium text-neutral-700">
          {label}
          {required && <span className="text-error-500 ml-1">*</span>}
        </label>
      )}

      <div className="relative">
        {Icon && (
          <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
            <Icon className="h-5 w-5 text-neutral-400" />
          </div>
        )}

        <input
          id={inputId}
          className={classes}
          type={type}
          value={value}
          placeholder={placeholder}
          disabled={disabled}
          aria-describedby={error ? `${inputId}-error` : helperText ? `${inputId}-description` : undefined}
          onChange={handleChange}
          {...props}
        />
      </div>

      {error && (
        <p id={`${inputId}-error`} className="text-sm text-error-600">
          {error}
        </p>
      )}

      {helperText && !error && (
        <p id={`${inputId}-description`} className="text-sm text-neutral-500">
          {helperText}
        </p>
      )}
    </div>
  );
};

export default FormInput; 