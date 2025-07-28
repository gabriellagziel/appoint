#!/bin/bash

echo "⚡ בדיקת בריאות מהירה - APP-OINT"
echo "================================="
echo ""

# בדיקות בסיסיות
echo "🔧 בדיקות בסיסיות..."

# Flutter
if command -v flutter &> /dev/null; then
    echo "✅ Flutter מותקן"
else
    echo "❌ Flutter לא מותקן"
    exit 1
fi

# pubspec.yaml
if [ -f "pubspec.yaml" ]; then
    echo "✅ pubspec.yaml נמצא"
else
    echo "❌ pubspec.yaml לא נמצא"
    exit 1
fi

# תיקיית lib
if [ -d "lib" ]; then
    echo "✅ תיקיית lib נמצאה"
else
    echo "❌ תיקיית lib לא נמצאה"
fi

# תיקיית test
if [ -d "test" ]; then
    test_count=$(find test/ -name "*.dart" | wc -l)
    echo "✅ תיקיית test נמצאה עם $test_count קבצי טסט"
else
    echo "⚠️ תיקיית test לא נמצאה"
fi

echo ""
echo "📦 בודק תלויות..."
flutter pub get --no-precompile > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ תלויות בסדר"
else
    echo "⚠️ יש בעיה עם התלויות"
fi

echo ""
echo "🔍 ניתוח קוד מהיר..."
flutter analyze --no-fatal-infos > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ קוד נקי"
else
    echo "⚠️ יש שגיאות בקוד"
fi

echo ""
echo "🧪 טסט מהיר..."
if [ -f "test/smoke_test.dart" ]; then
    flutter test test/smoke_test.dart > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "✅ טסט בסיסי עבר"
    else
        echo "⚠️ טסט בסיסי נכשל"
    fi
else
    echo "ℹ️ אין טסט smoke"
fi

echo ""
echo "✨ בדיקה מהירה הושלמה!"
echo "להרצת בדיקה מלאה הרץ: ./check_workspace_health.sh"