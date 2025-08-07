'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { 
  HomeIcon, 
  UserGroupIcon, 
  CalendarIcon, 
  ChartBarIcon, 
  CogIcon, 
  BuildingOfficeIcon,
  BellIcon
} from '@heroicons/react/24/outline'
import { cn } from '@/lib/utils'

const navigation = [
  { name: 'Dashboard', href: '/dashboard', icon: HomeIcon },
  { name: 'Customers', href: '/customers', icon: UserGroupIcon },
  { name: 'Appointments', href: '/appointments', icon: CalendarIcon },
  { name: 'Analytics', href: '/analytics', icon: ChartBarIcon },
  { name: 'Settings', href: '/settings', icon: CogIcon },
  { name: 'Business', href: '/business', icon: BuildingOfficeIcon },
]

export default function Sidebar() {
  const pathname = usePathname()

  return (
    <div className="flex h-full w-64 flex-col bg-white border-r border-gray-200">
      <div className="flex h-16 items-center justify-center border-b border-gray-200">
        <div className="flex items-center">
          <BuildingOfficeIcon className="h-8 w-8 text-primary-600" />
          <span className="ml-2 text-xl font-bold text-gray-900">Enterprise</span>
        </div>
      </div>
      
      <nav className="flex-1 space-y-1 px-4 py-4">
        {navigation.map((item) => {
          const isActive = pathname === item.href
          return (
            <Link
              key={item.name}
              href={item.href}
              className={cn(
                'group flex items-center px-2 py-2 text-sm font-medium rounded-md transition-colors duration-200',
                isActive
                  ? 'bg-primary-100 text-primary-900'
                  : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900'
              )}
            >
              <item.icon
                className={cn(
                  'mr-3 h-5 w-5 flex-shrink-0',
                  isActive ? 'text-primary-600' : 'text-gray-400 group-hover:text-gray-500'
                )}
              />
              {item.name}
            </Link>
          )
        })}
      </nav>
      
      <div className="border-t border-gray-200 p-4">
        <div className="flex items-center">
          <div className="flex-shrink-0">
            <div className="h-8 w-8 rounded-full bg-primary-600 flex items-center justify-center">
              <span className="text-sm font-medium text-white">A</span>
            </div>
          </div>
          <div className="ml-3">
            <p className="text-sm font-medium text-gray-900">Admin User</p>
            <p className="text-xs text-gray-500">admin@company.com</p>
          </div>
        </div>
      </div>
    </div>
  )
} 