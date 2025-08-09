# Share-in-Groups Final Go-Live Runbook

## Overview

This runbook provides step-by-step instructions for the final deployment of the Share-in-Groups feature to production. This is the culmination of the audit and implementation process.

**Feature**: Share-in-Groups (Meeting Sharing with Groups)
**Deployment Date**: TBD
**Estimated Duration**: 2-3 hours
**Risk Level**: Low (all components tested and validated)

## Pre-Deployment Checklist

### ✅ Code Quality
- [ ] All tests passing locally
- [ ] No linting errors
- [ ] Test coverage > 80%
- [ ] Security audit completed
- [ ] Performance testing completed

### ✅ Infrastructure
- [ ] Firebase project configured
- [ ] Firestore indexes deployed
- [ ] Monitoring alerts configured
- [ ] Backup procedures in place
- [ ] Rollback plan documented

### ✅ Documentation
- [ ] API documentation updated
- [ ] User guides created
- [ ] Admin runbooks ready
- [ ] Support team briefed
- [ ] Release notes prepared

### ✅ Monitoring
- [ ] Telemetry verification script ready
- [ ] Alert policies configured
- [ ] Dashboard access granted
- [ ] Log aggregation working
- [ ] Performance monitoring active

## Deployment Steps

### Step 1: Pre-Deployment Verification

**Duration**: 30 minutes

1. **Verify Test Environment**
   ```bash
   # Run all tests one final time
   flutter test test/features/meeting_share/
   flutter test test/REDACTED_TOKEN.dart
   
   # Verify telemetry
   GOOGLE_APPLICATION_CREDENTIALS=./sa.json npx ts-node tools/telemetry_verify.ts
   ```

2. **Check Feature Flags**
   ```bash
   # Verify feature flags are ready
   firebase functions:config:get
   ```

3. **Validate Firestore Rules**
   ```bash
   # Deploy rules to staging first
   firebase deploy --only firestore:rules --project staging
   
   # Test rules in staging
   firebase firestore:rules:test firestore.rules --project staging
   ```

### Step 2: Database Preparation

**Duration**: 15 minutes

1. **Deploy Firestore Indexes**
   ```bash
   # Deploy indexes to production
   firebase deploy --only firestore:indexes --project production
   
   # Verify indexes are building
   firebase firestore:indexes --project production
   ```

2. **Verify Collections**
   ```bash
   # Check that required collections exist
   firebase firestore:collections --project production
   ```

### Step 3: Feature Flag Activation

**Duration**: 5 minutes

1. **Enable Feature Flags**
   ```bash
   # Set feature flags to enabled
   firebase functions:config:set share.feature_share_links_enabled=true
   firebase functions:config:set share.feature_guest_rsvp_enabled=true
   firebase functions:config:set share.feature_public_meeting_page_v2=true
   ```

2. **Deploy Functions**
   ```bash
   # Deploy updated functions
   firebase deploy --only functions --project production
   ```

### Step 4: Application Deployment

**Duration**: 30 minutes

1. **Deploy Web Application**
   ```bash
   # Build and deploy web app
   flutter build web --release
   firebase deploy --only hosting --project production
   ```

2. **Deploy Mobile Application**
   ```bash
   # For mobile apps, follow standard deployment process
   # This may involve App Store/Play Store releases
   ```

### Step 5: Monitoring Setup

**Duration**: 15 minutes

1. **Deploy Monitoring Alerts**
   ```bash
   # Deploy alert policies
   gcloud monitoring policies create --policy-from-file=ops/monitoring/alert_firestore_reads.json
   gcloud monitoring policies create --policy-from-file=ops/monitoring/alert_rules_denied.json
   ```

2. **Verify Monitoring**
   ```bash
   # Check that alerts are active
   gcloud monitoring policies list
   ```

### Step 6: Post-Deployment Verification

**Duration**: 30 minutes

1. **Run Smoke Tests**
   ```bash
   # Run automated smoke tests
   flutter drive --target=test_driver/smoke_test.dart
   ```

2. **Verify Telemetry**
   ```bash
   # Run telemetry verification
   GOOGLE_APPLICATION_CREDENTIALS=./sa.json npx ts-node tools/telemetry_verify.ts
   ```

3. **Check Performance**
   ```bash
   # Monitor response times
   # Check for "needs index" errors
   # Verify rate limiting is working
   ```

