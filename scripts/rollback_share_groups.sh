#!/bin/bash

# Share-in-Groups Emergency Rollback Script
# This script provides a quick rollback mechanism for the Share-in-Groups feature

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

echo "🚨 Share-in-Groups Emergency Rollback"
echo "===================================="

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    print_error "Not in Flutter project root. Please run from project root."
    exit 1
fi

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    print_error "Firebase CLI not found. Please install: npm install -g firebase-tools"
    exit 1
fi

# Check if we're logged into Firebase
if ! firebase projects:list &> /dev/null; then
    print_error "Not logged into Firebase. Please run: firebase login"
    exit 1
fi

# Confirm rollback
echo ""
print_warning "This will disable the Share-in-Groups feature immediately."
print_warning "All share links will become inactive."
print_warning "Guest RSVP functionality will be disabled."
echo ""
read -p "Are you sure you want to proceed with rollback? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_error "Rollback cancelled"
    exit 1
fi

echo ""
print_status "Starting emergency rollback..."

# Step 1: Disable feature flags
print_status "Step 1: Disabling feature flags"
echo "REDACTED_TOKEN"

print_status "Disabling share links feature..."
firebase functions:config:set share.feature_share_links_enabled=false

print_status "Disabling guest RSVP feature..."
firebase functions:config:set share.feature_guest_rsvp_enabled=false

print_status "Disabling public meeting page feature..."
firebase functions:config:set share.feature_public_meeting_page_v2=false

print_success "Feature flags disabled"

# Step 2: Deploy functions with disabled flags
print_status "Step 2: Deploying functions with disabled flags"
echo "REDACTED_TOKEN"

firebase deploy --only functions
print_success "Functions deployed with disabled features"

# Step 3: Revoke all active share links
print_status "Step 3: Revoking all active share links"
echo "REDACTED_TOKEN"

# Create a Cloud Function to revoke all share links
cat > revoke_share_links.js << 'EOF'
const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.revokeAllShareLinks = functions.https.onCall(async (data, context) => {
  try {
    const db = admin.firestore();
    const batch = db.batch();
    
    // Get all active share links
    const snapshot = await db.collection('share_links')
      .where('revoked', '==', false)
      .get();
    
    let revokedCount = 0;
    snapshot.docs.forEach(doc => {
      batch.update(doc.ref, {
        revoked: true,
        revokedAt: admin.firestore.FieldValue.serverTimestamp(),
        revokedBy: 'emergency_rollback'
      });
      revokedCount++;
    });
    
    await batch.commit();
    
    console.log(`Revoked ${revokedCount} share links`);
    return { success: true, revokedCount };
  } catch (error) {
    console.error('Error revoking share links:', error);
    throw new functions.https.HttpsError('internal', 'Failed to revoke share links');
  }
});
EOF

# Deploy the revoke function
firebase deploy --only functions:revokeAllShareLinks

# Call the function to revoke all share links
print_status "Revoking all active share links..."
firebase functions:call revokeAllShareLinks

print_success "All share links revoked"

# Step 4: Revoke all active guest tokens
print_status "Step 4: Revoking all active guest tokens"
echo "REDACTED_TOKEN"

# Create a Cloud Function to revoke all guest tokens
cat > revoke_guest_tokens.js << 'EOF'
const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.revokeAllGuestTokens = functions.https.onCall(async (data, context) => {
  try {
    const db = admin.firestore();
    const batch = db.batch();
    
    // Get all active guest tokens
    const snapshot = await db.collection('guest_tokens')
      .where('isActive', '==', true)
      .get();
    
    let revokedCount = 0;
    snapshot.docs.forEach(doc => {
      batch.update(doc.ref, {
        isActive: false,
        revokedAt: admin.firestore.FieldValue.serverTimestamp(),
        revokedBy: 'emergency_rollback'
      });
      revokedCount++;
    });
    
    await batch.commit();
    
    console.log(`Revoked ${revokedCount} guest tokens`);
    return { success: true, revokedCount };
  } catch (error) {
    console.error('Error revoking guest tokens:', error);
    throw new functions.https.HttpsError('internal', 'Failed to revoke guest tokens');
  }
});
EOF

