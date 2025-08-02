# Cool Blues Design System

A comprehensive cross-platform design system for App-Oint with the "Cool Blues" theme.

## 🎨 Design Tokens

### Colors
- **Primary**: `#0A84FF` - Main brand color
- **Secondary**: `#5AC8FA` - Secondary brand color  
- **Accent**: `#64D2FF` - Accent color for highlights
- **Neutral Dark**: `#141414` - Dark text and icons
- **Neutral Light**: `#E5E5EA` - Light backgrounds and borders

### Typography
- **Font Family**: Inter, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif
- **Desktop Headings**: 24px, bold, line-height 1.4, letter-spacing 0.5px
- **Mobile Headings**: 20px, bold, line-height 1.4, letter-spacing 0.5px
- **Desktop Body**: 16px, regular, line-height 1.4, letter-spacing 0.5px
- **Mobile Body**: 14px, regular, line-height 1.4, letter-spacing 0.5px

### Spacing
8-point grid system:
- **xs**: 4px
- **sm**: 8px  
- **md**: 16px
- **lg**: 24px
- **xl**: 32px
- **xxl**: 40px

### Border Radius
- **Default**: 8px
- **Pill**: 24px
- **Circle**: 50%

### Shadows
- **Level 1**: `0 2px 8px rgba(0, 0, 0, 0.1)` - Cards
- **Level 2**: `0 4px 12px rgba(0, 0, 0, 0.15)` - Elevated elements
- **Level 3**: `0 6px 16px rgba(0, 0, 0, 0.2)` - Modals

### Animations
- **Duration**: 200ms
- **Easing**: ease-in-out
- **Transition**: `200ms ease-in-out`

### Breakpoints
- **Mobile**: ≤600px
- **Tablet**: 600-960px
- **Desktop**: ≥960px

## 🧩 Core Components

### Buttons
```jsx
import { Button } from './react-components';

<Button variant="primary">Primary</Button>
<Button variant="secondary">Secondary</Button>
<Button variant="outline">Outline</Button>
<Button variant="ghost">Ghost</Button>
```

### Cards
```jsx
import { Card, CardHeader, CardBody, CardTitle } from './react-components';

<Card>
  <CardHeader>
    <CardTitle>Card Title</CardTitle>
  </CardHeader>
  <CardBody>
    <p>Card content</p>
  </CardBody>
</Card>
```

### Inputs
```jsx
import { Input } from './react-components';

<Input 
  type="text" 
  placeholder="Enter text..."
  label="Input Label"
/>
```

### Modals
```jsx
import { Modal, ModalHeader, ModalBody, ModalFooter } from './react-components';

const { isOpen, open, close } = useModal();

<Button onClick={open}>Open Modal</Button>
<Modal isOpen={isOpen} onClose={close}>
  <ModalHeader onClose={close}>
    <ModalTitle>Modal Title</ModalTitle>
  </ModalHeader>
  <ModalBody>
    <p>Modal content</p>
  </ModalBody>
  <ModalFooter>
    <Button variant="outline" onClick={close}>Cancel</Button>
    <Button onClick={close}>Save</Button>
  </ModalFooter>
</Modal>
```

### Navigation
```jsx
import { Navbar, Sidebar, BottomNav } from './react-components';

// Desktop Navigation
<Navbar>
  <NavbarBrand>APP-OINT</NavbarBrand>
  <NavbarNav>
    <NavLink href="#" isActive>Home</NavLink>
  </NavbarNav>
</Navbar>

<Sidebar>
  <SidebarNavItem icon="📅" isActive>Calendar</SidebarNavItem>
</Sidebar>

// Mobile Navigation
<BottomNav>
  <BottomNavItem icon="📅" label="Calendar" isActive />
  <BottomNavItem icon="📋" label="Today" />
</BottomNav>
```

### Calendar Components
```jsx
import { Calendar, CalendarGrid, CalendarEvent } from './react-components';

<Calendar>
  <CalendarHeader>
    <CalendarTitle>August 2025</CalendarTitle>
  </CalendarHeader>
  <CalendarGrid>
    <CalendarEvent variant="primary">Team Standup</CalendarEvent>
    <CalendarEvent variant="accent">Client Call</CalendarEvent>
  </CalendarGrid>
</Calendar>
```

## 📱 Platform Examples

### Desktop Web (1440×900)
- **Layout**: 3-column CSS grid (sidebar 1fr, calendar 2fr, detail panel 1fr)
- **Header**: Fixed 64px bar with logo, search, and profile
- **Calendar**: Weekly view (Mon-Fri, 8:00-18:00) with current day highlight
- **Events**: Colored blocks with hover effects
- **Detail Panel**: Upcoming meetings list

### Tablet (768×1024)
- **Layout**: 2-column (collapsible sidebar 200px + main)
- **Calendar**: Compact grid with smaller fonts
- **Stats**: 2×2 metric cards
- **Responsive**: Sidebar auto-collapse at ≤960px

### Mobile App (375×812)
- **Top Bar**: "Today" title + date with bottom shadow
- **Event List**: Vertical timeline with time dots
- **FAB**: 56px circle with white "+" icon
- **Bottom Nav**: 5 icons with active states

## 🚀 Installation

### CSS Only
```html
<link rel="stylesheet" href="design-system/shared-tokens.css">
<link rel="stylesheet" href="design-system/components.css">
```

### React/TypeScript
```bash
npm install design-system
```

```jsx
import { Button, Card, Input } from 'design-system';
import 'design-system/shared-tokens.css';
import 'design-system/components.css';
```

## 📋 Usage Guidelines

### Responsive Design
- Use mobile-first approach
- Sidebar collapses to top drawer on tablet/mobile
- Typography scales automatically
- Touch interactions on mobile, hover on desktop

### Interactions
- **Desktop Hover**: Scale 1.02 + shadow level 2
- **Mobile Tap**: Background fade to neutral light
- **Transitions**: 200ms ease-in-out

### Accessibility
- Proper focus states
- Keyboard navigation support
- Screen reader friendly
- High contrast ratios

## 🎯 File Structure

```
design-system/
├── design-tokens.json          # Design tokens specification
├── shared-tokens.css          # CSS variables and utilities
├── components.css             # Core component styles
├── react-components.tsx       # React component library
├── examples/
│   ├── desktop-dashboard-complete.html
│   ├── tablet-dashboard.html
│   └── mobile-today.html
└── README.md                  # This file
```

## 🔧 Customization

### CSS Variables
All design tokens are available as CSS custom properties:

```css
:root {
  --color-primary: #0A84FF;
  --color-secondary: #5AC8FA;
  --spacing-md: 16px;
  --border-radius: 8px;
  /* ... more tokens */
}
```

### Component Props
All React components accept standard HTML attributes and custom props:

```jsx
<Button 
  variant="primary" 
  size="lg" 
  onClick={handleClick}
  className="custom-class"
>
  Custom Button
</Button>
```

## 📊 Browser Support

- **Modern Browsers**: Chrome 88+, Firefox 85+, Safari 14+, Edge 88+
- **CSS Grid**: Full support
- **CSS Custom Properties**: Full support
- **Flexbox**: Full support

## 🤝 Contributing

1. Follow the design tokens specification
2. Maintain responsive behavior
3. Test across all platforms
4. Update documentation
5. Ensure accessibility compliance

## 📄 License

MIT License - see LICENSE file for details.

---

**Built with ❤️ for App-Oint** 