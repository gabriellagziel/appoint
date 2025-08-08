# 🧭 Manual QA Guide for Playtime System

## Quick 1-Minute Validation Tests

### Test 1: Adult User (No Restrictions) ✅
**Expected**: Adult can create any session with no approval prompts

1. **Setup**: Set user age to 25 in database
2. **Action**: Try to create virtual session with "Mature Shooter" game
3. **Expected Result**: 
   - ✅ Session created immediately
   - ✅ No parent approval required
   - ✅ Badge shows "🟢 Available"

### Test 2: Child User (Blocked Content) 🔴
**Expected**: Child blocked from inappropriate games

1. **Setup**: Set user age to 10 in database
2. **Action**: Try to create session with "Mature Shooter" (minAge: 18)
3. **Expected Result**:
   - ❌ Session creation blocked
   - 🔴 Badge shows "🔴 Restricted"
   - 🔒 Virtual link stays locked/inaccessible

### Test 3: Teen with Parent Override 🟡➡️🟢
**Expected**: Teen needs approval, then succeeds

1. **Setup**: 
   - Set user age to 15
   - Set parent preference `allowOverrideAgeRestriction: true`
2. **Action**: Try to create session with "Call of Duty" (minAge: 17)
3. **Expected Result**:
   - 🟡 Initial: Badge shows "🟡 Needs Approval"
   - 📱 Parent gets notification/approval request
   - ✅ After approval: Session created successfully

### Test 4: Age-Appropriate Content 🟢
**Expected**: Teens can play age-appropriate games

1. **Setup**: User age 15, game "Among Us" (minAge: 12)
2. **Action**: Create virtual session
3. **Expected Result**:
   - ✅ Session created (may still need parent approval depending on COPPA settings)
   - 🟢 Badge shows "🟢 Available" or "🟡 Needs Approval"

## Detailed Validation Scenarios

### Scenario A: COPPA Compliance (Under 13)
```
User: 10 years old
Game: Minecraft (minAge: 8) - Age appropriate
Expected: Still requires parent approval due to COPPA
```

### Scenario B: Teen Override Testing
```
User: 15 years old
Game: Fortnite (minAge: 13) - Age appropriate
Parent Setting: allowOverrideAgeRestriction = false
Expected: Can play without special approval
```

### Scenario C: Safety Flagging
```
User: Any age
Action: Create session with inappropriate title/description
Expected: Content flagged, requires admin review
```

### Scenario D: Parent Preference Blocks
```
User: 15 years old
Game: Any game in parent's blockedGames list
Expected: Blocked regardless of age appropriateness
```

## UI Badge Reference

| Badge | Icon | Color | Meaning |
|-------|------|-------|---------|
| 🟢 Available | ✅ | Green | Can play immediately |
| 🟡 Needs Approval | ⏳ | Orange | Parent approval required |
| 🔴 Restricted | 🚫 | Red | Cannot play (age/content restricted) |

## Database Setup for Testing

### Users Collection
```json
{
  "adult_25": { "age": 25, "isChild": false, "parentUid": null },
  "teen_15": { "age": 15, "isChild": true, "parentUid": "parent_40" },
  "child_10": { "age": 10, "isChild": true, "parentUid": "parent_40" },
  "parent_40": { "age": 40, "isChild": false }
}
```

### Parent Preferences
```json
{
  "parent_40": {
    "allowOverrideAgeRestriction": true,
    "blockedGames": [],
    "allowedPlatforms": ["PC", "Console", "Mobile"],
    "requirePreApproval": true
  }
}
```

### Test Games
```json
{
  "minecraft": { "minAge": 8, "name": "Minecraft" },
  "fortnite": { "minAge": 13, "name": "Fortnite" },
  "cod": { "minAge": 17, "name": "Call of Duty" },
  "mature_shooter": { "minAge": 18, "name": "Mature Shooter" }
}
```

## Analytics Events to Verify

After each test, check for these logged events:

1. `playtime_session_create_attempt` - Every creation attempt
2. `REDACTED_TOKEN` - When blocked by age
3. `playtime_parent_approval` - When parent approves/denies
4. `playtime_safety_flag` - When content is flagged

## Quick Commands for Testing

```bash
# Run unit tests
flutter test test/e2e/playtime_unit_test.dart

# Start emulator for manual testing
firebase emulators:start --only firestore

# Check analytics in emulator UI
open http://localhost:4000
```

## Success Criteria

✅ **All age categories work correctly**
- Adults: No restrictions
- Teens: Age-appropriate games OK, restricted games need approval
- Children: Everything needs parent approval

✅ **Parent controls are respected**
- Override settings work
- Blocked games are enforced
- Approval workflow functions

✅ **Safety systems active**
- Content flagging works
- Admin review required for flagged content
- Analytics events logged

✅ **UI provides clear feedback**
- Badges show correct status
- Messages explain restrictions
- Approval flow is clear
