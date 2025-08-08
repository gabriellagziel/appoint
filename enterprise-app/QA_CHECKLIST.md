# 🧪 Enterprise Portal - QA Checklist

## 📋 **Manual Testing Checklist**

### **1. Registration Flow**
- [ ] Visit `http://localhost:3000/register`
- [ ] Fill out business registration form
- [ ] Submit form → Should show success message
- [ ] Check email for confirmation link (if SendGrid configured)
- [ ] Verify application created in Firestore

### **2. Email Confirmation**
- [ ] Click confirmation link in email
- [ ] Should redirect to `/confirm` with token
- [ ] Confirmation page should show loading → success
- [ ] Should redirect to `/login?confirmed=1`
- [ ] Verify client status changed to 'active' in Firestore

### **3. Authentication**
- [ ] Visit `http://localhost:3000/login`
- [ ] Login with valid credentials
- [ ] Should redirect to `/dashboard`
- [ ] Try accessing `/dashboard` without auth → should redirect to `/login`
- [ ] Test logout functionality

### **4. Dashboard & Usage Charts**
- [ ] Dashboard loads with real data from Firestore
- [ ] Usage charts display correctly (Line, Bar, Pie)
- [ ] Date range selector works (7d/30d/90d)
- [ ] Charts update in real-time with onSnapshot
- [ ] Export CSV/JSON buttons work
- [ ] Summary stats display correctly

### **5. API Documentation**
- [ ] Visit `http://localhost:3000/docs`
- [ ] All sections load correctly (Auth, Rate Limits, Endpoints, Errors)
- [ ] Code examples display with tabs (cURL, Node.js, Fetch)
- [ ] Copy functionality works
- [ ] Links to Terms/Privacy work

### **6. Admin Functions**
- [ ] Test `/api/admin/approve` endpoint
- [ ] Test `/api/admin/reject` endpoint  
- [ ] Test `/api/admin/rotate-key` endpoint
- [ ] Verify logs created in Firestore
- [ ] Check status updates in collections

### **7. Security Rules**
- [ ] Client cannot read other client's usage data
- [ ] Only admins can approve/reject applications
- [ ] API key rotation requires admin privileges
- [ ] Public registration works with validation
- [ ] Private data protected by rules

### **8. Error Handling**
- [ ] Test invalid API keys
- [ ] Test rate limit exceeded
- [ ] Test network errors
- [ ] ErrorBoundary catches and displays errors
- [ ] Loading states work correctly

### **9. Export Functionality**
- [ ] Export CSV downloads correct data
- [ ] Export JSON downloads correct data
- [ ] Files have proper timestamps
- [ ] Data format is correct
- [ ] Buttons disabled when no data

### **10. Real-time Updates**
- [ ] Usage data updates live
- [ ] Charts refresh automatically
- [ ] No memory leaks with listeners
- [ ] Connection errors handled gracefully

---

## 🔧 **Technical Verification**

### **Firebase Configuration**
- [ ] Firebase project created and configured
- [ ] Authentication enabled (Email/Password)
- [ ] Firestore Database enabled
- [ ] Security rules deployed
- [ ] Indexes created

### **Environment Variables**
- [ ] `.env.local` created with all required variables
- [ ] Firebase config variables set
- [ ] SendGrid API key configured (if using emails)
- [ ] Functions base URL set

### **Dependencies**
- [ ] All packages installed: `npm install`
- [ ] Chart.js and react-chartjs-2 working
- [ ] Firebase SDK working
- [ ] No TypeScript errors

### **Performance**
- [ ] Dashboard loads in < 3 seconds
- [ ] Charts render smoothly
- [ ] Real-time updates don't cause lag
- [ ] Export functions work quickly

---

## 🚨 **Security Testing**

### **Authentication**
- [ ] Unauthorized users cannot access dashboard
- [ ] API routes protected
- [ ] Session management works
- [ ] Logout clears session

### **Data Protection**
- [ ] Client data isolated by UID
- [ ] Admin functions require admin role
- [ ] API keys properly secured
- [ ] No sensitive data in client-side code

### **Input Validation**
- [ ] Registration form validates all fields
- [ ] Email format validated
- [ ] Required fields enforced
- [ ] XSS protection in place

---

## 📊 **Data Integrity**

### **Firestore Collections**
- [ ] `enterprise_applications` - Business registrations
- [ ] `enterprise_clients` - Client user data
- [ ] `enterprise_usage` - Usage analytics
- [ ] `enterprise_logs` - Activity logs
- [ ] `enterprise_flags` - Security flags
- [ ] `api_keys` - API key management
- [ ] `invoices` - Billing data

### **Data Flow**
- [ ] Registration creates all required documents
- [ ] Usage data logged correctly
- [ ] Admin actions logged
- [ ] Status updates propagate correctly

---

## 🎯 **User Experience**

### **Responsive Design**
- [ ] Works on desktop (1920x1080)
- [ ] Works on tablet (768x1024)
- [ ] Works on mobile (375x667)
- [ ] Charts responsive on all screen sizes

### **Accessibility**
- [ ] Keyboard navigation works
- [ ] Screen reader compatible
- [ ] Color contrast sufficient
- [ ] Focus indicators visible

### **Error Messages**
- [ ] Clear, helpful error messages
- [ ] Loading states informative
- [ ] Empty states handled gracefully
- [ ] Network errors communicated

---

## 🚀 **Deployment Checklist**

### **Production Ready**
- [ ] Environment variables set for production
- [ ] Firebase project configured for production
- [ ] Security rules deployed
- [ ] Indexes created
- [ ] Domain configured

### **Monitoring**
- [ ] Error tracking configured
- [ ] Analytics enabled
- [ ] Performance monitoring active
- [ ] Logs accessible

---

## ✅ **Final Sign-off**

- [ ] All tests pass
- [ ] No critical bugs found
- [ ] Performance acceptable
- [ ] Security verified
- [ ] Documentation complete
- [ ] Ready for production deployment

**QA Tester:** _________________  
**Date:** _________________  
**Status:** ✅ PASS / ❌ FAIL
