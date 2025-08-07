import React from 'react';

interface CardProps {
  children: React.ReactNode;
  className?: string;
  variant?: 'default' | 'glass' | 'elevated' | 'outlined';
  padding?: 'none' | 'sm' | 'md' | 'lg';
  hover?: boolean;
}

const Card: React.FC<CardProps> = ({
  children,
  className = '',
  variant = 'default',
  padding = 'md',
  hover = false,
}) => {
  const baseClasses = 'rounded-xl border transition-all duration-200';
  
  const variantClasses = {
    default: 'bg-white border-neutral-200 shadow-sm',
    glass: 'bg-white/80 backdrop-blur-sm border-white/20 shadow-glass',
    elevated: 'bg-white border-neutral-200 shadow-lg',
    outlined: 'bg-transparent border-neutral-300',
  };
  
  const paddingClasses = {
    none: '',
    sm: 'p-4',
    md: 'p-6',
    lg: 'p-8',
  };
  
  const hoverClasses = hover ? 'hover:shadow-lg hover:-translate-y-1' : '';
  
  const classes = `${baseClasses} ${variantClasses[variant]} ${paddingClasses[padding]} ${hoverClasses} ${className}`;
  
  return (
    <div className={classes}>
      {children}
    </div>
  );
};

export default Card; 