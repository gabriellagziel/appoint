import { jsx as _jsx, jsxs as _jsxs } from "react/jsx-runtime";
import * as React from "react";
import { Menu, X } from "lucide-react";
import { cn } from "../lib/utils";
import { Button } from "./button";
const Navbar = React.forwardRef(({ className, logo, navigationItems = [], actions, mobileMenuItems, ...props }, ref) => {
    const [isMenuOpen, setIsMenuOpen] = React.useState(false);
    return (_jsx("nav", { ref: ref, className: cn("bg-white shadow-sm border-b", className), ...props, children: _jsxs("div", { className: "max-w-7xl mx-auto px-4 sm:px-6 lg:px-8", children: [_jsxs("div", { className: "flex justify-between items-center h-16", children: [_jsx("div", { className: "flex-shrink-0", children: logo }), _jsxs("div", { className: "hidden md:flex items-center space-x-6", children: [_jsx("div", { className: "flex items-baseline space-x-4", children: navigationItems.map((item) => (_jsx("a", { href: item.href, className: cn("text-gray-500 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium transition-colors", item.isActive && "text-gray-900 bg-gray-100"), children: item.label }, item.href))) }), actions] }), _jsx("div", { className: "md:hidden", children: _jsx(Button, { variant: "ghost", size: "sm", onClick: () => setIsMenuOpen(!isMenuOpen), className: "text-gray-500 hover:text-gray-900", children: isMenuOpen ? _jsx(X, { className: "h-6 w-6" }) : _jsx(Menu, { className: "h-6 w-6" }) }) })] }), isMenuOpen && (_jsx("div", { className: "md:hidden", children: _jsxs("div", { className: "px-2 pt-2 pb-3 space-y-1 sm:px-3", children: [navigationItems.map((item) => (_jsx("a", { href: item.href, className: cn("text-gray-500 hover:text-gray-900 block px-3 py-2 rounded-md text-base font-medium transition-colors", item.isActive && "text-gray-900 bg-gray-100"), children: item.label }, item.href))), mobileMenuItems && (_jsx("div", { className: "px-3 py-2", children: mobileMenuItems }))] }) }))] }) }));
});
Navbar.displayName = "Navbar";
export { Navbar };
