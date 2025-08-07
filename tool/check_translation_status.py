#!/usr/bin/env python3
"""
Script to check which languages still need real translations
"""

import json
import os
from pathlib import Path

ARB_DIR = Path('lib/l10n')
ENGLISH_FILE = ARB_DIR / 'app_en.arb'

def load_arb_file(file_path):
    """Load and parse an ARB file."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except Exception as e:
        print(f"Error loading {file_path}: {e}")
        return {}

def check_translation_status():
    """Check which languages need real translations."""
    english_data = load_arb_file(ENGLISH_FILE)
    if not english_data:
        print("❌ Cannot load English ARB file")
        return
    
    english_keys = {k: v for k, v in english_data.items() if not k.startswith('@')}
    
    print("🔍 Checking translation status for all languages...")
    print(f"English file has {len(english_keys)} translation keys")
    print()
    
    results = []
    
    for arb_file in ARB_DIR.glob('app_*.arb'):
        if arb_file.name == 'app_en.arb':
            continue
            
        locale = arb_file.stem.replace('app_', '')
        arb_data = load_arb_file(arb_file)
        
        if not arb_data:
            continue
        
        # Count keys that match English exactly (likely not translated)
        untranslated_count = 0
        translated_count = 0
        total_keys = 0
        
        for key, english_value in english_keys.items():
            if key in arb_data:
                total_keys += 1
                if arb_data[key] == english_value:
                    untranslated_count += 1
                else:
                    translated_count += 1
        
        completion_rate = (translated_count / total_keys * 100) if total_keys > 0 else 0
        
        results.append({
            'locale': locale,
            'file': arb_file.name,
            'total_keys': total_keys,
            'translated': translated_count,
            'untranslated': untranslated_count,
            'completion_rate': completion_rate
        })
        
        status = "✅" if completion_rate > 80 else "⚠️" if completion_rate > 50 else "❌"
        print(f"{status} {locale}: {completion_rate:.1f}% ({translated_count}/{total_keys} translated)")
    
    # Sort by completion rate (lowest first)
    results.sort(key=lambda x: x['completion_rate'])
    
    print("\n📊 Summary:")
    print("Languages that need translation work:")
    print()
    
    for result in results:
        if result['completion_rate'] < 80:
            print(f"❌ {result['locale']}: {result['completion_rate']:.1f}% ({result['untranslated']} keys need translation)")
    
    print(f"\n✅ Languages with good translation coverage:")
    for result in results:
        if result['completion_rate'] >= 80:
            print(f"✅ {result['locale']}: {result['completion_rate']:.1f}%")

if __name__ == "__main__":
    check_translation_status() 