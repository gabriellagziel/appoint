#!/usr/bin/env python3
"""
Convert ARB translation files to JSON format for Next.js
Converts all 56 language files from Flutter .arb format to Next.js JSON format
"""

import json
import os
import glob
from pathlib import Path
import re

def convert_arb_to_json(arb_file_path, output_dir):
    """Convert a single .arb file to JSON format"""
    
    # Read the ARB file
    with open(arb_file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Parse the ARB content
    translations = {}
    
    # Extract locale
    locale_match = re.search(r'"@@locale":\s*"([^"]+)"', content)
    if locale_match:
        locale = locale_match.group(1)
    else:
        # Extract from filename
        locale = Path(arb_file_path).stem.replace('app_', '')
    
    # Parse ARB format - extract key-value pairs
    # Look for patterns like: "key": "value"
    # Skip metadata lines starting with @
    lines = content.split('\n')
    current_key = None
    
    for line in lines:
        line = line.strip()
        
        # Skip empty lines, comments, and metadata
        if not line or line.startswith('//') or line.startswith('@'):
            continue
        
        # Check if this is a key-value pair
        if '"' in line and ':' in line:
            # Extract key and value
            parts = line.split(':', 1)
            if len(parts) == 2:
                key = parts[0].strip().strip('"')
                value = parts[1].strip().strip(',').strip('"')
                
                # Skip metadata keys
                if not key.startswith('@@'):
                    translations[key] = value
    
    # Create output directory
    os.makedirs(output_dir, exist_ok=True)
    
    # Write JSON file
    output_file = os.path.join(output_dir, f"{locale}.json")
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(translations, f, ensure_ascii=False, indent=2)
    
    print(f"✅ Converted {arb_file_path} -> {output_file} ({len(translations)} keys)")
    return locale, len(translations)

def main():
    """Main conversion function"""
    
    # Paths
    arb_dir = "../translation_backup"
    output_dir = "messages"
    
    # Find all .arb files
    arb_files = glob.glob(os.path.join(arb_dir, "app_*.arb"))
    
    if not arb_files:
        print(f"❌ No .arb files found in {arb_dir}")
        return
    
    print(f"🚀 Converting {len(arb_files)} ARB files to JSON...")
    print(f"📁 Input: {arb_dir}")
    print(f"📁 Output: {output_dir}")
    print()
    
    # Convert each file
    total_keys = 0
    converted_languages = []
    
    for arb_file in sorted(arb_files):
        try:
            locale, key_count = convert_arb_to_json(arb_file, output_dir)
            converted_languages.append(locale)
            total_keys += key_count
        except Exception as e:
            print(f"❌ Error converting {arb_file}: {e}")
    
    print()
    print(f"🎉 Conversion complete!")
    print(f"✅ Languages converted: {len(converted_languages)}")
    print(f"✅ Total translation keys: {total_keys}")
    print(f"📁 Output directory: {output_dir}")
    
    # List all converted languages
    print("\n🌍 Converted languages:")
    for i, lang in enumerate(converted_languages, 1):
        print(f"  {i:2d}. {lang}")
    
    # Create a summary file
    summary = {
        "total_languages": len(converted_languages),
        "total_keys": total_keys,
        "languages": converted_languages,
        "conversion_date": str(Path().absolute()),
        "source_format": "ARB (Flutter)",
        "target_format": "JSON (Next.js)"
    }
    
    summary_file = os.path.join(output_dir, "_conversion_summary.json")
    with open(summary_file, 'w', encoding='utf-8') as f:
        json.dump(summary, f, ensure_ascii=False, indent=2)
    
    print(f"\n📋 Summary saved to: {summary_file}")

if __name__ == "__main__":
    main()
