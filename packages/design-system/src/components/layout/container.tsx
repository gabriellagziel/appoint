import * as React from "react"
import { cn } from "../../lib/utils"

export interface ContainerProps extends React.HTMLAttributes<HTMLDivElement> {
  size?: "sm" | "md" | "lg" | "xl" | "full"
  centered?: boolean
}

const Container = React.forwardRef<HTMLDivElement, ContainerProps>(
  ({ className, size = "lg", centered = true, ...props }, ref) => {
    const sizeClasses = {
      sm: "max-w-3xl",
      md: "max-w-5xl",
      lg: "max-w-7xl",
      xl: "max-w-7xl",
      full: "max-w-none",
    }

    return (
      <div
        ref={ref}
        className={cn(
          "px-4 sm:px-6 lg:px-8",
          sizeClasses[size],
          centered && "mx-auto",
          className
        )}
        {...props}
      />
    )
  }
)
Container.displayName = "Container"

export { Container }
