# Personal UI/UX Restore Plan

**Timestamp:** 2025-08-25_233355

## Findings snapshot

- See: tree_scan.txt, git_personal_commits.txt, git_meeting_commits.txt, component_clusters.txt, audit_summary.txt

## CRITICAL DISCOVERY: NO WEB PERSONAL UI EXISTS

**The personal meeting flow UI exists ONLY in Flutter mobile app, not as web React components.**

### What Was Found

✅ **Personal Route Configuration:** `business/vercel.json` routes `personal.app-oint.com` → `/personal/$1`
✅ **Meeting Flow Commits:** Multiple Flutter commits (78627917, 2f9dd6e8, fe7f9496, 83b6f5e4, 13623e90)
✅ **Personal Spec Documentation:** `520fad84` contains detailed personal user subdomain spec
❌ **NO Web React Components:** No personal pages, wizard components, or meeting flow UI found
❌ **NO Personal Route Pages:** `/personal/` route exists but no actual pages serve it

### What This Means

1. **Personal.app-oint.com is configured but broken** - routes to non-existent pages
2. **The "smart personal meeting flow" exists only in Flutter mobile app**
3. **No web-based personal UI can be "restored" because it never existed**
4. **The personal domain is currently serving 404s or redirects**

## RESTORE OPTIONS (Choose One)

### Option 1: Build Web React Components from Scratch

```bash
# Create new personal app structure
mkdir -p business/pages/personal
cd business/pages/personal

# Create personal meeting flow components
touch index.tsx
touch create-meeting.tsx
touch meeting-wizard.tsx
touch availability-picker.tsx
touch slot-selector.tsx

# Would need to implement:
# - Multi-step wizard (Type → Participants → Location → Time → Review)
# - Availability picker with calendar integration
# - Slot selection with conflict detection
# - Meeting creation and confirmation flow
```

### Option 2: Convert Flutter Web to React Components

```bash
# Extract Flutter meeting flow logic from commits:
git show 78627917:appoint/lib/features/meeting/create_flow/create_meeting_flow_screen.dart
git show 78627917:appoint/lib/features/meeting/create_flow/flow_maps/meeting_type_to_steps.dart

# Convert to React:
# - Flutter stepper → React multi-step form
# - Flutter state management → React hooks/context
# - Flutter UI components → React components with Tailwind
```

### Option 3: Use Flutter Web Build for Personal Domain

```bash
# Build Flutter web version
cd appoint
flutter build web

# Deploy to personal.app-oint.com
# Update business/vercel.json to serve Flutter web build
```

## RECOMMENDED APPROACH: Option 1 (Build from Scratch)

**Why:** Most reliable, modern web stack, consistent with existing business/enterprise apps

**Implementation Steps:**

1. **Create Personal App Structure:**

   ```bash
   cd business
   mkdir -p pages/personal components/personal
   ```

2. **Build Core Components:**
   - Meeting Type Selector (oneOnOne, group, event, openCall, business, playtime)
   - Multi-step Wizard with progress indicator
   - Availability Calendar with slot picker
   - Participant Management
   - Location/Time Selection
   - Review & Confirmation

3. **Integrate with Existing:**
   - Use existing design system (shadcn/ui, Tailwind)
   - Follow business app patterns
   - Implement proper routing and state management

4. **Update Vercel Configuration:**

   ```json
   // business/vercel.json
   {
     "rewrites": [
       {
         "source": "/personal/(.*)",
         "destination": "/personal/$1"
       }
     ]
   }
   ```

## IMMEDIATE ACTION REQUIRED

**The personal.app-oint.com domain is currently broken and needs immediate attention.**

**Choose your approach and implement the personal meeting flow UI from scratch, as no existing web components exist to restore.**
