#!/usr/bin/env python3
"""
Final script to achieve 100% translation coverage for ALL languages
"""

import json
import time
import os
from pathlib import Path
from googletrans import Translator

ARB_DIR = Path('lib/l10n')
ENGLISH_FILE = ARB_DIR / 'app_en.arb'

# Language code mapping with fallbacks
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
    'fo': 'da',      # Faroese -> Danish (closest available)
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
    'bn': 'bn',      # Bengali
    'bn_BD': 'bn',   # Bengali Bangladesh
    'ha': 'ha',      # Hausa
}

def load_arb_file(file_path):
    """Load and parse an ARB file."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except Exception as e:
        print(f"Error loading {file_path}: {e}")
        return {}

def translate_text(text, target_lang, translator):
    """Translate text with error handling and retries."""
    if not text or len(text.strip()) < 2:
        return text
    
    # Skip technical/short keys
    if text.upper() in ['OK', 'NO', 'YES', 'CRM', 'APP-OINT']:
        return text
    
    # Skip keys with only placeholders
    if all(c in '{}_0123456789' for c in text.replace(' ', '')):
        return text
    
    max_retries = 3
    for attempt in range(max_retries):
        try:
            # Use the mapped language code
            lang_code = LANGUAGE_MAPPING.get(target_lang, target_lang)
            result = translator.translate(text, dest=lang_code)
            
            if result and result.text:
                return result.text
            else:
                print(f"    ⚠️  Empty translation for: {text}")
                return text
                
        except Exception as e:
            if attempt < max_retries - 1:
                print(f"    ⚠️  Translation attempt {attempt + 1} failed: {e}")
                time.sleep(2)  # Wait before retry
            else:
                print(f"    ❌ Translation failed after {max_retries} attempts: {text}")
                return text
    
    return text

def complete_translations():
    """Complete all missing translations to achieve 100% coverage."""
    print("🎯 FINAL PUSH: Achieving 100% translation coverage for ALL languages...")
    
    english_data = load_arb_file(ENGLISH_FILE)
    if not english_data:
        print("❌ Cannot load English ARB file")
        return
    
    english_keys = {k: v for k, v in english_data.items() if not k.startswith('@')}
    translator = Translator()
    
    # Get all language files
    arb_files = list(ARB_DIR.glob('app_*.arb'))
    arb_files = [f for f in arb_files if f.name != 'app_en.arb']
    
    print(f"Found {len(arb_files)} languages to process")
    
    for arb_file in arb_files:
        lang_code = arb_file.stem.replace('app_', '')
        print(f"\n🔄 Processing {lang_code} for 100% completion...")
        
        lang_data = load_arb_file(arb_file)
        if not lang_data:
            continue
        
        # Find missing translations
        missing_keys = []
        for key, english_value in english_keys.items():
            if key not in lang_data or lang_data[key] == english_value:
                missing_keys.append((key, english_value))
        
        if not missing_keys:
            print(f"✅ {lang_code}: Already 100% translated!")
            continue
        
        print(f"📝 {lang_code}: Found {len(missing_keys)} keys to translate")
        
        # Translate missing keys
        translated_count = 0
        for i, (key, english_value) in enumerate(missing_keys, 1):
            print(f"  Translating {i}/{len(missing_keys)}: {key}")
            
            translated_value = translate_text(english_value, lang_code, translator)
            
            if translated_value and translated_value != english_value:
                lang_data[key] = translated_value
                translated_count += 1
                print(f"    ✅ Translated: '{english_value}' → '{translated_value}'")
            else:
                print(f"    ⚠️  No translation found for: {english_value}")
            
            # Rate limiting
            time.sleep(0.5)
        
        # Save updated file
        try:
            with open(arb_file, 'w', encoding='utf-8') as f:
                json.dump(lang_data, f, ensure_ascii=False, indent=2)
            print(f"✅ {lang_code}: Translated {translated_count} keys, saved to {arb_file}")
        except Exception as e:
            print(f"❌ Error saving {arb_file}: {e}")
    
    print("\n🎉 FINAL 100% translation completion process finished!")
    print("Run the check script to verify all languages are now at 100%")

if __name__ == "__main__":
    complete_translations() 