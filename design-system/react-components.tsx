import React, { useCallback, useState } from 'react';
import './components.css';
import './shared-tokens.css';

// ===== TYPE DEFINITIONS =====
export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
    variant?: 'primary' | 'secondary' | 'outline' | 'ghost';
    size?: 'sm' | 'md' | 'lg';
    children: React.ReactNode;
}

export interface CardProps extends React.HTMLAttributes<HTMLDivElement> {
    variant?: 'default' | 'elevated' | 'outlined';
    children: React.ReactNode;
}

export interface InputProps extends React.InputHTMLAttributes<HTMLInputElement> {
    type?: 'text' | 'email' | 'password' | 'search';
    error?: boolean;
    label?: string;
}

export interface ModalProps {
    isOpen: boolean;
    onClose: () => void;
    children: React.ReactNode;
    variant?: 'default' | 'drawer' | 'fullscreen';
}

export interface TabProps {
    label: string;
    isActive: boolean;
    onClick: () => void;
    icon?: React.ReactNode;
}

export interface NavigationItem {
    label: string;
    icon: React.ReactNode;
    href?: string;
    isActive?: boolean;
}

export interface CalendarEvent {
    id: string;
    title: string;
    time: string;
    duration: number;
    color?: 'primary' | 'accent';
}

// ===== BUTTON COMPONENTS =====
export const Button: React.FC<ButtonProps> = ({
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
export const Card: React.FC<CardProps> = ({
    children,
    variant = 'default',
    className = '',
    ...props
}) => {
    const variantClass = variant === 'elevated' ? 'shadow-level-2' :
        variant === 'outlined' ? 'border border-neutral-light' : '';

    return (
        <div className={`card ${variantClass} ${className}`} {...props}>
            {children}
        </div>
    );
};

export const CardHeader: React.FC<React.HTMLAttributes<HTMLDivElement>> = ({
    children,
    className = '',
    ...props
}) => (
    <div className={`card-header ${className}`} {...props}>
        {children}
    </div>
);

export const CardBody: React.FC<React.HTMLAttributes<HTMLDivElement>> = ({
    children,
    className = '',
    ...props
}) => (
    <div className={`card-body ${className}`} {...props}>
        {children}
    </div>
);

export const CardFooter: React.FC<React.HTMLAttributes<HTMLDivElement>> = ({
    children,
    className = '',
    ...props
}) => (
    <div className={`card-footer ${className}`} {...props}>
        {children}
    </div>
);

export const CardTitle: React.FC<React.HTMLAttributes<HTMLHeadingElement>> = ({
    children,
    className = '',
    ...props
}) => (
    <h3 className={`card-title ${className}`} {...props}>
        {children}
    </h3>
);

export const CardSubtitle: React.FC<React.HTMLAttributes<HTMLParagraphElement>> = ({
    children,
    className = '',
    ...props
}) => (
    <p className={`card-subtitle ${className}`} {...props}>
        {children}
    </p>
);

// ===== INPUT COMPONENTS =====
export const Input: React.FC<InputProps> = ({
    type = 'text',
    error = false,
    label,
    className = '',
    ...props
}) => {
    const errorClass = error ? 'border-red-500' : '';

    return (
        <div className="input-wrapper">
            {label && (
                <label className="input-label text-body text-neutral-dark mb-sm">
                    {label}
                </label>
            )}
            <input
                type={type}
                className={`input ${errorClass} ${className}`}
                {...props}
            />
        </div>
    );
};

export const InputGroup: React.FC<React.HTMLAttributes<HTMLDivElement>> = ({
    children,
    className = '',
    ...props
}) => (
    <div className={`input-group ${className}`} {...props}>
        {children}
    </div>
);

// ===== MODAL COMPONENTS =====
export const Modal: React.FC<ModalProps> = ({
    isOpen,
    onClose,
    children,
    variant = 'default',
    ...props
}) => {
    if (!isOpen) return null;

    const variantClass = variant === 'drawer' ? 'modal-drawer' :
        variant === 'fullscreen' ? 'modal-fullscreen' : '';

    return (
        <div className="modal-overlay" onClick={onClose}>
            <div
                className={`modal ${variantClass}`}
                onClick={e => e.stopPropagation()}
                {...props}
            >
                {children}
            </div>
        </div>
    );
};

export const ModalHeader: React.FC<{
    children: React.ReactNode;
    onClose?: () => void;
    className?: string;
}> = ({ children, onClose, className = '', ...props }) => (
    <div className={`modal-header ${className}`} {...props}>
        {children}
        {onClose && (
            <button className="modal-close" onClick={onClose}>
                ×
            </button>
        )}
    </div>
);

export const ModalTitle: React.FC<React.HTMLAttributes<HTMLHeadingElement>> = ({
    children,
    className = '',
    ...props
}) => (
    <h2 className={`modal-title ${className}`} {...props}>
        {children}
    </h2>
);

export const ModalBody: React.FC<React.HTMLAttributes<HTMLDivElement>> = ({
    children,
    className = '',
    ...props
}) => (
    <div className={`modal-body ${className}`} {...props}>
        {children}
    </div>
);

export const ModalFooter: React.FC<React.HTMLAttributes<HTMLDivElement>> = ({
    children,
    className = '',
    ...props
}) => (
    <div className={`modal-footer ${className}`} {...props}>
        {children}
    </div>
);

// ===== TAB COMPONENTS =====
export const Tabs: React.FC<React.HTMLAttributes<HTMLDivElement>> = ({
    children,
    className = '',
    ...props
}) => (
    <div className={`tabs ${className}`} {...props}>
        {children}
    </div>
);

export const Tab: React.FC<TabProps> = ({
    label,
    isActive = false,
    onClick,
    icon,
    className = '',
    ...props
}) => (
    <button
        className={`tab ${isActive ? 'active' : ''} ${className}`}
        onClick={onClick}
        {...props}
    >
        {icon && <span className="tab-icon">{icon}</span>}
        {label}
    </button>
);

export const TabContent: React.FC<React.HTMLAttributes<HTMLDivElement>> = ({
    children,
    className = '',
    ...props
}) => (
    <div className={`tab-content ${className}`} {...props}>
        {children}
    </div>
);

// ===== NAVIGATION COMPONENTS =====
export const Navbar: React.FC<React.HTMLAttributes<HTMLElement>> = ({
    children,
    className = '',
    ...props
}) => (
    <nav className={`navbar ${className}`} {...props}>
        {children}
    </nav>
);

export const NavbarBrand: React.FC<React.AnchorHTMLAttributes<HTMLAnchorElement>> = ({
    children,
    className = '',
    ...props
}) => (
    <a className={`navbar-brand ${className}`} {...props}>
        {children}
    </a>
);

export const NavbarNav: React.FC<React.HTMLAttributes<HTMLDivElement>> = ({
    children,
    className = '',
    ...props
}) => (
    <div className={`navbar-nav ${className}`} {...props}>
        {children}
    </div>
);

export const NavLink: React.FC<{
    children: React.ReactNode;
    isActive?: boolean;
    href?: string;
    className?: string;
}> = ({ children, isActive = false, href, className = '', ...props }) => (
    <a
        href={href}
        className={`nav-link ${isActive ? 'active' : ''} ${className}`}
        {...props}
    >
        {children}
    </a>
);

export const Sidebar: React.FC<React.HTMLAttributes<HTMLElement>> = ({
    children,
    className = '',
    ...props
}) => (
    <aside className={`sidebar ${className}`} {...props}>
        {children}
    </aside>
);

export const SidebarNav: React.FC<React.HTMLAttributes<HTMLElement>> = ({
    children,
    className = '',
    ...props
}) => (
    <nav className={`sidebar-nav ${className}`} {...props}>
        {children}
    </nav>
);

export const SidebarNavItem: React.FC<{
    children: React.ReactNode;
    icon?: React.ReactNode;
    isActive?: boolean;
    href?: string;
    className?: string;
}> = ({ children, icon, isActive = false, href, className = '', ...props }) => (
    <a
        href={href}
        className={`sidebar-nav-item ${isActive ? 'active' : ''} ${className}`}
        {...props}
    >
        {icon && <span className="sidebar-nav-icon">{icon}</span>}
        {children}
    </a>
);

export const BottomNav: React.FC<React.HTMLAttributes<HTMLElement>> = ({
    children,
    className = '',
    ...props
}) => (
    <nav className={`bottom-nav ${className}`} {...props}>
        {children}
    </nav>
);

export const BottomNavItem: React.FC<{
    children: React.ReactNode;
    icon: React.ReactNode;
    label: string;
    isActive?: boolean;
    href?: string;
    className?: string;
}> = ({ children, icon, label, isActive = false, href, className = '', ...props }) => (
    <a
        href={href}
        className={`bottom-nav-item ${isActive ? 'active' : ''} ${className}`}
        {...props}
    >
        <span className="bottom-nav-icon">{icon}</span>
        <span className="bottom-nav-label">{label}</span>
    </a>
);

// ===== FLOATING ACTION BUTTON =====
export const FAB: React.FC<React.ButtonHTMLAttributes<HTMLButtonElement>> = ({
    children,
    className = '',
    ...props
}) => (
    <button className={`fab ${className}`} {...props}>
        {children}
    </button>
);

// ===== CALENDAR COMPONENTS =====
export const Calendar: React.FC<React.HTMLAttributes<HTMLDivElement>> = ({
    children,
    className = '',
    ...props
}) => (
    <div className={`calendar ${className}`} {...props}>
        {children}
    </div>
);

export const CalendarHeader: React.FC<React.HTMLAttributes<HTMLDivElement>> = ({
    children,
    className = '',
    ...props
}) => (
    <div className={`calendar-header ${className}`} {...props}>
        {children}
    </div>
);

export const CalendarTitle: React.FC<React.HTMLAttributes<HTMLHeadingElement>> = ({
    children,
    className = '',
    ...props
}) => (
    <h2 className={`calendar-title ${className}`} {...props}>
        {children}
    </h2>
);

export const CalendarGrid: React.FC<React.HTMLAttributes<HTMLDivElement>> = ({
    children,
    className = '',
    ...props
}) => (
    <div className={`calendar-grid ${className}`} {...props}>
        {children}
    </div>
);

export const CalendarTimeSlot: React.FC<React.HTMLAttributes<HTMLDivElement>> = ({
    children,
    className = '',
    ...props
}) => (
    <div className={`calendar-time-slot ${className}`} {...props}>
        {children}
    </div>
);

export const CalendarDayHeader: React.FC<{
    children: React.ReactNode;
    isToday?: boolean;
    className?: string;
}> = ({ children, isToday = false, className = '', ...props }) => (
    <div
        className={`calendar-day-header ${isToday ? 'today' : ''} ${className}`}
        {...props}
    >
        {children}
    </div>
);

export const CalendarCell: React.FC<React.HTMLAttributes<HTMLDivElement>> = ({
    children,
    className = '',
    ...props
}) => (
    <div className={`calendar-cell ${className}`} {...props}>
        {children}
    </div>
);

export const CalendarEvent: React.FC<{
    children: React.ReactNode;
    variant?: 'primary' | 'accent';
    className?: string;
}> = ({ children, variant = 'primary', className = '', ...props }) => (
    <div
        className={`calendar-event ${variant === 'accent' ? 'accent' : ''} ${className}`}
        {...props}
    >
        {children}
    </div>
);

// ===== EVENT LIST COMPONENTS (MOBILE) =====
export const EventList: React.FC<React.HTMLAttributes<HTMLDivElement>> = ({
    children,
    className = '',
    ...props
}) => (
    <div className={`event-list ${className}`} {...props}>
        {children}
    </div>
);

export const EventItem: React.FC<React.HTMLAttributes<HTMLDivElement>> = ({
    children,
    className = '',
    ...props
}) => (
    <div className={`event-item ${className}`} {...props}>
        {children}
    </div>
);

export const TimeIndicator: React.FC<React.HTMLAttributes<HTMLDivElement>> = ({
    children,
    className = '',
    ...props
}) => (
    <div className={`time-indicator ${className}`} {...props}>
        {children}
    </div>
);

export const TimeDot: React.FC<React.HTMLAttributes<HTMLDivElement>> = ({
    className = '',
    ...props
}) => (
    <div className={`time-dot ${className}`} {...props} />
);

export const TimeLine: React.FC<React.HTMLAttributes<HTMLDivElement>> = ({
    className = '',
    ...props
}) => (
    <div className={`time-line ${className}`} {...props} />
);

export const EventContent: React.FC<React.HTMLAttributes<HTMLDivElement>> = ({
    children,
    className = '',
    ...props
}) => (
    <div className={`event-content ${className}`} {...props}>
        {children}
    </div>
);

export const EventTime: React.FC<React.HTMLAttributes<HTMLDivElement>> = ({
    children,
    className = '',
    ...props
}) => (
    <div className={`event-time ${className}`} {...props}>
        {children}
    </div>
);

export const EventTitle: React.FC<React.HTMLAttributes<HTMLDivElement>> = ({
    children,
    className = '',
    ...props
}) => (
    <div className={`event-title ${className}`} {...props}>
        {children}
    </div>
);

export const EventSubtitle: React.FC<React.HTMLAttributes<HTMLDivElement>> = ({
    children,
    className = '',
    ...props
}) => (
    <div className={`event-subtitle ${className}`} {...props}>
        {children}
    </div>
);

export const EventStatus: React.FC<React.HTMLAttributes<HTMLDivElement>> = ({
    className = '',
    ...props
}) => (
    <div className={`event-status ${className}`} {...props} />
);

// ===== LAYOUT COMPONENTS =====
export const Container: React.FC<React.HTMLAttributes<HTMLDivElement>> = ({
    children,
    className = '',
    ...props
}) => (
    <div className={`container ${className}`} {...props}>
        {children}
    </div>
);

export const Row: React.FC<React.HTMLAttributes<HTMLDivElement>> = ({
    children,
    className = '',
    ...props
}) => (
    <div className={`row ${className}`} {...props}>
        {children}
    </div>
);

export const Col: React.FC<React.HTMLAttributes<HTMLDivElement>> = ({
    children,
    className = '',
    ...props
}) => (
    <div className={`col ${className}`} {...props}>
        {children}
    </div>
);

// ===== UTILITY COMPONENTS =====
export const Spacer: React.FC<{
    size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl';
    className?: string;
}> = ({ size = 'md', className = '', ...props }) => (
    <div
        className={`spacer-${size} ${className}`}
        style={{ height: `var(--spacing-${size})` }}
        {...props}
    />
);

export const Divider: React.FC<React.HTMLAttributes<HTMLHRElement>> = ({
    className = '',
    ...props
}) => (
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

// ===== CUSTOM HOOKS =====
export const useModal = () => {
    const [isOpen, setIsOpen] = useState(false);

    const open = useCallback(() => setIsOpen(true), []);
    const close = useCallback(() => setIsOpen(false), []);
    const toggle = useCallback(() => setIsOpen(prev => !prev), []);

    return { isOpen, open, close, toggle };
};

export const useTabs = (initialTab = 0) => {
    const [activeTab, setActiveTab] = useState(initialTab);

    const switchTab = useCallback((index: number) => setActiveTab(index), []);

    return { activeTab, switchTab };
};

// ===== EXAMPLE USAGE =====
export const ExampleUsage: React.FC = () => {
    const { isOpen, open, close } = useModal();
    const { activeTab, switchTab } = useTabs();

    return (
        <div className="p-lg">
            <h1 className="text-heading mb-lg">Component Examples</h1>

            {/* Buttons */}
            <section className="mb-lg">
                <h2 className="text-heading mb-md">Buttons</h2>
                <div className="flex gap-md">
                    <Button variant="primary">Primary</Button>
                    <Button variant="secondary">Secondary</Button>
                    <Button variant="outline">Outline</Button>
                    <Button variant="ghost">Ghost</Button>
                </div>
            </section>

            {/* Cards */}
            <section className="mb-lg">
                <h2 className="text-heading mb-md">Cards</h2>
                <div className="grid grid-cols-3 gap-md">
                    <Card>
                        <CardHeader>
                            <CardTitle>Card Title</CardTitle>
                        </CardHeader>
                        <CardBody>
                            <p>Card content goes here</p>
                        </CardBody>
                    </Card>
                </div>
            </section>

            {/* Modal */}
            <section className="mb-lg">
                <h2 className="text-heading mb-md">Modal</h2>
                <Button onClick={open}>Open Modal</Button>
                <Modal isOpen={isOpen} onClose={close}>
                    <ModalHeader onClose={close}>
                        <ModalTitle>Modal Title</ModalTitle>
                    </ModalHeader>
                    <ModalBody>
                        <p>Modal content goes here</p>
                    </ModalBody>
                    <ModalFooter>
                        <Button variant="outline" onClick={close}>Cancel</Button>
                        <Button onClick={close}>Save</Button>
                    </ModalFooter>
                </Modal>
            </section>

            {/* Tabs */}
            <section className="mb-lg">
                <h2 className="text-heading mb-md">Tabs</h2>
                <Tabs>
                    <Tab
                        label="Tab 1"
                        isActive={activeTab === 0}
                        onClick={() => switchTab(0)}
                    />
                    <Tab
                        label="Tab 2"
                        isActive={activeTab === 1}
                        onClick={() => switchTab(1)}
                    />
                </Tabs>
                <TabContent>
                    {activeTab === 0 && <p>Tab 1 content</p>}
                    {activeTab === 1 && <p>Tab 2 content</p>}
                </TabContent>
            </section>
        </div>
    );
}; 