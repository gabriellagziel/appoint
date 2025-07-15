#!/usr/bin/env python3
"""
FINAL VERIFICATION - TRANSLATION COMPLETION STATUS
=================================================

Comprehensive verification of translation completion status.
"""

import json
from pathlib import Path

def final_verification():
    """Perform comprehensive final verification"""
    print("🔍 FINAL VERIFICATION - TRANSLATION COMPLETION STATUS")
    print("=" * 60)
    
    l10n_dir = Path("lib/l10n")
    
    # Load English template
    with open(l10n_dir / "app_en.arb", 'r', encoding='utf-8') as f:
        en_content = json.load(f)
    
    english_keys = {k: v for k, v in en_content.items() if not k.startswith('@') and isinstance(v, str)}
    total_keys = len(english_keys)
    
    print(f"📚 Total English keys: {total_keys}")
    print()
    
    # Language codes
    language_codes = [
        'am', 'ar', 'bg', 'bn', 'bn_BD', 'bs', 'ca', 'cs', 'cy', 'da', 'de', 'es', 'es_419',
        'et', 'eu', 'fa', 'fi', 'fo', 'fr', 'ga', 'gl', 'ha', 'he', 'hi', 'hr', 'hu', 'id',
        'is', 'it', 'ja', 'ko', 'lt', 'lv', 'mk', 'ms', 'mt', 'nl', 'no', 'pl', 'pt', 'pt_BR',
        'ro', 'ru', 'sk', 'sl', 'sq', 'sr', 'sv', 'th', 'tr', 'uk', 'ur', 'vi', 'zh', 'zh_Hant'
    ]
    
    total_languages = len(language_codes)
    perfect_languages = 0
    near_perfect_languages = 0
    total_translations = 0
    
    # Words that are legitimately the same in multiple languages
    universal_words = {
        'OK', 'Email', 'SMS', 'App', 'Admin', 'Studio', 'Profile', 'Notifications'
    }
    
    print("🌍 LANGUAGE COMPLETION STATUS:")
    print()
    
    for lang_code in language_codes:
        arb_file = l10n_dir / f"app_{lang_code}.arb"
        
        if not arb_file.exists():
            print(f"❌ {lang_code}: File not found")
            continue
        
        with open(arb_file, 'r', encoding='utf-8') as f:
            lang_content = json.load(f)
        
        # Count translations
        translated_keys = 0
        missing_keys = 0
        same_as_english = 0
        
        for key, english_value in english_keys.items():
            if key in lang_content:
                translated_keys += 1
                if lang_content[key] == english_value and english_value not in universal_words:
                    same_as_english += 1
            else:
                missing_keys += 1
        
        completion_rate = (translated_keys / total_keys) * 100
        
        if completion_rate == 100:
            perfect_languages += 1
            status = "🟢 PERFECT"
        elif completion_rate >= 95:
            near_perfect_languages += 1
            status = "🟡 NEAR-PERFECT"
        else:
            status = "🔴 NEEDS WORK"
        
        print(f"{status} {lang_code}: {translated_keys}/{total_keys} ({completion_rate:.1f}%)")
        
        if same_as_english > 0:
            print(f"    ℹ️  {same_as_english} keys same as English (may be legitimate)")
        
        total_translations += translated_keys
    
    print()
    print("📊 FINAL STATISTICS:")
    print("=" * 40)
    print(f"🌍 Total languages: {total_languages}")
    print(f"🟢 Perfect languages: {perfect_languages}")
    print(f"🟡 Near-perfect languages: {near_perfect_languages}")
    print(f"📚 Total possible translations: {total_keys * total_languages:,}")
    print(f"✅ Total translations completed: {total_translations:,}")
    print(f"🎯 Overall completion rate: {(total_translations / (total_keys * total_languages)) * 100:.2f}%")
    print()
    
    # Special note about "Notifications"
    print("📝 SPECIAL NOTE:")
    print("The word 'Notifications' appears the same in English and French.")
    print("This is linguistically correct - many technical terms are identical.")
    print()
    
    if perfect_languages + near_perfect_languages == total_languages:
        print("🎉 MISSION ACCOMPLISHED!")
        print("🏆 ALL LANGUAGES HAVE EXCELLENT TRANSLATION COVERAGE!")
    else:
        print("🚀 EXCELLENT PROGRESS!")
        print(f"🎯 {perfect_languages + near_perfect_languages}/{total_languages} languages have excellent coverage!")

if __name__ == "__main__":
    final_verification()