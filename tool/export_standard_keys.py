#!/usr/bin/env python3
"""
Export standard translation keys for localization pipeline.
This script extracts non-Ambassador translation keys and prepares ARB files for all languages.
"""

import json
import os
import shutil
from pathlib import Path

def load_arb_file(file_path):
    """Load and parse an ARB file."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except Exception as e:
        print(f"Error loading {file_path}: {e}")
        return {}

def save_arb_file(data, file_path):
    """Save data to an ARB file."""
    try:
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        print(f"Saved: {file_path}")
    except Exception as e:
        print(f"Error saving {file_path}: {e}")

def extract_standard_keys(arb_data):
    """Extract standard (non-Ambassador) translation keys."""
    standard_keys = {}
    ambassador_prefixes = ['ambassador', 'branch', 'quota', 'referral']
    
    for key, value in arb_data.items():
        if key.startswith('@'):
            continue
            
        # Check if key contains ambassador-related terms
        is_ambassador_key = any(prefix in key.lower() for prefix in ambassador_prefixes)
        
        if not is_ambassador_key:
            standard_keys[key] = value
            
            # Also include the metadata if it exists
            metadata_key = f"@{key}"
            if metadata_key in arb_data:
                standard_keys[metadata_key] = arb_data[metadata_key]
    
    return standard_keys

def create_language_arb_files(standard_keys, languages):
    """Create ARB files for all languages."""
    l10n_dir = Path("lib/l10n")
    l10n_dir.mkdir(exist_ok=True)
    
    # Create standard keys file
    standard_keys_file = l10n_dir / "standard_keys.json"
    save_arb_file(standard_keys, standard_keys_file)
    
    # Create ARB files for each language
    for lang_code in languages:
        arb_file = l10n_dir / f"app_{lang_code}.arb"
        
        # Start with standard keys
        lang_data = standard_keys.copy()
        
        # Add locale metadata
        lang_data["@@locale"] = lang_code
        
        # If backup exists, merge with existing translations
        backup_file = l10n_dir / "backup" / f"app_{lang_code}.arb"
        if backup_file.exists():
            backup_data = load_arb_file(backup_file)
            for key, value in backup_data.items():
                if key in standard_keys and not key.startswith('@'):
                    lang_data[key] = value
        
        save_arb_file(lang_data, arb_file)

def main():
    """Main function to export standard keys and create language files."""
    print("🚀 Starting localization pipeline...")
    
    # Load English ARB file
    en_arb_path = Path("lib/l10n/app_en.arb")
    if not en_arb_path.exists():
        print("❌ English ARB file not found!")
        return
    
    en_data = load_arb_file(en_arb_path)
    if not en_data:
        print("❌ Failed to load English ARB file!")
        return
    
    print(f"📊 Loaded {len(en_data)} total keys from English ARB")
    
    # Extract standard keys
    standard_keys = extract_standard_keys(en_data)
    print(f"✅ Extracted {len(standard_keys)} standard keys")
    
    # List of 50 languages to support (using valid ISO codes)
    languages = [
        'en', 'es', 'fr', 'de', 'it', 'pt', 'ru', 'ja', 'ko', 'zh',
        'ar', 'hi', 'bn', 'ur', 'fa', 'tr', 'nl', 'pl', 'sv', 'da',
        'no', 'fi', 'cs', 'sk', 'hu', 'ro', 'bg', 'hr', 'sl', 'et',
        'lv', 'lt', 'mt', 'ga', 'cy', 'eu', 'ca', 'gl', 'is', 'fo',
        'sq', 'mk', 'sr', 'bs', 'am', 'th', 'vi', 'id', 'ms'
    ]
    
    # Create language ARB files
    create_language_arb_files(standard_keys, languages)
    
    # Generate summary report
    print("\n📋 Localization Summary:")
    print(f"   • Standard keys: {len(standard_keys)}")
    print(f"   • Languages: {len(languages)}")
    print(f"   • Total ARB files created: {len(languages)}")
    
    # Create a summary file
    summary = {
        "standard_keys_count": len(standard_keys),
        "languages_count": len(languages),
        "standard_keys": list(standard_keys.keys()),
        "languages": languages,
        "timestamp": str(Path.cwd())
    }
    
    summary_file = Path("lib/l10n/localization_summary.json")
    save_arb_file(summary, summary_file)
    
    print(f"\n✅ Localization pipeline completed!")
    print(f"📁 Files created in: lib/l10n/")
    print(f"📄 Summary: lib/l10n/localization_summary.json")

if __name__ == "__main__":
    main() 