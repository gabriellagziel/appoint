#!/bin/bash

echo "🔍 בדיקת בריאות סביבת העבודה - APP-OINT"
echo "=========================================="
echo ""

# בדיקת Flutter
echo "📱 בדיקת Flutter..."
if command -v flutter &> /dev/null; then
    echo "✅ Flutter מותקן"
    flutter --version
    echo ""
    echo "🏥 Flutter Doctor:"
    flutter doctor -v
else
    echo "❌ Flutter לא מותקן"
fi

echo ""
echo "=========================================="

# בדיקת Dart
echo "🎯 בדיקת Dart..."
if command -v dart &> /dev/null; then
    echo "✅ Dart מותקן"
    dart --version
else
    echo "❌ Dart לא מותקן"
fi

echo ""
echo "=========================================="

# בדיקת תלויות הפרויקט
echo "📦 בדיקת תלויות הפרויקט..."
if [ -f "pubspec.yaml" ]; then
    echo "✅ pubspec.yaml נמצא"
    echo "🔄 מנסה לעדכן תלויות..."
    flutter pub get
    if [ $? -eq 0 ]; then
        echo "✅ תלויות עודכנו בהצלחה"
    else
        echo "⚠️ יש בעיה עם התלויות"
    fi
else
    echo "❌ pubspec.yaml לא נמצא - האם אתה בתיקיית הפרויקט הנכונה?"
fi

echo ""
echo "=========================================="

# בדיקת ניתוח קוד
echo "🔍 ניתוח קוד סטטי..."
flutter analyze
if [ $? -eq 0 ]; then
    echo "✅ ניתוח הקוד עבר בהצלחה"
else
    echo "⚠️ נמצאו בעיות בניתוח הקוד"
fi

echo ""
echo "=========================================="

# בדיקת טסטים
echo "🧪 הרצת טסטים..."
if [ -d "test" ]; then
    echo "✅ תיקיית test נמצאה"
    test_count=$(find test/ -name "*.dart" | wc -l)
    echo "📊 נמצאו $test_count קבצי טסט"
    
    echo "🏃‍♂️ מריץ טסטים..."
    flutter test
    if [ $? -eq 0 ]; then
        echo "✅ כל הטסטים עברו בהצלחה"
    else
        echo "⚠️ חלק מהטסטים נכשלו"
    fi
else
    echo "❌ תיקיית test לא נמצאה"
fi

echo ""
echo "=========================================="

# בדיקת build
echo "🏗️ בדיקת build..."
echo "📱 מנסה build לאנדרואיד..."
flutter build apk --debug
if [ $? -eq 0 ]; then
    echo "✅ Build לאנדרואיד הצליח"
else
    echo "⚠️ Build לאנדרואיד נכשל"
fi

echo ""
echo "🌐 מנסה build לוואב..."
flutter build web
if [ $? -eq 0 ]; then
    echo "✅ Build לוואב הצליח"
else
    echo "⚠️ Build לוואב נכשל"
fi

echo ""
echo "=========================================="

# סיכום
echo "📋 סיכום בדיקת בריאות סביבת העבודה"
echo "בדיקה הושלמה! בדוק את התוצאות למעלה."
echo "אם יש בעיות, העתק את התוצאות לצ'אט עם הבוט לקבלת עזרה."
echo ""
echo "תאריך הבדיקה: $(date)"