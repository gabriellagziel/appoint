# App-Oint Design System & UX Guidelines

## 🎨 Design Philosophy

The App-Oint platform maintains a **unified design language** across all subdomains while adapting the tone and layout to match each user type's needs.

### Core Principles
- **Consistency**: All subdomains share the same design tokens and components
- **Accessibility**: WCAG 2.1 AA compliance across all interfaces
- **Performance**: Optimized for speed and responsiveness
- **Scalability**: Design system grows with the platform

## 🎯 Subdomain-Specific Guidelines

### 1. User App (`app.app-oint.com`)
**Layout**: Mobile-first with tab navigation
**Tone**: Warm, human, encouraging
**CTA**: "Create meeting"
**Key Features**:
- Bottom tab navigation
- Large touch targets (44px minimum)
- Simplified workflows
- Progressive disclosure

**Copy Examples**:
- "Let's plan your day"
- "Find a time that works"
- "Your next meeting is in 15 minutes"

### 2. Business CRM (`business.app-oint.com`)
**Layout**: Sidebar + topbar navigation
**Tone**: Confident, actionable, professional
**CTA**: "Add customer"
**Key Features**:
- Left sidebar for primary navigation
- Top bar for context and actions
- Data-dense interfaces
- Bulk operations

**Copy Examples**:
- "Add a new lead"
- "Schedule follow-up"
- "Export customer data"

### 3. Enterprise API (`enterprise.app-oint.com`)
**Layout**: Topbar-only navigation
**Tone**: Technical, clear, precise
**CTA**: "Connect system"
**Key Features**:
- Clean, minimal interface
- Code examples prominently displayed
- Technical documentation integration
- API status indicators

**Copy Examples**:
- "Generate new API key"
- "View API documentation"
- "Monitor system health"

### 4. Admin Panel (`admin.app-oint.com`)
**Layout**: Full dashboard with multiple panels
**Tone**: Operational, informative, data-driven
**CTA**: "Broadcast message"
**Key Features**:
- Multi-column layouts
- Real-time data visualization
- Administrative controls
- System monitoring

**Copy Examples**:
- "23 users flagged today"
- "System performance: 99.8%"
- "Deploy to production"

## 🎨 Color System

### Primary Colors
- **Primary Blue**: `#0A84FF` - Main actions, links, primary CTAs
- **Secondary Cyan**: `#5AC8FA` - Secondary actions, highlights
- **Accent Yellow**: `#FFD560` - Warnings, important notices

### Semantic Colors
- **Success**: `#34C759` - Success states, confirmations
- **Warning**: `#FF9500` - Warnings, pending states
- **Danger**: `#FF3B30` - Errors, destructive actions
- **Background**: `#F9FAFB` - Page backgrounds
- **Text**: `#1C1C1E` - Primary text

### Neutral Scale
- **50**: `#FAFAFA` - Subtle backgrounds
- **100**: `#F5F5F5` - Light backgrounds
- **200**: `#E5E5E5` - Borders, dividers
- **300**: `#D4D4D4` - Disabled states
- **400**: `#A3A3A3` - Placeholder text
- **500**: `#737373` - Secondary text
- **600**: `#525252` - Primary text
- **700**: `#404040` - Headings
- **800**: `#262626` - Strong emphasis
- **900**: `#171717` - Maximum contrast

## 📝 Typography

### Font Stack
- **Primary**: Inter (system-ui fallback)
- **Monospace**: JetBrains Mono (for code)

### Font Sizes
- **xs**: 12px - Captions, metadata
- **sm**: 14px - Body text, labels
- **base**: 16px - Default body text
- **lg**: 18px - Large body text
- **xl**: 20px - Small headings
- **2xl**: 24px - Section headings
- **3xl**: 30px - Page titles
- **4xl**: 36px - Hero titles

### Font Weights
- **Regular**: 400 - Body text
- **Medium**: 500 - Labels, emphasis
- **Semibold**: 600 - Headings
- **Bold**: 700 - Strong emphasis

### Line Heights
- **Tight**: 1.25 - Headings
- **Normal**: 1.5 - Body text
- **Relaxed**: 1.75 - Large text blocks

## 🧩 Component Guidelines

### Button Usage
- **Primary**: Main actions, CTAs
- **Secondary**: Supporting actions
- **Outline**: Alternative actions
- **Ghost**: Subtle actions
- **Danger**: Destructive actions

### Card Usage
- **Default**: Standard content containers
- **Elevated**: Important content, modals
- **Outlined**: Subtle content separation

### Badge Usage
- **Default**: General status indicators
- **Primary**: Important status
- **Success**: Positive states
- **Warning**: Caution states
- **Danger**: Error states
- **Outline**: Subtle indicators

## 📱 Responsive Design

### Breakpoints
- **Mobile**: < 768px
- **Tablet**: 768px - 1024px
- **Desktop**: > 1024px

### Mobile-First Approach
1. Design for mobile first
2. Enhance for larger screens
3. Ensure touch targets are 44px minimum
4. Use appropriate text sizes for readability

## ♿ Accessibility

### WCAG 2.1 AA Compliance
- **Color Contrast**: Minimum 4.5:1 for normal text
- **Focus Indicators**: Visible focus states
- **Keyboard Navigation**: Full keyboard accessibility
- **Screen Reader Support**: Proper ARIA labels
- **Alternative Text**: Images have descriptive alt text

### Best Practices
- Use semantic HTML elements
- Provide clear error messages
- Ensure logical tab order
- Test with screen readers
- Maintain color contrast ratios

## 🚀 Performance Guidelines

### Loading States
- Show skeleton screens for content
- Use progressive loading
- Implement optimistic updates
- Provide clear loading indicators

### Animation Guidelines
- Keep animations under 300ms
- Use easing functions for natural feel
- Respect user's motion preferences
- Avoid excessive animations

## 📊 Data Visualization

### Charts and Graphs
- Use consistent color schemes
- Provide clear labels and legends
- Ensure accessibility for colorblind users
- Include data tables as alternatives

### Tables
- Use zebra striping for readability
- Implement proper sorting and filtering
- Ensure mobile responsiveness
- Provide clear column headers

## 🔧 Implementation Notes

### CSS Custom Properties
Use design tokens for consistent theming:
```css
:root {
  --color-primary: #0A84FF;
  --color-secondary: #5AC8FA;
  --color-accent: #FFD560;
  --color-background: #F9FAFB;
  --color-text: #1C1C1E;
}
```

### Component Import Pattern
```typescript
import { Button, Card, Badge } from '../../components/shared';
```

### Tailwind Configuration
All subdomains should extend the base design tokens in their `tailwind.config.js` files.

## 📋 Quality Checklist

Before deploying any UI changes:
- [ ] Design tokens are consistent
- [ ] Components follow accessibility guidelines
- [ ] Responsive design works on all breakpoints
- [ ] Performance meets standards
- [ ] Copy matches subdomain tone
- [ ] Loading states are implemented
- [ ] Error states are handled gracefully
- [ ] User testing feedback is incorporated

---

*This document should be updated as the design system evolves. All team members should reference these guidelines when building new features.*
