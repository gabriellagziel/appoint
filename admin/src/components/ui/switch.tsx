"use client";
import * as React from "react";

export interface SwitchProps extends React.InputHTMLAttributes<HTMLInputElement> {
  className?: string;
  checked?: boolean;
  defaultChecked?: boolean;
  onCheckedChange?: (checked: boolean) => void;
}

export const Switch = React.forwardRef<HTMLInputElement, SwitchProps>(
  ({ className, checked, defaultChecked, onCheckedChange, onChange, ...props }, ref) => {
    const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
      onCheckedChange?.(e.target.checked);
      onChange?.(e);
    };
    return (
      <label className={("inline-flex cursor-pointer items-center ") + (className ?? "")}>
        <input
          type="checkbox"
          className="peer sr-only"
          ref={ref}
          checked={checked}
          defaultChecked={defaultChecked}
          onChange={handleChange}
          {...props}
        />
        <span className="h-5 w-9 rounded-full bg-muted peer-checked:bg-primary transition-colors"></span>
      </label>
    );
  }
);
Switch.displayName = "Switch";


