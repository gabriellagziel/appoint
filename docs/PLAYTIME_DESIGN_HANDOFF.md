# Playtime Feature - Complete Design Handoff

## Overview
This document provides comprehensive design specifications for the Playtime feature that can be directly translated into Figma/Sketch wireframes and component libraries.

## 🎨 Design System Foundation

### Color Palette
```css
/* Primary Colors */
--playtime-purple: #8B5CF6;
--playtime-pink: #EC4899;
--playtime-blue: #3B82F6;
--playtime-green: #10B981;

/* Secondary Colors */
--warm-yellow: #F59E0B;
--soft-orange: #FB923C;
--light-purple: #DDD6FE;
--light-pink: #FCE7F3;

/* Neutral Colors */
--pure-white: #FFFFFF;
--light-gray: #F8FAFC;
--medium-gray: #94A3B8;
--dark-gray: #475569;
--charcoal: #1E293B;

/* Status Colors */
--success-green: #10B981;
--warning-orange: #F59E0B;
--error-red: #EF4444;
--info-blue: #3B82F6;
```

### Typography Scale
```css
/* Font Family: Nunito (Primary), Roboto (Fallback) */

/* Display */
--display-large: 32px / 700 / 1.2;
--display-medium: 24px / 600 / 1.2;
--display-small: 20px / 600 / 1.2;

/* Body */
--body-large: 18px / 400 / 1.4;
--body-medium: 16px / 400 / 1.4;
--body-small: 14px / 400 / 1.4;

/* Labels */
--label: 12px / 600 / 1.2;
```

### Spacing System
```css
/* Base Unit: 4px */
--spacing-xs: 4px;
--spacing-s: 8px;
--spacing-m: 16px;
--spacing-l: 24px;
--spacing-xl: 32px;
--spacing-xxl: 48px;

/* Component Spacing */
--card-padding: 16px;
--button-padding: 12px 24px;
--input-padding: 12px 16px;
--section-margin: 24px;
--screen-padding: 16px;
```

## 📱 Screen Specifications

### 1. Playtime Hub

**Layout Structure:**
```
┌─────────────────────────────────────┐
│ 🔙 Back    Playtime Hub    ⚙️ Settings │
├─────────────────────────────────────┤
│                                     │
│  🎮 Welcome to Playtime!            │
│  Ready to have fun with friends?    │
│                                     │
│  ┌─────────────────────────────────┐ │
│  │         🎯 Play Now             │ │
│  │    Start a game right away      │ │
│  └─────────────────────────────────┘ │
│                                     │
│  ┌─────────────────────────────────┐ │
│  │        📅 Schedule Play         │ │
│  │    Plan a game for later        │ │
│  └─────────────────────────────────┘ │
│                                     │
│  ┌─────────────────────────────────┐ │
│  │      🔗 Regular Meeting         │ │
│  │    Join your scheduled session  │ │
│  └─────────────────────────────────┘ │
│                                     │
│  📊 Recent Activity                 │
│  ┌─────────────────────────────────┐ │
│  │ 🎮 Minecraft - 2 hours ago      │ │
│  │ 👥 3 friends joined             │ │
│  └─────────────────────────────────┘ │
│                                     │
└─────────────────────────────────────┘
```

**Component Specifications:**
- **Header**: 56px height, 16px padding
- **Welcome Text**: Display Medium (24px/600), Playtime Purple
- **CTA Buttons**: 56px height, 16px border radius, Playtime Pink/Blue
- **Recent Activity Card**: 80px height, 16px padding, white background, 12px border radius

### 2. Game List & "+ Add New Game"

**Layout Structure:**
```
┌─────────────────────────────────────┐
│ 🔙 Back    Choose Game    🔍 Search │
├─────────────────────────────────────┤
│                                     │
│  🔍 Search games...                 │
│                                     │
│  📱 Popular Games                   │
│  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐   │
│  │ 🎮  │ │ 🎲  │ │ 🧩  │ │ 🎨  │   │
│  │Mine │ │Board │ │Puzz │ │Draw │   │
│  │craft│ │Game │ │le   │ │ing  │   │
│  └─────┘ └─────┘ └─────┘ └─────┘   │
│                                     │
│  🎯 My Games                        │
│  ┌─────────────────────────────────┐ │
│  │ 🎮 Minecraft Adventure          │ │
│  │ 👥 3 friends • 2 hours ago      │ │
│  │ ⭐ 4.8 stars                     │ │
│  └─────────────────────────────────┘ │
│                                     │
│  ┌─────────────────────────────────┐ │
│  │         ➕ Add New Game         │ │
│  │      Create your own game       │ │
│  └─────────────────────────────────┘ │
│                                     │
└─────────────────────────────────────┘
```

