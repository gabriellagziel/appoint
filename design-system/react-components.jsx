import React from 'react';
import './components.css';
import './shared-tokens.css';

// ===== BUTTON COMPONENTS =====
export const Button = ({
    children,
    variant = 'primary',
    size = 'md',
    className = '',
    ...props
}) => {
    const baseClass = 'btn';
    const variantClass = `btn-${variant}`;
    const sizeClass = size === 'sm' ? 'btn-sm' : size === 'lg' ? 'btn-lg' : '';

    return (
        <button
            className={`${baseClass} ${variantClass} ${sizeClass} ${className}`}
            {...props}
        >
            {children}
        </button>
    );
};

// ===== CARD COMPONENTS =====
export const Card = ({ children, className = '', ...props }) => (
    <div className={`card ${className}`} {...props}>
        {children}
    </div>
);

export const CardHeader = ({ children, className = '', ...props }) => (
    <div className={`card-header ${className}`} {...props}>
        {children}
    </div>
);

export const CardBody = ({ children, className = '', ...props }) => (
    <div className={`card-body ${className}`} {...props}>
        {children}
    </div>
);

export const CardFooter = ({ children, className = '', ...props }) => (
    <div className={`card-footer ${className}`} {...props}>
        {children}
    </div>
);

export const CardTitle = ({ children, className = '', ...props }) => (
    <h3 className={`card-title ${className}`} {...props}>
        {children}
    </h3>
);

export const CardSubtitle = ({ children, className = '', ...props }) => (
    <p className={`card-subtitle ${className}`} {...props}>
        {children}
    </p>
);

// ===== INPUT COMPONENTS =====
export const Input = ({ className = '', ...props }) => (
    <input className={`input ${className}`} {...props} />
);

export const InputGroup = ({ children, className = '', ...props }) => (
    <div className={`input-group ${className}`} {...props}>
        {children}
    </div>
);

// ===== MODAL COMPONENTS =====
export const Modal = ({ isOpen, onClose, children, className = '', ...props }) => {
    if (!isOpen) return null;

    return (
        <div className="modal-overlay" onClick={onClose}>
            <div className={`modal ${className}`} onClick={e => e.stopPropagation()} {...props}>
                {children}
            </div>
        </div>
    );
};

export const ModalHeader = ({ children, onClose, className = '', ...props }) => (
    <div className={`modal-header ${className}`} {...props}>
        {children}
        {onClose && (
            <button className="modal-close" onClick={onClose}>
                ×
            </button>
        )}
    </div>
);

export const ModalTitle = ({ children, className = '', ...props }) => (
    <h2 className={`modal-title ${className}`} {...props}>
        {children}
    </h2>
);

export const ModalBody = ({ children, className = '', ...props }) => (
    <div className={`modal-body ${className}`} {...props}>
        {children}
    </div>
);

export const ModalFooter = ({ children, className = '', ...props }) => (
    <div className={`modal-footer ${className}`} {...props}>
        {children}
    </div>
);

// ===== TAB COMPONENTS =====
export const Tabs = ({ children, className = '', ...props }) => (
    <div className={`tabs ${className}`} {...props}>
        {children}
    </div>
);

export const Tab = ({
    children,
    isActive = false,
    onClick,
    className = '',
    ...props
}) => (
    <button
        className={`tab ${isActive ? 'active' : ''} ${className}`}
        onClick={onClick}
        {...props}
    >
        {children}
    </button>
);

export const TabContent = ({ children, className = '', ...props }) => (
    <div className={`tab-content ${className}`} {...props}>
        {children}
    </div>
);

// ===== NAVIGATION COMPONENTS =====
export const Navbar = ({ children, className = '', ...props }) => (
    <nav className={`navbar ${className}`} {...props}>
        {children}
    </nav>
);

export const NavbarBrand = ({ children, className = '', ...props }) => (
    <a className={`navbar-brand ${className}`} {...props}>
        {children}
    </a>
);

export const NavbarNav = ({ children, className = '', ...props }) => (
    <div className={`navbar-nav ${className}`} {...props}>
        {children}
    </div>
);

export const NavLink = ({
    children,
    isActive = false,
    className = '',
    ...props
}) => (
    <a
        className={`nav-link ${isActive ? 'active' : ''} ${className}`}
        {...props}
    >
        {children}
    </a>
);

export const Sidebar = ({ children, className = '', ...props }) => (
    <aside className={`sidebar ${className}`} {...props}>
        {children}
    </aside>
);

export const SidebarNav = ({ children, className = '', ...props }) => (
    <nav className={`sidebar-nav ${className}`} {...props}>
        {children}
    </nav>
);

export const SidebarNavItem = ({
    children,
    icon,
    isActive = false,
    className = '',
    ...props
}) => (
    <a
        className={`sidebar-nav-item ${isActive ? 'active' : ''} ${className}`}
        {...props}
    >
        {icon && <span className="sidebar-nav-icon">{icon}</span>}
        {children}
    </a>
);

export const BottomNav = ({ children, className = '', ...props }) => (
    <nav className={`bottom-nav ${className}`} {...props}>
        {children}
    </nav>
);

