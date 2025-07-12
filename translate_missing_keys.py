#!/usr/bin/env python3
"""
Translate missing keys using Google Translate
"""

import json
import os
import time
import requests
from typing import Dict, List, Optional

def translate_with_google(text: str, target_lang: str, source_lang: str = 'en') -> Optional[str]:
    """
    Translate text using Google Translate (free API)
    """
    try:
        # Using Google Translate's free API endpoint
        url = "https://translate.googleapis.com/translate_a/single"
        params = {
            'client': 'gtx',
            'sl': source_lang,
            'tl': target_lang,
            'dt': 't',
            'q': text
        }
        
        response = requests.get(url, params=params, timeout=10)
        response.raise_for_status()
        
        # Parse the response
        data = response.json()
        if data and len(data) > 0 and len(data[0]) > 0:
            translated_text = data[0][0][0]
            return translated_text
        
    except Exception as e:
        print(f"Translation error for '{text}': {e}")
    
    return None

def get_language_code_mapping() -> Dict[str, str]:
    """Get mapping from our language codes to Google Translate codes."""
    return {
        'it': 'it',      # Italian
        'fr': 'fr',      # French
        'de': 'de',      # German
        'es': 'es',      # Spanish
        'he': 'iw',      # Hebrew (Google uses 'iw')
        'ar': 'ar',      # Arabic
        'ru': 'ru',      # Russian
        'zh': 'zh',      # Chinese Simplified
        'zh_Hant': 'zh-TW', # Chinese Traditional
        'ja': 'ja',      # Japanese
        'ko': 'ko',      # Korean
        'hi': 'hi',      # Hindi
        'ur': 'ur',      # Urdu
        'fa': 'fa',      # Persian
        'ha': 'ha',      # Hausa
        'pt': 'pt',      # Portuguese
        'nl': 'nl',      # Dutch
        'pl': 'pl',      # Polish
        'tr': 'tr',      # Turkish
        'el': 'el',      # Greek
        'cs': 'cs',      # Czech
        'sv': 'sv',      # Swedish
        'fi': 'fi',      # Finnish
        'ro': 'ro',      # Romanian
        'hu': 'hu',      # Hungarian
        'da': 'da',      # Danish
        'no': 'no',      # Norwegian
        'bg': 'bg',      # Bulgarian
        'th': 'th',      # Thai
        'uk': 'uk',      # Ukrainian
        'sr': 'sr',      # Serbian
        'ms': 'ms',      # Malay
        'vi': 'vi',      # Vietnamese
        'sk': 'sk',      # Slovak
        'id': 'id',      # Indonesian
        'lt': 'lt',      # Lithuanian
        'lv': 'lv',      # Latvian
        'et': 'et',      # Estonian
        'sl': 'sl',      # Slovenian
        'hr': 'hr',      # Croatian
        'ca': 'ca',      # Catalan
        'eu': 'eu',      # Basque
        'gl': 'gl',      # Galician
        'is': 'is',      # Icelandic
        'mt': 'mt',      # Maltese
        'sq': 'sq',      # Albanian
        'mk': 'mk',      # Macedonian
        'bs': 'bs',      # Bosnian
        'cy': 'cy',      # Welsh
        'ga': 'ga',      # Irish
        'fo': 'fo',      # Faroese
        'am': 'am',      # Amharic
        'bn': 'bn',      # Bengali
        'bn_BD': 'bn',   # Bengali (Bangladesh)
        'es_419': 'es',  # Spanish (Latin America)
        'pt_BR': 'pt',   # Portuguese (Brazil)
        'ur': 'ur',      # Urdu
    }

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

def translate_language_keys(language_code: str, missing_keys: Dict[str, str]) -> Dict[str, str]:
    """Translate missing keys for a language."""
    translations = {}
    language_mapping = get_language_code_mapping()
    
    if language_code not in language_mapping:
        print(f"  ⚠️  No translation mapping for {language_code}")
        return {}
    
    google_lang_code = language_mapping[language_code]
    print(f"  🔄 Translating {len(missing_keys)} keys to {language_code} ({google_lang_code})...")
    
    for i, (key, english_text) in enumerate(missing_keys.items(), 1):
        # Skip keys with placeholders or variables
        if '{' in english_text or '}' in english_text:
            translations[key] = english_text  # Keep as-is
            continue
            
        # Skip very short texts that might be technical terms
        if len(english_text.strip()) < 3:
            translations[key] = english_text
            continue
            
        translated = translate_with_google(english_text, google_lang_code)
        if translated:
            translations[key] = translated
            print(f"    ✅ {i}/{len(missing_keys)}: '{english_text}' -> '{translated}'")
        else:
            translations[key] = english_text  # Keep original if translation fails
            print(f"    ❌ {i}/{len(missing_keys)}: Failed to translate '{english_text}'")
        
        # Rate limiting to avoid being blocked
        time.sleep(0.5)
    
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
    """Main function to translate missing keys."""
    l10n_dir = "lib/l10n"
    english_arb = os.path.join(l10n_dir, "app_en.arb")
    
    if not os.path.exists(english_arb):
        print(f"English ARB file not found: {english_arb}")
        return
    
    # Get all ARB files
    arb_files = [f for f in os.listdir(l10n_dir) if f.startswith("app_") and f.endswith(".arb")]
    
    print(f"Found {len(arb_files)} ARB files")
    
    # Ask user which language to translate
    print("\nAvailable languages:")
    language_mapping = get_language_code_mapping()
    for i, (code, google_code) in enumerate(language_mapping.items(), 1):
        print(f"  {i:2d}. {code} ({google_code})")
    
    try:
        choice = input("\nEnter language code to translate (or 'all' for all languages): ").strip()
    except KeyboardInterrupt:
        print("\nCancelled.")
        return
    
    if choice.lower() == 'all':
        target_languages = list(language_mapping.keys())
    else:
        if choice not in language_mapping:
            print(f"Invalid language code: {choice}")
            return
        target_languages = [choice]
    
    for language_code in target_languages:
        arb_file = f"app_{language_code}.arb"
        if arb_file not in arb_files:
            print(f"  ⚠️  {language_code}: ARB file not found")
            continue
            
        arb_path = os.path.join(l10n_dir, arb_file)
        
        print(f"\n{'='*50}")
        print(f"Processing {language_code}...")
        print(f"{'='*50}")
        
        # Get missing keys
        missing_keys = get_missing_keys_for_language(arb_path, english_arb)
        
        if not missing_keys:
            print(f"  ✅ {language_code}: No missing keys")
            continue
        
        print(f"  ⚠️  {language_code}: {len(missing_keys)} missing keys")
        
        # Translate
        translations = translate_language_keys(language_code, missing_keys)
        
        if translations:
            # Update ARB file
            update_arb_file(arb_path, translations)
            print(f"  ✅ {language_code}: Updated with {len(translations)} translations")
        else:
            print(f"  ❌ {language_code}: No translations generated")

if __name__ == "__main__":
    main() 