import React from 'react';
import { TopBar } from '../../../components/shared';

export interface EnterpriseLayoutProps {
  children: React.ReactNode;
  title?: string;
  subtitle?: string;
  actions?: React.ReactNode;
  userMenu?: React.ReactNode;
  breadcrumbs?: Array<{ label: string; href?: string }>;
}

const EnterpriseLayout: React.FC<EnterpriseLayoutProps> = ({
  children,
  title,
  subtitle,
  actions,
  userMenu,
  breadcrumbs,
}) => {
  return (
    <div className="min-h-screen bg-gray-50">
      {/* Top Bar Only - Enterprise uses minimal navigation */}
      <TopBar
        title={title}
        subtitle={subtitle}
        actions={actions}
        userMenu={userMenu}
        showBreadcrumbs={true}
        breadcrumbs={breadcrumbs}
      />
      
      {/* Page Content */}
      <main className="max-w-6xl mx-auto p-6">
        {children}
      </main>
    </div>
  );
};

export default EnterpriseLayout;
