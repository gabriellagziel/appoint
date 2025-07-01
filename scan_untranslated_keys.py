#!/usr/bin/env python3
import json
import os
from pathlib import Path

def extract_keys_from_arb(file_path):
    """Extract translation keys from an ARB file."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Parse JSON
        data = json.loads(content)
        
        # Extract keys (excluding metadata keys that start with @)
        keys = {}
        for key, value in data.items():
            if not key.startswith('@') and key != '@@locale':
                keys[key] = value
        
        return keys
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        return {}

def scan_untranslated_keys():
    """Scan all ARB files and identify untranslated keys."""
    l10n_dir = Path("lib/l10n")
    english_arb = l10n_dir / "app_en.arb"
    
    # Get English keys as reference
    english_keys = extract_keys_from_arb(english_arb)
    print(f"English ARB has {len(english_keys)} keys")
    
    # Get all ARB files (excluding backup and English)
    arb_files = []
    for arb_file in l10n_dir.glob("app_*.arb"):
        if arb_file.name != "app_en.arb" and "backup" not in str(arb_file):
            arb_files.append(arb_file)
    
    print(f"Found {len(arb_files)} ARB files to analyze")
    
    # Results storage
    all_untranslated = []
    
    for arb_file in sorted(arb_files):
        locale = arb_file.stem.replace("app_", "")
        locale_keys = extract_keys_from_arb(arb_file)
        
        # Find missing keys
        missing_keys = set(english_keys.keys()) - set(locale_keys.keys())
        for key in missing_keys:
            all_untranslated.append({
                'locale': locale,
                'key': key,
                'english_value': english_keys[key],
                'type': 'missing'
            })
        
        # Find untranslated keys (same as English or TODO_TRANSLATE placeholders)
        for key, value in locale_keys.items():
            if key in english_keys:
                # Check if it's the same as English or a TODO_TRANSLATE placeholder
                if value == english_keys[key] or value.startswith("TODO_TRANSLATE:"):
                    all_untranslated.append({
                        'locale': locale,
                        'key': key,
                        'english_value': english_keys[key],
                        'type': 'untranslated'
                    })
        
        # Find empty keys
        for key, value in locale_keys.items():
            if value == "":
                all_untranslated.append({
                    'locale': locale,
                    'key': key,
                    'english_value': english_keys.get(key, ''),
                    'type': 'empty'
                })
    
    return all_untranslated, english_keys

def generate_markdown_table(untranslated_keys):
    """Generate markdown table of untranslated keys."""
    markdown = []
    markdown.append("# Untranslated Localization Keys")
    markdown.append("")
    markdown.append("| Locale | Key | English Value | Type |")
    markdown.append("|--------|-----|---------------|------|")
    
    for item in sorted(untranslated_keys, key=lambda x: (x['locale'], x['key'])):
        markdown.append(f"| {item['locale']} | `{item['key']}` | `{item['english_value']}` | {item['type']} |")
    
    return "\n".join(markdown)

def generate_csv(untranslated_keys):
    """Generate CSV of untranslated keys."""
    csv_lines = []
    csv_lines.append("Locale,Key,English Value,Type")
    
    for item in sorted(untranslated_keys, key=lambda x: (x['locale'], x['key'])):
        # Escape quotes in CSV
        english_value = item['english_value'].replace('"', '""')
        csv_lines.append(f"{item['locale']},\"{item['key']}\",\"{english_value}\",{item['type']}")
    
    return "\n".join(csv_lines)

def generate_summary(untranslated_keys):
    """Generate summary statistics."""
    locales = set(item['locale'] for item in untranslated_keys)
    keys = set(item['key'] for item in untranslated_keys)
    
    summary = []
    summary.append("## Summary")
    summary.append("")
    summary.append(f"- **Total locales with issues:** {len(locales)}")
    summary.append(f"- **Total unique keys needing translation:** {len(keys)}")
    summary.append(f"- **Total translation entries needed:** {len(untranslated_keys)}")
    summary.append("")
    
    # Per locale breakdown
    summary.append("### Per Locale Breakdown")
    summary.append("")
    summary.append("| Locale | Missing | Untranslated | Empty | Total |")
    summary.append("|--------|---------|--------------|-------|-------|")
    
    for locale in sorted(locales):
        locale_items = [item for item in untranslated_keys if item['locale'] == locale]
        missing = len([item for item in locale_items if item['type'] == 'missing'])
        untranslated = len([item for item in locale_items if item['type'] == 'untranslated'])
        empty = len([item for item in locale_items if item['type'] == 'empty'])
        total = len(locale_items)
        
        summary.append(f"| {locale} | {missing} | {untranslated} | {empty} | {total} |")
    
    return "\n".join(summary)

if __name__ == "__main__":
    print("Scanning for untranslated keys...")
    untranslated_keys, english_keys = scan_untranslated_keys()
    
    print(f"Found {len(untranslated_keys)} untranslated entries across all locales")
    
    # Generate markdown table
    markdown_table = generate_markdown_table(untranslated_keys)
    summary = generate_summary(untranslated_keys)
    
    # Save markdown
    with open("untranslated_keys_report.md", "w", encoding="utf-8") as f:
        f.write(markdown_table + "\n\n" + summary)
    
    # Generate CSV
    csv_data = generate_csv(untranslated_keys)
    with open("untranslated_keys.csv", "w", encoding="utf-8") as f:
        f.write(csv_data)
    
    print("Reports saved:")
    print("- untranslated_keys_report.md (markdown table)")
    print("- untranslated_keys.csv (CSV format)")
    
    # Also print summary to console
    print("\n" + summary) 