**Component Specifications:**
- **Search Bar**: 48px height, 24px border radius, white background
- **Game Cards**: 120px width, 16px padding, white background, 16px border radius
- **Add Game Card**: 80px height, gradient background, 16px border radius

### 3. Create Game Dialog

**Layout Structure:**
```
┌─────────────────────────────────────┐
│                                     │
│  ┌─────────────────────────────────┐ │
│  │         Create New Game         │ │
│  │                                 │ │
│  │  🎮 Game Name                   │ │
│  │  ┌─────────────────────────────┐ │ │
│  │  │ Enter game name...          │ │ │
│  │  └─────────────────────────────┘ │ │
│  │                                 │ │
│  │  🎨 Choose Icon                 │ │
│  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐ │ │
│  │  │ 🎮  │ │ 🎲  │ │ 🧩  │ │ 🎨  │ │ │
│  │  │     │ │     │ │     │ │     │ │ │
│  │  └─────┘ └─────┘ └─────┘ └─────┘ │ │
│  │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐ │ │
│  │  │ 🏃  │ │ 🎵  │ │ 📚  │ │ 🌟  │ │ │
│  │  │     │ │     │ │     │ │     │ │ │
│  │  └─────┘ └─────┘ └─────┘ └─────┘ │ │
│  │                                 │ │
│  │  🔒 Privacy Settings             │ │
│  │  ○ Public - Anyone can join     │ │
│  │  ● Private - Invite only        │ │
│  │                                 │ │
│  │  ┌─────────┐    ┌─────────┐     │ │
│  │  │ Cancel  │    │  Save   │     │ │
│  │  └─────────┘    └─────────┘     │ │
│  └─────────────────────────────────┘ │
│                                     │
└─────────────────────────────────────┘
```

**Component Specifications:**
- **Modal**: 500px max width, 32px padding, 24px border radius
- **Input Field**: 48px height, 8px border radius, light gray background
- **Icon Grid**: 32px icons, 8px spacing, 8px border radius
- **Radio Buttons**: 20px diameter, 8px spacing

### 4. Playtime Virtual Flow

**Step 1: Game Selection**
```
┌─────────────────────────────────────┐
│ 🔙 Back    Virtual Play    ⚙️ Settings │
├─────────────────────────────────────┤
│                                     │
│  🎮 Choose Your Game                │
│                                     │
│  ┌─────────────────────────────────┐ │
│  │ 🎮 Minecraft Adventure          │ │
│  │ 👥 3 friends online             │ │
│  │ ⏱️ 2 hours average session      │ │
│  │ ✅ Parent approved              │ │
│  └─────────────────────────────────┘ │
│                                     │
│  ┌─────────────────────────────────┐ │
│  │ 🎲 Board Game Night             │ │
│  │ 👥 5 friends online             │ │
│  │ ⏱️ 1 hour average session       │ │
│  │ ⏳ Pending parent approval      │ │
│  └─────────────────────────────────┘ │
│                                     │
└─────────────────────────────────────┘
```

**Step 2: Invite Now Modal**
```
┌─────────────────────────────────────┐
│                                     │
│  ┌─────────────────────────────────┐ │
│  │         Invite Friends          │ │
│  │                                 │ │
│  │  👥 Select Friends               │ │
│  │  ┌─────────────────────────────┐ │ │
│  │  │ 🔍 Search friends...        │ │ │
│  │  └─────────────────────────────┘ │ │
│  │                                 │ │
│  │  📋 Selected (3)                │ │
│  │  ┌─────┐ ┌─────┐ ┌─────┐        │ │
│  │  │ 👧  │ │ 👦  │ │ 👧  │        │ │
│  │  │Emma │ │Tom  │ │Sara │        │ │
│  │  └─────┘ └─────┘ └─────┘        │ │
│  │                                 │ │
│  │  ⏰ Session Duration             │ │
│  │  ○ 30 minutes                   │ │
│  │  ● 1 hour                       │ │
│  │  ○ 2 hours                      │ │
│  │                                 │ │
│  │  ┌─────────┐    ┌─────────┐     │ │
│  │  │ Cancel  │    │  Start  │     │ │
│  │  └─────────┘    └─────────┘     │ │
│  └─────────────────────────────────┘ │
│                                     │
└─────────────────────────────────────┘
```

