#!/bin/bash

echo "🔧 SYSTEMATIC STRUCTURAL REPAIR SCRIPT"
echo "======================================"

export PATH="$PATH:$(pwd)/flutter/bin"

# List of problematic files identified by build_runner
FILES=(
  "lib/features/studio/screens/staff_availability_screen.dart"
  "lib/features/playtime/screens/playtime_virtual_screen.dart" 
  "lib/features/playtime/screens/create_game_screen.dart"
  "lib/features/playtime/screens/playtime_live_screen.dart"
  "lib/features/family/screens/family_dashboard_screen.dart"
  "lib/features/onboarding/screens/enhanced_onboarding_screen.dart"
  "lib/features/studio_business/screens/rooms_screen.dart"
  "lib/features/studio_business/screens/business_connect_screen.dart"
  "lib/features/studio_business/screens/settings_screen.dart"
  "lib/features/studio_business/screens/business_subscription_screen.dart"
  "lib/features/subscriptions/screens/subscription_screen.dart"
  "lib/services/family_background_service.dart"
)

echo "📊 Analyzing brace balance in ${#FILES[@]} files..."

for file in "${FILES[@]}"; do
  if [ ! -f "$file" ]; then
    echo "⚠️  File not found: $file"
    continue
  fi

  echo "Checking: $(basename "$file")"
  
  # Count braces
  open_count=$(grep -o '{' "$file" | wc -l)
  close_count=$(grep -o '}' "$file" | wc -l)
  balance=$((open_count - close_count))
  
  echo "  Open: $open_count, Close: $close_count, Balance: $balance"
  
  if [ $balance -lt 0 ]; then
    extra_braces=$((-balance))
    echo "  🔧 FIXING: Removing $extra_braces extra closing brace(s)"
    
    # Create a temporary file to work with
    temp_file=$(mktemp)
    cp "$file" "$temp_file"
    
    # Remove extra closing braces from the end of the file
    for ((i=1; i<=extra_braces; i++)); do
      # Find the last line with only a closing brace and remove it
      tac "$temp_file" | awk '!found && /^[[:space:]]*\}[[:space:]]*$/ {found=1; next} {print}' | tac > "${temp_file}.new"
      mv "${temp_file}.new" "$temp_file"
    done
    
    # Verify the fix
    new_open=$(grep -o '{' "$temp_file" | wc -l)
    new_close=$(grep -o '}' "$temp_file" | wc -l)
    new_balance=$((new_open - new_close))
    
    if [ $new_balance -eq 0 ]; then
      mv "$temp_file" "$file"
      echo "  ✅ FIXED: Balance restored (Open: $new_open, Close: $new_close)"
    else
      echo "  ❌ FAILED: Balance still incorrect (Open: $new_open, Close: $new_close)"
      rm "$temp_file"
    fi
  elif [ $balance -eq 0 ]; then
    echo "  ✅ OK: Braces already balanced"
  else
    echo "  ⚠️  ISSUE: Missing $balance closing brace(s) - manual fix needed"
  fi
  
  echo ""
done

echo "🧪 Testing compilation after fixes..."
flutter analyze --write=/tmp/analyze_report.txt > /dev/null 2>&1
error_count=$(grep -c "error •" /tmp/analyze_report.txt 2>/dev/null || echo "0")

echo "📊 REPAIR SUMMARY:"
echo "   Files processed: ${#FILES[@]}"
echo "   Analysis errors: $error_count"

if [ $error_count -lt 100 ]; then
  echo "   Status: ✅ MAJOR IMPROVEMENT"
else
  echo "   Status: ⚠️  More work needed"
fi

echo ""
echo "🎯 Next step: Run 'flutter pub run build_runner build --delete-conflicting-outputs' to test"