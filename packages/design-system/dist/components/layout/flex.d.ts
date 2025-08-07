import * as React from "react";
export interface FlexProps extends React.HTMLAttributes<HTMLDivElement> {
    direction?: "row" | "col" | "row-reverse" | "col-reverse";
    justify?: "start" | "end" | "center" | "between" | "around" | "evenly";
    align?: "start" | "end" | "center" | "baseline" | "stretch";
    wrap?: "wrap" | "wrap-reverse" | "nowrap";
    gap?: "sm" | "md" | "lg" | "xl";
}
declare const Flex: React.ForwardRefExoticComponent<FlexProps & React.RefAttributes<HTMLDivElement>>;
export { Flex };
//# sourceMappingURL=flex.d.ts.map