### 5. Playtime Live Flow

**Step 1: Game Selection**
```
┌─────────────────────────────────────┐
│ 🔙 Back    Live Play    ⚙️ Settings │
├─────────────────────────────────────┤
│                                     │
│  🎮 Choose Your Game                │
│                                     │
│  ┌─────────────────────────────────┐ │
│  │ 🏃 Outdoor Adventure            │ │
│  │ 👥 4 friends available          │ │
│  │ 📍 Local park                   │ │
│  │ ✅ Parent approved              │ │
│  └─────────────────────────────────┘ │
│                                     │
│  ┌─────────────────────────────────┐ │
│  │ 🎨 Art & Craft Session          │ │
│  │ 👥 3 friends available          │ │
│  │ 📍 Community center             │ │
│  │ ⏳ Pending parent approval      │ │
│  └─────────────────────────────────┘ │
│                                     │
└─────────────────────────────────────┘
```

**Step 2: Date Picker**
```
┌─────────────────────────────────────┐
│                                     │
│  ┌─────────────────────────────────┐ │
│  │         Pick Date               │ │
│  │                                 │ │
│  │  📅 Calendar                    │ │
│  │  ┌─────────────────────────────┐ │ │
│  │  │ Sun Mon Tue Wed Thu Fri Sat │ │ │
│  │  │  1   2   3   4   5   6   7  │ │ │
│  │  │  8   9  10  11  12  13  14  │ │ │
│  │  │ 15  16  17  18  19  20  21  │ │ │
│  │  │ 22  23  24  25  26  27  28  │ │ │
│  │  └─────────────────────────────┘ │ │
│  │                                 │ │
│  │  Selected: Saturday, March 15   │ │
│  │                                 │ │
│  │  ┌─────────┐    ┌─────────┐     │ │
│  │  │ Cancel  │    │  Next   │     │ │
│  │  └─────────┘    └─────────┘     │ │
│  └─────────────────────────────────┘ │
│                                     │
└─────────────────────────────────────┘
```

### 6. Chat Room

**Layout Structure:**
```
┌─────────────────────────────────────┐
│ 🔙 Back    Minecraft Adventure    ⚙️ │
├─────────────────────────────────────┤
│                                     │
│  💬 Chat Room                       │
│                                     │
│  ┌─────────────────────────────────┐ │
│  │ 👧 Emma: Ready to start!        │ │
│  │ 👦 Tom: Just joining...         │ │
│  │ 👧 Sara: Can't wait!            │ │
│  │                                 │ │
│  │ 👧 Emma: What should we build?  │ │
│  │ 👦 Tom: How about a castle?     │ │
│  │ 👧 Sara: Great idea!            │ │
│  │                                 │ │
│  │ 👧 Emma: I'll start with the    │ │
│  │     foundation                   │ │
│  │ 👦 Tom: I'll gather materials   │ │
│  │                                 │ │
│  │                                 │ │
│  │                                 │ │
│  │                                 │ │
│  └─────────────────────────────────┘ │
│                                     │
│  ┌─────────────────────────────────┐ │
│  │ 💬 Type a message...      📤   │ │
│  └─────────────────────────────────┘ │
│                                     │
│  🛡️ Safety Controls                 │
│  ┌─────────────────────────────────┐ │
│  │ 🚫 Report Message    ⏸️ Pause Chat│ │
│  └─────────────────────────────────┘ │
│                                     │
└─────────────────────────────────────┘
```

**Component Specifications:**
- **Message Bubbles**: 80% max width, 12px padding, 16px border radius
- **Input Bar**: 48px height, 24px border radius, white background
- **Safety Panel**: 40px height, 12px padding, light gray background

