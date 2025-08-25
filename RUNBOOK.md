# App-oint Deployment Runbook

## Quick Deploy & Alias Commands

### 1. Deploy All Projects

```bash
# Deploy marketing site (main)
cd marketing && vercel --prod

# Deploy business portal
cd business && vercel --prod

# Deploy enterprise app
cd enterprise-app && vercel --prod
```

### 2. Set Domain Aliases

```bash
# Main site
vercel domains add app-oint.com

# Business portal
vercel domains add business.app-oint.com

# Enterprise app
vercel domains add enterprise.app-oint.com
```

### 3. Remove www Redirect (if needed)

```bash
# Remove www subdomain from main project
vercel domains rm www.app-oint.com
```

## Rollback Commands

### Quick Rollback to Previous Deployment

```bash
# Get deployment list
vercel ls

# Rollback to specific deployment
vercel rollback <deployment-id>
```

### Emergency Rollback (last known good)

```bash
# Rollback to production
vercel rollback production

# Or use specific deployment aliases:
# Marketing
npx -y vercel alias set "https://marketing-<good>.vercel.app" app-oint.com
npx -y vercel alias set "https://marketing-<good>.vercel.app" www.app-oint.com

# Business
npx -y vercel alias set "https://business-<good>.vercel.app" business.app-oint.com

# Enterprise
npx -y vercel alias set "https://enterprise-<good>.vercel.app" enterprise.app-oint.com
```

## Health & Headers Verification

### Run Full Health Check

```bash
./ops/health/health_check.sh
```

### Verify Security Headers

```bash
./ops/health/verify_headers.sh
```

### Check Domain Status

```bash
./ops/health/check_domains.sh
```

## Ownership Rules

**One Domain Per Project:**

- `marketing/` → `app-oint.com` (apex)
- `business/` → `business.app-oint.com`
- `enterprise-app/` → `enterprise.app-oint.com`

**Never mix domains across projects.**

## Troubleshooting

### Common Issues

1. **Domain already exists**: Use `vercel domains rm` first
2. **Build fails**: Check `vercel logs`
3. **Headers not working**: Verify `vercel.json` syntax

### Emergency Contacts

- Check `ops/health/` for diagnostic scripts
- Review `fix_deployments.sh` for domain fixes
- Use `vercel --help` for command reference

## Maintenance

### Monthly Checks

- Run health check script
- Verify all domains are live
- Check security headers are present
- Review deployment logs for errors

### Before Major Changes

- Test in staging environment
- Have rollback plan ready
- Update this runbook if needed
