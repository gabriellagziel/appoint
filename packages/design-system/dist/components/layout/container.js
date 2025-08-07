import { jsx as _jsx } from "react/jsx-runtime";
import * as React from "react";
import { cn } from "../../lib/utils";
const Container = React.forwardRef(({ className, size = "lg", centered = true, ...props }, ref) => {
    const sizeClasses = {
        sm: "max-w-3xl",
        md: "max-w-5xl",
        lg: "max-w-7xl",
        xl: "max-w-7xl",
        full: "max-w-none",
    };
    return (_jsx("div", { ref: ref, className: cn("px-4 sm:px-6 lg:px-8", sizeClasses[size], centered && "mx-auto", className), ...props }));
});
Container.displayName = "Container";
export { Container };
