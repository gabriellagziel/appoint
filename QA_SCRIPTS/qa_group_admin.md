# Group Admin QA Manual Script

## Overview
This script covers comprehensive testing of the Group Admin UI with 5 tabs: Members, Admin, Policy, Votes, and Audit.

## Prerequisites
- Firestore emulator running on localhost:8080
- Seed data loaded: `flutter pub run tool/seed/group_admin_seed.dart`
- Test group ID: `test-group-admin-123`
- Test users: userA (Owner), userB (Admin), userC (Member)

## Test Environment Setup

### 1. Start Firestore Emulator
```bash
firebase emulators:start --only firestore
```

### 2. Load Seed Data
```bash
flutter pub run tool/seed/group_admin_seed.dart
```

### 3. Run Smoke Tests
```bash
flutter test test/smoke
```

### 4. Run Integration Tests
```bash
flutter test integration_test/group_admin_e2e_test.dart
```

## QA Checklist

### 🔐 Permission Testing

#### Owner Permissions
- [ ] **Promote/Demote Admin**: Owner can promote members to admin and demote admins to members
- [ ] **Transfer Ownership**: Owner can transfer ownership to another member
- [ ] **Remove Any Member**: Owner can remove any member (including admins)
- [ ] **Manage Policy**: Owner can update all policy settings
- [ ] **Close Votes**: Owner can close any vote
- [ ] **View Audit Log**: Owner can view complete audit trail

#### Admin Permissions
- [ ] **Remove Members**: Admin can remove regular members
- [ ] **Cannot Remove Admin/Owner**: Admin cannot remove other admins or owner
- [ ] **Cannot Transfer Ownership**: Admin cannot transfer ownership
- [ ] **Manage Policy**: Admin can update policy settings
- [ ] **Close Votes**: Admin can close votes
- [ ] **View Audit Log**: Admin can view audit trail

#### Member Permissions
- [ ] **Vote**: Member can cast votes on open votes
- [ ] **Cannot Manage Roles**: Member cannot promote/demote users
- [ ] **Cannot Remove Members**: Member cannot remove other members
- [ ] **Cannot Manage Policy**: Member cannot update policy settings
- [ ] **Cannot Close Votes**: Member cannot close votes
- [ ] **Cannot View Audit**: Member cannot view audit log

### 📋 Tab Functionality Testing

#### Members Tab
- [ ] **Member List Display**: All members shown with correct roles
- [ ] **Role Indicators**: Owner, Admin, Member roles clearly displayed
- [ ] **Action Buttons**: Correct buttons shown based on user permissions
- [ ] **Promote Member**: Confirmation dialog and success feedback
- [ ] **Demote Admin**: Confirmation dialog and success feedback
- [ ] **Remove Member**: Confirmation dialog and success feedback
- [ ] **Transfer Ownership**: Confirmation dialog and success feedback
- [ ] **Permission Errors**: Clear error messages for unauthorized actions

#### Admin Tab
- [ ] **Quick Actions**: All quick actions visible for authorized users
- [ ] **Role Statistics**: Correct count of owners, admins, members
- [ ] **Role Distribution Chart**: Visual representation of role distribution
- [ ] **Promote via Vote**: When policy requires voting, shows "Start Vote" button
- [ ] **Direct Promote**: When policy allows direct promotion, shows "Promote" button
- [ ] **Demote Admin**: Admin demotion functionality
- [ ] **Transfer Ownership**: Ownership transfer functionality

#### Policy Tab
- [ ] **Policy Settings**: All policy switches visible and functional
- [ ] **Members Can Invite**: Toggle functionality and persistence
- [ ] **Require Vote for Admin**: Toggle functionality and persistence
- [ ] **Allow Non-Members RSVP**: Toggle functionality and persistence
- [ ] **Real-time Updates**: Changes reflect immediately in UI
- [ ] **Success Feedback**: SnackBar shows "Policy updated successfully"
- [ ] **Error Handling**: Clear error messages for failed updates
- [ ] **Permission Restrictions**: Non-admin users see restricted access message

