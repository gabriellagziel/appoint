"use client";
import * as React from "react";

export interface CalendarProps {
  selected?: Date | null;
  onSelect?: (date: Date | null) => void;
  mode?: "single" | "multiple" | "range";
  initialFocus?: boolean;
  disabled?: (date: Date) => boolean;
  className?: string;
}

export function Calendar({
  selected,
  onSelect,
  mode,
  initialFocus,
  disabled,
  className,
}: CalendarProps) {
  // Minimal placeholder calendar – replace with real calendar as needed
  const value = selected ? new Date(selected).toISOString().slice(0, 10) : "";
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const v = e.target.value ? new Date(e.target.value) : null;
    if (v && disabled && disabled(v)) {
      return; // ignore disabled dates
    }
    onSelect?.(v);
  };
  return (
    <input
      type="date"
      className={(className ?? "") + " rounded-md border px-3 py-2 text-sm"}
      value={value}
      onChange={handleChange}
      autoFocus={!!initialFocus}
      aria-label={mode ? `calendar-${mode}` : "calendar"}
    />
  );
}