export const BottomNavItem = ({
    children,
    icon,
    label,
    isActive = false,
    className = '',
    ...props
}) => (
    <a
        className={`bottom-nav-item ${isActive ? 'active' : ''} ${className}`}
        {...props}
    >
        <span className="bottom-nav-icon">{icon}</span>
        <span className="bottom-nav-label">{label}</span>
    </a>
);

// ===== FLOATING ACTION BUTTON =====
export const FAB = ({ children, className = '', ...props }) => (
    <button className={`fab ${className}`} {...props}>
        {children}
    </button>
);

// ===== CALENDAR COMPONENTS =====
export const Calendar = ({ children, className = '', ...props }) => (
    <div className={`calendar ${className}`} {...props}>
        {children}
    </div>
);

export const CalendarHeader = ({ children, className = '', ...props }) => (
    <div className={`calendar-header ${className}`} {...props}>
        {children}
    </div>
);

export const CalendarTitle = ({ children, className = '', ...props }) => (
    <h2 className={`calendar-title ${className}`} {...props}>
        {children}
    </h2>
);

export const CalendarGrid = ({ children, className = '', ...props }) => (
    <div className={`calendar-grid ${className}`} {...props}>
        {children}
    </div>
);

export const CalendarTimeSlot = ({ children, className = '', ...props }) => (
    <div className={`calendar-time-slot ${className}`} {...props}>
        {children}
    </div>
);

export const CalendarDayHeader = ({
    children,
    isToday = false,
    className = '',
    ...props
}) => (
    <div
        className={`calendar-day-header ${isToday ? 'today' : ''} ${className}`}
        {...props}
    >
        {children}
    </div>
);

export const CalendarCell = ({ children, className = '', ...props }) => (
    <div className={`calendar-cell ${className}`} {...props}>
        {children}
    </div>
);

export const CalendarEvent = ({
    children,
    variant = 'primary',
    className = '',
    ...props
}) => (
    <div
        className={`calendar-event ${variant === 'accent' ? 'accent' : ''} ${className}`}
        {...props}
    >
        {children}
    </div>
);

// ===== EVENT LIST COMPONENTS (MOBILE) =====
export const EventList = ({ children, className = '', ...props }) => (
    <div className={`event-list ${className}`} {...props}>
        {children}
    </div>
);

export const EventItem = ({ children, className = '', ...props }) => (
    <div className={`event-item ${className}`} {...props}>
        {children}
    </div>
);

export const TimeIndicator = ({ children, className = '', ...props }) => (
    <div className={`time-indicator ${className}`} {...props}>
        {children}
    </div>
);

export const TimeDot = ({ className = '', ...props }) => (
    <div className={`time-dot ${className}`} {...props} />
);

export const TimeLine = ({ className = '', ...props }) => (
    <div className={`time-line ${className}`} {...props} />
);

export const EventContent = ({ children, className = '', ...props }) => (
    <div className={`event-content ${className}`} {...props}>
        {children}
    </div>
);

export const EventTime = ({ children, className = '', ...props }) => (
    <div className={`event-time ${className}`} {...props}>
        {children}
    </div>
);

export const EventTitle = ({ children, className = '', ...props }) => (
    <div className={`event-title ${className}`} {...props}>
        {children}
    </div>
);

export const EventSubtitle = ({ children, className = '', ...props }) => (
    <div className={`event-subtitle ${className}`} {...props}>
        {children}
    </div>
);

export const EventStatus = ({ className = '', ...props }) => (
    <div className={`event-status ${className}`} {...props} />
);

// ===== LAYOUT COMPONENTS =====
export const Container = ({ children, className = '', ...props }) => (
    <div className={`container ${className}`} {...props}>
        {children}
    </div>
);

export const Row = ({ children, className = '', ...props }) => (
    <div className={`row ${className}`} {...props}>
        {children}
    </div>
);

export const Col = ({ children, className = '', ...props }) => (
    <div className={`col ${className}`} {...props}>
        {children}
    </div>
);

// ===== UTILITY COMPONENTS =====
export const Spacer = ({ size = 'md', className = '', ...props }) => (
    <div
        className={`spacer-${size} ${className}`}
        style={{ height: `var(--spacing-${size})` }}
        {...props}
    />
);

export const Divider = ({ className = '', ...props }) => (
    <hr
        className={`divider ${className}`}
        style={{
            border: 'none',
            height: '1px',
            background: 'var(--color-neutral-light)',
            margin: 'var(--spacing-md) 0'
        }}
        {...props}
    />
);

// ===== HOOKS =====
export const useModal = () => {
    const [isOpen, setIsOpen] = React.useState(false);

    const open = React.useCallback(() => setIsOpen(true), []);
    const close = React.useCallback(() => setIsOpen(false), []);
    const toggle = React.useCallback(() => setIsOpen(prev => !prev), []);

    return { isOpen, open, close, toggle };
};

export const useTabs = (initialTab = 0) => {
    const [activeTab, setActiveTab] = React.useState(initialTab);

    const switchTab = React.useCallback((index) => setActiveTab(index), []);

    return { activeTab, switchTab };
}; 