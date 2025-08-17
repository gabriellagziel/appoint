import * as React from "react";

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: "primary" | "outline" | "ghost";
}

export const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className = "", variant = "primary", ...rest }, ref) => {
    const base =
      "px-4 py-2 rounded-md transition focus:outline-none focus-visible:ring-2 focus-visible:ring-[var(--primary)]";
    const styles =
      {
        primary: "bg-[var(--primary)] text-white shadow-[var(--shadow-2)]",
        outline: "border hover:bg-[color:var(--primary)/0.08)]",
        ghost: "hover:bg-[color:var(--fg)/0.06)]",
      }[variant] || "";
    return <button ref={ref} className={`${base} ${styles} ${className}`} {...rest} />;
  }
);

Button.displayName = "Button";

export default Button;
 