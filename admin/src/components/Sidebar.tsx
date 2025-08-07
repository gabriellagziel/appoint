"use client"

import { Button } from "@/components/ui/button"
import { cn } from "@/lib/utils"
import {
  BarChart3,
  Bell,
  Calendar,
  ClipboardList,
  CreditCard,
  Download,
  FileText,
  Flag,
  Gavel,
  Gift,
  Globe,
  Home,
  Key,
  Megaphone,
  Menu,
  MessageSquare,
  Settings,
  Shield,
  Users,
  Users2
} from "lucide-react"
import Link from "next/link"
import { usePathname } from "next/navigation"
import { Logo } from "./Logo"

interface SidebarProps {
  isOpen: boolean
  onToggle: () => void
}

const navigation = [
  { name: "Dashboard", href: "/admin", icon: Home },
  { name: "Users", href: "/admin/users", icon: Users },
  { name: "Analytics", href: "/admin/analytics", icon: BarChart3 },
  { name: "System", href: "/admin/system", icon: Shield },
  { name: "Flags", href: "/admin/flags", icon: Flag },
  { name: "Appointments", href: "/admin/appointments", icon: Calendar },
  { name: "Payments", href: "/admin/payments", icon: CreditCard },
  { name: "Broadcasts", href: "/admin/broadcasts", icon: Megaphone },
  { name: "Notifications", href: "/admin/notifications", icon: Bell },
  { name: "Business Accounts", href: "/admin/business", icon: Shield },
  { name: "Registrations", href: "/admin/business/registrations", icon: ClipboardList },
  { name: "Billing & Revenue", href: "/admin/billing", icon: CreditCard },
  { name: "Security & Abuse", href: "/admin/security", icon: Shield },
  { name: "API Admin", href: "/admin/api", icon: Key },
  { name: "Legal & Compliance", href: "/admin/legal", icon: Gavel },
  { name: "Admin Communication", href: "/admin/communication", icon: MessageSquare },
  { name: "Content", href: "/admin/content", icon: FileText },
  { name: "Exports", href: "/admin/exports", icon: Download },
  { name: "Surveys", href: "/admin/surveys", icon: ClipboardList },
  { name: "Free Passes", href: "/admin/free-passes", icon: Gift },
  { name: "Ambassador Program", href: "/admin/ambassadors", icon: Users2 },
  { name: "Localization", href: "/admin/localization", icon: Globe },
  { name: "Feature Flags", href: "/admin/features", icon: Flag },
  { name: "Settings", href: "/admin/settings", icon: Settings },
]

export function Sidebar({ isOpen, onToggle }: SidebarProps) {
  const pathname = usePathname()

  return (
    <>
      {/* Mobile overlay */}
      {isOpen && (
        <div
          className="fixed inset-0 z-40 bg-black bg-opacity-50 lg:hidden"
          onClick={onToggle}
        />
      )}

      {/* Sidebar */}
      <div className={cn(
        "w-64 bg-white shadow-lg lg:block",
        isOpen ? "block" : "hidden lg:block"
      )}>
        <div className="flex h-full flex-col">
          {/* Header */}
          <div className="flex h-16 items-center justify-between px-6 border-b">
            <Logo size={32} showText={false} />
            <Button
              variant="ghost"
              size="sm"
              onClick={onToggle}
              className="lg:hidden"
            >
              <Menu className="h-5 w-5" />
            </Button>
          </div>

          {/* Navigation */}
          <nav className="flex-1 px-4 py-6 space-y-2">
            {navigation.map((item) => {
              const isActive = pathname === item.href

              return (
                <Link
                  key={item.name}
                  href={item.href}
                  className={cn(
                    "flex items-center px-3 py-2 text-sm font-medium rounded-md transition-colors",
                    isActive
                      ? "bg-gray-100 text-gray-900"
                      : "text-gray-600 hover:bg-gray-50 hover:text-gray-900"
                  )}
                >
                  <item.icon className="mr-3 h-5 w-5" />
                  {item.name}
                </Link>
              )
            })}
          </nav>
        </div>
      </div>
    </>
  )
} 