"use client";
import * as React from "react";

type TabsContextValue = {
  active: string | undefined;
  setActive: (v: string) => void;
};

const TabsContext = React.createContext<TabsContextValue | null>(null);

export interface TabsProps extends React.HTMLAttributes<HTMLDivElement> {
  defaultValue?: string;
  value?: string;
  onValueChange?: (value: string) => void;
}

export const Tabs: React.FC<TabsProps> = ({
  children,
  defaultValue,
  value,
  onValueChange,
  className,
  ...rest
}) => {
  const [internal, setInternal] = React.useState<string | undefined>(defaultValue);
  const active = value !== undefined ? value : internal;
  const setActive = (v: string) => {
    if (onValueChange) onValueChange(v);
    if (value === undefined) setInternal(v);
  };
  return (
    <TabsContext.Provider value={{ active, setActive }}>
      <div className={className} {...rest}>{children}</div>
    </TabsContext.Provider>
  );
};

export const TabsList: React.FC<React.HTMLAttributes<HTMLDivElement>> = ({ children, className, ...rest }) => (
  <div className={(className ?? "") + " inline-flex rounded-md bg-muted p-1 text-muted-foreground"} {...rest}>
    {children}
  </div>
);

export interface TabsTriggerProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  value?: string;
}

export const TabsTrigger: React.FC<TabsTriggerProps> = ({ children, value, className, onClick, ...rest }) => {
  const ctx = React.useContext(TabsContext);
  const isActive = ctx?.active !== undefined && value !== undefined && ctx.active === value;
  return (
    <button
      data-state={isActive ? "active" : "inactive"}
      className={
        (className ?? "") +
        " inline-flex items-center justify-center whitespace-nowrap rounded-sm px-3 py-1 text-sm font-medium ring-offset-background transition-all focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 " +
        (isActive ? " bg-background text-foreground shadow" : "")
      }
      onClick={(e) => {
        if (value) ctx?.setActive(value);
        onClick?.(e);
      }}
      {...rest}
    >
      {children}
    </button>
  );
};

export interface TabsContentProps extends React.HTMLAttributes<HTMLDivElement> {
  value?: string;
}

export const TabsContent: React.FC<TabsContentProps> = ({ children, value, className, ...rest }) => {
  const ctx = React.useContext(TabsContext);
  if (value && ctx?.active !== undefined && ctx.active !== value) return null;
  return (
    <div className={(className ?? "") + " mt-2"} {...rest}>
      {children}
    </div>
  );
};


