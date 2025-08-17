import React from 'react';

type DivBaseProps = Omit<React.HTMLAttributes<HTMLDivElement>, 'onChange'>;
type DivPropsWithSelect = DivBaseProps & {
  value?: string;
  defaultValue?: string;
  onValueChange?: (v: string) => void;
  onChange?: (e: any) => void;
};

type ButtonPropsWithSelect = React.ButtonHTMLAttributes<HTMLButtonElement> & {
  value?: string;
  asChild?: boolean;
};

type SpanPropsWithPlaceholder = React.HTMLAttributes<HTMLSpanElement> & {
  placeholder?: string;
};

export const Select: React.FC<DivPropsWithSelect> = ({ children, ...props }) => (
  <div {...props}>{children}</div>
);
export const SelectTrigger: React.FC<ButtonPropsWithSelect> = ({ children, asChild, ...props }) => (
  asChild ? <>{children}</> : <button {...props}>{children}</button>
);
export const SelectValue: React.FC<SpanPropsWithPlaceholder> = ({ children, ...props }) => (
  <span {...props}>{children}</span>
);
export const SelectContent: React.FC<DivPropsWithSelect> = ({ children, ...props }) => (
  <div {...props}>{children}</div>
);
export const SelectItem: React.FC<DivPropsWithSelect> = ({ children, ...props }) => (
  <div {...props}>{children}</div>
);


