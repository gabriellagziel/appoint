import React from 'react';
import Link from 'next/link';
import { Home, User, LogOut } from 'lucide-react';
import Button from './Button';

interface LayoutProps {
  children: React.ReactNode;
  showSidebar?: boolean;
}

const Layout: React.FC<LayoutProps> = ({ children, showSidebar = false }) => {
  return (
    <div className="min-h-screen bg-gray-50">
      {/* Top Bar */}
      <header className="bg-white border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center py-4">
            {/* Logo and Home Link */}
            <div className="flex items-center space-x-4">
              <Link href="/" className="flex items-center space-x-3 hover:opacity-80 transition-opacity">
                <div className="w-8 h-8 bg-primary-600 rounded-lg flex items-center justify-center">
                  <span className="text-white font-bold text-sm">A</span>
                </div>
                <div>
                  <h1 className="text-lg font-bold text-gray-900">App-Oint</h1>
                  <p className="text-xs text-gray-500">Enterprise Portal</p>
                </div>
              </Link>
              <Link href="/" className="flex items-center space-x-2 text-gray-600 hover:text-gray-900 text-sm">
                <Home className="w-4 h-4" />
                <span>Home</span>
              </Link>
            </div>

            {/* User Menu */}
            <div className="flex items-center space-x-4">
              <Button variant="outline" size="sm">
                <User className="w-4 h-4 mr-2" />
                Account
              </Button>
              <Button variant="outline" size="sm">
                <LogOut className="w-4 h-4 mr-2" />
                Sign Out
              </Button>
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <div className="flex">
        {showSidebar && (
          <aside className="w-64 bg-white border-r border-gray-200 min-h-screen">
            <nav className="p-4">
              <div className="space-y-2">
                <Link href="/dashboard" className="block px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-md">
                  Dashboard
                </Link>
                <Link href="/dashboard/api-keys" className="block px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-md">
                  API Keys
                </Link>
                <Link href="/dashboard/usage" className="block px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-md">
                  Usage Analytics
                </Link>
                <Link href="/dashboard/billing" className="block px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-md">
                  Billing
                </Link>
                <Link href="/docs" className="block px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-md">
                  Documentation
                </Link>
              </div>
            </nav>
          </aside>
        )}
        
        <main className="flex-1">
          {children}
        </main>
      </div>
    </div>
  );
};

export default Layout;
