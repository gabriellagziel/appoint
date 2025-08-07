import { Bell, LogOut, Search, Settings, User } from 'lucide-react';
import React from 'react';
import Button from './Button';

interface TopbarProps {
  user?: {
    name: string;
    email: string;
    avatar?: string;
  };
  onLogout?: () => void;
  onSettings?: () => void;
}

const Topbar: React.FC<TopbarProps> = ({ user, onLogout, onSettings }) => {
  return (
    <header className="bg-white border-b border-neutral-200 px-6 py-4">
      <div className="flex items-center justify-between">
        {/* Logo */}
        <div className="flex items-center space-x-3">
          <div className="w-8 h-8 bg-primary-600 rounded-lg flex items-center justify-center">
            <span className="text-white font-bold text-sm">A</span>
          </div>
          <div>
            <h1 className="text-lg font-semibold text-neutral-900">App-Oint</h1>
            <p className="text-xs text-neutral-500">Enterprise Portal</p>
          </div>
        </div>

        {/* Search */}
        <div className="flex-1 max-w-md mx-8">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-neutral-400" />
            <input
              type="text"
              placeholder="Search..."
              className="w-full pl-10 pr-4 py-2 border border-neutral-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
            />
          </div>
        </div>

        {/* Right side */}
        <div className="flex items-center space-x-4">
          {/* Notifications */}
          <button
            className="relative p-2 text-neutral-600 hover:text-neutral-900 hover:bg-neutral-100 rounded-lg transition-colors"
            aria-label="Notifications"
          >
            <Bell className="h-5 w-5" />
            <span className="absolute top-1 right-1 w-2 h-2 bg-error-500 rounded-full"></span>
          </button>

          {/* User menu */}
          {user ? (
            <div className="flex items-center space-x-3">
              <div className="text-right">
                <p className="text-sm font-medium text-neutral-900">{user.name}</p>
                <p className="text-xs text-neutral-500">{user.email}</p>
              </div>
              <div className="relative group">
                <button className="flex items-center space-x-2 p-2 rounded-lg hover:bg-neutral-100 transition-colors">
                  {user.avatar ? (
                    <img src={user.avatar} alt={user.name} className="w-8 h-8 rounded-full" />
                  ) : (
                    <div className="w-8 h-8 bg-primary-100 rounded-full flex items-center justify-center">
                      <User className="h-4 w-4 text-primary-600" />
                    </div>
                  )}
                </button>

                {/* Dropdown menu */}
                <div className="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg border border-neutral-200 opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-200 z-50">
                  <div className="py-1">
                    <button
                      onClick={onSettings}
                      className="flex items-center w-full px-4 py-2 text-sm text-neutral-700 hover:bg-neutral-100"
                    >
                      <Settings className="h-4 w-4 mr-2" />
                      Settings
                    </button>
                    <button
                      onClick={onLogout}
                      className="flex items-center w-full px-4 py-2 text-sm text-neutral-700 hover:bg-neutral-100"
                    >
                      <LogOut className="h-4 w-4 mr-2" />
                      Logout
                    </button>
                  </div>
                </div>
              </div>
            </div>
          ) : (
            <Button variant="primary" size="sm">
              Sign In
            </Button>
          )}
        </div>
      </div>
    </header>
  );
};

export default Topbar; 