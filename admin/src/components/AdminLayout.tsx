"use client"

import { useState } from "react"
import { Sidebar } from "./Sidebar"
import { TopNav } from "./TopNav"

interface AdminLayoutProps {
  children: React.ReactNode
}

export function AdminLayout({ children }: AdminLayoutProps) {
  const [sidebarOpen, setSidebarOpen] = useState(false)

  return (
    <div className="min-h-screen bg-gray-50 flex">
      <Sidebar
        isOpen={sidebarOpen}
        onToggle={() => setSidebarOpen(!sidebarOpen)}
      />

      <div className="flex-1 flex flex-col min-h-screen">
        <TopNav onSidebarToggle={() => setSidebarOpen(!sidebarOpen)} />

        <main className="p-4 lg:p-8 flex-grow">
          <div className="mx-auto max-w-7xl">
            {children}
          </div>
        </main>

        {/* Attribution - Required for all admin screens */}
        <footer className="bg-gray-50 border-t border-gray-200 mt-auto">
          <div className="px-4 py-3 text-center">
            <p className="text-xs text-gray-500">
              Powered by{" "}
              <a
                href="https://app-oint.com"
                target="_blank"
                rel="noopener noreferrer"
                className="font-semibold text-blue-600 hover:text-blue-800 no-underline hover:underline"
              >
                APP-OINT
              </a>
            </p>
          </div>
        </footer>
      </div>
    </div>
  )
} 