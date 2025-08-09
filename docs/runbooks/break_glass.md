# Break-Glass Emergency Access Checklist

## Pre-Incident Setup

### Emergency Access Account
- [ ] One SuperAdmin account with hardware MFA
- [ ] Recovery codes printed & sealed offline
- [ ] Cloud Console org-level role *only* for break-glass
- [ ] Quarterly test: sign-in, rotate creds, re-seal
- [ ] Audit: log access + justification

### Emergency Contacts
- [ ] Primary on-call engineer contact info
- [ ] Secondary backup contact info
- [ ] Management escalation contacts
- [ ] Legal/PR contacts for major incidents

### Emergency Procedures
- [ ] Break-glass account credentials stored securely
- [ ] Emergency access procedures documented
- [ ] Incident response team contacts available
- [ ] Communication templates ready

## During Incident

### Access Verification
- [ ] Verify break-glass account has necessary permissions
- [ ] Confirm MFA device is accessible
- [ ] Test login to Firebase Console
- [ ] Verify access to critical services

### Emergency Actions
- [ ] Log all emergency access actions
- [ ] Document reason for break-glass access
- [ ] Notify incident response team
- [ ] Begin incident documentation

### Communication
- [ ] Notify stakeholders of emergency access
- [ ] Update incident status
- [ ] Document all actions taken
- [ ] Prepare post-incident report

## Post-Incident

### Access Review
- [ ] Review all actions taken during emergency
- [ ] Verify no unauthorized changes
- [ ] Document lessons learned
- [ ] Update emergency procedures if needed

### Credential Rotation
- [ ] Rotate break-glass account credentials
- [ ] Update recovery codes
- [ ] Re-seal offline credentials
- [ ] Update access logs

### Documentation
- [ ] Complete incident report
- [ ] Update runbooks based on lessons learned
- [ ] Schedule post-mortem meeting
- [ ] Update emergency procedures

## Emergency Access Commands

### Firebase Console Access
```bash
# Emergency login
firebase login --no-localhost

# Verify access
firebase projects:list
```

### Firestore Emergency Access
```bash
# Emergency data export
gcloud firestore export gs://emergency-backup-bucket/$(date +%Y%m%d_%H%M%S) \
  --project YOUR_PROJECT_ID

# Emergency data import (if needed)
gcloud firestore import gs://emergency-backup-bucket/backup_name \
  --project YOUR_PROJECT_ID
```

### Admin Claims Emergency
```bash
# Emergency admin claim grant
firebase functions:call setAdminClaim \
  --data '{"targetUid":"emergency_user","role":"owner","action":"grant"}'

# Verify claims
firebase functions:call verifyAdminStatus \
  --data '{"targetUid":"emergency_user"}'
```

## Emergency Contact Information

### Primary Contacts
- **On-Call Engineer**: [Name] - [Phone] - [Email]
- **Backup Engineer**: [Name] - [Phone] - [Email]
- **Engineering Manager**: [Name] - [Phone] - [Email]

### Escalation Contacts
- **CTO**: [Name] - [Phone] - [Email]
- **Legal**: [Name] - [Phone] - [Email]
- **PR**: [Name] - [Phone] - [Email]

### Emergency Numbers
- **Firebase Support**: +1-866-246-6453
- **Google Cloud Support**: [Support Portal]
- **Security Team**: [Internal Number]

## Emergency Procedures by Incident Type

### Complete System Outage
1. [ ] Verify break-glass account access
2. [ ] Check Firebase Console status
3. [ ] Review recent deployments
4. [ ] Check for configuration changes
5. [ ] Initiate emergency rollback if needed

### Data Breach
1. [ ] Immediately revoke all admin access
2. [ ] Preserve evidence (logs, snapshots)
3. [ ] Contact legal team
4. [ ] Begin incident documentation
5. [ ] Prepare customer notifications

### Performance Crisis
1. [ ] Check monitoring dashboards
2. [ ] Review recent code changes
3. [ ] Check for resource limits
4. [ ] Implement emergency scaling
5. [ ] Monitor recovery

### Compliance Breach
1. [ ] Immediately stop affected processing
2. [ ] Document the breach
3. [ ] Contact compliance team
4. [ ] Prepare regulatory notifications
5. [ ] Implement immediate fixes

## Recovery Procedures

### System Recovery
1. [ ] Verify all services are operational
2. [ ] Check data integrity
3. [ ] Test critical user flows
4. [ ] Monitor for 24 hours
5. [ ] Document recovery actions

### Access Recovery
1. [ ] Rotate all emergency credentials
2. [ ] Update access logs
3. [ ] Review all actions taken
4. [ ] Update security procedures
5. [ ] Schedule security review

### Communication Recovery
1. [ ] Send resolution notifications
2. [ ] Update status pages
3. [ ] Prepare post-mortem
4. [ ] Update stakeholders
5. [ ] Document lessons learned

---

**Last Updated**: [Date]
**Next Review**: [Date + 3 months]
**Approved By**: [Name, Title]

