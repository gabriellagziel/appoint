# 📦 Archived DigitalOcean App Specs

## ⚠️ **DO NOT USE THESE SPECS**

These DigitalOcean app specification files are archived to avoid confusion and deployment conflicts.

## 🎯 **ACTIVE SPEC ONLY**

The **ONLY** active DigitalOcean app spec is:
- **`.do/app_spec.yaml`** ← **Use this for all deployments**

## 🔄 **Why Archived?**

- **Scattered configuration** - Multiple incomplete specs across directories
- **Port conflicts** - Different specs trying to use same ports
- **Inconsistent patterns** - Different build/run commands for same services
- **Maintenance nightmare** - Hard to keep multiple specs in sync

## ✅ **New Unified Approach**

The new `.do/app_spec.yaml` provides:
- **Single source of truth** for all 6 services
- **Consistent configuration** across all apps
- **No port conflicts** (3000, 3001, 3002, 3003, 8080, 8088)
- **Proper health checks** and environment variables
- **Easy maintenance** - one file to update

## 🚫 **What NOT to do**

- ❌ Don't deploy from these archived specs
- ❌ Don't copy-paste from these specs
- ❌ Don't reference these in documentation
- ❌ Don't use these for troubleshooting

## 📚 **Keep for History Only**

This folder is preserved for:
- **Historical reference** - See how specs evolved
- **Rollback reference** - If you need to understand old configs
- **Documentation** - Show the migration path

## 🚀 **Next Steps**

1. **Use only** `.do/app_spec.yaml` for deployments
2. **Update** the unified spec when making changes
3. **Validate** with `doctl apps spec validate .do/app_spec.yaml`
4. **Deploy** with `doctl apps create/update --spec .do/app_spec.yaml`