### 7. Parent Dashboard

**Sessions Tab:**
```
┌─────────────────────────────────────┐
│ 🔙 Back    Parent Dashboard    ⚙️   │
├─────────────────────────────────────┤
│                                     │
│  📱 Sessions                        │
│                                     │
│  ⏳ Pending Approval (2)            │
│  ┌─────────────────────────────────┐ │
│  │ 🎮 Minecraft Adventure          │ │
│  │ 👧 Emma • Saturday, 2:00 PM    │ │
│  │ 👥 3 friends • 1 hour           │ │
│  │ 🏠 Local Park                   │ │
│  │                                 │ │
│  │  ┌─────────┐    ┌─────────┐     │ │
│  │  │ Decline │    │ Approve │     │ │
│  │  └─────────┘    └─────────┘     │ │
│  └─────────────────────────────────┘ │
│                                     │
│  ✅ Approved (5)                    │
│  ┌─────────────────────────────────┐ │
│  │ 🏃 Outdoor Adventure            │ │
│  │ 👧 Emma • Yesterday, 2:00 PM   │ │
│  │ ✅ Completed • 1 hour           │ │
│  └─────────────────────────────────┘ │
│                                     │
└─────────────────────────────────────┘
```

**Backgrounds Tab:**
```
┌─────────────────────────────────────┐
│ 🔙 Back    Parent Dashboard    ⚙️   │
├─────────────────────────────────────┤
│                                     │
│  🖼️ Backgrounds                     │
│                                     │
│  ⏳ Pending Uploads (1)             │
│  ┌─────────────────────────────────┐ │
│  │ 🖼️ Custom Park Scene            │ │
│  │ 👧 Emma • 2 hours ago           │ │
│  │ 📏 1920x1080 • 2.3 MB           │ │
│  │                                 │ │
│  │  ┌─────────┐    ┌─────────┐     │ │
│  │  │ Decline │    │ Approve │     │ │
│  │  └─────────┘    └─────────┘     │ │
│  └─────────────────────────────────┘ │
│                                     │
│  ✅ Approved (8)                    │
│  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐   │
│  │ 🌳  │ │ 🏠  │ │ 🎨  │ │ 🌟  │   │
│  │Park │ │Home │ │Art  │ │Space│   │
│  │     │ │     │ │Room │ │     │   │
│  └─────┘ └─────┘ └─────┘ └─────┘   │
│                                     │
└─────────────────────────────────────┘
```

### 8. Admin Backgrounds Management

**Layout Structure:**
```
┌─────────────────────────────────────┐
│ 🔙 Back    Background Management    │
├─────────────────────────────────────┤
│                                     │
│  🖼️ All Backgrounds (24)            │
│                                     │
│  🔍 Search backgrounds...           │
│                                     │
│  📊 Statistics                      │
│  ┌─────────────────────────────────┐ │
│  │ ✅ Approved: 18                 │ │
│  │ ⏳ Pending: 3                   │ │
│  │ 🚫 Rejected: 3                  │ │
│  └─────────────────────────────────┘ │
│                                     │
│  🖼️ Background Grid                 │
│  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐   │
│  │ 🌳  │ │ 🏠  │ │ 🎨  │ │ 🌟  │   │
│  │ ✅  │ │ ✅  │ │ ✅  │ │ ✅  │   │
│  │ 12  │ │ 8   │ │ 15  │ │ 6   │   │
│  └─────┘ └─────┘ └─────┘ └─────┘   │
│                                     │
│  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐   │
│  │ 🏫  │ │ 🏖️  │ │ 🏔️  │ │ 🎭  │   │
│  │ ✅  │ │ ⏳  │ │ ✅  │ │ 🚫  │   │
│  │ 9   │ │ 2   │ │ 11  │ │ 0   │   │
│  └─────┘ └─────┘ └─────┘ └─────┘   │
│                                     │
│  ┌─────────────────────────────────┐ │
│  │         Upload New              │ │
│  │      Add background image       │ │
│  └─────────────────────────────────┘ │
│                                     │
└─────────────────────────────────────┘
```

## 🧩 Component Library Specifications

### Buttons

