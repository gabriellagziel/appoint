import React from 'react';

type ButtonProps = React.ButtonHTMLAttributes<HTMLButtonElement> & {
  variant?: string;
  size?: string;
  asChild?: boolean;
};

export const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ children, asChild, variant, size, ...props }, ref) => (
    asChild ? <>{children}</> : <button ref={ref} {...props}>{children}</button>
  )
);

Button.displayName = 'Button';


