#!/bin/bash

# 🔧 סקריפט לתיקון בעיות קריטיות בקובצי השפה

cd lib/l10n

reference_file="app_en.arb"

echo "🔧 מתחיל תיקון בעיות קריטיות בקובצי השפה..."
echo ""

# רשימת הקבצים עם בעיות חמורות
critical_files=("app_fa.arb" "app_ha.arb" "app_hi.arb" "app_ur.arb" "app_zh_Hant.arb")

echo "🚨 קבצים עם בעיות חמורות שדורשים תרגום מחדש:"
echo ""

for file in "${critical_files[@]}"; do
    if [ -f "$file" ]; then
        # ספירת שורות באנגלית
        english_lines=$(grep -E '^  "[^"]*": "[A-Za-z0-9 ,.!?\"'\''()\-]+",?$' "$file" | wc -l)
        
        # ספירת ערכים זהים לאנגלית
        identical_count=$(comm -12 \
            <(grep '^  "' "$reference_file" | sed 's/^  "\([^"]*\)": "\([^"]*\)".*/\1: \2/') \
            <(grep '^  "' "$file" | sed 's/^  "\([^"]*\)": "\([^"]*\)".*/\1: \2/') 2>/dev/null | wc -l)
        
        echo "📄 $file:"
        echo "  - שורות באנגלית: $english_lines"
        echo "  - ערכים זהים לאנגלית: $identical_count"
        echo "  - אחוז תרגום: $(( (381 - english_lines) * 100 / 381 ))%"
        echo ""
    fi
done

echo "📋 דוגמאות לשורות שדורשות תרגום:"
echo ""

# הצג דוגמאות מהקובץ הראשון עם בעיות
if [ -f "app_fa.arb" ]; then
    echo "🔍 דוגמאות מ-app_fa.arb (פרסית):"
    grep -E '^  "[^"]*": "[A-Za-z0-9 ,.!?\"'\''()\-]+",?$' "app_fa.arb" | head -10 | sed 's/^/  • /'
    echo ""
fi

if [ -f "app_hi.arb" ]; then
    echo "🔍 דוגמאות מ-app_hi.arb (הינדי):"
    grep -E '^  "[^"]*": "[A-Za-z0-9 ,.!?\"'\''()\-]+",?$' "app_hi.arb" | head -10 | sed 's/^/  • /'
    echo ""
fi

echo "💡 המלצות לתיקון:"
echo ""
echo "1. 🔴 עדיפות גבוהה - תרגום מחדש:"
echo "   - app_fa.arb (פרסית) - 134 שורות באנגלית"
echo "   - app_ha.arb (האוסה) - 150 שורות באנגלית"
echo "   - app_hi.arb (הינדי) - 134 שורות באנגלית"
echo "   - app_ur.arb (אורדו) - 134 שורות באנגלית"
echo "   - app_zh_Hant.arb (סינית מסורתית) - 133 שורות באנגלית"
echo ""
echo "2. 🟡 עדיפות בינונית - בדיקה ותיקון:"
echo "   - קבצים עם 10-50 שורות באנגלית"
echo ""
echo "3. 🟢 עדיפות נמוכה - בדיקה קלה:"
echo "   - קבצים עם 1-5 שורות באנגלית (רובם רק locale)"
echo ""

echo "📝 הוראות לתיקון:"
echo "1. פתח את הקובץ הבעייתי בעורך טקסט"
echo "2. חפש שורות שמכילות טקסט באנגלית בלבד"
echo "3. תרגם את הטקסט לשפת היעד"
echo "4. שמור את הקובץ"
echo "5. הרץ שוב את סקריפט ה-Audit לבדיקה"
echo ""

echo "✅ סקריפט התיקון הושלם!" 