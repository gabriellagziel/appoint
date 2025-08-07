import * as React from "react"
import { cn } from "../../lib/utils"

export interface GridProps extends React.HTMLAttributes<HTMLDivElement> {
  cols?: 1 | 2 | 3 | 4 | 5 | 6 | 12
  gap?: "sm" | "md" | "lg" | "xl"
  responsive?: boolean
}

const Grid = React.forwardRef<HTMLDivElement, GridProps>(
  ({ className, cols = 1, gap = "md", responsive = true, ...props }, ref) => {
    const colClasses = {
      1: "grid-cols-1",
      2: responsive ? "grid-cols-1 md:grid-cols-2" : "grid-cols-2",
      3: responsive ? "grid-cols-1 md:grid-cols-2 lg:grid-cols-3" : "grid-cols-3",
      4: responsive ? "grid-cols-1 md:grid-cols-2 lg:grid-cols-4" : "grid-cols-4",
      5: responsive ? "grid-cols-1 md:grid-cols-2 lg:grid-cols-5" : "grid-cols-5",
      6: responsive ? "grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6" : "grid-cols-6",
      12: responsive ? "grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 2xl:grid-cols-6" : "grid-cols-12",
    }

    const gapClasses = {
      sm: "gap-2",
      md: "gap-4",
      lg: "gap-6",
      xl: "gap-8",
    }

    return (
      <div
        ref={ref}
        className={cn(
          "grid",
          colClasses[cols],
          gapClasses[gap],
          className
        )}
        {...props}
      />
    )
  }
)
Grid.displayName = "Grid"

export { Grid }
