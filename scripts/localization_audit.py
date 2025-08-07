#!/usr/bin/env python3
"""
Localization Audit Script for APP-OINT
Compares all ARB files against English reference to identify missing keys and untranslated values.
"""

import json
import os
import re
from pathlib import Path
from typing import Dict, List, Set, Tuple

def load_arb_file(file_path: str) -> Dict:
    """Load and parse an ARB file."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            return json.loads(content)
    except (json.JSONDecodeError, FileNotFoundError) as e:
        print(f"Error loading {file_path}: {e}")
        return {}

def extract_keys(arb_data: Dict) -> Set[str]:
    """Extract translation keys (excluding metadata keys)."""
    keys = set()
    for key in arb_data.keys():
        if not key.startswith('@') and key != '@@locale':
            keys.add(key)
    return keys

def check_untranslated_values(arb_data: Dict, locale: str) -> List[str]:
    """Check for untranslated values (TODO, empty, or English text in non-English files)."""
    untranslated = []
    english_patterns = [
        r'\bTODO\b',
        r'\bTBD\b',
        r'^\s*$',  # Empty or whitespace only
        r'^[A-Z][a-z]+(\s+[A-Z][a-z]+)*$',  # Title case English words
    ]
    
    for key, value in arb_data.items():
        if key.startswith('@') or key == '@@locale':
            continue
            
        if not isinstance(value, str):
            continue
            
        # Check for TODO/TBD placeholders
        if re.search(r'\bTODO\b', value, re.IGNORECASE):
            untranslated.append(f"{key}: Contains TODO placeholder")
            continue
            
        # Check for empty values
        if not value.strip():
            untranslated.append(f"{key}: Empty value")
            continue
            
        # For non-English locales, check for English text patterns
        if locale != 'en':
            # Simple heuristic: if it looks like English title case and is short
            if re.match(r'^[A-Z][a-z]+(\s+[A-Z][a-z]+)*$', value) and len(value.split()) <= 3:
                untranslated.append(f"{key}: Possible English text: '{value}'")
    
    return untranslated

def audit_localization():
    """Main audit function."""
    l10n_dir = Path("lib/l10n")
    
    # Load English reference
    en_file = l10n_dir / "app_en.arb"
    if not en_file.exists():
        print("❌ English reference file not found: app_en.arb")
        return
    
    en_data = load_arb_file(str(en_file))
    en_keys = extract_keys(en_data)
    print(f"📋 English reference contains {len(en_keys)} keys")
    
    # Find all ARB files
    arb_files = list(l10n_dir.glob("app_*.arb"))
    arb_files = [f for f in arb_files if f.name != "app_en.arb"]
    
    print(f"\n🔍 Auditing {len(arb_files)} ARB files...")
    
    # Results storage
    results = {
        'missing_keys': {},
        'untranslated_values': {},
        'empty_files': [],
        'summary': {}
    }
    
    for arb_file in sorted(arb_files):
        locale = arb_file.stem.replace('app_', '')
        print(f"\n📄 Checking {locale}...")
        
        # Check if file is empty
        if arb_file.stat().st_size <= 1:
            results['empty_files'].append(locale)
            print(f"  ❌ Empty file")
            continue
        
        # Load ARB data
        arb_data = load_arb_file(str(arb_file))
        if not arb_data:
            results['empty_files'].append(locale)
            print(f"  ❌ Failed to load or empty")
            continue
        
        # Extract keys
        file_keys = extract_keys(arb_data)
        missing_keys = en_keys - file_keys
        
        # Check for untranslated values
        untranslated = check_untranslated_values(arb_data, locale)
        
        # Store results
        if missing_keys:
            results['missing_keys'][locale] = sorted(missing_keys)
        if untranslated:
            results['untranslated_values'][locale] = untranslated
        
        # Summary
        results['summary'][locale] = {
            'total_keys': len(file_keys),
            'missing_keys': len(missing_keys),
            'untranslated_values': len(untranslated),
            'completion_percentage': round((len(file_keys) / len(en_keys)) * 100, 1)
        }
        
        print(f"  📊 {len(file_keys)}/{len(en_keys)} keys ({results['summary'][locale]['completion_percentage']}%)")
        if missing_keys:
            print(f"  ❌ Missing {len(missing_keys)} keys")
        if untranslated:
            print(f"  ⚠️  {len(untranslated)} untranslated values")
    
    # Generate detailed report
    generate_report(results, en_keys)

def generate_report(results: Dict, en_keys: Set[str]):
    """Generate detailed audit report."""
    print("\n" + "="*80)
    print("📋 LOCALIZATION AUDIT REPORT")
    print("="*80)
    
    # Empty files
    if results['empty_files']:
        print(f"\n❌ EMPTY FILES ({len(results['empty_files'])}):")
        for locale in results['empty_files']:
            print(f"  - {locale}")
    
    # Missing keys summary
    missing_count = sum(len(keys) for keys in results['missing_keys'].values())
    if missing_count > 0:
        print(f"\n❌ MISSING KEYS ({missing_count} total):")
        for locale, keys in sorted(results['missing_keys'].items()):
            print(f"\n  {locale} ({len(keys)} missing):")
            for key in keys[:10]:  # Show first 10
                print(f"    - {key}")
            if len(keys) > 10:
                print(f"    ... and {len(keys) - 10} more")
    
    # Untranslated values summary
    untranslated_count = sum(len(values) for values in results['untranslated_values'].values())
    if untranslated_count > 0:
        print(f"\n⚠️  UNTRANSLATED VALUES ({untranslated_count} total):")
        for locale, values in sorted(results['untranslated_values'].items()):
            print(f"\n  {locale} ({len(values)} untranslated):")
            for value in values[:5]:  # Show first 5
                print(f"    - {value}")
            if len(values) > 5:
                print(f"    ... and {len(values) - 5} more")
    
    # Completion summary
    print(f"\n📊 COMPLETION SUMMARY:")
    print(f"{'Locale':<10} {'Keys':<8} {'Missing':<8} {'Untranslated':<12} {'Completion':<12}")
    print("-" * 60)
    
    for locale, stats in sorted(results['summary'].items()):
        print(f"{locale:<10} {stats['total_keys']:<8} {stats['missing_keys']:<8} "
              f"{stats['untranslated_values']:<12} {stats['completion_percentage']}%")
    
    # Priority recommendations
    print(f"\n🎯 PRIORITY RECOMMENDATIONS:")
    
    # Empty files first
    if results['empty_files']:
        print(f"1. Populate empty files: {', '.join(results['empty_files'])}")
    
    # Files with most missing keys
    if results['missing_keys']:
        worst_files = sorted(results['missing_keys'].items(), 
                           key=lambda x: len(x[1]), reverse=True)[:3]
        print(f"2. Focus on files with most missing keys:")
        for locale, keys in worst_files:
            print(f"   - {locale}: {len(keys)} missing keys")
    
    # Files with most untranslated values
    if results['untranslated_values']:
        worst_untranslated = sorted(results['untranslated_values'].items(),
                                  key=lambda x: len(x[1]), reverse=True)[:3]
        print(f"3. Fix untranslated values in:")
        for locale, values in worst_untranslated:
            print(f"   - {locale}: {len(values)} untranslated values")
    
    print(f"\n📝 Next steps:")
    print(f"1. Copy missing keys from app_en.arb to incomplete files")
    print(f"2. Replace TODO/TBD placeholders with proper translations")
    print(f"3. Review and translate English text in non-English files")
    print(f"4. Run 'flutter gen-l10n' to regenerate localization files")

if __name__ == "__main__":
    audit_localization() 