# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.3.0] - 2024-12-19

### 🚀 Added

- **Rich Conversational Edit Flow**: Full editing system for meetings with title, date, time, and all-day support
- **All-Day Meeting Support**: End-to-end all-day meeting creation, editing, and display
- **Smart Time Merging**: Intelligent date+time input combination into epoch timestamps
- **Custom Calendar UI**: Professional toolbar, event chips with inline delete buttons
- **Undo Delete Functionality**: 10-second undo window with restore capability
- **Advanced Slot Selection**: Automatic all-day detection and smart meeting creation
- **Enhanced Firestore Operations**: Efficient title-only vs full updates, restore functionality

### 🔧 Changed

- **Meeting Model**: Extended with `allDay` boolean field
- **Firestore Helpers**: Added `updateMeetingTitle`, `restoreMeeting`, `getMeeting` methods
- **Calendar Component**: Complete UI overhaul with custom components and RTL support
- **Conversational Flow**: Enhanced edit state management with temp fields

### 🐛 Fixed

- **Type Safety**: Resolved all TypeScript errors in core implementation
- **Null Safety**: Added proper null checks throughout edit flow
- **SSR Compatibility**: Ensured all components remain SSR-safe

### 📱 Technical

- **Dependencies**: Added `react-big-calendar`, `date-fns`, `react-dnd` for advanced calendar functionality
- **Architecture**: Firebase-gated operations with graceful fallbacks
- **Performance**: Optimized Firestore operations based on change type

## [1.2.0] - 2024-12-19

### 🚀 Added

- **Calendar Integration**: Month/Week/Day views with drag & drop functionality
- **Real-Time Updates**: Live calendar updates across multiple tabs
- **Conversational Edit**: Click events to open conversational editing flow
- **Drag & Drop**: Reschedule meetings by dragging events
- **Event Resizing**: Adjust meeting duration by resizing event edges

### 🔧 Changed

- **Calendar Component**: Integrated `react-big-calendar` with custom event handling
- **Meeting Management**: Enhanced with visual calendar interface
- **User Experience**: Intuitive calendar-based meeting management

## [1.1.0] - 2024-12-19

### 🚀 Added

- **Firebase Integration**: Firestore persistence and real-time synchronization
- **Authentication**: Anonymous and Google Sign-In support
- **Local-to-Cloud Migration**: Automatic data migration on first authentication
- **Real-Time Listeners**: Live updates across multiple browser tabs
- **Persistence Preview**: QA page for testing Firestore functionality

### 🔧 Changed

- **Data Storage**: Moved from localStorage to Firestore with fallback
- **State Management**: Enhanced Zustand store with Firebase integration
- **Architecture**: SSR-safe Firebase initialization with graceful degradation

### 📱 Technical

- **Dependencies**: Added Firebase SDK and related packages
- **Security**: Implemented Firestore security rules
- **Environment**: Added Firebase configuration template

## [1.0.0] - 2024-12-19

### 🚀 Added

- **Initial Release**: Personal meeting management application
- **Conversational UI**: Natural language meeting creation flow
- **Meeting Types**: Support for in-person, video, and phone meetings
- **Basic Persistence**: Local storage for meetings and reminders
- **Internationalization**: Hebrew and English language support
- **Progressive Web App**: PWA capabilities with offline support

### 📱 Technical

- **Framework**: Next.js 14 with App Router
- **Styling**: Tailwind CSS with responsive design
- **State Management**: Zustand for conversational flow
- **TypeScript**: Full type safety throughout
