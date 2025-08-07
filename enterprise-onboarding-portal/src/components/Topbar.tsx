'use client'

import { useState } from 'react'
import { 
  MagnifyingGlassIcon, 
  BellIcon, 
  Bars3Icon,
  UserCircleIcon
} from '@heroicons/react/24/outline'

export default function Topbar() {
  const [searchQuery, setSearchQuery] = useState('')

  return (
    <div className="bg-white border-b border-gray-200 px-4 py-3">
      <div className="flex items-center justify-between">
        <div className="flex items-center">
          <button className="lg:hidden p-2 rounded-md text-gray-400 hover:text-gray-500 hover:bg-gray-100">
            <Bars3Icon className="h-6 w-6" />
          </button>
          
          <div className="ml-4 flex-1 max-w-lg">
            <div className="relative">
              <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                <MagnifyingGlassIcon className="h-5 w-5 text-gray-400" />
              </div>
              <input
                type="text"
                placeholder="Search..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md leading-5 bg-white placeholder-gray-500 focus:outline-none focus:placeholder-gray-400 focus:ring-1 focus:ring-primary-500 focus:border-primary-500"
              />
            </div>
          </div>
        </div>
        
        <div className="flex items-center space-x-4">
          <button className="p-2 rounded-md text-gray-400 hover:text-gray-500 hover:bg-gray-100 relative">
            <BellIcon className="h-6 w-6" />
            <span className="absolute top-1 right-1 block h-2 w-2 rounded-full bg-red-400"></span>
          </button>
          
          <div className="relative">
            <button className="flex items-center space-x-2 p-2 rounded-md text-gray-400 hover:text-gray-500 hover:bg-gray-100">
              <UserCircleIcon className="h-6 w-6" />
              <span className="hidden md:block text-sm font-medium text-gray-900">Admin User</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  )
} 