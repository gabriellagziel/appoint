import React from 'react';
import { cn } from '../../lib/utils';

export interface SidebarItem {
  id: string;
  label: string;
  icon?: React.ReactNode;
  href?: string;
  onClick?: () => void;
  active?: boolean;
  children?: SidebarItem[];
}

export interface SidebarProps {
  items: SidebarItem[];
  className?: string;
  collapsed?: boolean;
  onItemClick?: (item: SidebarItem) => void;
}

const Sidebar = React.forwardRef<HTMLDivElement, SidebarProps>(
  ({ items, className, collapsed = false, onItemClick }, ref) => {
    const renderItem = (item: SidebarItem) => {
      const isActive = item.active;
      
      return (
        <div key={item.id}>
          <button
            onClick={() => {
              if (item.onClick) {
                item.onClick();
              } else if (onItemClick) {
                onItemClick(item);
              }
            }}
            className={cn(
              'w-full flex items-center px-4 py-2 text-sm font-medium rounded-md transition-colors',
              isActive
                ? 'bg-blue-100 text-blue-700'
                : 'text-gray-700 hover:bg-gray-100 hover:text-gray-900',
              collapsed && 'justify-center'
            )}
          >
            {item.icon && (
              <span className={cn('mr-3', collapsed && 'mr-0')}>
                {item.icon}
              </span>
            )}
            {!collapsed && item.label}
          </button>
          
          {item.children && !collapsed && (
            <div className="ml-4 mt-1 space-y-1">
              {item.children.map(renderItem)}
            </div>
          )}
        </div>
      );
    };

    return (
      <div
        ref={ref}
        className={cn(
          'flex flex-col bg-white border-r border-gray-200',
          collapsed ? 'w-16' : 'w-64',
          className
        )}
      >
        <div className="flex-1 flex flex-col pt-5 pb-4 overflow-y-auto">
          <nav className="flex-1 px-2 space-y-1">
            {items.map(renderItem)}
          </nav>
        </div>
      </div>
    );
  }
);

Sidebar.displayName = 'Sidebar';

export { Sidebar };
