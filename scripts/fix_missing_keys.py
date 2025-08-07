#!/usr/bin/env python3
"""
Fix Missing Keys Script for APP-OINT
Automatically adds missing keys to ARB files based on English reference.
"""

import json
import os
from pathlib import Path
from typing import Dict, Set

def load_arb_file(file_path: str) -> Dict:
    """Load and parse an ARB file."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            return json.loads(content)
    except (json.JSONDecodeError, FileNotFoundError) as e:
        print(f"Error loading {file_path}: {e}")
        return {}

def save_arb_file(file_path: str, data: Dict):
    """Save ARB data to file with proper formatting."""
    try:
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        print(f"✅ Saved {file_path}")
    except Exception as e:
        print(f"❌ Error saving {file_path}: {e}")

def extract_keys(arb_data: Dict) -> Set[str]:
    """Extract translation keys (excluding metadata keys)."""
    keys = set()
    for key in arb_data.keys():
        if not key.startswith('@') and key != '@@locale':
            keys.add(key)
    return keys

def add_missing_keys(target_data: Dict, reference_data: Dict, locale: str) -> Dict:
    """Add missing keys to target ARB file."""
    target_keys = extract_keys(target_data)
    reference_keys = extract_keys(reference_data)
    missing_keys = reference_keys - target_keys
    
    if not missing_keys:
        return target_data
    
    print(f"  Adding {len(missing_keys)} missing keys to {locale}")
    
    # Add missing keys with TODO placeholders
    for key in sorted(missing_keys):
        if key in reference_data:
            # Add the key with TODO placeholder
            target_data[key] = f"TODO: Translate '{reference_data[key]}'"
            
            # Add the description if it exists
            desc_key = f"@{key}"
            if desc_key in reference_data:
                target_data[desc_key] = reference_data[desc_key]
    
    return target_data

def fix_empty_file(file_path: str, reference_data: Dict, locale: str):
    """Fix completely empty ARB files."""
    print(f"  Creating new ARB file for {locale}")
    
    # Start with basic structure
    new_data = {
        "@@locale": locale
    }
    
    # Add all keys from reference with TODO placeholders
    for key, value in reference_data.items():
        if key == "@@locale":
            continue
        elif key.startswith("@"):
            # Copy descriptions as-is
            new_data[key] = value
        else:
            # Add TODO placeholder for translation
            new_data[key] = f"TODO: Translate '{value}'"
    
    save_arb_file(file_path, new_data)

def main():
    """Main function to fix missing keys."""
    l10n_dir = Path("lib/l10n")
    
    # Load English reference
    en_file = l10n_dir / "app_en.arb"
    if not en_file.exists():
        print("❌ English reference file not found: app_en.arb")
        return
    
    en_data = load_arb_file(str(en_file))
    en_keys = extract_keys(en_data)
    print(f"📋 English reference contains {len(en_keys)} keys")
    
    # Files that need fixing (from audit results)
    files_to_fix = {
        "es_419": "empty",  # Completely empty
        "bn_BD": "missing_19_keys",
        "he": "missing_19_keys", 
        "pt_BR": "missing_19_keys",
        "tr": "missing_19_keys",
        "uk": "missing_19_keys",
        "bn": "missing_1_key",
        "ur": "missing_1_key",
        "zh": "missing_1_key"
    }
    
    print(f"\n🔧 Fixing {len(files_to_fix)} ARB files...")
    
    for locale, issue in files_to_fix.items():
        arb_file = l10n_dir / f"app_{locale}.arb"
        print(f"\n📄 Processing {locale} ({issue})...")
        
        if issue == "empty":
            # Handle completely empty files
            if arb_file.exists() and arb_file.stat().st_size <= 1:
                fix_empty_file(str(arb_file), en_data, locale)
            else:
                print(f"  ⚠️  File {arb_file} not found or not empty")
        else:
            # Handle files with missing keys
            if not arb_file.exists():
                print(f"  ⚠️  File {arb_file} not found")
                continue
                
            arb_data = load_arb_file(str(arb_file))
            if not arb_data:
                print(f"  ⚠️  Failed to load {arb_file}")
                continue
            
            # Add missing keys
            updated_data = add_missing_keys(arb_data, en_data, locale)
            
            # Save updated file
            save_arb_file(str(arb_file), updated_data)
    
    print(f"\n✅ Completed fixing missing keys!")
    print(f"\n📝 Next steps:")
    print(f"1. Review the TODO placeholders in the updated files")
    print(f"2. Translate the TODO placeholders to appropriate languages")
    print(f"3. Run 'flutter gen-l10n' to regenerate localization files")
    print(f"4. Test the app with different locales")

if __name__ == "__main__":
    main() 