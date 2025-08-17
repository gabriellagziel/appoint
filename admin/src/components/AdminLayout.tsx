"use client";
import React from 'react';
import { TopBar } from './TopBar';
import { Sidebar } from './Sidebar';

export interface AdminLayoutProps {
  children: React.ReactNode;
  sidebarItems?: Array<{
    id: string;
    label: string;
    icon?: React.ReactNode;
    active?: boolean;
    onClick?: () => void;
  }>;
  title?: string;
  subtitle?: string;
  actions?: React.ReactNode;
  userMenu?: React.ReactNode;
}

const AdminLayout: React.FC<AdminLayoutProps> = ({
  children,
  sidebarItems = [],
  title,
  subtitle,
  actions,
  userMenu,
}) => {
  return (
    <div className="flex h-screen bg-gray-50">
      {/* Sidebar */}
      <Sidebar isOpen={true} onToggle={() => {}} />
      
      {/* Main Content */}
      <div className="flex-1 flex flex-col overflow-hidden">
        {/* Top Bar */}
        <TopBar
          title={title}
          subtitle={subtitle}
          actions={actions}
          userMenu={userMenu}
        />
        
        {/* Page Content */}
        <main className="flex-1 overflow-y-auto p-6">
          {children}
        </main>
      </div>
    </div>
  );
};

export default AdminLayout; 
export { AdminLayout };