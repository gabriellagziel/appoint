import {
  BarChart3,
  CreditCard,
  FileText, HelpCircle,
  Key,
  LayoutDashboard,
  Palette,
  Settings,
  Users
} from 'lucide-react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import React from 'react';

interface SidebarProps {
  isOpen?: boolean;
  onClose?: () => void;
}

const Sidebar: React.FC<SidebarProps> = ({ isOpen = true, onClose }) => {
  const pathname = usePathname();

  const mainNavigation = [
    {
      name: 'Dashboard',
      href: '/dashboard',
      icon: LayoutDashboard,
    },
    {
      name: 'Access Keys',
      href: '/dashboard/keys',
      icon: Key,
    },
    {
      name: 'Billing',
      href: '/dashboard/billing',
      icon: CreditCard,
    },
    {
      name: 'Analytics',
      href: '/dashboard/analytics',
      icon: BarChart3,
    },
    {
      name: 'White Label',
      href: '/dashboard/white-label',
      icon: Palette,
    },
    {
      name: 'Settings',
      href: '/dashboard/settings',
      icon: Settings,
    },
  ];

  const secondaryNavigation = [
    {
      name: 'Documentation',
      href: '/docs',
      icon: FileText,
    },
    {
      name: 'Support',
      href: '/support',
      icon: HelpCircle,
    },
  ];

  return (
    <>
      {/* Mobile overlay */}
      {isOpen && (
        <div
          className="fixed inset-0 bg-black bg-opacity-50 z-40 lg:hidden"
          onClick={onClose}
        />
      )}

      {/* Sidebar */}
      <div className={`
        fixed inset-y-0 left-0 z-50 w-64 bg-white border-r border-neutral-200 transform transition-transform duration-300 ease-in-out lg:translate-x-0 lg:static lg:inset-0
        ${isOpen ? 'translate-x-0' : '-translate-x-full'}
      `}>
        <div className="flex flex-col h-full">
          {/* Header */}
          <div className="flex items-center justify-between p-6 border-b border-neutral-200">
            <div className="flex items-center space-x-3">
              <div className="w-8 h-8 bg-primary-600 rounded-lg flex items-center justify-center">
                <span className="text-white font-bold text-sm">A</span>
              </div>
              <div>
                <h1 className="text-lg font-semibold text-neutral-900">App-Oint</h1>
                <p className="text-xs text-neutral-500">Enterprise Portal</p>
              </div>
            </div>
            <button
              onClick={onClose}
              className="lg:hidden p-2 text-neutral-400 hover:text-neutral-600"
              aria-label="Close sidebar"
            >
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>

          {/* Navigation */}
          <nav className="flex-1 px-4 py-6 space-y-2">
            {/* Main Navigation */}
            <div>
              <h3 className="text-xs font-semibold text-neutral-500 uppercase tracking-wider mb-3">
                Main
              </h3>
              <div className="space-y-1">
                {mainNavigation.map((item) => {
                  const isActive = pathname === item.href;
                  return (
                    <Link
                      key={item.name}
                      href={item.href}
                      className={`
                        flex items-center px-3 py-2 text-sm font-medium rounded-lg transition-colors
                        ${isActive
                          ? 'bg-primary-50 text-primary-700 border-r-2 border-primary-700'
                          : 'text-neutral-700 hover:bg-neutral-50 hover:text-neutral-900'
                        }
                      `}
                    >
                      <item.icon className="h-5 w-5 mr-3" />
                      {item.name}
                    </Link>
                  );
                })}
              </div>
            </div>

            {/* Secondary Navigation */}
            <div className="pt-6">
              <h3 className="text-xs font-semibold text-neutral-500 uppercase tracking-wider mb-3">
                Resources
              </h3>
              <div className="space-y-1">
                {secondaryNavigation.map((item) => {
                  const isActive = pathname === item.href;
                  return (
                    <Link
                      key={item.name}
                      href={item.href}
                      className={`
                        flex items-center px-3 py-2 text-sm font-medium rounded-lg transition-colors
                        ${isActive
                          ? 'bg-primary-50 text-primary-700 border-r-2 border-primary-700'
                          : 'text-neutral-700 hover:bg-neutral-50 hover:text-neutral-900'
                        }
                      `}
                    >
                      <item.icon className="h-5 w-5 mr-3" />
                      {item.name}
                    </Link>
                  );
                })}
              </div>
            </div>
          </nav>

          {/* Footer */}
          <div className="p-4 border-t border-neutral-200">
            <div className="flex items-center space-x-3 p-3 bg-neutral-50 rounded-lg">
              <div className="w-8 h-8 bg-primary-100 rounded-full flex items-center justify-center">
                <Users className="h-4 w-4 text-primary-600" />
              </div>
              <div className="flex-1">
                <p className="text-sm font-medium text-neutral-900">Enterprise Plan</p>
                <p className="text-xs text-neutral-500">Pay-per-meeting</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default Sidebar; 