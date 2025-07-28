#!/bin/bash

echo "🚀 בדיקה מהירה במיוחד"
echo "====================="

# בדיקות מיידיות בלבד
start_time=$(date +%s)

# Flutter זמין?
flutter --version > /dev/null 2>&1 && echo "✅ Flutter" || echo "❌ Flutter"

# קבצים בסיסיים?
[ -f "pubspec.yaml" ] && echo "✅ pubspec.yaml" || echo "❌ pubspec.yaml"
[ -d "lib" ] && echo "✅ lib/" || echo "❌ lib/"
[ -d "test" ] && echo "✅ test/" || echo "❌ test/"

# ספירה מהירה
if [ -d "test" ]; then
    test_count=$(find test/ -name "*.dart" | wc -l)
    echo "📊 $test_count קבצי טסט"
fi

if [ -d "lib" ]; then
    lib_count=$(find lib/ -name "*.dart" | wc -l)
    echo "📊 $lib_count קבצי קוד"
fi

# בדיקת תלויות בלי עדכון
if [ -f "pubspec.lock" ]; then
    echo "✅ תלויות כבר מותקנות"
else
    echo "⚠️ תלויות לא מותקנות"
fi

# בדיקת git
if [ -d ".git" ]; then
    echo "✅ Git repository"
    branch=$(git branch --show-current 2>/dev/null)
    [ ! -z "$branch" ] && echo "🌿 ענף: $branch"
fi

end_time=$(date +%s)
duration=$((end_time - start_time))
echo ""
echo "⏱️ הושלם תוך $duration שניות"
echo ""
echo "לבדיקה מעמיקה (איטית): ./check_workspace_health.sh"
echo "לבדיקה בינונית: ./quick_health_check.sh"