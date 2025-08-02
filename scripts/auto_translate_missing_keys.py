#!/usr/bin/env python3
"""
Auto-translate missing keys using translation API
"""

import json
import os
import time
from typing import Dict, List, Optional

def translate_text(text: str, target_language: str, source_language: str = 'en') -> Optional[str]:
    """
    Translate text using a translation service.
    This is a placeholder - you can integrate with Google Translate, DeepL, or other services.
    """
    # For now, return None to indicate manual translation needed
    # You can integrate with:
    # - Google Translate API
    # - DeepL API  
    # - Microsoft Translator
    # - LibreTranslate
    return None

def get_missing_keys_for_language(arb_file_path: str, english_arb_path: str) -> Dict[str, str]:
    """Get missing translation keys for a specific language."""
    try:
        with open(english_arb_path, 'r', encoding='utf-8') as f:
            english_data = json.load(f)
        
        with open(arb_file_path, 'r', encoding='utf-8') as f:
            target_data = json.load(f)
    except FileNotFoundError:
        return {}
    
    missing_keys = {}
    
    for key, english_value in english_data.items():
        # Skip metadata keys and system admin keys
        if key.startswith('@') or key in ['adminMetrics', 'adminDashboard', 'adminUsers', 'adminSettings', 'adminLogs', 'adminReports']:
            continue
            
        # Check if key is missing or has placeholder value
        if key not in target_data or target_data[key] in [
            f"{key} (TRANSLATE)",
            f"TODO: Translate '{english_value}'",
            english_value  # Same as English
        ]:
            missing_keys[key] = english_value
    
    return missing_keys

def auto_translate_language(language_code: str, missing_keys: Dict[str, str]) -> Dict[str, str]:
    """Auto-translate missing keys for a language."""
    translations = {}
    
    print(f"Auto-translating {len(missing_keys)} keys for {language_code}...")
    
    for key, english_text in missing_keys.items():
        # Skip keys with placeholders or variables
        if '{' in english_text or '}' in english_text:
            translations[key] = english_text  # Keep as-is for now
            continue
            
        translated = translate_text(english_text, language_code)
        if translated:
            translations[key] = translated
        else:
            # For now, mark as needing manual translation
            translations[key] = f"TODO: Translate '{english_text}'"
        
        # Rate limiting
        time.sleep(0.1)
    
    return translations

def update_arb_file(arb_file_path: str, new_translations: Dict[str, str]):
    """Update ARB file with new translations."""
    try:
        with open(arb_file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
    except FileNotFoundError:
        data = {}
    
    # Update with new translations
    for key, translation in new_translations.items():
        data[key] = translation
    
    # Write back to file
    with open(arb_file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

def main():
    """Main function to auto-translate missing keys."""
    l10n_dir = "lib/l10n"
    english_arb = os.path.join(l10n_dir, "app_en.arb")
    
    if not os.path.exists(english_arb):
        print(f"English ARB file not found: {english_arb}")
        return
    
    # Get all ARB files
    arb_files = [f for f in os.listdir(l10n_dir) if f.startswith("app_") and f.endswith(".arb")]
    
    print(f"Found {len(arb_files)} ARB files")
    
    for arb_file in arb_files:
        if arb_file == "app_en.arb":
            continue
            
        language_code = arb_file[4:-4]  # Remove "app_" and ".arb"
        arb_path = os.path.join(l10n_dir, arb_file)
        
        print(f"\nProcessing {language_code}...")
        
        # Get missing keys
        missing_keys = get_missing_keys_for_language(arb_path, english_arb)
        
        if not missing_keys:
            print(f"  ✅ {language_code}: No missing keys")
            continue
        
        print(f"  ⚠️  {language_code}: {len(missing_keys)} missing keys")
        
        # Auto-translate
        translations = auto_translate_language(language_code, missing_keys)
        
        # Update ARB file
        update_arb_file(arb_path, translations)
        
        print(f"  ✅ {language_code}: Updated with {len(translations)} translations")

if __name__ == "__main__":
    main() 