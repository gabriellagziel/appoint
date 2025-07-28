#!/bin/bash

echo "🎯 הרצת טסטים ספציפיים"
echo "======================"

if [ $# -eq 0 ]; then
    echo "שימוש:"
    echo "./test_specific.sh [smoke|models|services|widgets|all]"
    echo ""
    echo "אפשרויות זמינות:"
    echo "  smoke    - טסט בסיסי מהיר"
    echo "  models   - טסטי מודלים"
    echo "  services - טסטי שירותים"
    echo "  widgets  - טסטי UI"
    echo "  unit     - כל הטסטים היחידה"
    echo "  all      - כל הטסטים"
    exit 1
fi

case $1 in
    "smoke")
        echo "🚀 הרצת טסט smoke..."
        if [ -f "test/smoke_test.dart" ]; then
            flutter test test/smoke_test.dart
        else
            echo "⚠️ קובץ smoke_test.dart לא נמצא"
        fi
        ;;
    
    "models")
        echo "📦 הרצת טסטי מודלים..."
        flutter test test/models/
        ;;
    
    "services")
        echo "🔧 הרצת טסטי שירותים..."
        flutter test test/services/
        ;;
    
    "widgets")
        echo "🎨 הרצת טסטי UI..."
        flutter test test/widgets/ test/ui/
        ;;
    
    "unit")
        echo "🧪 הרצת טסטי יחידה..."
        flutter test test/ --exclude-tags=integration
        ;;
    
    "all")
        echo "🏃‍♂️ הרצת כל הטסטים..."
        flutter test
        ;;
    
    *)
        echo "❌ אפשרות לא מוכרת: $1"
        echo "אפשרויות זמינות: smoke, models, services, widgets, unit, all"
        exit 1
        ;;
esac