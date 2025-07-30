#!/usr/bin/env python3
"""
ARB Translation Validator for App-Oint
Validates translation files and ensures consistent key count across languages.
"""

import json
import os
import sys
from pathlib import Path
from typing import Dict, List, Set

# Expected key count for all languages
EXPECTED_KEY_COUNT = 709

def load_arb_file(file_path: Path) -> Dict:
    """Load and parse an ARB file."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except json.JSONDecodeError as e:
        print(f"❌ Error parsing {file_path}: {e}")
        return {}
    except FileNotFoundError:
        print(f"❌ File not found: {file_path}")
        return {}

def count_keys(arb_data: Dict) -> int:
    """Count the number of translation keys in ARB data."""
    # Count keys that start with a letter (exclude metadata keys like @)
    return len([key for key in arb_data.keys() if key and key[0].isalpha()])

def validate_arb_file(file_path: Path, expected_count: int) -> bool:
    """Validate a single ARB file."""
    arb_data = load_arb_file(file_path)
    if not arb_data:
        return False
    
    key_count = count_keys(arb_data)
    language = file_path.stem.replace('app_', '')
    
    print(f"📊 {file_path.name}: {key_count} keys")
    
    if key_count != expected_count:
        print(f"❌ {file_path.name}: Expected {expected_count} keys, found {key_count}")
        return False
    
    return True

def find_missing_keys(base_arb_data: Dict, target_arb_data: Dict, language: str) -> List[str]:
    """Find missing keys in target language compared to base language."""
    base_keys = {key for key in base_arb_data.keys() if key and key[0].isalpha()}
    target_keys = {key for key in target_arb_data.keys() if key and key[0].isalpha()}
    
    missing_keys = base_keys - target_keys
    if missing_keys:
        print(f"⚠️  Missing keys in {language}: {sorted(missing_keys)}")
    
    return list(missing_keys)

def validate_translations():
    """Main validation function."""
    print("🔍 Validating ARB translation files...")
    
    # Find ARB files
    l10n_dir = Path("lib/l10n")
    if not l10n_dir.exists():
        print("❌ lib/l10n directory not found")
        return False
    
    arb_files = list(l10n_dir.glob("*.arb"))
    if not arb_files:
        print("❌ No ARB files found in lib/l10n")
        return False
    
    print(f"📁 Found {len(arb_files)} ARB files")
    
    # Load base English file
    base_file = l10n_dir / "app_en.arb"
    if not base_file.exists():
        print("❌ Base English file (app_en.arb) not found")
        return False
    
    base_data = load_arb_file(base_file)
    if not base_data:
        return False
    
    base_key_count = count_keys(base_data)
    print(f"📊 Base English file: {base_key_count} keys")
    
    # Validate all files
    all_valid = True
    missing_keys_total = 0
    
    for arb_file in arb_files:
        if arb_file.name == "app_en.arb":
            continue  # Skip base file, we already processed it
        
        language = arb_file.stem.replace('app_', '')
        target_data = load_arb_file(arb_file)
        
        if not target_data:
            all_valid = False
            continue
        
        # Check key count
        if not validate_arb_file(arb_file, base_key_count):
            all_valid = False
            continue
        
        # Check for missing keys
        missing_keys = find_missing_keys(base_data, target_data, language)
        missing_keys_total += len(missing_keys)
        
        if missing_keys:
            all_valid = False
    
    # Summary
    print("\n📋 Validation Summary:")
    print(f"✅ Files processed: {len(arb_files)}")
    print(f"📊 Expected key count: {base_key_count}")
    print(f"❌ Missing keys total: {missing_keys_total}")
    
    if all_valid and missing_keys_total == 0:
        print("🎉 All translation files are valid!")
        return True
    else:
        print("❌ Translation validation failed")
        return False

def check_arb_syntax():
    """Check ARB file syntax and formatting."""
    print("🔍 Checking ARB file syntax...")
    
    l10n_dir = Path("lib/l10n")
    arb_files = list(l10n_dir.glob("*.arb"))
    
    syntax_valid = True
    
    for arb_file in arb_files:
        try:
            with open(arb_file, 'r', encoding='utf-8') as f:
                content = f.read()
                
            # Check for common syntax issues
            issues = []
            
            # Check for trailing commas
            if content.rstrip().endswith(','):
                issues.append("Trailing comma at end of file")
            
            # Check for missing quotes
            lines = content.split('\n')
            for i, line in enumerate(lines, 1):
                if '"' in line and not line.strip().startswith('"') and not line.strip().startswith('@'):
                    if line.count('"') % 2 != 0:
                        issues.append(f"Unmatched quotes on line {i}")
            
            if issues:
                print(f"❌ {arb_file.name} has syntax issues:")
                for issue in issues:
                    print(f"   - {issue}")
                syntax_valid = False
            else:
                print(f"✅ {arb_file.name}: Syntax OK")
                
        except Exception as e:
            print(f"❌ Error reading {arb_file}: {e}")
            syntax_valid = False
    
    return syntax_valid

def main():
    """Main entry point."""
    print("🚀 App-Oint Translation Validator")
    print("=" * 40)
    
    # Check syntax first
    syntax_ok = check_arb_syntax()
    if not syntax_ok:
        print("\n❌ Syntax validation failed. Please fix syntax issues first.")
        sys.exit(1)
    
    print()
    
    # Validate translations
    translations_ok = validate_translations()
    
    if translations_ok:
        print("\n🎉 All validations passed!")
        sys.exit(0)
    else:
        print("\n❌ Validation failed. Please fix the issues above.")
        sys.exit(1)

if __name__ == "__main__":
    main()