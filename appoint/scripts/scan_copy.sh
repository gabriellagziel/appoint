#!/usr/bin/env bash
set -e

echo "🔍 Scanning for WhatsApp-only copy..."

# Search for WhatsApp references that aren't followed by comma, space, or end of line
# This catches standalone "WhatsApp" mentions that should be universal
found_issues=false

while IFS=: read -r file line_number content; do
    if [[ -n "$file" && -n "$line_number" && -n "$content" ]]; then
        echo "❌ REVIEW: $file:$line_number - $content"
        found_issues=true
    fi
done < <(rg -n "WhatsApp(?!,| |$)" appoint/lib || true)

if [[ "$found_issues" == "true" ]]; then
    echo ""
    echo "🚨 Found WhatsApp-only copy that needs to be made universal!"
    echo "Please update these references to be platform-agnostic."
    echo "Examples:"
    echo "  - 'WhatsApp' → 'messaging app'"
    echo "  - 'WhatsApp group' → 'group chat'"
    echo "  - 'WhatsApp message' → 'message'"
    exit 1
else
    echo "✅ No WhatsApp-only copy found. All references are universal!"
fi
