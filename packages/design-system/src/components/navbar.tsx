import { Menu, X } from "lucide-react"
import * as React from "react"
import { cn } from "../lib/utils"
import { Button } from "./button"

export interface NavbarProps extends React.HTMLAttributes<HTMLElement> {
  logo?: React.ReactNode
  navigationItems?: Array<{
    href: string
    label: string
    isActive?: boolean
  }>
  actions?: React.ReactNode
  mobileMenuItems?: React.ReactNode
}

const Navbar = React.forwardRef<HTMLElement, NavbarProps>(
  ({ className, logo, navigationItems = [], actions, mobileMenuItems, ...props }, ref) => {
    const [isMenuOpen, setIsMenuOpen] = React.useState(false)

    return (
      <nav
        ref={ref}
        className={cn("bg-white shadow-sm border-b", className)}
        {...props}
      >
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            {/* Logo */}
            <div className="flex-shrink-0">
              {logo}
            </div>

            {/* Desktop Navigation */}
            <div className="hidden md:flex items-center space-x-6">
              <div className="flex items-baseline space-x-4">
                {navigationItems.map((item) => (
                  <a
                    key={item.href}
                    href={item.href}
                    className={cn(
                      "text-gray-500 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium transition-colors",
                      item.isActive && "text-gray-900 bg-gray-100"
                    )}
                  >
                    {item.label}
                  </a>
                ))}
              </div>
              {actions}
            </div>

            {/* Mobile menu button */}
            <div className="md:hidden">
              <Button
                variant="ghost"
                onClick={() => setIsMenuOpen(!isMenuOpen)}
                className="text-gray-500 hover:text-gray-900 h-8 px-3"
              >
                {isMenuOpen ? <X className="h-6 w-6" /> : <Menu className="h-6 w-6" />}
              </Button>
            </div>
          </div>

          {/* Mobile Navigation */}
          {isMenuOpen && (
            <div className="md:hidden">
              <div className="px-2 pt-2 pb-3 space-y-1 sm:px-3">
                {navigationItems.map((item) => (
                  <a
                    key={item.href}
                    href={item.href}
                    className={cn(
                      "text-gray-500 hover:text-gray-900 block px-3 py-2 rounded-md text-base font-medium transition-colors",
                      item.isActive && "text-gray-900 bg-gray-100"
                    )}
                  >
                    {item.label}
                  </a>
                ))}
                {mobileMenuItems && (
                  <div className="px-3 py-2">
                    {mobileMenuItems}
                  </div>
                )}
              </div>
            </div>
          )}
        </div>
      </nav>
    )
  }
)
Navbar.displayName = "Navbar"

export { Navbar }
