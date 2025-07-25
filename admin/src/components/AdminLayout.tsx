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
    <div className="min-h-screen bg-gray-50 flex flex-col">
      <Sidebar 
        isOpen={sidebarOpen} 
        onToggle={() => setSidebarOpen(!sidebarOpen)} 
      />
      
      <div className="lg:pl-64 flex flex-col min-h-screen">
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
              Powered by <span className="font-semibold text-gray-700">APP-OINT</span>
            </p>
          </div>
        </footer>
      </div>
    </div>
  )
} 