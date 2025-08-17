# 🚀 DigitalOcean App Platform Deployment Runbook

## 🎯 **Pre-Deployment Checklist**

- [ ] ✅ Unified app spec created (`.do/app_spec.yaml`)
- [ ] ✅ All old specs archived (`config/deprecated-specs/`)
- [ ] ✅ Spec validated with `doctl apps spec validate`
- [ ] ✅ DNS records ready for subdomains
- [ ] ✅ Environment variables documented
- [ ] ✅ Rollback plan ready

---

## 🔧 **Preflight Checks**

```bash
# From repo root
doctl auth list
doctl account get

# Validate spec
doctl apps spec validate .do/app_spec.yaml
```

**Expected Output:**
- ✅ Authentication: Active
- ✅ Account: Your account details
- ✅ Spec: Valid YAML with all services

---

## 🚀 **Phase 1: Deploy App**

### **Option A: First-Time Deployment**
```bash
# Creates new app and returns APP_ID
doctl apps create --spec .do/app_spec.yaml
```

### **Option B: Update Existing App**
```bash
# Replace <APP_ID> with your actual app ID
doctl apps update <APP_ID> --spec .do/app_spec.yaml
```

**Save the APP_ID** - you'll need it for monitoring and rollback.

---

## 📊 **Phase 2: Monitor Rollout**

### **Real-time Status**
```bash
# Shows live deployment status
doctl apps get <APP_ID>

# Refresh every 10 seconds
watch -n 10 "doctl apps get <APP_ID> | sed -n '1,120p'"
```

### **Expected Status Flow**
1. **Building** → Services are building from source
2. **Deploying** → Services are being deployed
3. **Running** → All services are healthy and running

**Target: All 6 services showing "Running" status**

---

## 🌐 **Phase 3: DNS Configuration**

### **Required CNAME Records**
Add these to your DNS provider (e.g., Cloudflare, Route53):

| Subdomain | Points To | Service |
|------------|-----------|---------|
| `business.app-oint.com` | DO hostname | Business Portal |
| `admin.app-oint.com` | DO hostname | Admin Panel |
| `enterprise.app-oint.com` | DO hostname | Enterprise Portal |
| `personal.app-oint.com` | DO hostname | Flutter PWA |
| `api.app-oint.com` | DO hostname | Functions/API |

### **Get DO Hostnames**
```bash
doctl apps get <APP_ID> | grep -A 5 "Routes:"
```

**Note:** DigitalOcean will provision SSL certificates automatically once DNS resolves.

---

## 🔐 **Phase 4: Environment Variables & Secrets**

### **DO App Platform → Settings → Environment Variables**

#### **Core Environment**
| Key | Value | Scope | Notes |
|-----|-------|-------|-------|
| `NODE_ENV` | `production` | Run and Build | All services |
| `PORT` | Service-specific | Run and Build | Each service |

#### **Firebase (Server Only)**
| Key | Value | Scope | Notes |
|-----|-------|-------|-------|
| `FIREBASE_PROJECT_ID` | Your project ID | Run and Build | Secret |
| `FIREBASE_CLIENT_EMAIL` | Service account email | Run and Build | Secret |
| `FIREBASE_PRIVATE_KEY` | Service account key | Run and Build | Secret |

#### **Stripe (Server Only)**
| Key | Value | Scope | Notes |
|-----|-------|-------|-------|
| `STRIPE_SECRET_KEY` | Live secret key | Run and Build | Secret |
| `STRIPE_WEBHOOK_SECRET` | Webhook endpoint secret | Run and Build | Secret |

#### **Authentication**
| Key | Value | Scope | Notes |
|-----|-------|-------|-------|
| `NEXTAUTH_URL` | Service URL | Run and Build | Each service |
| `NEXTAUTH_SECRET` | Random string | Run and Build | Secret |

#### **External Services**
| Key | Value | Scope | Notes |
|-----|-------|-------|-------|
| `GOOGLE_MAPS_API_KEY` | API key | Run and Build | Client bundle |
| `SENDGRID_API_KEY` | API key | Run and Build | Secret |

