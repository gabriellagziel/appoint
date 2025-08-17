import React from 'react';

type DivPropsWithValue = React.HTMLAttributes<HTMLDivElement> & {
  value?: string;
  defaultValue?: string;
  onValueChange?: (v: string) => void;
};

type ButtonPropsWithValue = React.ButtonHTMLAttributes<HTMLButtonElement> & {
  value?: string;
  asChild?: boolean;
};

export const Tabs: React.FC<DivPropsWithValue> = ({ children, ...props }) => (
  <div {...props}>{children}</div>
);
export const TabsList: React.FC<DivPropsWithValue> = ({ children, ...props }) => (
  <div {...props}>{children}</div>
);
export const TabsTrigger: React.FC<ButtonPropsWithValue> = ({ children, asChild, ...props }) => (
  asChild ? <>{children}</> : <button {...props}>{children}</button>
);
export const TabsContent: React.FC<DivPropsWithValue> = ({ children, ...props }) => (
  <div {...props}>{children}</div>
);


