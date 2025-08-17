"use client";
import React from 'react';

type DialogProps = React.HTMLAttributes<HTMLDivElement> & {
  open?: boolean;
  onOpenChange?: (open: boolean) => void;
};

type DialogButtonProps = React.ButtonHTMLAttributes<HTMLButtonElement> & {
  asChild?: boolean;
};

export const Dialog: React.FC<DialogProps> = ({ children, onOpenChange, open, ...props }) => (
  <div aria-hidden={!open} {...props}>{children}</div>
);
export const DialogTrigger: React.FC<DialogButtonProps> = ({ children, asChild, ...props }) => (
  asChild ? <>{children}</> : <button {...props}>{children}</button>
);
export const DialogContent: React.FC<DialogProps> = ({ children, ...props }) => (
  <div role="dialog" {...props}>{children}</div>
);
export const DialogHeader: React.FC<React.ComponentProps<'div'>> = ({ children, ...props }) => (
  <div {...props}>{children}</div>
);
export const DialogFooter: React.FC<React.ComponentProps<'div'>> = ({ children, ...props }) => (
  <div {...props}>{children}</div>
);
export const DialogTitle: React.FC<React.ComponentProps<'h3'>> = ({ children, ...props }) => (
  <h3 {...props}>{children}</h3>
);
export const DialogDescription: React.FC<React.ComponentProps<'p'>> = ({ children, ...props }) => (
  <p {...props}>{children}</p>
);


