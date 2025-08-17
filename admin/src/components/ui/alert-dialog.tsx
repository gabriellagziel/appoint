"use client";
import React from 'react';

export const AlertDialog: React.FC<React.ComponentProps<'div'>> = ({ children, ...props }) => (
  <div {...props}>{children}</div>
);

export const AlertDialogTrigger: React.FC<{ asChild?: boolean } & React.ComponentProps<'button'>> = ({ children, asChild, ...props }) => (
  asChild ? <>{children}</> : <button {...props}>{children}</button>
);

export const AlertDialogContent: React.FC<React.ComponentProps<'div'>> = ({ children, ...props }) => (
  <div role="dialog" {...props}>{children}</div>
);

export const AlertDialogHeader: React.FC<React.ComponentProps<'div'>> = ({ children, ...props }) => (
  <div {...props}>{children}</div>
);

export const AlertDialogFooter: React.FC<React.ComponentProps<'div'>> = ({ children, ...props }) => (
  <div {...props}>{children}</div>
);

export const AlertDialogTitle: React.FC<React.ComponentProps<'h3'>> = ({ children, ...props }) => (
  <h3 {...props}>{children}</h3>
);

export const AlertDialogDescription: React.FC<React.ComponentProps<'p'>> = ({ children, ...props }) => (
  <p {...props}>{children}</p>
);

export const AlertDialogAction: React.FC<React.ComponentProps<'button'>> = ({ children, ...props }) => (
  <button {...props}>{children}</button>
);

export const AlertDialogCancel: React.FC<React.ComponentProps<'button'>> = ({ children, ...props }) => (
  <button {...props}>{children}</button>
);