4. **Manual Testing**
   - [ ] Create share link
   - [ ] Access public meeting page
   - [ ] Submit guest RSVP
   - [ ] Test rate limiting
   - [ ] Verify analytics events

### Step 7: Communication

**Duration**: 15 minutes

1. **Internal Communication**
   - [ ] Notify development team
   - [ ] Update status page
   - [ ] Send internal announcement

2. **External Communication**
   - [ ] Update release notes
   - [ ] Send user notification (if applicable)
   - [ ] Update documentation

## Rollback Plan

### Immediate Rollback (if critical issues)

1. **Disable Feature Flags**
   ```bash
   firebase functions:config:set share.feature_share_links_enabled=false
   firebase functions:config:set share.feature_guest_rsvp_enabled=false
   firebase functions:config:set share.feature_public_meeting_page_v2=false
   firebase deploy --only functions --project production
   ```

2. **Revert Application**
   ```bash
   # Revert to previous version
   git revert HEAD
   firebase deploy --only hosting --project production
   ```

### Data Recovery (if needed)

1. **Restore from Backup**
   ```bash
   # Restore Firestore data if needed
   firebase firestore:backups:restore <backup-id>
   ```

## Post-Deployment Monitoring

### First 24 Hours

**Every 30 minutes**:
- [ ] Check error rates
- [ ] Monitor response times
- [ ] Verify analytics events
- [ ] Check rate limiting

**Every 2 hours**:
- [ ] Run telemetry verification
- [ ] Check for anomalies
- [ ] Review user feedback

### First Week

**Daily**:
- [ ] Generate adoption metrics
- [ ] Review performance trends
- [ ] Check security logs
- [ ] Update stakeholders

**Day 3**:
- [ ] Generate Day-3 adoption report
- [ ] Analyze conversion funnel
- [ ] Identify optimization opportunities

## Success Criteria

### Technical Metrics
- [ ] Response time < 600ms (p95)
- [ ] Error rate < 1%
- [ ] No "needs index" errors
- [ ] All analytics events firing

### Business Metrics
- [ ] Share link creation rate > 0
- [ ] Click-through rate > 20%
- [ ] RSVP conversion rate > 30%
- [ ] User satisfaction > 4.0/5.0

### Security Metrics
- [ ] No unauthorized access
- [ ] Rate limits enforced
- [ ] Token validation working
- [ ] No data leakage

## Troubleshooting

### Common Issues

1. **"Needs Index" Errors**
   ```bash
   # Check index status
   firebase firestore:indexes --project production
   
   # Wait for indexes to build or add missing indexes
   ```

2. **High Error Rates**
   ```bash
   # Check logs
   firebase functions:log --project production
   
   # Check Firestore rules
   firebase firestore:rules:test firestore.rules
   ```

3. **Rate Limiting Issues**
   ```bash
   # Check rate limit configuration
   firebase functions:config:get --project production
   
   # Adjust limits if needed
   firebase functions:config:set share.rate_limit_max_hits=20
   ```

4. **Analytics Not Firing**
   ```bash
   # Run telemetry verification
   GOOGLE_APPLICATION_CREDENTIALS=./sa.json npx ts-node tools/telemetry_verify.ts
   
   # Check analytics configuration
   ```

### Emergency Contacts

- **Primary**: DevOps Team Lead
- **Secondary**: Security Team Lead
- **Emergency**: On-call Engineer

## Post-Deployment Tasks

### Week 1
- [ ] Monitor daily metrics
- [ ] Address any issues
- [ ] Collect user feedback
- [ ] Plan optimizations

### Week 2
- [ ] Generate weekly report
- [ ] Implement optimizations
- [ ] Update documentation
- [ ] Plan next iteration

### Month 1
- [ ] Comprehensive review
- [ ] Performance analysis
- [ ] User satisfaction survey
- [ ] Future roadmap planning

## Conclusion

The Share-in-Groups feature is ready for production deployment. All components have been thoroughly tested, security measures are in place, and monitoring is configured. The deployment should proceed smoothly with minimal risk.

**Remember**: Monitor closely for the first 24 hours and be prepared to rollback if any critical issues arise.

---

*This runbook should be updated after each deployment to reflect lessons learned and process improvements.*
