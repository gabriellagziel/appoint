#!/bin/bash
echo "🔗 LINK VALIDATION SCRIPT STARTING..."
echo "========================================="
REPORT_FILE="link_validation_report_$(date +%Y%m%d_%H%M%S).txt"
echo "Checking HTML files for broken links..."
find . -name "*.html" | grep -v node_modules | while read file; do
    echo "Checking: $file"
    grep -o "href=[\"'][^\"']*[\"']" "$file" 2>/dev/null | sed "s/href=[\"']//g" | sed "s/[\"']//g" | while read link; do
        if [[ $link != http* ]] && [[ $link != mailto:* ]] && [[ $link != tel:* ]]; then
            if [ ! -f "$link" ] && [ ! -d "$link" ]; then
                echo "BROKEN LINK: $file -> $link" >> "$REPORT_FILE"
            fi
        fi
    done
done
echo "Checking Dart files for broken imports..."
find . -name "*.dart" | grep -v node_modules | while read file; do
    grep "^import" "$file" 2>/dev/null | while read import; do
        module=$(echo "$import" | sed "s/import //g" | sed "s/['\"].*//g")
        if [[ $module != package:* ]] && [[ $module != dart:* ]]; then
            module_file="${module}.dart"
            if [ ! -f "$module_file" ]; then
                echo "BROKEN IMPORT: $file -> $module" >> "$REPORT_FILE"
            fi
        fi
    done
done
echo "✅ LINK VALIDATION COMPLETE!"
echo "📊 Report saved to: $REPORT_FILE"
