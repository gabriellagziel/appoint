import * as React from "react";
export interface ContainerProps extends React.HTMLAttributes<HTMLDivElement> {
    size?: "sm" | "md" | "lg" | "xl" | "full";
    centered?: boolean;
}
declare const Container: React.ForwardRefExoticComponent<ContainerProps & React.RefAttributes<HTMLDivElement>>;
export { Container };
//# sourceMappingURL=container.d.ts.map