#### Votes Tab
- [ ] **Open Votes Section**: Open votes displayed correctly
- [ ] **Closed Votes Section**: Closed votes displayed correctly
- [ ] **Vote Progress**: Progress bars and vote counts accurate
- [ ] **Cast Vote**: Yes/No buttons functional
- [ ] **Vote Disabled**: Buttons disabled after user votes
- [ ] **Vote Feedback**: "You voted Yes/No" message displayed
- [ ] **Close Vote**: Close button functional for admins/owners
- [ ] **Close Confirmation**: Confirmation dialog for vote closing
- [ ] **Vote Results**: Results displayed for closed votes

#### Audit Tab
- [ ] **Audit Timeline**: Events displayed in chronological order
- [ ] **Event Types**: Different event types with correct icons
- [ ] **Event Details**: Event descriptions and metadata accurate
- [ ] **Filter Functionality**: Filter by event type works correctly
- [ ] **Permission Check**: Non-admin users see restricted access
- [ ] **Event Count**: Total event count displayed correctly

### 🎯 Specific Test Scenarios

#### Scenario 1: Owner Promotes Member to Admin
1. Navigate to Members tab as Owner
2. Find a member (userC)
3. Tap promote button (arrow up)
4. Confirm in dialog
5. Verify success SnackBar
6. Check member role changed to Admin
7. Verify audit event created

#### Scenario 2: Policy Requires Voting for Admin Changes
1. Navigate to Policy tab as Owner
2. Enable "Require Vote for Admin"
3. Navigate to Admin tab
4. Try to promote a member
5. Verify "Start Vote" button appears
6. Start vote and verify vote created
7. Check Votes tab for new vote

#### Scenario 3: Admin Tries to Remove Another Admin
1. Navigate to Members tab as Admin
2. Try to remove another admin
3. Verify error message appears
4. Check that admin is still in list

#### Scenario 4: Member Votes on Open Vote
1. Navigate to Votes tab as Member
2. Find open vote
3. Tap "Vote Yes"
4. Verify SnackBar feedback
5. Check that buttons are disabled
6. Verify vote count updated

#### Scenario 5: Transfer Ownership
1. Navigate to Members tab as Owner
2. Tap transfer ownership button
3. Select new owner from dropdown
4. Confirm transfer
5. Verify ownership transferred
6. Check audit log for event

### 🚨 Error Handling Testing

#### Network Errors
- [ ] **No Internet**: Clear error message with retry button
- [ ] **Slow Connection**: Loading indicators displayed
- [ ] **Timeout**: Appropriate timeout handling

#### Permission Errors
- [ ] **Insufficient Permissions**: Clear error messages
- [ ] **Unauthorized Actions**: Buttons disabled/hidden
- [ ] **Server Rejection**: Error feedback for server-side permission checks

#### Data Errors
- [ ] **Missing Data**: Graceful handling of missing fields
- [ ] **Invalid Data**: Error handling for malformed data
- [ ] **Empty Lists**: Empty state messages displayed

### 📱 Responsive Design Testing

#### Mobile (320px - 768px)
- [ ] **Tab Navigation**: Tabs scrollable and accessible
- [ ] **Button Sizes**: Touch-friendly button sizes
- [ ] **Text Readability**: Text readable on small screens
- [ ] **Dialog Positioning**: Dialogs properly positioned
- [ ] **Loading States**: Loading indicators visible

#### Tablet (768px - 1024px)
- [ ] **Layout Adaptation**: Layout adapts to medium screens
- [ ] **Touch Interactions**: Touch interactions work correctly
- [ ] **Orientation**: Portrait and landscape orientations work

#### Desktop (1024px+)
- [ ] **Mouse Interactions**: Hover states and mouse interactions
- [ ] **Keyboard Navigation**: Tab navigation and keyboard shortcuts
- [ ] **Window Resizing**: UI adapts to window resizing

