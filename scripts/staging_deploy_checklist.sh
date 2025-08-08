#!/bin/bash

# Staging Deployment Checklist
# Copy/paste these commands to deploy to staging

echo "🚀 Playtime Staging Deployment Checklist"
echo "========================================"

# Set your staging project ID
echo ""
echo "1️⃣ Set your staging project ID:"
echo "export STAGING_PROJECT_ID=\"your-staging-project-id\""
echo "firebase use \$STAGING_PROJECT_ID"
echo ""

# Deploy Firestore rules first (safety net)
echo "2️⃣ Deploy Firestore rules (safety net):"
echo "firebase deploy --only firestore:rules"
echo ""

# Build and deploy hosting
echo "3️⃣ Build and deploy hosting:"
echo "flutter build web --release"
echo "firebase deploy --only hosting"
echo ""

# Seed minimal staging data
echo "4️⃣ Seed minimal staging data:"
echo "firebase firestore:documents:create users/adult_18 '{\"uid\":\"adult_18\",\"age\":18,\"isChild\":false}'"
echo "firebase firestore:documents:create users/teen_15 '{\"uid\":\"teen_15\",\"age\":15,\"isChild\":true,\"parentUid\":\"parent_42\"}'"
echo "firebase firestore:documents:create users/child_10 '{\"uid\":\"child_10\",\"age\":10,\"isChild\":true,\"parentUid\":\"parent_42\"}'"
echo "firebase firestore:documents:create users/parent_42 '{\"uid\":\"parent_42\",\"age\":40,\"isChild\":false}'"
echo "firebase firestore:documents:create playtime_preferences/parent_42 '{\"allowOverrideAgeRestriction\":true}'"
echo "firebase firestore:documents:create playtime_games/minecraft '{\"id\":\"minecraft\",\"name\":\"Minecraft\",\"platform\":\"PC\",\"minAge\":8,\"maxPlayers\":10,\"parentApproved\":true}'"
echo "firebase firestore:documents:create playtime_games/mature_shooter '{\"id\":\"mature_shooter\",\"name\":\"Mature Shooter\",\"platform\":\"Console\",\"minAge\":18,\"maxPlayers\":8,\"parentApproved\":true}'"
echo ""

# Manual browser checks
echo "5️⃣ Manual browser checks (1 min):"
echo "🌐 Open your staging URL: https://\$STAGING_PROJECT_ID.web.app"
echo ""
echo "✅ Adult test:"
echo "   - Login as adult_18"
echo "   - Create virtual + physical with 'Mature Shooter'"
echo "   - Expected: no prompts, session created immediately"
echo ""
echo "🔴 Child test:"
echo "   - Login as child_10"
echo "   - Try to create session with 'Mature Shooter'"
echo "   - Expected: blocked, virtual link locked until parent approval"
echo ""
echo "🟡 Teen test:"
echo "   - Login as teen_15"
echo "   - Try to create session with 'Mature Shooter'"
echo "   - Expected: needs parent approval"
echo "   - Toggle parentApproved: true in Firestore"
echo "   - Confirm session becomes joinable"
echo ""

# Quick test commands
echo "6️⃣ Quick test commands:"
echo "# Kill zombie emulators:"
echo "lsof -i :8080 | awk 'NR>1 {print \$2}' | xargs -r kill -9"
echo "lsof -i :8081 | awk 'NR>1 {print \$2}' | xargs -r kill -9"
echo ""
echo "# Run tests with emulator:"
echo "firebase emulators:start --only firestore &"
echo "flutter test test/e2e/playtime_mock_e2e_test.dart \\"
echo "  --dart-define=FIRESTORE_EMULATOR_HOST=localhost \\"
echo "  --dart-define=FIRESTORE_EMULATOR_PORT=8081"
echo ""

echo "🎉 Deployment checklist complete!"
echo "📋 Follow scripts/staging_test_guide.md for detailed testing"
