"use client";
import * as React from "react";

type AlertDialogCtx = {
  open: boolean;
  setOpen: (v: boolean) => void;
};

const Ctx = React.createContext<AlertDialogCtx | null>(null);

export interface AlertDialogProps extends React.HTMLAttributes<HTMLDivElement> {
  open?: boolean;
  onOpenChange?: (open: boolean) => void;
}

export const AlertDialog: React.FC<AlertDialogProps> = ({
  children,
  open,
  onOpenChange,
  ...rest
}) => {
  const [internal, setInternal] = React.useState<boolean>(!!open);
  const isControlled = open !== undefined;
  const actualOpen = isControlled ? !!open : internal;
  const setOpen = (v: boolean) => {
    onOpenChange?.(v);
    if (!isControlled) setInternal(v);
  };
  return (
    <Ctx.Provider value={{ open: actualOpen, setOpen }}>
      <div {...rest}>{children}</div>
    </Ctx.Provider>
  );
};

export const AlertDialogTrigger: React.FC<React.ButtonHTMLAttributes<HTMLButtonElement> & { asChild?: boolean }> = ({ children, onClick, asChild, ...props }) => {
  const ctx = React.useContext(Ctx);
  if (asChild && React.isValidElement(children)) {
    const child = children as React.ReactElement<any>;
    const mergedOnClick = (e: any) => {
      ctx?.setOpen(true);
      if (typeof child.props.onClick === 'function') child.props.onClick(e);
      onClick?.(e);
    };
    return React.cloneElement(child, { onClick: mergedOnClick });
  }
  return (
    <button
      onClick={(e) => {
        ctx?.setOpen(true);
        onClick?.(e);
      }}
      {...props}
    >
      {children}
    </button>
  );
};

export const AlertDialogContent: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const ctx = React.useContext(Ctx);
  if (!ctx?.open) return null;
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40">
      <div className="w-full max-w-lg rounded-md bg-background p-6 shadow-lg">{children}</div>
    </div>
  );
};

export const AlertDialogHeader: React.FC<{ children: React.ReactNode }> = ({ children }) => (
  <div className="mb-4">{children}</div>
);

export const AlertDialogFooter: React.FC<{ children: React.ReactNode }> = ({ children }) => (
  <div className="mt-6 flex justify-end gap-2">{children}</div>
);

export const AlertDialogTitle: React.FC<{ children: React.ReactNode }> = ({ children }) => (
  <h2 className="text-lg font-semibold">{children}</h2>
);

export const AlertDialogDescription: React.FC<{ children: React.ReactNode }> = ({ children }) => (
  <p className="mt-2 text-sm text-muted-foreground">{children}</p>
);

export const AlertDialogAction: React.FC<React.ButtonHTMLAttributes<HTMLButtonElement>> = ({ children, onClick, ...props }) => {
  const ctx = React.useContext(Ctx);
  return (
    <button
      className="rounded-md bg-primary px-3 py-2 text-primary-foreground"
      onClick={(e) => {
        onClick?.(e);
        ctx?.setOpen(false);
      }}
      {...props}
    >
      {children}
    </button>
  );
};

export const AlertDialogCancel: React.FC<React.ButtonHTMLAttributes<HTMLButtonElement>> = ({ children, onClick, ...props }) => {
  const ctx = React.useContext(Ctx);
  return (
    <button
      className="rounded-md border px-3 py-2"
      onClick={(e) => {
        onClick?.(e);
        ctx?.setOpen(false);
      }}
      {...props}
    >
      {children}
    </button>
  );
};


