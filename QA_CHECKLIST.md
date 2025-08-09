# Meeting Page QA Checklist

## Pre-Testing Setup

### Environment
- [ ] Firebase emulator running
- [ ] Two browsers open (Chrome/Firefox)
- [ ] Mobile device ready (iOS/Android)
- [ ] Network connection stable

### Test Data
- [ ] Meeting created with participants
- [ ] User accounts logged in (User A, User B)
- [ ] Guest access available
- [ ] Test meeting with publicReadChat: true

## 1. Real-time RSVP Testing

### Two Browser Test
- [ ] **Browser A**: Open meeting as User A
- [ ] **Browser B**: Open same meeting as User B
- [ ] **Action**: User A clicks "Accept" RSVP
- [ ] **Expected**: User B sees status change immediately
- [ ] **Action**: User B clicks "Decline" RSVP
- [ ] **Expected**: User A sees status change immediately
- [ ] **Action**: User A marks "I've Arrived"
- [ ] **Expected**: User B sees green checkmark icon
- [ ] **Action**: User B marks "I'm Late" with reason
- [ ] **Expected**: User A sees orange clock icon and reason text

### Visual Indicators
- [ ] **Late Indicators**: Orange clock icon appears for late users
- [ ] **Late Reason**: Text shows below status (e.g., "Late: Traffic")
- [ ] **Arrived Status**: Green checkmark for arrived participants
- [ ] **Status Colors**: Different colors for accepted/declined/pending

## 2. Checklist Functionality

### Add/Remove Items
- [ ] **Add Item**: Type in text field and press Enter
- [ ] **Expected**: New item appears in list
- [ ] **Add via Dialog**: Click + button, enter text, click Add
- [ ] **Expected**: Item added successfully
- [ ] **Remove Item**: Click delete icon on item
- [ ] **Expected**: Item removed from list

### Toggle Functionality
- [ ] **Check Item**: Click checkbox on item
- [ ] **Expected**: Item marked as done (strikethrough)
- [ ] **Uncheck Item**: Click checkbox again
- [ ] **Expected**: Item marked as undone
- [ ] **Real-time Sync**: Test in two browsers
- [ ] **Expected**: Changes sync immediately

### Permission Testing
- [ ] **Host**: Can add/remove items
- [ ] **Cohost**: Can add/remove items
- [ ] **Participant**: Can only toggle items
- [ ] **Guest**: Read-only access (if public)

## 3. Chat Functionality

### Message Sending
- [ ] **Send Message**: Type text and click send
- [ ] **Expected**: Message appears in chat
- [ ] **Empty Message**: Try to send empty message
- [ ] **Expected**: Send button disabled
- [ ] **Long Message**: Try to send >2000 characters
- [ ] **Expected**: Validation prevents sending

### Real-time Delivery
- [ ] **Browser A**: Send message
- [ ] **Browser B**: Message appears immediately
- [ ] **Browser B**: Send reply
- [ ] **Browser A**: Reply appears immediately
- [ ] **Chronological Order**: Messages in correct order

### Public Access Testing
- [ ] **Meeting with publicReadChat: false**
  - [ ] Guest user: Chat not visible
- [ ] **Meeting with publicReadChat: true**
  - [ ] Guest user: Chat visible but read-only
  - [ ] Guest user: Cannot send messages

### Message Validation
- [ ] **Empty Message**: Cannot send
- [ ] **Whitespace Only**: Cannot send
- [ ] **2000+ Characters**: Cannot send
- [ ] **Valid Message**: Sends successfully

## 4. Go/Join Navigation

### Virtual Meetings
- [ ] **Join Button**: Click on virtual meeting
- [ ] **Expected**: Opens URL in external browser
- [ ] **Fallback**: If external fails, opens in same tab
- [ ] **Invalid URL**: Test with broken link
- [ ] **Expected**: Graceful error handling

