# 🚀 App-Oint PWA Deployment Usage

## Quick Start

### 1. Make scripts executable
```bash
chmod +x deploy.sh rollback.sh
```

### 2. Deploy to both environments
```bash
./deploy.sh
```

### 3. Rollback if needed
```bash
./rollback.sh
```

## 📋 Pre-Deployment Setup

### Firebase Hosting
1. **Install Firebase CLI**: `npm install -g firebase-tools`
2. **Login**: `firebase login`
3. **Initialize**: `firebase init hosting` (if not already done)
4. **Update firebase.json** with PWA cache headers (already done)

### DigitalOcean/Nginx Server
1. **SSH Access**: Ensure SSH key access to your server
2. **Update deploy.sh**: Replace `user@your-server` with your actual server details
3. **Update rollback.sh**: Replace `/var/www/backup/app.app-oint.com/` with your backup path
4. **Nginx Config**: Apply `nginx-pwa.conf` to your server

## 🔧 Configuration

### Update Server Details
Edit `deploy.sh` and `rollback.sh`:
```bash
# Replace with your actual server details
rsync -av build/web/ your-username@your-server-ip:/var/www/app.app-oint.com/
ssh your-username@your-server-ip "sudo nginx -s reload"
```

### Backup Path
Edit `rollback.sh`:
```bash
# Replace with your actual backup path
ssh user@your-server "rsync -av /var/www/backup/app.app-oint.com/ /var/www/app.app-oint.com/"
```

## 🚀 Deployment Process

### What deploy.sh does:
1. **Build**: Clean, get dependencies, build production PWA
2. **Firebase**: Deploy to Firebase Hosting with PWA headers
3. **Nginx**: Sync files to DigitalOcean server and reload nginx
4. **Complete**: Both environments updated

### What rollback.sh does:
1. **Firebase**: Rollback to previous Firebase Hosting version
2. **Nginx**: Restore from backup and reload nginx
3. **Complete**: Both environments rolled back

## 🔍 Post-Deployment Testing

### Quick Smoke Test
```bash
./smoke_test.sh https://app.app-oint.com
```

### Manual Testing Checklist
- [ ] **Android Chrome**: Create 3 meetings → PWA prompt → Install
- [ ] **iOS Safari**: Create 3 meetings → Manual instructions → Add to Home Screen
- [ ] **Desktop**: No PWA prompts (correct behavior)
- [ ] **Analytics**: Check browser console for events

## 📊 Monitoring

### Analytics Events to Watch
```javascript
// Expected events in browser console:
pwa_prompt_shown {device: "android", reason: "meeting_count_trigger"}
pwa_install_accepted {device: "android"}
pwa_installed {device: "android", source: "android_native_prompt"}
meeting_created {meetingType: "personal", userMeetingCount: 3, willShowPwaPrompt: true}
```

### Performance Metrics
- **Lighthouse PWA Score**: Should be 100/100
- **Load Time**: < 2 seconds
- **Install Rate**: Target 20%+ of prompted users

## 🛡️ Troubleshooting

### Common Issues
1. **Build fails**: Check Flutter version and dependencies
2. **Firebase deploy fails**: Check authentication and project setup
3. **Nginx sync fails**: Check SSH access and server permissions
4. **PWA not working**: Verify HTTPS and service worker registration

### Emergency Rollback
```bash
# Quick rollback to previous version
./rollback.sh

# Or manual rollback
firebase hosting:rollback
ssh user@your-server "sudo systemctl reload nginx"
```

## 📈 Success Metrics

### Week 1 Targets
- **PWA Install Rate**: 20%+ of prompted users
- **User Engagement**: PWA users vs web users
- **Performance**: <2s load times
- **Error Rate**: <1% PWA-related errors

---

**Status**: Ready for Production Deployment ✅
**Next Action**: Run `./deploy.sh` and monitor results
