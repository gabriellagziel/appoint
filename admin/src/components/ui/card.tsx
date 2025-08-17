import React from 'react';

export const Card: React.FC<React.ComponentProps<'div'>> = ({ children, ...props }) => (
  <div {...props}>{children}</div>
);
export const CardHeader: React.FC<React.ComponentProps<'div'>> = ({ children, ...props }) => (
  <div {...props}>{children}</div>
);
export const CardTitle: React.FC<React.ComponentProps<'h3'>> = ({ children, ...props }) => (
  <h3 {...props}>{children}</h3>
);
export const CardContent: React.FC<React.ComponentProps<'div'>> = ({ children, ...props }) => (
  <div {...props}>{children}</div>
);


