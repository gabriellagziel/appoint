---
name: Harden Firestore Rules
about: Enhance Firestore security rules (admin checks + rate limiting)
title: "Enhance Firestore security rules (admin checks + rate limiting)"
labels: ["security", "firestore", "high priority"]
assignees: []
---

## Description
Current rules rely solely on document-existence checks for admin role and allow unbounded write frequency. We need stronger admin validation and per-user rate limits to prevent abuse.

## Current Issues
- Weak admin role validation
- No rate limiting on write operations
- Potential for abuse through rapid API calls
- Insufficient security for sensitive operations

## Acceptance Criteria
- [ ] `isAdmin()` function verifies both `auth.token.admin == true` and user document's `role == 'admin'`
- [ ] Implement `isWithinRateLimit()` to restrict new bookings to 1 per second per user
- [ ] All existing rules updated to call these helper functions
- [ ] Rules simulator tests pass with no denials for valid operations
- [ ] Rate limiting applies to all write operations, not just bookings

## Files to Update
- [ ] `firestore.rules` - main security rules file
- [ ] Add rate limiting helper functions
- [ ] Update admin validation logic
- [ ] Test rules in Firebase console

## Implementation Steps
1. Create `isAdmin()` function that checks both token and document
2. Implement `isWithinRateLimit()` function with per-user tracking
3. Update all write rules to use these helper functions
4. Test rules in Firebase console simulator
5. Verify existing functionality still works
6. Document the new security measures

## Example Rule Structure
```javascript
function isAdmin() {
  return auth.token.admin == true && 
         get(/databases/$(database.name)/documents/users/$(auth.uid)).data.role == 'admin';
}

function isWithinRateLimit() {
  return request.time > resource.data.lastWrite.toMillis() + 1000;
}
```

## Definition of Done
- [ ] Admin validation is strengthened
- [ ] Rate limiting is implemented and working
- [ ] All rules use the new helper functions
- [ ] Rules simulator tests pass
- [ ] Existing functionality is preserved
- [ ] Security improvements are documented 