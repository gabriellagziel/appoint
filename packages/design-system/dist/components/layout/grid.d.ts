import * as React from "react";
export interface GridProps extends React.HTMLAttributes<HTMLDivElement> {
    cols?: 1 | 2 | 3 | 4 | 5 | 6 | 12;
    gap?: "sm" | "md" | "lg" | "xl";
    responsive?: boolean;
}
declare const Grid: React.ForwardRefExoticComponent<GridProps & React.RefAttributes<HTMLDivElement>>;
export { Grid };
//# sourceMappingURL=grid.d.ts.map