### Physical Meetings
- [ ] **Go Button**: Click on physical meeting
- [ ] **Expected**: Opens OSM map with location
- [ ] **Coordinates**: Map shows correct lat/lng
- [ ] **Label**: Map shows meeting location name
- [ ] **Mobile**: Test on mobile device
- [ ] **Expected**: Opens native map app

### Responsive Testing
- [ ] **Desktop**: Buttons work correctly
- [ ] **Mobile**: Touch-friendly button size
- [ ] **Tablet**: Proper layout adaptation

## 5. Guest Redirect Testing

### Authentication Flow
- [ ] **Unauthenticated User**: Open meeting URL
- [ ] **Expected**: Redirected to public page (/m/{meetingId})
- [ ] **Public Page**: Meeting info visible
- [ ] **Limited Features**: Only read-only access
- [ ] **Login Link**: Option to sign in

### Public Meeting Access
- [ ] **Public Meeting**: Open as guest
- [ ] **Expected**: Can view meeting details
- [ ] **Participant List**: Visible but read-only
- [ ] **Chat**: Visible if publicReadChat: true
- [ ] **Checklist**: Visible but read-only

## 6. Role-based Permissions

### Host Permissions
- [ ] **Assign Roles**: Can assign cohost/editor
- [ ] **Remove Roles**: Can remove user roles
- [ ] **Manage Chat**: Can delete messages
- [ ] **Manage Checklist**: Can add/remove items
- [ ] **Manage Participants**: Full control

### Cohost Permissions
- [ ] **Chat Management**: Can delete messages
- [ ] **Checklist Management**: Can add/remove items
- [ ] **Role Assignment**: Cannot assign roles
- [ ] **Participant Management**: Limited control

### Editor Permissions
- [ ] **Checklist Editing**: Can add/remove items
- [ ] **Chat Access**: Read/write access
- [ ] **Role Management**: No role assignment
- [ ] **Participant Management**: No control

### Participant Permissions
- [ ] **RSVP**: Can accept/decline
- [ ] **Status Updates**: Can mark arrived/late
- [ ] **Chat**: Can send messages
- [ ] **Checklist**: Can toggle items only

## 7. Responsive Design Testing

### Desktop Layout
- [ ] **Header**: Full-width with proper spacing
- [ ] **Actions Bar**: Horizontal button layout
- [ ] **Participant List**: Multi-column grid
- [ ] **Chat & Checklist**: Side-by-side panels
- [ ] **Map Preview**: Proper sizing

### Mobile Layout
- [ ] **Header**: Stacked layout
- [ ] **Actions Bar**: Vertical button stack
- [ ] **Participant List**: Single column
- [ ] **Chat & Checklist**: Stacked panels
- [ ] **Touch Targets**: Minimum 44px

### Tablet Layout
- [ ] **Hybrid Layout**: Combines desktop/mobile
- [ ] **Orientation**: Works in portrait/landscape
- [ ] **Touch Friendly**: Appropriate button sizes

## 8. Performance Testing

### Load Testing
- [ ] **Large Participant List**: 50+ participants
- [ ] **Expected**: Smooth scrolling, no lag
- [ ] **Long Chat History**: 100+ messages
- [ ] **Expected**: Efficient rendering
- [ ] **Many Checklist Items**: 20+ items
- [ ] **Expected**: Responsive interactions

### Network Testing
- [ ] **Slow Connection**: Simulate 3G
- [ ] **Expected**: Graceful degradation
- [ ] **Offline Mode**: Disconnect network
- [ ] **Expected**: Clear error messages
- [ ] **Reconnection**: Restore connection
- [ ] **Expected**: Automatic sync

### Memory Testing
- [ ] **Long Session**: Use for 30+ minutes
- [ ] **Expected**: No memory leaks
- [ ] **Multiple Meetings**: Switch between meetings
- [ ] **Expected**: Clean state management

## 9. Security Testing

