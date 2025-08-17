"use client"

import React from "react"
import clsx from "clsx"

type Variant = "primary" | "secondary" | "outline"
type Size = "sm" | "md" | "lg"

interface ButtonProps extends Omit<React.ButtonHTMLAttributes<HTMLButtonElement>, 'loading'> {
  variant?: Variant
  size?: Size
  icon?: React.ReactNode
  className?: string
  loading?: boolean
}

const variantClasses: Record<Variant, string> = {
  primary: "bg-primary-600 text-white hover:bg-primary-700",
  secondary: "bg-white text-primary-700 hover:bg-white/90",
  outline: "border border-neutral-300 text-neutral-900 hover:bg-neutral-50",
}

const sizeClasses: Record<Size, string> = {
  sm: "px-3 py-1.5 text-sm",
  md: "px-4 py-2 text-sm",
  lg: "px-5 py-2.5 text-base",
}

export default function Button({
  children,
  variant = "primary",
  size = "md",
  icon,
  className,
  loading,
  ...props
}: ButtonProps) {
  return (
    <button
      {...props}
      className={clsx(
        "inline-flex items-center justify-center rounded-lg font-medium transition-colors focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500",
        variantClasses[variant],
        sizeClasses[size],
        className
      )}
      aria-busy={loading ? true : undefined}
    >
      {icon}
      {children}
    </button>
  )
}


