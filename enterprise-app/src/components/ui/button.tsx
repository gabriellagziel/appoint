import React from 'react';

interface ButtonProps {
    children: React.ReactNode;
    className?: string;
    onClick?: () => void;
    size?: 'sm' | 'md' | 'lg';
    variant?: 'default' | 'outline';
}

export function Button({ children, className = '', onClick, size = 'md', variant = 'default' }: ButtonProps) {
    const sizeClasses = {
        sm: 'px-3 py-1 text-sm',
        md: 'px-4 py-2',
        lg: 'px-6 py-3 text-lg'
    };

    const variantClasses = {
        default: 'bg-green-600 text-white hover:bg-green-700',
        outline: 'bg-transparent text-green-600 border-2 border-green-600 hover:bg-green-50'
    };

    return (
        <button
            className={`${sizeClasses[size]} ${variantClasses[variant]} rounded-lg transition-colors ${className}`}
            onClick={onClick}
        >
            {children}
        </button>
    );
}