### Authentication
- [ ] **Valid User**: Full access to features
- [ ] **Invalid User**: Proper access restrictions
- [ ] **Token Expiry**: Handle expired tokens
- [ ] **Logout**: Clear session properly

### Data Validation
- [ ] **XSS Prevention**: Test script injection
- [ ] **SQL Injection**: Test malicious inputs
- [ ] **Input Sanitization**: Clean user inputs
- [ ] **Output Encoding**: Safe data display

### Permission Bypass
- [ ] **URL Manipulation**: Try to access restricted data
- [ ] **Expected**: Proper access denied
- [ ] **Role Escalation**: Try to gain higher permissions
- [ ] **Expected**: Permission denied

## 10. Error Handling

### Network Errors
- [ ] **Connection Lost**: Disconnect network
- [ ] **Expected**: Clear error message
- [ ] **Reconnection**: Restore connection
- [ ] **Expected**: Automatic retry
- [ ] **Timeout**: Slow network response
- [ ] **Expected**: Timeout handling

### Validation Errors
- [ ] **Invalid Input**: Test edge cases
- [ ] **Expected**: Clear error messages
- [ ] **Server Errors**: Simulate 500 errors
- [ ] **Expected**: Graceful handling
- [ ] **Permission Errors**: Access denied
- [ ] **Expected**: User-friendly messages

## 11. Accessibility Testing

### Screen Reader
- [ ] **NVDA/JAWS**: Test with screen reader
- [ ] **Expected**: Proper navigation
- [ ] **ARIA Labels**: All elements labeled
- [ ] **Keyboard Navigation**: Full keyboard access

### Visual Accessibility
- [ ] **Color Contrast**: WCAG AA compliance
- [ ] **Font Sizes**: Readable text sizes
- [ ] **Focus Indicators**: Clear focus states
- [ ] **High Contrast**: Test high contrast mode

### Motor Accessibility
- [ ] **Touch Targets**: Minimum 44px
- [ ] **Gesture Support**: Swipe actions
- [ ] **Voice Control**: Voice navigation
- [ ] **Switch Control**: Switch navigation

## 12. Cross-browser Testing

### Desktop Browsers
- [ ] **Chrome**: Latest version
- [ ] **Firefox**: Latest version
- [ ] **Safari**: Latest version
- [ ] **Edge**: Latest version

### Mobile Browsers
- [ ] **iOS Safari**: Latest version
- [ ] **Chrome Mobile**: Latest version
- [ ] **Samsung Internet**: Latest version

### Feature Support
- [ ] **Real-time Updates**: All browsers
- [ ] **Map Integration**: All browsers
- [ ] **File Upload**: All browsers
- [ ] **Push Notifications**: All browsers

## 13. Final Validation

### Feature Completeness
- [ ] **All Features**: Working as designed
- [ ] **Edge Cases**: Handled properly
- [ ] **Error States**: Graceful handling
- [ ] **Performance**: Acceptable speed

### Documentation
- [ ] **README**: Complete and accurate
- [ ] **Code Comments**: Clear and helpful
- [ ] **API Documentation**: Up to date
- [ ] **User Guide**: Available for users

### Deployment Ready
- [ ] **Production Build**: Successful
- [ ] **Firestore Rules**: Deployed
- [ ] **Indexes**: Created
- [ ] **Monitoring**: Configured

## Test Results Summary

### Pass/Fail Tracking
- [ ] **Total Tests**: ___ / ___
- [ ] **Critical Issues**: ___ found
- [ ] **Minor Issues**: ___ found
- [ ] **Performance Issues**: ___ found

### Recommendations
- [ ] **High Priority**: Fix critical issues
- [ ] **Medium Priority**: Address minor issues
- [ ] **Low Priority**: Consider improvements
- [ ] **Future**: Plan enhancements

### Sign-off
- [ ] **QA Lead**: ________________
- [ ] **Developer**: ________________
- [ ] **Product Owner**: ________________
- [ ] **Date**: ________________


