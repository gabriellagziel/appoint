#!/usr/bin/env python3
"""
Comprehensive ARB Metadata Fix Script
Adds missing metadata entries for all keys in ARB files
"""

import json
import os
from pathlib import Path

ARB_DIR = Path("lib/l10n")
REFERENCE_FILE = ARB_DIR / "app_en.arb"

def load_arb_file(file_path):
    """Load ARB file and return data"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except Exception as e:
        print(f"Error loading {file_path}: {e}")
        return None

def save_arb_file(file_path, data):
    """Save ARB file with proper formatting"""
    try:
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        return True
    except Exception as e:
        print(f"Error saving {file_path}: {e}")
        return False

def add_missing_metadata(data):
    """Add missing metadata entries for all keys"""
    if not data:
        return False
    
    changed = False
    
    # Get all keys that should have metadata
    keys_to_check = []
    for key in data.keys():
        if key != '@@locale' and not key.startswith('@'):
            keys_to_check.append(key)
    
    # Add missing metadata
    for key in keys_to_check:
        metadata_key = f'@{key}'
        if metadata_key not in data:
            # Create basic metadata
            metadata = {
                "description": f"Localization key for: {data[key]}"
            }
            
            # Add placeholders if the value contains placeholders
            value = data[key]
            if isinstance(value, str):
                import re
                placeholders = re.findall(r'\{([^}]+)\}', value)
                if placeholders:
                    metadata["placeholders"] = {}
                    for placeholder in placeholders:
                        metadata["placeholders"][placeholder] = {}
            
            data[metadata_key] = metadata
            changed = True
            print(f"  ✅ Added metadata for: {key}")
    
    return changed

def main():
    """Main function to fix ARB metadata"""
    print("🔧 Comprehensive ARB Metadata Fix")
    print("=" * 50)
    
    # Process all ARB files
    for arb_file in ARB_DIR.glob("*.arb"):
        if arb_file.name == "app_en.arb":
            continue  # Skip English file as reference
            
        print(f"\n🔄 Processing {arb_file.name}...")
        
        # Load ARB file
        data = load_arb_file(arb_file)
        if not data:
            continue
        
        # Add missing metadata
        changed = add_missing_metadata(data)
        
        if changed:
            # Save updated file
            if save_arb_file(arb_file, data):
                print(f"✅ Updated {arb_file.name}")
            else:
                print(f"❌ Failed to save {arb_file.name}")
        else:
            print(f"✅ {arb_file.name} - No changes needed")
    
    print("\n🎉 ARB metadata fix completed!")

if __name__ == "__main__":
    main() 