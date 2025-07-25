"use client"

import { signOut, useSession } from "next-auth/react"
import { Button } from "@/components/ui/button"
import { Menu, LogOut, User } from "lucide-react"
import { Logo } from "./Logo"

interface TopNavProps {
  onSidebarToggle: () => void
}

export function TopNav({ onSidebarToggle }: TopNavProps) {
  const { data: session } = useSession()

  return (
    <header className="sticky top-0 z-40 bg-white border-b">
      <div className="flex h-16 items-center justify-between px-4 lg:px-6">
        {/* Left side */}
        <div className="flex items-center space-x-4">
          <Button
            variant="ghost"
            size="sm"
            onClick={onSidebarToggle}
            className="lg:hidden"
          >
            <Menu className="h-5 w-5" />
          </Button>
          <div className="hidden lg:block">
            <Logo size={32} showText={true} />
          </div>
        </div>

        {/* Right side */}
        <div className="flex items-center space-x-4">
          {/* User info */}
          <div className="hidden md:flex items-center space-x-2">
            <div className="flex items-center justify-center w-8 h-8 bg-gray-100 rounded-full">
              <User className="h-4 w-4 text-gray-600" />
            </div>
            <div className="text-sm">
              <p className="font-medium text-gray-900">
                {session?.user?.name || "Admin"}
              </p>
              <p className="text-gray-500">
                {session?.user?.email || "admin@app-oint.com"}
              </p>
            </div>
          </div>

          {/* Logout button */}
          <Button
            variant="outline"
            size="sm"
            onClick={() => signOut({ callbackUrl: "/auth/signin" })}
            className="flex items-center space-x-2"
          >
            <LogOut className="h-4 w-4" />
            <span className="hidden sm:inline">Logout</span>
          </Button>
        </div>
      </div>
    </header>
  )
} 