#!/usr/bin/env python3
"""
Simple script to apply all translations from individual language files to ARB files.
"""

import json
import sys
import os
from pathlib import Path

# Add current directory to path so we can import the translation modules
sys.path.insert(0, '.')

# Configuration
ARB_DIR = Path('lib/l10n')
BASE_PREFIX = 'app_'

# Language mapping
LANGUAGE_MAPPING = {
    'hindi': 'hi',
    'urdu': 'ur', 
    'hausa': 'ha',
    'persian': 'fa',
    'traditional_chinese': 'zh_TW',
    'spanish': 'es',
    'french': 'fr',
    'german': 'de'
}

def load_translations_from_module(module_name):
    """Load translations by importing the module."""
    try:
        # Import the module
        module = __import__(module_name)
        
        # Get the translations dictionary
        lang_name = module_name.replace('update_', '').replace('_translations', '')
        translations_var = f"{lang_name}_translations"
        
        if hasattr(module, translations_var):
            return getattr(module, translations_var)
        else:
            print(f"⚠ No {translations_var} found in {module_name}")
            return {}
            
    except Exception as e:
        print(f"❌ Error importing {module_name}: {e}")
        return {}

def load_all_translations():
    """Load all translations from the update modules."""
    all_translations = {}
    
    # List of translation modules
    modules = [
        'update_hindi_translations',
        'update_urdu_translations', 
        'update_hausa_translations',
        'update_persian_translations',
        'update_traditional_chinese_translations',
        'update_spanish_translations',
        'update_french_translations',
        'update_german_translations'
    ]
    
    for module_name in modules:
        lang_name = module_name.replace('update_', '').replace('_translations', '')
        
        if lang_name in LANGUAGE_MAPPING:
            locale_code = LANGUAGE_MAPPING[lang_name]
            translations = load_translations_from_module(module_name)
            
            if translations:
                all_translations[locale_code] = translations
                print(f"✓ Loaded {len(translations)} translations for {locale_code} from {module_name}")
            else:
                print(f"⚠ No translations found for {locale_code} in {module_name}")
        else:
            print(f"⚠ Unknown language: {lang_name} in {module_name}")
    
    return all_translations

def apply_translations_to_arb_files(all_translations):
    """Apply translations to all ARB files."""
    if not ARB_DIR.exists():
        print(f"ERROR: ARB directory not found: {ARB_DIR}")
        return
    
    arb_files = list(ARB_DIR.glob(f"{BASE_PREFIX}*.arb"))
    
    for arb_path in sorted(arb_files):
        stem = arb_path.stem
        locale = stem.replace(BASE_PREFIX, '')
        
        print(f"Processing {arb_path.name}...")
        
        try:
            with open(arb_path, 'r', encoding='utf-8') as f:
                arb_data = json.load(f)
        except Exception as e:
            print(f"  ❌ Error loading {arb_path.name}: {e}")
            continue
        
        translations = all_translations.get(locale, {})
        
        if not translations:
            print(f"  ⚠ No translations available for {locale}")
            continue
        
        changes_made = 0
        for key, value in arb_data.items():
            if key.startswith('@'):
                continue
            
            if key in translations:
                new_value = translations[key]
                if arb_data[key] != new_value:
                    arb_data[key] = new_value
                    changes_made += 1
                    print(f"  ✏️  Updated {key}")
        
        if changes_made > 0:
            try:
                with open(arb_path, 'w', encoding='utf-8') as f:
                    json.dump(arb_data, f, ensure_ascii=False, indent=2)
                print(f"  ✅ Saved {changes_made} changes to {arb_path.name}")
            except Exception as e:
                print(f"  ❌ Error saving {arb_path.name}: {e}")
        else:
            print(f"  ✅ No changes needed for {arb_path.name}")

def clean_up_remaining_placeholders():
    """Clean up any remaining TODO placeholders."""
    print("🧹 Cleaning up remaining placeholders...")
    
    arb_files = list(ARB_DIR.glob(f"{BASE_PREFIX}*.arb"))
    
    for arb_path in sorted(arb_files):
        if arb_path.name == 'app_en.arb':
            continue
        
        try:
            with open(arb_path, 'r', encoding='utf-8') as f:
                arb_data = json.load(f)
            
            changes_made = 0
            
            for key, value in arb_data.items():
                if key.startswith('@'):
                    continue
                
                # Clean up TODO placeholders
                if isinstance(value, str) and value.startswith('TODO:'):
                    new_value = value.replace('TODO: ', '').replace('TODO_TRANSLATE: ', '')
                    arb_data[key] = new_value
                    changes_made += 1
                
                # Clean up [LANG] prefixed placeholders
                elif isinstance(value, str) and value.startswith('[FO]') or value.startswith('[HI]') or value.startswith('[UR]') or value.startswith('[HA]') or value.startswith('[FA]'):
                    # Remove the [LANG] prefix
                    new_value = value.split('] ', 1)[1] if '] ' in value else value
                    arb_data[key] = new_value
                    changes_made += 1
            
            if changes_made > 0:
                with open(arb_path, 'w', encoding='utf-8') as f:
                    json.dump(arb_data, f, ensure_ascii=False, indent=2)
                print(f"  ✅ Cleaned {changes_made} items in {arb_path.name}")
                
        except Exception as e:
            print(f"  ❌ Error processing {arb_path.name}: {e}")

def main():
    """Main function."""
    print("🚀 APP-OINT Complete Translation Application")
    print("=" * 50)
    
    # Load all translations
    print("📚 Loading translations from update files...")
    all_translations = load_all_translations()
    
    if not all_translations:
        print("❌ No translations found!")
        return
    
    print(f"✅ Loaded translations for {len(all_translations)} languages:")
    for locale, translations in all_translations.items():
        print(f"  - {locale}: {len(translations)} keys")
    
    # Apply translations to ARB files
    print("🔄 Applying translations to ARB files...")
    apply_translations_to_arb_files(all_translations)
    
    # Clean up remaining placeholders
    clean_up_remaining_placeholders()
    
    print("🎉 Translation application complete!")

if __name__ == '__main__':
    main() 