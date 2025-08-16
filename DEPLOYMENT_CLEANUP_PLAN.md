# 🧹 DigitalOcean App Spec Cleanup Plan

## ✅ **NEW UNIFIED SPEC (KEEP)**
- **`.do/app_spec.yaml`** ← **PRIMARY** - Production-ready unified spec
- **`config/app_spec_final.yaml`** ← **BACKUP** - Safe copy

## 📦 **ARCHIVE THESE OLD SPECS**

### **Individual App Specs (Replace with unified spec)**
- `marketing/marketing-app-spec.yaml` → Archive to `archive/old-specs/`
- `business/business-app-spec.yaml` → Archive to `archive/old-specs/`
- `admin/admin-app-spec.yaml` → Archive to `archive/old-specs/`

### **Outdated/Incomplete Specs**
- `config/do-app.yaml` → Archive (Flutter-specific, now covered in unified)
- `config/app_spec.yaml` → Archive (incomplete, only marketing + API)
- `config/app-spec-nyc1.yaml` → Archive (template with placeholders)
- `config/app-spec-fra1.yaml` → Archive (if exists)

### **Duplicate/Conflicting Specs**
- `.do/app_spec_final.yaml` → Archive (replaced by new unified spec)
- `.do/app_spec_simple.yaml` → Archive (outdated)

## 🚀 **DEPLOYMENT COMMANDS**

```bash
# 1. Create archive directory
mkdir -p archive/old-specs

# 2. Archive old individual app specs
mv marketing/marketing-app-spec.yaml archive/old-specs/
mv business/business-app-spec.yaml archive/old-specs/
mv admin/admin-app-spec.yaml archive/old-specs/

# 3. Archive outdated config specs
mv config/do-app.yaml archive/old-specs/
mv config/app_spec.yaml archive/old-specs/
mv config/app-spec-nyc1.yaml archive/old-specs/

# 4. Archive duplicate .do specs
mv .do/app_spec_final.yaml archive/old-specs/
mv .do/app_spec_simple.yaml archive/old-specs/

# 5. Deploy with new unified spec
doctl apps create --spec .do/app_spec.yaml
```

## 📋 **VERIFICATION CHECKLIST**

- [x] New unified spec saved as `.do/app_spec.yaml`
- [x] Backup copy saved as `config/app_spec_final.yaml`
- [x] Old individual app specs archived
- [x] Outdated config specs archived
- [x] Duplicate .do specs archived
- [ ] Git commit with new unified spec
- [ ] Test deployment with new spec

## 🎯 **BENEFITS OF UNIFIED SPEC**

1. **Single source of truth** for all 6 services
2. **Consistent configuration** across all apps
3. **No port conflicts** (3000, 3001, 3002, 3003, 8080, 8088)
4. **Proper health checks** for each service
5. **Environment variables** properly configured
6. **Cost optimization** with `basic-xxs` instances
7. **Easy maintenance** - one file to update

## ⚠️ **IMPORTANT NOTES**

- **Region changed** from `nyc1` to `fra` (Frankfurt)
- **Flutter app** now routes to `/personal` instead of `/flutter-web`
- **All services** use consistent `npm ci` build pattern
- **Health checks** point to actual endpoints in each app
- **Ports are unique** to prevent conflicts during deployment

## 🚀 **FINAL DEPLOYMENT STEPS**

### **1. Commit & Push**
```bash
git add .do/app_spec.yaml config/app_spec_final.yaml config/deprecated-specs DEPLOYMENT_CLEANUP_PLAN.md
git commit -m "chore(deploy): unify DO spec to .do/app_spec.yaml; archive legacy specs"
git push
```

### **2. Validate & Deploy**
```bash
# Validate spec locally
doctl apps spec validate .do/app_spec.yaml

# Create new app (first-time) OR update existing
doctl apps create --spec .do/app_spec.yaml
# OR
doctl apps update <app-id> --spec .do/app_spec.yaml

# Monitor deployment
doctl apps list
doctl apps get <app-id>
```

### **3. Health Checks**
```bash
# Health endpoints
curl -s https://app-oint.com/ | head -5
curl -s https://business.app-oint.com/api/health/
curl -s https://enterprise.app-oint.com/api/health/
curl -s https://admin.app-oint.com/api/health/
curl -s https://personal.app-oint.com/health.txt
curl -s https://app-oint.com/api | head -5
```

## 🔧 **TROUBLESHOOTING TIPS**

- **Flutter build issues**: If DigitalOcean build fails, consider building in CI and serving as static
- **Environment secrets**: Put Firebase/Stripe/API keys in DO App Settings → Environment Variables
- **Instance sizing**: For production load, consider `basic-xs` (2GB/0.5vCPU) for Business/Enterprise/Admin
- **Port conflicts**: All ports are unique in unified spec (3000, 3001, 3002, 3003, 8080, 8088)