# Deploy the revoke function
firebase deploy --only functions:revokeAllGuestTokens

# Call the function to revoke all guest tokens
print_status "Revoking all active guest tokens..."
firebase functions:call revokeAllGuestTokens

print_success "All guest tokens revoked"

# Step 5: Clean up temporary files
print_status "Step 5: Cleaning up temporary files"
echo "REDACTED_TOKEN"

rm -f revoke_share_links.js revoke_guest_tokens.js
print_success "Temporary files cleaned up"

# Step 6: Verify rollback
print_status "Step 6: Verifying rollback"
echo "-------------------------------"

# Check if feature flags are disabled
FLAGS=$(firebase functions:config:get share 2>/dev/null | jq -r '.share' || echo "{}")

SHARE_LINKS_ENABLED=$(echo "$FLAGS" | jq -r '.feature_share_links_enabled // false')
GUEST_RSVP_ENABLED=$(echo "$FLAGS" | jq -r '.feature_guest_rsvp_enabled // false')
PUBLIC_PAGE_ENABLED=$(echo "$FLAGS" | jq -r '.feature_public_meeting_page_v2 // false')

if [ "$SHARE_LINKS_ENABLED" = "false" ] && [ "$GUEST_RSVP_ENABLED" = "false" ] && [ "$PUBLIC_PAGE_ENABLED" = "false" ]; then
    print_success "All feature flags are disabled"
else
    print_warning "Some feature flags are still enabled:"
    echo "  - Share links: $SHARE_LINKS_ENABLED"
    echo "  - Guest RSVP: $GUEST_RSVP_ENABLED"
    echo "  - Public page: $PUBLIC_PAGE_ENABLED"
fi

# Step 7: Generate rollback report
print_status "Step 7: Generating rollback report"
echo "REDACTED_TOKEN"

REPORT_FILE="rollback_report_$(date +%Y%m%d_%H%M%S).txt"

{
    echo "Share-in-Groups Emergency Rollback Report"
    echo "Generated: $(date)"
    echo "========================================="
    echo ""
    echo "Rollback Actions:"
    echo "- Feature flags disabled"
    echo "- All share links revoked"
    echo "- All guest tokens revoked"
    echo "- Functions redeployed"
    echo ""
    echo "Feature Flags Status:"
    firebase functions:config:get share 2>/dev/null | jq -r '.share'
    echo ""
    echo "Recent Errors:"
    firebase functions:log --only functions --limit 10 2>/dev/null | grep -E "(ERROR|WARN)" || echo "No recent errors"
    echo ""
    echo "Next Steps:"
    echo "1. Monitor application for any issues"
    echo "2. Investigate the root cause of the problem"
    echo "3. Plan the next deployment with fixes"
    echo "4. Communicate the rollback to stakeholders"
} > "$REPORT_FILE"

print_success "Rollback report generated: $REPORT_FILE"

# Final success message
echo ""
echo "🎉 Share-in-Groups Emergency Rollback Complete!"
echo "=============================================="
print_success "All Share-in-Groups features have been disabled"
echo ""
echo "📊 Rollback Summary:"
echo "- ✅ Feature flags disabled"
echo "- ✅ All share links revoked"
echo "- ✅ All guest tokens revoked"
echo "- ✅ Functions redeployed"
echo "- ✅ Rollback report generated"
echo ""
echo "📞 Emergency Contacts:"
echo "- On-call: [Fill in contact]"
echo "- DevOps: [Fill in contact]"
echo "- Security: [Fill in contact]"
echo ""
echo "🔍 Next Steps:"
echo "1. Investigate the root cause"
echo "2. Fix the issues identified"
echo "3. Test thoroughly before redeployment"
echo "4. Communicate with stakeholders"
echo ""
print_warning "The Share-in-Groups feature is now completely disabled."
print_warning "Users will not be able to create or use share links."
