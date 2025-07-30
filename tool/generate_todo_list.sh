#!/bin/bash

# Generate TODO list for translations
# This script creates a comprehensive list of all TODO items in ARB files

set -e

L10N_DIR="lib/l10n"
OUTPUT_FILE="todo_list.txt"
REPORT_FILE="translation_report.md"

echo "🔍 Generating translation TODO list..."

# Create the TODO list
echo "# Translation TODO List" > "$OUTPUT_FILE"
echo "Generated on: $(date)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Count total TODO items
total_todos=$(grep -c "TODO:" "$L10N_DIR"/app_*.arb | awk -F: '{sum += $2} END {print sum}')
echo "Total TODO items found: $total_todos" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Generate detailed TODO list by locale
for arb_file in "$L10N_DIR"/app_*.arb; do
    locale=$(basename "$arb_file" .arb | sed 's/app_//')
    
    if [ "$locale" = "en" ]; then
        continue  # Skip English as it's the source
    fi
    
    echo "## $locale" >> "$OUTPUT_FILE"
    
    # Extract TODO items for this locale
    grep "TODO:" "$arb_file" | while read -r line; do
        # Extract key and English text using a more robust approach
        if [[ $line =~ \"([^\"]+)\":\ \"TODO:\ ([^\"]+)\" ]]; then
            key="${BASH_REMATCH[1]}"
            english_text="${BASH_REMATCH[2]}"
            echo "- **$key**: $english_text" >> "$OUTPUT_FILE"
        fi
    done
    
    echo "" >> "$OUTPUT_FILE"
done

# Create a summary report
echo "# Translation Progress Report" > "$REPORT_FILE"
echo "Generated on: $(date)" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "## Summary" >> "$REPORT_FILE"
echo "- Total locales: 32" >> "$REPORT_FILE"
echo "- Total TODO items: $total_todos" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "## Progress by Locale" >> "$REPORT_FILE"
echo "| Locale | TODO Count | Status |" >> "$REPORT_FILE"
echo "|--------|------------|--------|" >> "$REPORT_FILE"

for arb_file in "$L10N_DIR"/app_*.arb; do
    locale=$(basename "$arb_file" .arb | sed 's/app_//')
    todo_count=$(grep -c "TODO:" "$arb_file" || echo "0")
    
    if [ "$locale" = "en" ]; then
        status="✅ Source"
    elif [ "$todo_count" -eq 0 ]; then
        status="✅ Complete"
    elif [ "$todo_count" -lt 50 ]; then
        status="🟡 In Progress"
    else
        status="🔴 Needs Work"
    fi
    
    echo "| $locale | $todo_count | $status |" >> "$REPORT_FILE"
done

echo "" >> "$REPORT_FILE"
echo "## Next Steps" >> "$REPORT_FILE"
echo "1. Review the TODO list in \`todo_list.txt\`" >> "$REPORT_FILE"
echo "2. Prioritize high-impact strings (UI labels, error messages)" >> "$REPORT_FILE"
echo "3. Work on one locale at a time" >> "$REPORT_FILE"
echo "4. Run \`npm run gen-todos\` to regenerate this list after updates" >> "$REPORT_FILE"

echo "✅ Generated TODO list: $OUTPUT_FILE"
echo "✅ Generated progress report: $REPORT_FILE"
echo "📊 Total TODO items: $total_todos" 