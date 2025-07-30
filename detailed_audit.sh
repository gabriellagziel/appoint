#!/bin/bash

# 🔍 Audit מפורט של קובצי השפה

cd lib/l10n

reference_file="app_en.arb"

echo "🔍 Audit מפורט של קובצי השפה..."
echo ""

# בדוק מפתחות חסרים ספציפיים
echo "📋 מפתחות חסרים בכל קובץ:"
echo ""

for file in app_*.arb; do
    [[ "$file" == "$reference_file" ]] && continue
    [[ "$file" == "app_en.arb.bak" ]] && continue
    
    missing_keys=$(comm -23 \
        <(grep '^  "' "$reference_file" | cut -d'"' -f2 | sort) \
        <(grep '^  "' "$file" | cut -d'"' -f2 | sort) 2>/dev/null)
    
    if [ ! -z "$missing_keys" ]; then
        echo "🔴 $file - מפתחות חסרים:"
        echo "$missing_keys" | sed 's/^/  • /'
        echo ""
    fi
done

# בדוק קבצים עם תרגומים באנגלית
echo "📝 קבצים עם תרגומים באנגלית:"
echo ""

for file in app_*.arb; do
    [[ "$file" == "$reference_file" ]] && continue
    [[ "$file" == "app_en.arb.bak" ]] && continue
    
    untranslated=$(grep -E '^  "[^"]*": "[A-Za-z0-9 ,.!?\"'\''()\-]+",?$' "$file")
    
    if [ ! -z "$untranslated" ]; then
        count=$(echo "$untranslated" | wc -l)
        echo "🔴 $file - $count שורות באנגלית:"
        echo "$untranslated" | head -3 | sed 's/^/  • /'
        if [ $count -gt 3 ]; then
            echo "  ... ועוד $((count - 3)) שורות"
        fi
        echo ""
    fi
done

# בדוק קבצים עם ערכים זהים לאנגלית
echo "🔄 קבצים עם ערכים זהים לאנגלית:"
echo ""

for file in app_*.arb; do
    [[ "$file" == "$reference_file" ]] && continue
    [[ "$file" == "app_en.arb.bak" ]] && continue
    
    identical_count=$(comm -12 \
        <(grep '^  "' "$reference_file" | sed 's/^  "\([^"]*\)": "\([^"]*\)".*/\1: \2/') \
        <(grep '^  "' "$file" | sed 's/^  "\([^"]*\)": "\([^"]*\)".*/\1: \2/') 2>/dev/null | wc -l)
    
    if [ $identical_count -gt 0 ]; then
        echo "🟡 $file - $identical_count ערכים זהים לאנגלית"
    fi
done

echo ""
echo "✅ Audit מפורט הושלם!" 