#### Primary Button
```css
/* Specifications */
height: 48px;
padding: 12px 24px;
border-radius: 12px;
background: var(--playtime-purple);
color: var(--pure-white);
font: var(--body-medium);
font-weight: 600;
border: none;
cursor: pointer;

/* States */
:hover {
  background: #7C3AED;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(139, 92, 246, 0.3);
}

:pressed {
  transform: translateY(0);
  box-shadow: 0 2px 8px rgba(139, 92, 246, 0.2);
}

:disabled {
  background: var(--medium-gray);
  cursor: not-allowed;
  transform: none;
  box-shadow: none;
}
```

#### Play Button (Special)
```css
/* Specifications */
height: 56px;
padding: 16px 32px;
border-radius: 16px;
background: var(--playtime-pink);
color: var(--pure-white);
font: var(--body-large);
font-weight: 700;
border: none;
cursor: pointer;
box-shadow: 0 4px 12px rgba(236, 72, 153, 0.3);

/* Icon */
.icon {
  width: 24px;
  height: 24px;
  margin-right: 8px;
}
```

#### Secondary Button
```css
/* Specifications */
height: 48px;
padding: 12px 24px;
border-radius: 12px;
background: transparent;
color: var(--playtime-purple);
font: var(--body-medium);
font-weight: 600;
border: 2px solid var(--playtime-purple);
cursor: pointer;

/* States */
:hover {
  background: var(--light-purple);
  border-color: #7C3AED;
  color: #7C3AED;
}
```

### Cards

#### Game Card
```css
/* Specifications */
width: 100%;
padding: 16px;
border-radius: 16px;
background: var(--pure-white);
border: 1px solid var(--light-gray);
box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
cursor: pointer;
transition: all 0.2s ease;

/* States */
:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
}

/* Content */
.icon {
  width: 48px;
  height: 48px;
  margin-bottom: 12px;
}

.title {
  font: var(--display-small);
  color: var(--charcoal);
  margin-bottom: 4px;
}

.subtitle {
  font: var(--body-small);
  color: var(--dark-gray);
  margin-bottom: 8px;
}

.metadata {
  display: flex;
  align-items: center;
  gap: 8px;
  font: var(--label);
  color: var(--medium-gray);
}
```

#### Session Card
```css
/* Specifications */
width: 100%;
padding: 16px;
border-radius: 12px;
background: var(--pure-white);
border: 2px solid var(--light-purple);
cursor: pointer;
transition: all 0.2s ease;

/* Status Variants */
.status-pending {
  border-color: var(--warning-orange);
  background: #FEF3C7;
}

.status-approved {
  border-color: var(--success-green);
  background: #D1FAE5;
}

.status-declined {
  border-color: var(--error-red);
  background: #FEE2E2;
}

/* Actions */
.actions {
  display: flex;
  gap: 8px;
  margin-top: 12px;
}

.action-button {
  height: 32px;
  padding: 0 16px;
  border-radius: 8px;
  font: var(--label);
  font-weight: 600;
  border: none;
  cursor: pointer;
}

.approve {
  background: var(--success-green);
  color: var(--pure-white);
}

.decline {
  background: var(--error-red);
  color: var(--pure-white);
}
```

### Input Fields

#### Search Input
```css
/* Specifications */
height: 48px;
padding: 12px 20px;
border-radius: 24px;
background: var(--pure-white);
border: 1px solid var(--light-gray);
font: var(--body-medium);
color: var(--charcoal);
outline: none;
transition: all 0.2s ease;

/* Icon */
.search-icon {
  width: 20px;
  height: 20px;
  color: var(--medium-gray);
  margin-right: 12px;
}

/* States */
:focus {
  border-color: var(--playtime-purple);
  box-shadow: 0 0 0 3px rgba(139, 92, 246, 0.1);
}

::placeholder {
  color: var(--medium-gray);
}
```

#### Text Input
```css
/* Specifications */
height: 48px;
padding: 12px 16px;
border-radius: 8px;
background: var(--light-gray);
border: 2px solid var(--medium-gray);
font: var(--body-medium);
color: var(--charcoal);
outline: none;
transition: all 0.2s ease;

/* Label */
.label {
  font: var(--label);
  color: var(--dark-gray);
  margin-bottom: 4px;
  display: block;
}

/* States */
:focus {
  border-color: var(--playtime-purple);
  background: var(--pure-white);
}

.error {
  border-color: var(--error-red);
}

.error-message {
  font: var(--body-small);
  color: var(--error-red);
  margin-top: 4px;
}
```

