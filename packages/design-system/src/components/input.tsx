import * as React from "react";

export interface InputProps extends React.InputHTMLAttributes<HTMLInputElement> {}

export const Input = React.forwardRef<HTMLInputElement, InputProps>(({ className = "", ...rest }, ref) => {
  const base =
    "px-3 py-2 rounded-md border bg-white text-[var(--fg)] placeholder-[color:var(--muted)] focus:outline-none focus:ring-2 focus:ring-[var(--primary)]";
  return <input ref={ref} className={`${base} ${className}`} {...rest} />;
});

Input.displayName = "Input";

export default Input;
 