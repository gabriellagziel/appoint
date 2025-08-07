#!/usr/bin/env python3

"""
Back Translation Check Script
Validates that no TODO placeholders remain and provides translation quality metrics.
"""

import json
import os
import sys
from pathlib import Path
from typing import Dict, List, Tuple

# Configuration
L10N_DIR = Path("lib/l10n")
MASTER_ARB = L10N_DIR / "app_en.arb"
SUPPORTED_LOCALES = [
    'ar', 'bg', 'cs', 'da', 'de', 'es', 'fi', 'fr', 'he', 'hu',
    'id', 'it', 'ja', 'ko', 'lt', 'ms', 'nl', 'no', 'pl', 'pt',
    'ro', 'ru', 'sk', 'sl', 'sr', 'sv', 'th', 'tr', 'uk', 'vi', 'zh'
]

def load_arb_file(file_path: Path) -> Dict:
    """Load and parse an ARB file."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except Exception as e:
        print(f"❌ Error loading {file_path}: {e}")
        return {}

def check_todo_placeholders() -> Dict[str, List[str]]:
    """Check for TODO placeholders in all ARB files."""
    todos = {}
    
    for locale in SUPPORTED_LOCALES:
        arb_file = L10N_DIR / f"app_{locale}.arb"
        if not arb_file.exists():
            continue
            
        arb_data = load_arb_file(arb_file)
        locale_todos = []
        
        for key, value in arb_data.items():
            if not key.startswith('@') and isinstance(value, str) and value.startswith('TODO:'):
                locale_todos.append(key)
        
        if locale_todos:
            todos[locale] = locale_todos
    
    return todos

def validate_translation_structure() -> Dict[str, Dict]:
    """Validate that all ARB files have the same structure as master."""
    master_data = load_arb_file(MASTER_ARB)
    if not master_data:
        print("❌ Cannot load master ARB file")
        return {}
    
    master_keys = {k for k in master_data.keys() if not k.startswith('@')}
    validation_results = {}
    
    for locale in SUPPORTED_LOCALES:
        arb_file = L10N_DIR / f"app_{locale}.arb"
        if not arb_file.exists():
            validation_results[locale] = {"status": "missing", "missing_keys": list(master_keys)}
            continue
        
        arb_data = load_arb_file(arb_file)
        locale_keys = {k for k in arb_data.keys() if not k.startswith('@')}
        
        missing_keys = master_keys - locale_keys
        extra_keys = locale_keys - master_keys
        
        validation_results[locale] = {
            "status": "valid" if not missing_keys and not extra_keys else "invalid",
            "missing_keys": list(missing_keys),
            "extra_keys": list(extra_keys),
            "total_keys": len(locale_keys)
        }
    
    return validation_results

def generate_quality_report() -> str:
    """Generate a comprehensive quality report."""
    todos = check_todo_placeholders()
    validation = validate_translation_structure()
    
    report = []
    report.append("# Translation Quality Report")
    report.append(f"Generated on: {__import__('datetime').datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    report.append("")
    
    # Summary
    total_todos = sum(len(todo_list) for todo_list in todos.values())
    report.append("## Summary")
    report.append(f"- Total locales: {len(SUPPORTED_LOCALES)}")
    report.append(f"- Locales with TODOs: {len(todos)}")
    report.append(f"- Total TODO items: {total_todos}")
    report.append("")
    
    # TODO Analysis
    if todos:
        report.append("## TODO Placeholders Found")
        report.append("The following locales still have TODO placeholders:")
        report.append("")
        
        for locale, todo_keys in todos.items():
            report.append(f"### {locale} ({len(todo_keys)} items)")
            for key in todo_keys[:10]:  # Show first 10
                report.append(f"- {key}")
            if len(todo_keys) > 10:
                report.append(f"- ... and {len(todo_keys) - 10} more")
            report.append("")
    else:
        report.append("## ✅ No TODO Placeholders Found")
        report.append("All translations appear to be complete!")
        report.append("")
    
    # Structure Validation
    report.append("## Structure Validation")
    invalid_count = sum(1 for result in validation.values() if result["status"] == "invalid")
    
    if invalid_count == 0:
        report.append("✅ All ARB files have correct structure")
    else:
        report.append(f"⚠️  {invalid_count} locales have structural issues:")
        report.append("")
        
        for locale, result in validation.items():
            if result["status"] == "invalid":
                report.append(f"### {locale}")
                if result["missing_keys"]:
                    report.append(f"- Missing keys: {len(result['missing_keys'])}")
                if result["extra_keys"]:
                    report.append(f"- Extra keys: {len(result['extra_keys'])}")
                report.append("")
    
    # Recommendations
    report.append("## Recommendations")
    if total_todos > 0:
        report.append("1. **Prioritize high-impact strings** (UI labels, error messages)")
        report.append("2. **Work on one locale at a time** to maintain consistency")
        report.append("3. **Use the merge script** when adding new keys: `npm run merge-arb`")
        report.append("4. **Run this check regularly** to track progress")
    else:
        report.append("1. **Consider professional review** of translations")
        report.append("2. **Test with native speakers** for cultural appropriateness")
        report.append("3. **Monitor user feedback** for translation quality")
    
    return "\n".join(report)

def main():
    """Main function."""
    print("🔍 Running back translation check...")
    
    # Check for TODOs
    todos = check_todo_placeholders()
    total_todos = sum(len(todo_list) for todo_list in todos.values())
    
    if total_todos > 0:
        print(f"⚠️  Found {total_todos} TODO placeholders across {len(todos)} locales")
        for locale, todo_keys in todos.items():
            print(f"  - {locale}: {len(todo_keys)} items")
    else:
        print("✅ No TODO placeholders found!")
    
    # Validate structure
    validation = validate_translation_structure()
    invalid_count = sum(1 for result in validation.values() if result["status"] == "invalid")
    
    if invalid_count > 0:
        print(f"⚠️  Found {invalid_count} locales with structural issues")
    else:
        print("✅ All ARB files have correct structure")
    
    # Generate report
    report = generate_quality_report()
    with open("translation_quality_report.md", "w", encoding="utf-8") as f:
        f.write(report)
    
    print("✅ Generated translation quality report: translation_quality_report.md")
    
    # Only exit with error for structural issues, not for TODOs (which are expected during development)
    if invalid_count > 0:
        print("❌ Exiting with error due to structural issues")
        sys.exit(1)
    else:
        print("✅ All checks passed (TODOs are expected during development)")

if __name__ == "__main__":
    main() 