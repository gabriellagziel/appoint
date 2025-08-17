import React from 'react';

export const Label: React.FC<React.ComponentProps<'label'>> = ({ children, ...props }) => (
  <label {...props}>{children}</label>
);