### Modals

#### Standard Modal
```css
/* Specifications */
max-width: 400px;
padding: 24px;
border-radius: 20px;
background: var(--pure-white);
box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
position: relative;

/* Backdrop */
.backdrop {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

/* Header */
.modal-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16px;
}

.modal-title {
  font: var(--display-small);
  color: var(--charcoal);
}

.close-button {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: var(--light-gray);
  border: none;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
}

/* Content */
.modal-content {
  margin-bottom: 24px;
}

/* Actions */
.modal-actions {
  display: flex;
  gap: 12px;
  justify-content: flex-end;
}
```

#### Game Creation Modal
```css
/* Specifications */
max-width: 500px;
padding: 32px;
border-radius: 24px;
background: var(--pure-white);
box-shadow: 0 24px 48px rgba(0, 0, 0, 0.2);

/* Sections */
.section {
  margin-bottom: 24px;
}

.section-title {
  font: var(--display-small);
  color: var(--charcoal);
  margin-bottom: 12px;
}

/* Icon Grid */
.icon-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 8px;
  margin-top: 12px;
}

.icon-option {
  width: 48px;
  height: 48px;
  border-radius: 8px;
  background: var(--light-gray);
  border: 2px solid transparent;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  transition: all 0.2s ease;
}

.icon-option.selected {
  background: var(--playtime-purple);
  color: var(--pure-white);
  border-color: var(--playtime-purple);
}

.icon-option:hover {
  background: var(--light-purple);
  border-color: var(--playtime-purple);
}
```

## 🎭 Interaction Specifications

### Animations

#### Button Press
```css
/* Scale down on press */
transform: scale(0.95);
transition: transform 0.1s ease;
```

#### Card Hover
```css
/* Elevate with shadow */
transform: translateY(-2px);
box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
transition: all 0.2s ease;
```

#### Modal Entry
```css
/* Scale and fade in */
@keyframes modalEnter {
  from {
    opacity: 0;
    transform: scale(0.9);
  }
  to {
    opacity: 1;
    transform: scale(1);
  }
}

.modal {
  animation: modalEnter 0.3s ease-out;
}
```

#### Loading Spinner
```css
/* Rotating spinner */
@keyframes spin {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

.spinner {
  width: 24px;
  height: 24px;
  border: 2px solid var(--light-gray);
  border-top: 2px solid var(--playtime-purple);
  border-radius: 50%;
  animation: spin 1s linear infinite;
}
```

### States

#### Loading State
```css
/* Disable interactions and show spinner */
.loading {
  pointer-events: none;
  opacity: 0.7;
}

.loading::after {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 24px;
  height: 24px;
  border: 2px solid var(--light-gray);
  border-top: 2px solid var(--playtime-purple);
  border-radius: 50%;
  animation: spin 1s linear infinite;
}
```

#### Error State
```css
/* Shake animation for errors */
@keyframes shake {
  0%, 100% { transform: translateX(0); }
  25% { transform: translateX(-4px); }
  75% { transform: translateX(4px); }
}

.error {
  animation: shake 0.5s ease-in-out;
  border-color: var(--error-red);
}
```

#### Success State
```css
/* Checkmark with bounce */
@keyframes successBounce {
  0% { transform: scale(0); }
  50% { transform: scale(1.2); }
  100% { transform: scale(1); }
}

.success {
  animation: successBounce 0.5s ease-out;
}
```

## ♿ Accessibility Guidelines

### Touch Targets
- **Minimum Size**: 44px x 44px for all interactive elements
- **Button Height**: 48px minimum
- **Spacing**: 8px minimum between touch targets

### Color Contrast
- **Text on Background**: Minimum 4.5:1 ratio
- **Large Text**: Minimum 3:1 ratio
- **Interactive Elements**: Minimum 3:1 ratio

### Screen Reader Support
```html
<!-- Semantic labels for all interactive elements -->
<button aria-label="Play Minecraft Adventure game">
  🎮 Play Now
</button>

<!-- Descriptive text for images -->
<img src="park-scene.jpg" alt="Beautiful park with trees and playground equipment" />

<!-- Status announcements -->
<div role="status" aria-live="polite">
  Session approved by parent
</div>
```

