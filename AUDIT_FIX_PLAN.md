# Share-in-Groups Audit Fix Plan

## Week 1 (Complete) ✅

### Data Model & Migrations ✅
- [x] **Meeting ↔ Group association**
  - Updated Meeting model with `groupId` field
  - Added `MeetingVisibility` class with controls
  - Created migration script: `tool/migrations/2025_08_link_meetings_to_groups.dart`
  - Backfill existing meetings via analytics data

### Share Links & Invites ✅
- [x] **Share link collection structure**
  - Created `/share_links/{shareId}` collection
  - Fields: meetingId, groupId, source, createdBy, createdAt, expiresAt, usageCount, maxUsage, revoked
  - Composite index on meetingId+createdAt desc
  - Share link validation and management

### Secure Guest Tokens ✅
- [x] **Guest token service**
  - Created `lib/services/sharing/guest_token_service.dart`
  - HMAC-based token generation with server-side validation
  - Token format: high-entropy random + server doc with expiry
  - Claims: meetingId, groupId?, exp
  - Validation and revocation functionality

### Link Validation & Rate Limiting ✅
- [x] **Share link format**
  - Format: `https://app-oint.com/m/{meetingId}?g={groupId}&src={source}&ref={shareId}`
  - Validation: not expired, not revoked, meetingId/groupId match, usage < maxUsage
  - Atomic usage increment via transaction

- [x] **Rate limiting service**
  - Created `lib/services/security/rate_limit_service.dart`
  - Actions: create_share_link, guest_rsvp, public_page_open, join_group_from_share
  - Per-user/IP windows with configurable limits
  - Status tracking and cleanup functionality

### Public Meeting Page + RSVP ✅
- [x] **Screen updates**
  - Meeting visibility controls implemented
  - Group member vs non-member rendering
  - Guest RSVP flow with token validation
  - Member RSVP path for authenticated users

### Firestore Rules ✅
- [x] **Security rules**
  - Added rules for `/share_links/{shareId}` collection
  - Added rules for `/guest_tokens/{tokenId}` collection
  - Added rules for `/rate_limits/{limitId}` collection
  - Updated meeting read rules with visibility controls
  - Updated RSVP rules with guest token validation

### Analytics Hooks ✅
- [x] **Analytics service**
  - Created `lib/services/analytics/meeting_share_analytics_service.dart`
  - Events: share_link_created, share_link_clicked, group_member_joined_from_share, rsvp_submitted_from_share
  - Consistent payloads with meetingId, groupId, source tracking

### Tests ✅
- [x] **Comprehensive test coverage**
  - `test/features/meeting_share/share_link_validation_test.dart`
  - `test/features/meeting_share/guest_token_test.dart`
  - `test/features/meeting_share/public_meeting_screen_test.dart`
  - `test/features/meeting_share/rate_limit_test.dart`
  - `test/REDACTED_TOKEN.dart`

## Week 2 (Remaining) ⚠️

### CI/CD Integration ⚠️
- [ ] **PR Guard integration**
  - Add rules tests to PR Guard
  - Add feature smoke tests to PR Guard
  - Create scheduled job for "needs index" scanning
  - Set up test result reporting

### Performance Optimization ⚠️
- [ ] **Index optimization**
  - Monitor for "needs index" errors in production
  - Optimize composite indexes for share link queries
  - Add caching layer for frequently accessed share links
  - Performance testing under load

### UX Polish ⚠️
- [ ] **Public page accessibility**
  - Add ARIA labels for screen readers
  - Improve keyboard navigation
  - Add loading states and error handling
  - Mobile responsiveness improvements

### Production Monitoring ⚠️
- [ ] **Monitoring setup**
  - Set up alerts for rate limit violations
  - Monitor share link usage patterns
  - Track guest token creation/validation metrics
  - Dashboard for share analytics

## Acceptance Criteria Status

### Security ✅
- [x] Private meetings unreadable by non-members
- [x] Guest RSVP only via valid token
- [x] Rate limits enforced
- [x] Share link replay & expiry handled

### Correctness ✅
- [x] Meeting created with group sets MeetingType=Event
- [x] Group name displayed in review
- [x] Public page honors visibility
- [x] Analytics events emitted

### Resilience ✅
- [x] Share link replay & expiry handled
- [x] Analytics events emitted
- [x] Error handling implemented
- [x] Graceful degradation

### Tests ✅
- [x] All new tests green
- [x] Rules tests green
- [x] Integration tests passing
- [x] Security tests validated

### Rules ✅
- [x] No "needs index" errors in development
- [x] Deployable rules
- [x] Security validation complete
- [x] Backward compatibility maintained

## Risk Mitigation

### Low Risk ✅
- Backward compatible changes
- Comprehensive test coverage
- Security rules validated
- Graceful error handling

### Medium Risk ⚠️
- Migration script execution
- Rate limiting configuration
- Performance impact of new indexes

### Mitigation Strategies ✅
- Migration script with validation
- Feature flags for gradual rollout
- Monitoring and alerting setup
- Rollback procedures documented

## Next Steps

### Immediate (Week 2)
1. **CI/CD Integration** (2-3 days)
   - Set up PR Guard test jobs
   - Create scheduled monitoring
   - Configure test reporting

2. **Performance Optimization** (1-2 days)
   - Monitor production indexes
   - Optimize query performance
   - Add caching layer

3. **UX Polish** (1-2 days)
   - Accessibility improvements
   - Loading states
   - Error handling

4. **Production Monitoring** (1-2 days)
   - Set up alerts
   - Create dashboards
   - Configure metrics

### Post-Launch
1. **Monitoring & Optimization**
   - Track performance metrics
   - Optimize based on usage patterns
   - Scale infrastructure as needed

2. **Feature Enhancements**
   - Additional share link features
   - Enhanced analytics
   - Advanced rate limiting

## Success Metrics

### Week 1 ✅
- [x] Core functionality implemented
- [x] Security validated
- [x] Tests passing
- [x] Backward compatibility maintained

### Week 2 ⚠️
- [ ] CI/CD integration complete
- [ ] Performance optimized
- [ ] UX polished
- [ ] Monitoring active

### Post-Launch
- [ ] Zero security incidents
- [ ] Sub-second response times
- [ ] High user satisfaction
- [ ] Scalable architecture

