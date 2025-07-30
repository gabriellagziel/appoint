#!/usr/bin/env python3
"""
Script to achieve 100% translation coverage for all languages
"""

import json
import time
import os
from pathlib import Path
from googletrans import Translator

ARB_DIR = Path('lib/l10n')
ENGLISH_FILE = ARB_DIR / 'app_en.arb'

# Language code mapping for Google Translate
LANGUAGE_MAPPING = {
    'ar': 'ar',      # Arabic
    'am': 'am',      # Amharic
    'bg': 'bg',      # Bulgarian
    'bs': 'bs',      # Bosnian
    'ca': 'ca',      # Catalan
    'cs': 'cs',      # Czech
    'cy': 'cy',      # Welsh
    'da': 'da',      # Danish
    'de': 'de',      # German
    'es': 'es',      # Spanish
    'es_419': 'es',  # Spanish Latin America
    'et': 'et',      # Estonian
    'eu': 'eu',      # Basque
    'fa': 'fa',      # Persian
    'fi': 'fi',      # Finnish
    'fo': 'fo',      # Faroese
    'fr': 'fr',      # French
    'ga': 'ga',      # Irish
    'gl': 'gl',      # Galician
    'he': 'he',      # Hebrew
    'hi': 'hi',      # Hindi
    'hr': 'hr',      # Croatian
    'hu': 'hu',      # Hungarian
    'id': 'id',      # Indonesian
    'is': 'is',      # Icelandic
    'it': 'it',      # Italian
    'ja': 'ja',      # Japanese
    'ko': 'ko',      # Korean
    'lt': 'lt',      # Lithuanian
    'lv': 'lv',      # Latvian
    'mk': 'mk',      # Macedonian
    'ms': 'ms',      # Malay
    'mt': 'mt',      # Maltese
    'nl': 'nl',      # Dutch
    'no': 'no',      # Norwegian
    'pl': 'pl',      # Polish
    'pt': 'pt',      # Portuguese
    'pt_BR': 'pt',   # Portuguese Brazil
    'ro': 'ro',      # Romanian
    'ru': 'ru',      # Russian
    'sk': 'sk',      # Slovak
    'sl': 'sl',      # Slovenian
    'sq': 'sq',      # Albanian
    'sr': 'sr',      # Serbian
    'sv': 'sv',      # Swedish
    'th': 'th',      # Thai
    'tr': 'tr',      # Turkish
    'uk': 'uk',      # Ukrainian
    'ur': 'ur',      # Urdu
    'vi': 'vi',      # Vietnamese
    'zh': 'zh-cn',   # Chinese Simplified
    'zh_Hant': 'zh-tw',  # Chinese Traditional
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

def REDACTED_TOKEN(locale):
    """Complete translation for a specific language."""
    print(f"\n🔄 Processing {locale} for 100% completion...")
    
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
        print(f"✅ {locale}: Already 100% translated!")
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
        time.sleep(0.3)
    
    # Save updated ARB file
    try:
        with open(arb_file, 'w', encoding='utf-8') as f:
            json.dump(arb_data, f, indent=2, ensure_ascii=False)
        print(f"✅ {locale}: Translated {translated_count} keys, saved to {arb_file}")
    except Exception as e:
        print(f"❌ Error saving {arb_file}: {e}")

def main():
    """Main function."""
    print("🎯 Starting 100% translation completion for ALL languages...")
    
    # Get all ARB files except English
    arb_files = list(ARB_DIR.glob('app_*.arb'))
    languages = []
    
    for arb_file in arb_files:
        if arb_file.name != 'app_en.arb':
            locale = arb_file.stem.replace('app_', '')
            languages.append(locale)
    
    print(f"Found {len(languages)} languages to process:")
    print(", ".join(languages))
    print()
    
    # Process each language
    for locale in languages:
        REDACTED_TOKEN(locale)
    
    print("\n🎉 100% translation completion process finished!")
    print("Run the check script to verify all languages are now at 100%")

if __name__ == "__main__":
    main() 