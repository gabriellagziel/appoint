#!/usr/bin/env python3
"""
Translation Script for APP-OINT
Identifies missing translations and starts translating needed text for user and business interfaces.
"""

import json
import glob
import os
from typing import Dict, List, Set

class TranslationManager:
    def __init__(self):
        # Admin keys that should NOT be translated
        self.admin_keys = {
            'adminBroadcast', 'playtimeAdminPanelTitle', 'adminScreenTBD', 'adminMetrics',
            'adminFreeAccess', 'adminDashboard', 'adminSettings', 'adminLogadminemail',
            'admin', 'adminOverviewGoesHere'
        }
        
        # Technical keys that should generally stay in English
        self.technical_keys = {
            'fcmToken', 'authErrorAppNotAuthorized', 'authErrorInvalidIdToken',
            'authErrorIdTokenExpired', 'authErrorIdTokenRevoked', 'authErrorInvalidContinueUri',
            'REDACTED_TOKEN', 'authErrorInvalidHashKey',
            'authErrorInvalidPageToken', 'authErrorMissingContinueUri',
            'REDACTED_TOKEN', 'authErrorProjectNotFound',
            'REDACTED_TOKEN'
        }
        
        # Languages that need translation
        self.target_languages = [
            'ar', 'es', 'fr', 'de', 'zh', 'zh_Hant', 'ja', 'ko', 'pt', 'pt_BR',
            'ru', 'it', 'nl', 'sv', 'no', 'da', 'fi', 'pl', 'cs', 'hu', 'ro',
            'bg', 'hr', 'sr', 'sk', 'sl', 'et', 'lv', 'lt', 'el', 'tr', 'he',
            'fa', 'ur', 'hi', 'bn', 'ta', 'gu', 'mr', 'kn', 'th', 'vi', 'id',
            'ms', 'tl', 'sw', 'ha', 'am', 'si', 'ne', 'uk', 'cy', 'mk', 'mt', 'zu'
        ]
        
    def load_arb_file(self, file_path: str) -> Dict:
        """Load an ARB file"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                return json.load(f)
        except Exception as e:
            print(f"Error loading {file_path}: {e}")
            return {}
    
    def save_arb_file(self, file_path: str, content: Dict):
        """Save ARB file with proper formatting"""
        try:
            with open(file_path, 'w', encoding='utf-8') as f:
                json.dump(content, f, indent=2, ensure_ascii=False)
        except Exception as e:
            print(f"Error saving {file_path}: {e}")
    
    def get_translatable_keys(self) -> Dict[str, str]:
        """Get all keys that should be translated (exclude admin and technical)"""
        en_content = self.load_arb_file('lib/l10n/app_en.arb')
        translatable_keys = {}
        
        for key, value in en_content.items():
            if (not key.startswith('@') and 
                key not in self.admin_keys and 
                key not in self.technical_keys and
                isinstance(value, str)):
                translatable_keys[key] = value
        
        return translatable_keys
    
    def analyze_missing_translations(self) -> Dict[str, List[str]]:
        """Analyze what translations are missing for each language"""
        translatable_keys = self.get_translatable_keys()
        missing_by_language = {}
        
        for lang_code in self.target_languages:
            lang_file = f'lib/l10n/app_{lang_code}.arb'
            if os.path.exists(lang_file):
                lang_content = self.load_arb_file(lang_file)
                missing_keys = []
                
                for key in translatable_keys:
                    if key not in lang_content:
                        missing_keys.append(key)
                
                missing_by_language[lang_code] = missing_keys
            else:
                # Language file doesn't exist, all keys are missing
                missing_by_language[lang_code] = list(translatable_keys.keys())
        
        return missing_by_language
    
    def categorize_missing_keys(self, missing_keys: List[str]) -> Dict[str, List[str]]:
        """Categorize missing keys by type"""
        categories = {
            'user_facing': [],
            'business_facing': [],
            'common_ui': [],
            'other': []
        }
        
        business_terms = ['studio', 'business', 'provider', 'billing', 'subscription', 'client', 'service']
        user_terms = ['profile', 'family', 'child', 'reward', 'referral', 'booking', 'appointment', 'calendar']
        ui_terms = ['button', 'screen', 'title', 'label', 'message', 'welcome', 'home', 'settings']
        
        for key in missing_keys:
            key_lower = key.lower()
            
            if any(term in key_lower for term in business_terms):
                categories['business_facing'].append(key)
            elif any(term in key_lower for term in user_terms):
                categories['user_facing'].append(key)
            elif any(term in key_lower for term in ui_terms):
                categories['common_ui'].append(key)
            else:
                categories['other'].append(key)
        
        return categories
    
    def generate_translation_report(self):
        """Generate a comprehensive translation status report"""
        translatable_keys = self.get_translatable_keys()
        missing_by_language = self.analyze_missing_translations()
        
        print("🔍 Translation Status Report")
        print("=" * 60)
        print(f"Total translatable keys: {len(translatable_keys)}")
        print(f"Languages to translate: {len(self.target_languages)}")
        print()
        
        # Overall statistics
        total_missing = sum(len(missing) for missing in missing_by_language.values())
        total_possible = len(translatable_keys) * len(self.target_languages)
        completion_rate = ((total_possible - total_missing) / total_possible) * 100
        
        print(f"Overall completion: {completion_rate:.1f}%")
        print(f"Total missing translations: {total_missing}")
        print()
        
        # Language-specific status
        print("📊 Translation Status by Language:")
        for lang_code in sorted(self.target_languages):
            missing_count = len(missing_by_language.get(lang_code, []))
            completed = len(translatable_keys) - missing_count
            completion = (completed / len(translatable_keys)) * 100
            status = "✅" if completion > 90 else "⚠️" if completion > 50 else "❌"
            
            print(f"{status} {lang_code}: {completed}/{len(translatable_keys)} ({completion:.1f}%)")
        
        print()
        
        # Sample missing keys analysis
        if missing_by_language:
            sample_lang = list(missing_by_language.keys())[0]
            sample_missing = missing_by_language[sample_lang]
            categories = self.categorize_missing_keys(sample_missing)
            
            print(f"📋 Missing Key Categories (sample from {sample_lang}):")
            for category, keys in categories.items():
                if keys:
                    print(f"  {category}: {len(keys)} keys")
                    for key in keys[:3]:  # Show first 3 examples
                        print(f"    - {key}")
                    if len(keys) > 3:
                        print(f"    ... and {len(keys) - 3} more")
            print()
        
        return missing_by_language
    
    def start_translation_process(self):
        """Start the translation process for missing keys"""
        print("🚀 Starting Translation Process")
        print("=" * 40)
        
        # Get missing translations
        missing_by_language = self.analyze_missing_translations()
        
        # Priority languages (most commonly used)
        priority_languages = ['es', 'fr', 'de', 'zh', 'ja', 'ko', 'pt', 'ru', 'it', 'ar']
        
        print("🎯 Translation Priority:")
        print("1. Priority languages (most common): es, fr, de, zh, ja, ko, pt, ru, it, ar")
        print("2. All other languages")
        print()
        
        # Start with priority languages
        for lang_code in priority_languages:
            if lang_code in missing_by_language:
                missing_keys = missing_by_language[lang_code]
                if missing_keys:
                    print(f"📝 {lang_code}: {len(missing_keys)} keys need translation")
                    
                    # Categorize missing keys
                    categories = self.categorize_missing_keys(missing_keys)
                    
                    # Show what needs to be translated
                    for category, keys in categories.items():
                        if keys:
                            print(f"  {category}: {len(keys)} keys")
        
        print()
        print("💡 Next Steps:")
        print("1. Use professional translation services for priority languages")
        print("2. Focus on user_facing and business_facing categories first")
        print("3. Validate translations with native speakers")
        print("4. Test UI layout with longer translated text")
        print("5. Use automation tools for remaining languages")
        
        return missing_by_language

def main():
    manager = TranslationManager()
    
    print("🌐 APP-OINT Translation Manager")
    print("=" * 50)
    
    # Generate status report
    missing_translations = manager.generate_translation_report()
    
    # Start translation process
    manager.start_translation_process()
    
    print("\n📋 Summary:")
    print("- Translation gaps identified")
    print("- Priority languages highlighted")
    print("- Ready to start professional translation")
    print("- User and business text prioritized")
    
    return missing_translations

if __name__ == "__main__":
    main() 