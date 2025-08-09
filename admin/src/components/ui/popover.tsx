"use client";
import * as React from "react";

type Ctx = { open: boolean; setOpen: (v: boolean) => void };
const PopCtx = React.createContext<Ctx | null>(null);

export interface PopoverProps extends React.HTMLAttributes<HTMLDivElement> {
  open?: boolean;
  onOpenChange?: (open: boolean) => void;
}

export const Popover: React.FC<PopoverProps> = ({ children, open, onOpenChange, className, ...rest }) => {
  const [internal, setInternal] = React.useState(!!open);
  const controlled = open !== undefined;
  const actual = controlled ? !!open : internal;
  const setOpen = (v: boolean) => {
    onOpenChange?.(v);
    if (!controlled) setInternal(v);
  };
  return (
    <PopCtx.Provider value={{ open: actual, setOpen }}>
      <div className={(className ?? "") + " relative inline-block"} {...rest}>
        {children}
      </div>
    </PopCtx.Provider>
  );
};

export const PopoverTrigger: React.FC<React.ButtonHTMLAttributes<HTMLButtonElement> & { asChild?: boolean }>
  = ({ children, onClick, asChild, ...props }) => {
    const ctx = React.useContext(PopCtx);
    if (asChild && React.isValidElement(children)) {
      const child = children as React.ReactElement<any>;
      const mergedOnClick = (e: any) => {
        ctx?.setOpen(!ctx.open);
        if (typeof child.props.onClick === 'function') child.props.onClick(e);
        onClick?.(e);
      };
      return React.cloneElement(child, { onClick: mergedOnClick });
    }
    return (
      <button
        onClick={(e) => {
          ctx?.setOpen(!ctx.open);
          onClick?.(e);
        }}
        {...props}
      >
        {children}
      </button>
    );
  };

export const PopoverContent: React.FC<React.HTMLAttributes<HTMLDivElement>> = ({ children, className, ...rest }) => {
  const ctx = React.useContext(PopCtx);
  if (!ctx?.open) return null;
  return (
    <div className={(className ?? "") + " absolute z-50 mt-2 rounded-md border bg-background p-2 shadow-md"} {...rest}>
      {children}
    </div>
  );
};