### Focus Indicators
```css
/* Clear focus indicators */
:focus {
  outline: 2px solid var(--playtime-purple);
  outline-offset: 2px;
}

/* High contrast focus for accessibility */
@media (prefers-contrast: high) {
  :focus {
    outline: 3px solid var(--charcoal);
    outline-offset: 3px;
  }
}
```

### Motion Preferences
```css
/* Respect reduced motion preferences */
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

## 📱 Responsive Design

### Breakpoints
```css
/* Mobile First Approach */
/* Base styles for mobile (320px+) */

/* Tablet */
@media (min-width: 768px) {
  .container {
    max-width: 600px;
    margin: 0 auto;
  }
  
  .game-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

/* Desktop */
@media (min-width: 1024px) {
  .container {
    max-width: 800px;
  }
  
  .game-grid {
    grid-template-columns: repeat(3, 1fr);
  }
  
  .modal {
    max-width: 600px;
  }
}
```

### Mobile Optimizations
- **Thumb Navigation**: Bottom navigation bar
- **Large Touch Targets**: 48px minimum height
- **Simplified Layouts**: Single column layouts
- **Gesture Support**: Swipe, pinch, tap

## 🛡️ Safety & Moderation Features

### Visual Indicators
```css
/* Parent Approval Required */
.approval-required {
  position: relative;
}

.approval-required::after {
  content: '⚠️';
  position: absolute;
  top: -8px;
  right: -8px;
  width: 20px;
  height: 20px;
  background: var(--warning-orange);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
}

/* Safe Content */
.safe-content::after {
  content: '✅';
  position: absolute;
  top: -8px;
  right: -8px;
  width: 20px;
  height: 20px;
  background: var(--success-green);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
}

/* Pending Review */
.pending-review::after {
  content: '⏳';
  position: absolute;
  top: -8px;
  right: -8px;
  width: 20px;
  height: 20px;
  background: var(--medium-gray);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
}
```

### Content Warnings
```css
/* Age-appropriate indicators */
.age-indicator {
  display: inline-block;
  padding: 2px 8px;
  border-radius: 12px;
  font: var(--label);
  font-weight: 600;
  color: var(--pure-white);
}

.age-3-6 {
  background: var(--success-green);
}

.age-7-12 {
  background: var(--playtime-blue);
}

.age-13-16 {
  background: var(--playtime-purple);
}
```

## 📋 Implementation Checklist

### Design Files to Create
- [ ] **Figma/Sketch File**: Main design file with all screens
- [ ] **Component Library**: Reusable components with variants
- [ ] **Design Tokens**: Colors, typography, spacing, shadows
- [ ] **Icon Library**: Child-friendly icon set
- [ ] **Prototype**: Interactive prototype for user testing

### Screen Wireframes
- [ ] Playtime Hub
- [ ] Game List & "+ Add New Game"
- [ ] Create Game Dialog
- [ ] Playtime Virtual Flow (3 steps)
- [ ] Playtime Live Flow (6 steps)
- [ ] Chat Room
- [ ] Parent Dashboard (2 tabs)
- [ ] Admin Backgrounds Management

### Component Library
- [ ] Button variants (Primary, Secondary, Play, Icon)
- [ ] Card components (Game, Session, Chat)
- [ ] Input fields (Search, Text, Icon Picker)
- [ ] Modal components (Standard, Game Creation)
- [ ] Navigation components (Bottom Nav, Tabs)
- [ ] Status components (Badges, Indicators)

### Accessibility
- [ ] Touch target sizes (44px minimum)
- [ ] Color contrast ratios (4.5:1 minimum)
- [ ] Screen reader support
- [ ] Focus indicators
- [ ] Motion preferences

### Safety Features
- [ ] Parent approval indicators
- [ ] Content safety badges
- [ ] Age-appropriate labels
- [ ] Moderation controls
- [ ] Safety warnings

---

**Note**: This design handoff document provides all the specifications needed to create pixel-perfect wireframes and components in Figma/Sketch. All measurements, colors, typography, and interactions are precisely defined for direct implementation. 