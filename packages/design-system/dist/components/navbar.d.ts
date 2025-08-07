import * as React from "react";
export interface NavbarProps extends React.HTMLAttributes<HTMLElement> {
    logo?: React.ReactNode;
    navigationItems?: Array<{
        href: string;
        label: string;
        isActive?: boolean;
    }>;
    actions?: React.ReactNode;
    mobileMenuItems?: React.ReactNode;
}
declare const Navbar: React.ForwardRefExoticComponent<NavbarProps & React.RefAttributes<HTMLElement>>;
export { Navbar };
//# sourceMappingURL=navbar.d.ts.map