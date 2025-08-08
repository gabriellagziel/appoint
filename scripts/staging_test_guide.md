# 🧪 Staging Testing Guide for Playtime System

## 🚀 Quick Setup

### 1. Deploy to Staging
```bash
# Set your staging project ID
export STAGING_PROJECT_ID="your-staging-project-id"
export FIREBASE_TOKEN="your-firebase-token"

# Run the deployment script
./scripts/staging_deploy.sh
```

### 2. Seed Test Data
```bash
# Option A: Use the JSON seed file
firebase firestore:import test_data/playtime_games_seed.json --project $STAGING_PROJECT_ID

# Option B: Use the Node.js script (requires Firebase Admin setup)
node scripts/staging_seed_users.js
```

### 3. Manual User Creation
If you prefer to create users manually in Firebase Console:

**Users to Create:**
- **Adult User** (age 25+): `adult_25`
- **Teen User** (age 15): `teen_15` with parent `parent_40`
- **Child User** (age 10): `child_10` with parent `parent_40`
- **Parent User** (age 40): `parent_40`

## 🧭 Manual Testing Scenarios

### Scenario 1: Adult User (No Restrictions) ✅
**Expected**: Adult can create any session with no approval prompts

1. **Login** as adult user (age 25+)
2. **Navigate** to game selection
3. **Select** "Mature Shooter" (minAge: 18)
4. **Create** virtual session
5. **Expected Result**:
   - ✅ Session created immediately
   - ✅ No parent approval required
   - ✅ Badge shows "🟢 Available"

### Scenario 2: Child User (Blocked Content) 🔴
**Expected**: Child blocked from inappropriate games

1. **Login** as child user (age 10)
2. **Navigate** to game selection
3. **Try to select** "Mature Shooter" (minAge: 18)
4. **Expected Result**:
   - ❌ Game should be hidden or show "🔴 Restricted"
   - 🔒 Cannot create session
   - 📱 Parent approval required message

### Scenario 3: Teen with Parent Override 🟡➡️🟢
**Expected**: Teen needs approval, then succeeds

1. **Login** as teen user (age 15)
2. **Navigate** to game selection
3. **Select** "Fortnite" (minAge: 13) - should work
4. **Try to select** "Mature Shooter" (minAge: 18)
5. **Expected Result**:
   - 🟡 Badge shows "🟡 Needs Approval"
   - 📱 Parent gets notification/approval request
   - ✅ After parent approval: Session created successfully

### Scenario 4: Age-Appropriate Content 🟢
**Expected**: Teens can play age-appropriate games

1. **Login** as teen user (age 15)
2. **Select** "Minecraft" (minAge: 8)
3. **Expected Result**:
   - ✅ Session created (may still need parent approval depending on COPPA settings)
   - 🟢 Badge shows "🟢 Available" or "🟡 Needs Approval"

## 🔍 Detailed Validation Checklist

### ✅ Age Enforcement
- [ ] Adults (18+) can access all games
- [ ] Teens (13-17) are restricted from 18+ games without approval
- [ ] Children (<13) are restricted from 13+ games without approval
- [ ] COPPA compliance enforced for children under 13

### ✅ Parent Approval Workflow
- [ ] Parent receives notification when child/teen creates session
- [ ] Parent can approve/deny sessions
- [ ] Approved sessions become active
- [ ] Denied sessions are cancelled
- [ ] Parent preferences are respected

### ✅ UI/UX Validation
- [ ] Game availability badges show correct status
- [ ] Clear messaging explains restrictions
- [ ] Approval flow is intuitive
- [ ] Error messages are helpful
- [ ] Loading states work correctly

### ✅ Safety Systems
- [ ] Content flagging works for inappropriate content
- [ ] Admin review required for flagged content
- [ ] Analytics events are logged correctly
- [ ] Safety flags prevent access to problematic content

### ✅ Data Integrity
- [ ] Session data is saved correctly
- [ ] Parent approval status is tracked
- [ ] User age data is validated
- [ ] Game age restrictions are enforced

## 📊 Analytics Verification

Check Firebase Console > Analytics for these events:

### Expected Events
- `playtime_session_create_attempt` - Every creation attempt
- `playtime_age_restriction_violation` - When blocked by age
- `playtime_parent_approval` - When parent approves/denies
- `playtime_safety_flag` - When content is flagged
- `playtime_game_usage` - When games are selected/played

### Event Properties to Verify
- User age and ID
- Game ID and minAge
- Session type (virtual/live)
- Approval status
- Safety flags

## 🐛 Common Issues & Solutions

### Issue: Games not showing correct availability badges
**Solution**: Check that user age data is correctly set in Firestore

### Issue: Parent approval not working
**Solution**: Verify parent-child relationship in users collection

### Issue: Age restrictions not enforced
**Solution**: Ensure game minAge is set correctly in playtime_games collection

### Issue: Analytics not logging
**Solution**: Check PlaytimeAnalyticsService configuration and permissions

### Issue: Safety flags not working
**Solution**: Verify PlaytimeSafetyFlags model and admin approval workflow

## 📱 Mobile Testing

### iOS Safari
- Test parent approval flow
- Verify badge display
- Check responsive design

### Android Chrome
- Test session creation
- Verify age restrictions
- Check analytics logging

## 🌐 Browser Testing

### Chrome
- Test all scenarios
- Check DevTools for errors
- Verify analytics events

### Firefox
- Test session creation
- Verify age enforcement
- Check badge display

### Safari
- Test parent approval
- Verify COPPA compliance
- Check responsive design

## 🔧 Debugging Tips

### Firestore Rules Testing
```bash
# Test rules locally
firebase emulators:start --only firestore
# Then test your rules in the emulator UI
```

### Analytics Debugging
```javascript
// In browser console
console.log('Analytics events:', window.analyticsEvents);
```

### Age Validation Testing
```javascript
// Test COPPA service directly
import { COPPAService } from './lib/services/coppa_service.dart';
console.log('Is adult:', COPPAService.isAdult(25));
console.log('Is subject to COPPA:', COPPAService.isSubjectToCOPPA(10));
```

## 📈 Performance Testing

### Load Testing
- Create 100+ sessions simultaneously
- Test with multiple concurrent users
- Verify Firestore performance

### Memory Testing
- Monitor memory usage during long sessions
- Check for memory leaks in analytics
- Verify cleanup of completed sessions

## 🎯 Success Criteria

### ✅ All age categories work correctly
- Adults: No restrictions
- Teens: Age-appropriate games OK, restricted games need approval
- Children: Everything needs parent approval

### ✅ Parent controls are respected
- Override settings work
- Blocked games are enforced
- Approval workflow functions

### ✅ Safety systems active
- Content flagging works
- Admin review required for flagged content
- Analytics events logged

### ✅ UI provides clear feedback
- Badges show correct status
- Messages explain restrictions
- Approval flow is clear

## 📞 Support

If you encounter issues:

1. **Check Firebase Console** for errors
2. **Review Firestore Rules** for permission issues
3. **Verify Analytics Events** in Firebase Console
4. **Test with Emulator** to isolate issues
5. **Check Browser Console** for JavaScript errors

## 🚀 Next Steps

After successful staging testing:

1. **Deploy to Production** with same validation
2. **Set up Monitoring** for real-world usage
3. **Configure Alerts** for safety violations
4. **Plan User Training** for parents and admins
5. **Document Best Practices** for content moderation
