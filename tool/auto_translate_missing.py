#!/usr/bin/env python3
"""
Script to automatically translate missing keys in ARB files
"""

import json
import time
import os
from pathlib import Path
from googletrans import Translator

ARB_DIR = Path('lib/l10n')
ENGLISH_FILE = ARB_DIR / 'app_en.arb'

# Languages that need translation work (based on the check)
LANGUAGES_TO_TRANSLATE = ['bn', 'bn_BD', 'ha', 'zh_Hant', 'ur', 'fo']

# Language code mapping for Google Translate
LANGUAGE_MAPPING = {
    'bn': 'bn',      # Bengali
    'bn_BD': 'bn',   # Bengali Bangladesh (same as Bengali)
    'ha': 'ha',      # Hausa
    'zh_Hant': 'zh-tw',  # Traditional Chinese
    'ur': 'ur',      # Urdu
    'fo': 'fo',      # Faroese
}

def load_arb_file(file_path):
    """Load and parse an ARB file."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except Exception as e:
        print(f"Error loading {file_path}: {e}")
        return {}

def translate_text(text, target_lang):
    """Translate text using Google Translate."""
    try:
        translator = Translator()
        result = translator.translate(text, dest=target_lang)
        return result.text
    except Exception as e:
        print(f"Translation error for '{text}': {e}")
        return text

def auto_translate_language(locale):
    """Auto-translate missing keys for a specific language."""
    print(f"\n🔄 Processing {locale}...")
    
    english_data = load_arb_file(ENGLISH_FILE)
    if not english_data:
        print(f"❌ Cannot load English ARB file")
        return
    
    arb_file = ARB_DIR / f'app_{locale}.arb'
    if not arb_file.exists():
        print(f"❌ ARB file not found: {arb_file}")
        return
    
    arb_data = load_arb_file(arb_file)
    if not arb_data:
        print(f"❌ Cannot load ARB file: {arb_file}")
        return
    
    english_keys = {k: v for k, v in english_data.items() if not k.startswith('@')}
    
    # Find keys that need translation (match English exactly)
    keys_to_translate = []
    for key, english_value in english_keys.items():
        if key in arb_data and arb_data[key] == english_value:
            keys_to_translate.append((key, english_value))
    
    if not keys_to_translate:
        print(f"✅ {locale}: No keys need translation")
        return
    
    print(f"📝 {locale}: Found {len(keys_to_translate)} keys to translate")
    
    # Get target language code
    target_lang = LANGUAGE_MAPPING.get(locale, locale)
    
    # Translate keys
    translated_count = 0
    for i, (key, english_value) in enumerate(keys_to_translate):
        print(f"  Translating {i+1}/{len(keys_to_translate)}: {key}")
        
        # Skip very short or technical keys
        if len(english_value) < 3 or english_value.isupper():
            print(f"    Skipping short/technical key: {english_value}")
            continue
        
        translated_text = translate_text(english_value, target_lang)
        if translated_text and translated_text != english_value:
            arb_data[key] = translated_text
            translated_count += 1
            print(f"    ✅ Translated: '{english_value}' → '{translated_text}'")
        else:
            print(f"    ⚠️  No translation found for: {english_value}")
        
        # Add delay to avoid rate limiting
        time.sleep(0.5)
    
    # Save updated ARB file
    try:
        with open(arb_file, 'w', encoding='utf-8') as f:
            json.dump(arb_data, f, indent=2, ensure_ascii=False)
        print(f"✅ {locale}: Translated {translated_count} keys, saved to {arb_file}")
    except Exception as e:
        print(f"❌ Error saving {arb_file}: {e}")

def main():
    """Main function."""
    print("🤖 Starting automatic translation for missing keys...")
    print(f"Target languages: {', '.join(LANGUAGES_TO_TRANSLATE)}")
    
    for locale in LANGUAGES_TO_TRANSLATE:
        auto_translate_language(locale)
    
    print("\n✅ Automatic translation completed!")

if __name__ == "__main__":
    main() 