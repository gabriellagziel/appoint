# 🚀 **DEPLOYMENT CHECKLIST** - App-Oint Production

**Status:** ✅ **READY FOR DEPLOYMENT**  
**Priority:** HIGH  
**Estimated Time:** 2-3 hours  

---

## 📋 **Pre-Deployment Verification**

### **✅ Local Testing Complete**
- [x] Marketing app builds successfully
- [x] Design system CSS tokens generated
- [x] Functions API responds to `/api/status`
- [x] CORS configuration working
- [x] All dependencies resolved

---

## 🎯 **Deployment Tasks**

### **1. Marketing App (Vercel)** - Priority 1
**Estimated Time:** 30 minutes

**Steps:**
1. [ ] Connect repository to Vercel (if not already)
2. [ ] Set root directory to: `marketing`
3. [ ] Configure build settings:
   - Install: `pnpm -w install --frozen-lockfile`
   - Build: `pnpm -F marketing build`
4. [ ] Set Node.js version to 18
5. [ ] Add environment variables:
   - `NODE_ENV=production`
   - `NEXT_TELEMETRY_DISABLED=1`
   - `NEXT_PUBLIC_SITE_URL=https://marketing.app-oint.com`
   - `NEXT_PUBLIC_API_BASE=https://<functions-host>`
6. [ ] Deploy and verify preview URL
7. [ ] Confirm CSS loads correctly (no raw HTML)
8. [ ] Check browser console for errors

**Success Criteria:**
- ✅ Site loads with full UI/UX
- ✅ No console errors
- ✅ CSS tokens applied correctly

---

### **2. Functions API (DigitalOcean)** - Priority 2
**Estimated Time:** 45 minutes

**Steps:**
1. [ ] Update DigitalOcean app spec with `.do/app_spec.yaml`
2. [ ] Deploy functions service
3. [ ] Verify health check: `curl https://<functions-host>/api/status`
4. [ ] Test CORS with marketing subdomain
5. [ ] Confirm response format: `{"ok": true, ...}`

**Success Criteria:**
- ✅ `/api/status` returns 200 with `{ok: true}`
- ✅ CORS allows marketing.app-oint.com
- ✅ Server running on port 8080

---

### **3. Other Apps (DigitalOcean)** - Priority 3
**Estimated Time:** 1 hour

**Steps:**
1. [ ] Deploy business app (port 3002)
2. [ ] Deploy enterprise app (port 3001)
3. [ ] Deploy admin app (port 3003)
4. [ ] Deploy personal PWA (port 8080)
5. [ ] Verify all health endpoints respond

**Success Criteria:**
- ✅ All apps respond to health checks
- ✅ No deployment errors
- ✅ Services accessible on correct ports

---

## 🔍 **Post-Deployment Verification**

### **Health Check Matrix**
| Service | URL | Expected Response | Status |
|---------|-----|------------------|---------|
| Marketing | `https://marketing.app-oint.com` | Site loads with CSS | ⏳ |
| Functions API | `https://<functions-host>/api/status` | `{"ok": true}` | ⏳ |
| Business | `https://<business-host>/api/health` | Health status | ⏳ |
| Enterprise | `https://<enterprise-host>/api/health` | Health status | ⏳ |
| Admin | `https://<admin-host>/api/health` | Health status | ⏳ |
| Personal | `https://<personal-host>/health.txt` | `ok` | ⏳ |

### **CORS Testing**
- [ ] Test marketing → functions API
- [ ] Test business → functions API
- [ ] Test enterprise → functions API
- [ ] Verify no CORS errors in browser console

### **Performance Testing**
- [ ] Marketing site loads in <3 seconds
- [ ] API responses <100ms
- [ ] No 4xx/5xx errors
- [ ] Lighthouse score ≥90

---

## 🚨 **Rollback Plan**

### **If Marketing Fails:**
1. Revert to previous Vercel deployment
2. Check build logs for errors
3. Verify design-system package is accessible

### **If Functions API Fails:**
1. Revert to previous DigitalOcean deployment
2. Check server logs for errors
3. Verify CORS configuration

### **If Multiple Services Fail:**
1. Stop all deployments
2. Investigate root cause
3. Fix and redeploy in order of priority

---

## 📞 **Emergency Contacts**

**Deployment Lead:** [Name] - [Phone]  
**Technical Lead:** [Name] - [Phone]  
**DevOps Team:** [Slack Channel]  

**Escalation Path:**
1. Deployment team attempts resolution
2. Technical lead consulted if >15 minutes
3. DevOps team engaged if >30 minutes
4. Emergency call if >1 hour

---

## 📊 **Deployment Metrics**

**Start Time:** [Timestamp]  
**Marketing Deployed:** [Timestamp]  
**Functions API Deployed:** [Timestamp]  
**All Services Deployed:** [Timestamp]  
**Total Duration:** [Duration]  

**Issues Encountered:** [List any]  
**Resolution Time:** [Duration]  

---

## ✅ **Final Sign-off**

**Deployment Completed:** [ ]  
**All Health Checks Pass:** [ ]  
**CORS Working:** [ ]  
**No Critical Errors:** [ ]  
**Production Ready:** [ ]  

**Deployed By:** [Name]  
**Verified By:** [Name]  
**Date:** [Date]  

---

**Status:** 🚀 **READY FOR EXECUTION**
