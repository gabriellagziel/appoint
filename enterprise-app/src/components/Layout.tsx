'use client';

import { Menu } from 'lucide-react';
import React, { useState } from 'react';
import Sidebar from './Sidebar';
import Topbar from './Topbar';

interface LayoutProps {
  children: React.ReactNode;
  showSidebar?: boolean;
  user?: {
    name: string;
    email: string;
    avatar?: string;
  };
}

const Layout: React.FC<LayoutProps> = ({ children, showSidebar = true, user }) => {
  const [sidebarOpen, setSidebarOpen] = useState(false);

  return (
    <div className="min-h-screen bg-neutral-50">
      {/* Mobile menu button */}
      {showSidebar && (
        <div className="lg:hidden fixed top-4 left-4 z-50">
          <button
            onClick={() => setSidebarOpen(true)}
            className="p-2 bg-white rounded-lg shadow-lg border border-neutral-200"
            aria-label="Open menu"
          >
            <Menu className="h-5 w-5 text-neutral-600" />
          </button>
        </div>
      )}

      {/* Sidebar */}
      {showSidebar && (
        <Sidebar
          isOpen={sidebarOpen}
          onClose={() => setSidebarOpen(false)}
        />
      )}

      {/* Main content */}
      <div className={showSidebar ? 'lg:pl-64' : ''}>
        {/* Topbar */}
        <Topbar
          user={user}
          onLogout={() => console.log('Logout')}
          onSettings={() => console.log('Settings')}
        />

        {/* Page content */}
        <main className="p-6">
          {children}
        </main>
      </div>
    </div>
  );
};

export default Layout; 