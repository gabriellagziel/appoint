import React from 'react';
import { cn } from '../../lib/utils';

export interface TopBarProps {
  title?: string;
  subtitle?: string;
  actions?: React.ReactNode;
  userMenu?: React.ReactNode;
  className?: string;
  showBreadcrumbs?: boolean;
  breadcrumbs?: Array<{ label: string; href?: string }>;
}

const TopBar = React.forwardRef<HTMLDivElement, TopBarProps>(
  ({ title, subtitle, actions, userMenu, className, showBreadcrumbs = false, breadcrumbs = [] }, ref) => {
    return (
      <div
        ref={ref}
        className={cn(
          'bg-white border-b border-gray-200 px-6 py-4',
          className
        )}
      >
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-4">
            {showBreadcrumbs && breadcrumbs.length > 0 && (
              <nav className="flex items-center space-x-2 text-sm text-gray-500">
                {breadcrumbs.map((crumb, index) => (
                  <React.Fragment key={index}>
                    {index > 0 && (
                      <svg className="h-4 w-4" fill="currentColor" viewBox="0 0 20 20">
                        <path fillRule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clipRule="evenodd" />
                      </svg>
                    )}
                    {crumb.href ? (
                      <a
                        href={crumb.href}
                        className="hover:text-gray-700 transition-colors"
                      >
                        {crumb.label}
                      </a>
                    ) : (
                      <span>{crumb.label}</span>
                    )}
                  </React.Fragment>
                ))}
              </nav>
            )}
            
            <div>
              {title && (
                <h1 className="text-xl font-semibold text-gray-900">{title}</h1>
              )}
              {subtitle && (
                <p className="text-sm text-gray-500 mt-1">{subtitle}</p>
              )}
            </div>
          </div>
          
          <div className="flex items-center space-x-4">
            {actions && (
              <div className="flex items-center space-x-2">
                {actions}
              </div>
            )}
            
            {userMenu && (
              <div className="flex items-center">
                {userMenu}
              </div>
            )}
          </div>
        </div>
      </div>
    );
  }
);

TopBar.displayName = 'TopBar';

export { TopBar };