### 🔍 Accessibility Testing

#### Screen Reader Support
- [ ] **Semantic Labels**: All interactive elements have proper labels
- [ ] **Focus Management**: Logical tab order
- [ ] **ARIA Attributes**: Proper ARIA attributes where needed

#### Keyboard Navigation
- [ ] **Tab Navigation**: All elements accessible via keyboard
- [ ] **Enter/Space**: Buttons and switches respond to Enter/Space
- [ ] **Escape**: Dialogs can be closed with Escape

#### Visual Accessibility
- [ ] **Color Contrast**: Sufficient color contrast ratios
- [ ] **Text Sizing**: Text remains readable when zoomed
- [ ] **Focus Indicators**: Clear focus indicators

### 🧪 Performance Testing

#### Load Times
- [ ] **Initial Load**: Screen loads within 2 seconds
- [ ] **Tab Switching**: Tab switching is smooth
- [ ] **Data Loading**: Data loads progressively

#### Memory Usage
- [ ] **Memory Leaks**: No memory leaks during extended use
- [ ] **Image Optimization**: Images are optimized for size

#### Network Efficiency
- [ ] **API Calls**: Minimal API calls for data
- [ ] **Caching**: Data is cached appropriately
- [ ] **Error Recovery**: Graceful recovery from network issues

## Known Issues & Risks

### High Priority
- [ ] **Race Conditions**: Multiple users editing simultaneously
- [ ] **Permission Caching**: Stale permission data
- [ ] **Vote Timing**: Vote expiration handling

### Medium Priority
- [ ] **Large Groups**: Performance with 100+ members
- [ ] **Deep Nesting**: Complex group hierarchies
- [ ] **Offline Support**: Offline functionality

### Low Priority
- [ ] **Edge Cases**: Very long names, special characters
- [ ] **Internationalization**: RTL languages, different date formats
- [ ] **Accessibility**: Advanced screen reader features

## Test Data Validation

### Seed Data Verification
- [ ] **Group Created**: `test-group-admin-123` exists
- [ ] **Members Present**: userA, userB, userC with correct roles
- [ ] **Policy Set**: Policy with voting required
- [ ] **Vote Created**: Open vote for admin demotion
- [ ] **Audit Events**: 4 audit events created

### Data Integrity
- [ ] **Role Consistency**: Roles match across all tabs
- [ ] **Vote Accuracy**: Vote counts match actual ballots
- [ ] **Audit Trail**: All actions logged in audit
- [ ] **Policy Sync**: Policy changes reflect immediately

## Sign-off Checklist

### Development Team
- [ ] **Code Review**: All code reviewed and approved
- [ ] **Unit Tests**: All unit tests passing
- [ ] **Integration Tests**: All integration tests passing
- [ ] **Performance**: Performance benchmarks met

### QA Team
- [ ] **Manual Testing**: All manual tests completed
- [ ] **Bug Fixes**: All critical bugs fixed
- [ ] **Documentation**: Documentation updated
- [ ] **Release Notes**: Release notes prepared

### Product Team
- [ ] **Feature Complete**: All requirements implemented
- [ ] **User Acceptance**: User acceptance testing passed
- [ ] **Stakeholder Approval**: Stakeholders approved release
- [ ] **Go-Live**: Ready for production deployment

## Post-Release Monitoring

### Metrics to Track
- [ ] **Error Rates**: Monitor for increased error rates
- [ ] **Performance**: Track response times
- [ ] **User Engagement**: Monitor feature usage
- [ ] **Support Tickets**: Track support volume

### Rollback Plan
- [ ] **Database Backup**: Recent backup available
- [ ] **Feature Flags**: Ability to disable features
- [ ] **Rollback Script**: Automated rollback process
- [ ] **Communication Plan**: Stakeholder notification process

---

**QA Tester**: _________________  
**Date**: _________________  
**Status**: ✅ Pass / ❌ Fail / ⚠️ Partial  
**Notes**: _________________
