import * as React from "react";

export const Card = React.forwardRef<HTMLDivElement, React.HTMLAttributes<HTMLDivElement>>(
  ({ className = "", ...rest }, ref) => (
    <div
      ref={ref}
      className={`rounded-lg border bg-[var(--surface)] text-[var(--fg)] shadow-[var(--shadow-1)] ${className}`}
      {...rest}
    />
  )
);
Card.displayName = "Card";

export const CardHeader = React.forwardRef<HTMLDivElement, React.HTMLAttributes<HTMLDivElement>>(
  ({ className = "", ...rest }, ref) => (
    <div ref={ref} className={`p-4 border-b ${className}`} {...rest} />
  )
);
CardHeader.displayName = "CardHeader";

export const CardContent = React.forwardRef<HTMLDivElement, React.HTMLAttributes<HTMLDivElement>>(
  ({ className = "", ...rest }, ref) => (
    <div ref={ref} className={`p-4 ${className}`} {...rest} />
  )
);
CardContent.displayName = "CardContent";

export const CardFooter = React.forwardRef<HTMLDivElement, React.HTMLAttributes<HTMLDivElement>>(
  ({ className = "", ...rest }, ref) => (
    <div ref={ref} className={`p-4 border-t ${className}`} {...rest} />
  )
);
CardFooter.displayName = "CardFooter";

export const CardTitle: React.FC<React.HTMLAttributes<HTMLHeadingElement>> = ({ className = "", children, ...rest }) => (
  <h3 className={`text-base font-semibold ${className}`} {...rest}>{children}</h3>
);

export const CardDescription: React.FC<React.HTMLAttributes<HTMLParagraphElement>> = ({ className = "", children, ...rest }) => (
  <p className={`text-sm text-[var(--muted)] ${className}`} {...rest}>{children}</p>
);

export {};
 