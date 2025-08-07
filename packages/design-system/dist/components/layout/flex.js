import { jsx as _jsx } from "react/jsx-runtime";
import * as React from "react";
import { cn } from "../../lib/utils";
const Flex = React.forwardRef(({ className, direction = "row", justify = "start", align = "start", wrap = "nowrap", gap = "md", ...props }, ref) => {
    const directionClasses = {
        row: "flex-row",
        col: "flex-col",
        "row-reverse": "flex-row-reverse",
        "col-reverse": "flex-col-reverse",
    };
    const justifyClasses = {
        start: "justify-start",
        end: "justify-end",
        center: "justify-center",
        between: "justify-between",
        around: "justify-around",
        evenly: "justify-evenly",
    };
    const alignClasses = {
        start: "items-start",
        end: "items-end",
        center: "items-center",
        baseline: "items-baseline",
        stretch: "items-stretch",
    };
    const wrapClasses = {
        wrap: "flex-wrap",
        "wrap-reverse": "flex-wrap-reverse",
        nowrap: "flex-nowrap",
    };
    const gapClasses = {
        sm: "gap-2",
        md: "gap-4",
        lg: "gap-6",
        xl: "gap-8",
    };
    return (_jsx("div", { ref: ref, className: cn("flex", directionClasses[direction], justifyClasses[justify], alignClasses[align], wrapClasses[wrap], gapClasses[gap], className), ...props }));
});
Flex.displayName = "Flex";
export { Flex };
