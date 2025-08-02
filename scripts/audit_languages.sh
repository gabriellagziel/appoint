#!/bin/bash

# ✅ בצע Audit מלא לקובצי השפה של APP-OINT

cd lib/l10n

# 1. הגדר את הקובץ האנגלי כקובץ רפרנס
reference_file="app_en.arb"

echo "🔍 מתחיל Audit מלא של קובצי השפה..."
echo "📋 קובץ רפרנס: $reference_file"
echo ""

# בדוק שהקובץ האנגלי קיים
if [ ! -f "$reference_file" ]; then
    echo "❌ קובץ הרפרנס $reference_file לא נמצא!"
    exit 1
fi

# ספירת מפתחות בקובץ הרפרנס
expected_keys=$(grep -c '^  "' "$reference_file")
echo "📊 מספר מפתחות בקובץ הרפרנס: $expected_keys"
echo ""

# 2. עבור על כל קובץ שפה אחר ובדוק מה חסר
total_files=0
files_with_issues=0

for file in app_*.arb; do
    [[ "$file" == "$reference_file" ]] && continue
    [[ "$file" == "app_en.arb.bak" ]] && continue
    
    total_files=$((total_files + 1))
    echo "🔎 בודק את $file..."
    
    # ספירת מפתחות
    total_keys=$(grep -c '^  "' "$file")
    
    # מפתחות חסרים
    missing_keys=$(comm -23 \
        <(grep '^  "' "$reference_file" | cut -d'"' -f2 | sort) \
        <(grep '^  "' "$file" | cut -d'"' -f2 | sort) 2>/dev/null)
    
    # בדיקת תרגומים באנגלית (שורות שמכילות רק טקסט באנגלית)
    untranslated=$(grep -E '^  "[^"]*": "[A-Za-z0-9 ,.!?\"'\''()\-]+",?$' "$file" | wc -l)
    
    # בדיקת מפתחות ריקים
    empty_values=$(grep -E '^  "[^"]*": "",?$' "$file" | wc -l)
    
    # בדיקת מפתחות עם ערכים זהים לאנגלית
    identical_to_english=$(comm -12 \
        <(grep '^  "' "$reference_file" | sed 's/^  "\([^"]*\)": "\([^"]*\)".*/\1: \2/') \
        <(grep '^  "' "$file" | sed 's/^  "\([^"]*\)": "\([^"]*\)".*/\1: \2/') 2>/dev/null | wc -l)
    
    echo "📄 $file:"
    echo "  - מפתחות קיימים: $total_keys / $expected_keys"
    echo "  - מפתחות חסרים: $(echo "$missing_keys" | wc -l)"
    echo "  - שורות באנגלית: $untranslated"
    echo "  - ערכים ריקים: $empty_values"
    echo "  - זהים לאנגלית: $identical_to_english"
    
    # הצג מפתחות חסרים אם יש
    if [ ! -z "$missing_keys" ]; then
        echo "  - מפתחות חסרים:"
        echo "$missing_keys" | head -5 | sed 's/^/    • /'
        if [ $(echo "$missing_keys" | wc -l) -gt 5 ]; then
            echo "    ... ועוד $(( $(echo "$missing_keys" | wc -l) - 5 )) מפתחות"
        fi
        files_with_issues=$((files_with_issues + 1))
    fi
    
    echo ""
done

echo "📊 סיכום Audit:"
echo "  - סך הכל קבצים שנבדקו: $total_files"
echo "  - קבצים עם בעיות: $files_with_issues"
echo "  - אחוז השלמות: $(( (total_files - files_with_issues) * 100 / total_files ))%"
echo ""

# בדיקה נוספת - קבצים עם בעיות חמורות
echo "🚨 קבצים עם בעיות חמורות:"
for file in app_*.arb; do
    [[ "$file" == "$reference_file" ]] && continue
    [[ "$file" == "app_en.arb.bak" ]] && continue
    
    total_keys=$(grep -c '^  "' "$file")
    missing_count=$(comm -23 \
        <(grep '^  "' "$reference_file" | cut -d'"' -f2 | sort) \
        <(grep '^  "' "$file" | cut -d'"' -f2 | sort) 2>/dev/null | wc -l)
    
    if [ $missing_count -gt 10 ]; then
        echo "  ⚠️  $file: חסרים $missing_count מפתחות"
    fi
done

echo ""
echo "✅ Audit הושלם!" 