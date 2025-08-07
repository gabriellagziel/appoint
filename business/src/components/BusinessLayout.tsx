import React from 'react';
import { Sidebar, TopBar } from '../../../components/shared';

export interface BusinessLayoutProps {
  children: React.ReactNode;
  sidebarItems: Array<{
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

const BusinessLayout: React.FC<BusinessLayoutProps> = ({
  children,
  sidebarItems,
  title,
  subtitle,
  actions,
  userMenu,
}) => {
  return (
    <div className="flex h-screen bg-gray-50">
      {/* Sidebar */}
      <Sidebar
        items={sidebarItems}
        className="hidden lg:flex"
      />
      
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
          <div className="max-w-7xl mx-auto">
            {children}
          </div>
        </main>
      </div>
    </div>
  );
};

export default BusinessLayout;
