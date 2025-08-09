# 🚀 Production Runbook - Admin System

## 🚨 Critical Alerts & Response

### SLO Breach Alert
**Alert**: `admin_dashboard_p95 > 600ms`
**Actions**:
1. Check Firebase Console → Performance
2. Verify Firestore indexes
3. Review recent deployments
**Escalation**: If unresolved after 15 minutes

### COPPA Violation Alert
**Alert**: `coppa_violation > 0`
**Actions**:
1. Check admin logs for violation details
2. Verify child user age verification
3. Review parent approval flows
**Escalation**: **IMMEDIATE** - Legal compliance issue

### eCPM Drop Alert
**Alert**: `eCPM drop > 30% over 24h`
**Actions**:
1. Check ad impression data quality
2. Verify ad network connectivity
3. Review recent ad configuration changes
**Escalation**: If revenue impact > $100/day

## 🔧 Common Issues & Solutions

### Admin Dashboard Slow Loading
**Diagnosis**:
```bash
firebase firestore:indexes --project your-project
```
**Solutions**:
1. Create missing composite index
2. Add pagination or limits
3. Check Firebase connectivity

### Admin Users Cannot Access
**Diagnosis**:
```bash
firebase functions:call verifyAdminStatus --data '{"targetUid":"admin_user_1"}'
```
**Solutions**:
1. Set admin claims via Cloud Function
2. Force token refresh
3. Check Firestore rules

### COPPA Compliance Breach
**Diagnosis**:
```bash
firebase firestore:get /users --where 'age < 13'
```
**Solutions**:
1. Fix age collection logic
2. Ensure parent approval flow
3. Verify ads disabled for children

## 🛠️ Emergency Procedures

### Emergency Rollback
```bash
# Stop deployments
gh workflow disable admin-ci.yml

# Revert to last known good commit
git revert HEAD
firebase deploy --only hosting --project your-project
```

### Data Recovery
```bash
# Restore from backup
gcloud firestore import gs://your-backup-bucket/20240101 --project your-project
```

### Admin Access Recovery
```bash
# Grant emergency admin access
firebase functions:call setAdminClaim --data '{"targetUid":"your_uid","role":"owner","action":"grant"}'
```

## 📊 Key Metrics
- **Dashboard Response Time**: < 600ms p95
- **Error Rate**: < 1%
- **COPPA Compliance**: 100%
- **eCPM**: > $3.00
- **Ad Completion Rate**: > 85%

## 📞 Escalation
- **Level 1**: On-Call Engineer (0-15 min)
- **Level 2**: Senior Engineer (15 min - 1 hour)
- **Level 3**: Engineering Manager (1-4 hours)
- **Level 4**: CTO/VP Engineering (4+ hours)

## 🔐 Admin Credentials
- **Super Admin UID**: `owner_user_1`
- **Admin UID**: `admin_user_1`
- **Test Users**: `u_premium`, `u_free`, `u_child`

## 📋 Daily Health Check
- [ ] Admin dashboard loads < 2 seconds
- [ ] No SLO breaches in last 24h
- [ ] COPPA compliance = 100%
- [ ] Error rate < 1%
- [ ] All admin functions working

---

**Last Updated**: [Date]
**Next Review**: [Date + 30 days]
