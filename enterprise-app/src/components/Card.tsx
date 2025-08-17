import React from "react";

type Variant = "dark" | "light";

export default function Card({
  children,
  className = "",
  variant = "dark",
  hover = false,
}: {
  children: React.ReactNode;
  className?: string;
  variant?: Variant;
  hover?: boolean;
}) {
  const base = "rounded-xl p-6 shadow-sm border";
  const styles: Record<Variant, string> = {
    dark: "bg-neutral-950 border-neutral-800",
    light: "bg-white border-neutral-200",
  };

  const hoverStyles = hover
    ? variant === "light"
      ? "hover:shadow-md transition-shadow"
      : "hover:bg-neutral-900 transition-colors"
    : "";

  return <div className={`${base} ${styles[variant]} ${hoverStyles} ${className}`}>{children}</div>;
}