---

## 🧪 **Phase 5: Post-Deploy Smoke Tests**

### **Create Smoke Test Script**
```bash
# Create the script
cat > qa/post-deploy-smoke.sh << 'EOF'
#!/usr/bin/env bash
set -euo pipefail
BASE_DOMAIN="app-oint.com"

echo "🚀 Starting post-deploy smoke tests..."

echo "== Health Checks =="
echo "Testing marketing.app-oint.com..."
curl -sfS https://$BASE_DOMAIN/ | head -5 || exit 1

echo "Testing business.app-oint.com..."
curl -sfS https://business.$BASE_DOMAIN/api/health/ || exit 1

echo "Testing enterprise.app-oint.com..."
curl -sfS https://enterprise.$BASE_DOMAIN/api/health/ || exit 1

echo "Testing admin.app-oint.com..."
curl -sfS https://admin.$BASE_DOMAIN/api/health/ || exit 1

echo "Testing personal.app-oint.com..."
curl -sfS https://personal.$BASE_DOMAIN/health.txt || exit 1

echo "Testing api.app-oint.com..."
curl -sfS https://api.$BASE_DOMAIN/ || echo "API endpoint optional"

echo "== Content Validation =="
echo "Checking marketing page content..."
curl -sfS https://$BASE_DOMAIN/ | grep -i -E "App[- ]?Oint|time|organizer" || exit 1

echo "✅ All smoke tests passed!"
EOF

# Make executable
chmod +x qa/post-deploy-smoke.sh
```

### **Run Smoke Tests**
```bash
bash qa/post-deploy-smoke.sh
```

---

## 🔍 **Phase 6: Deep Validation**

### **Service Health Dashboard**
```bash
# Check all services status
doctl apps get <APP_ID> | grep -A 20 "Services:"

# Check specific service logs
doctl apps logs <APP_ID> --service=<SERVICE_NAME> --tail=50
```

### **Performance Checks**
- **Lighthouse** scores for each subdomain
- **Core Web Vitals** in real user conditions
- **API response times** for health endpoints

---

## 🧯 **Rollback Plan**

### **If Deployment Fails**
```bash
# List all deployments
doctl apps deployments list <APP_ID>

# Rollback to previous deployment
doctl apps deployments create <APP_ID> --deployment=<DEPLOYMENT_ID>
```

### **If DNS Issues**
- Verify CNAME records are pointing to correct DO hostnames
- Check DNS propagation (can take up to 48 hours)
- Verify SSL certificates are provisioned

### **If Build Fails**
- Check build logs: `doctl apps logs <APP_ID> --service=<SERVICE_NAME>`
- Verify source code is accessible
- Check build commands are correct

---

## 📈 **Post-Launch Optimization**

### **Immediate (Day 1)**
- [ ] Monitor error rates and performance
- [ ] Verify all health checks are passing
- [ ] Test user flows on each subdomain
- [ ] Check SSL certificates are valid

### **Week 1**
- [ ] Performance monitoring setup
- [ ] Alerting configuration
- [ ] Backup and disaster recovery
- [ ] Cost optimization review

### **Month 1**
- [ ] Load testing and scaling
- [ ] Security audit
- [ ] Performance optimization
- [ ] User feedback collection

---

## 🆘 **Emergency Contacts**

- **DigitalOcean Support**: [Support Portal](https://cloud.digitalocean.com/support)
- **DNS Provider**: Your DNS provider's support
- **Team Escalation**: Your team's on-call process

---

## 📋 **Deployment Checklist**

- [ ] Preflight checks passed
- [ ] App deployed successfully
- [ ] All services running
- [ ] DNS configured and propagated
- [ ] Environment variables set
- [ ] Smoke tests passed
- [ ] SSL certificates valid
- [ ] Monitoring configured
- [ ] Team notified of deployment
- [ ] Documentation updated

---

**🎯 You're ready to deploy! Follow this runbook step by step for a smooth launch.**
