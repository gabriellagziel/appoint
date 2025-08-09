# Data Protection Impact Assessment (DPIA) — AppOint

## 1. Overview
- **Controller**: AppOint Ltd.
- **DPO/Contact**: dpo@app-oint.com
- **Processing**: Scheduling platform with group features, analytics, ads (non-child contexts), COPPA paths for under-13.

## 2. Purposes & Legal Basis
- **Service delivery** (contract)
- **Security & abuse prevention** (legitimate interest)
- **Analytics** (consent where required)
- **COPPA parental consent** (legal obligation in US for under-13)

## 3. Data Categories
- **Account**: email, name, UID
- **Events**: meeting metadata, RSVP
- **Groups**: member UIDs, roles
- **Media/Checklists**: user-generated content
- **Admin logs**: actor UID, action, timestamp
- **Children flows**: age band, parent contact (hashed where possible)

## 4. Processing Map
- **Firestore** (EU region): primary store
- **Storage**: media files
- **Functions**: claim mgmt, analytics aggregation
- **Third-party ads**: **not shown** in child contexts

## 5. Risks & Mitigations
- **Unauthorized admin access** → Custom claims + MFA + strict rules
- **Excess PII in logs** → IDs only; rotate & redact
- **Child data exposure** → COPPA gates + visibility policies
- **Data breach** → IAM least privilege, VPC egress controls, backups

## 6. Retention
- **Admin logs**: 12–24 months (export to BQ/Archive)
- **Media/Checklists**: until user deletion or group owner purge
- **Form submissions**: 12 months after event end (configurable)

## 7. Rights & Requests
- **Access/Export/Delete endpoints**; parent-managed for under-13
- **Appeals/escalation** to DPO

## 8. Reviews
- **Reassess after major features**, annually at minimum

## 9. Technical Safeguards

### Data Minimization
- Admin logs contain only UIDs, not PII
- Child data hashed where possible
- Age bands used instead of exact ages

### Access Controls
- Role-based access (Admin/SuperAdmin)
- MFA required for admin accounts
- Audit trails for all admin actions

### Encryption
- Data encrypted in transit (TLS 1.3)
- Data encrypted at rest (AES-256)
- Keys managed by Google Cloud KMS

### Monitoring
- Real-time SLO monitoring
- Automated alerts for compliance breaches
- Regular security audits

## 10. Compliance Verification

### COPPA Compliance
- [ ] Age verification implemented
- [ ] Parent consent flow active
- [ ] No ads shown to under-13 users
- [ ] Data deletion for child accounts
- [ ] Parent access controls

### GDPR Compliance
- [ ] Data subject rights implemented
- [ ] Legal basis documented
- [ ] Retention policies enforced
- [ ] Data portability available
- [ ] Breach notification procedures

### Security Measures
- [ ] MFA enabled for admin accounts
- [ ] Regular access reviews conducted
- [ ] Security testing performed
- [ ] Incident response plan ready
- [ ] Backup and recovery tested

## 11. Risk Assessment

### High Risk
- **Child data processing** → Mitigated by COPPA compliance
- **Admin access abuse** → Mitigated by MFA and audit trails
- **Data breach** → Mitigated by encryption and access controls

### Medium Risk
- **Performance issues** → Mitigated by SLO monitoring
- **Cost overruns** → Mitigated by budget alerts
- **Compliance drift** → Mitigated by regular reviews

### Low Risk
- **Minor UX issues** → Standard development process
- **Documentation gaps** → Regular updates

## 12. Action Items

### Immediate (This Month)
- [ ] Deploy admin access review tool
- [ ] Set up budget alerts
- [ ] Test COPPA compliance flows
- [ ] Review retention policies

### Short Term (Next Quarter)
- [ ] Implement data export API
- [ ] Add parent consent management
- [ ] Set up automated compliance checks
- [ ] Conduct security audit

### Long Term (Next Year)
- [ ] Evaluate data residency requirements
- [ ] Consider additional privacy features
- [ ] Plan for regulatory changes
- [ ] Review and update DPIA

---

**Last Updated**: [Date]
**Next Review**: [Date + 6 months]
**Approved By**: [Name, Title]

