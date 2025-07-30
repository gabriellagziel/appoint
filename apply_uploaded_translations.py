#!/usr/bin/env python3
"""
Apply uploaded translations to ARB files
This script reads the uploaded translation files and applies them to the corresponding ARB files.
"""

import json
import os
import importlib.util

class TranslationApplier:
    def __init__(self):
        self.translation_files = {
            'update_spanish_translations.py': 'es',
            'update_french_translations.py': 'fr', 
            'update_german_translations.py': 'de',
            'update_hausa_translations.py': 'ha',
            'update_hindi_translations.py': 'hi',
            'update_persian_translations.py': 'fa',
            'update_traditional_chinese_translations.py': 'zh_Hant',
            'update_urdu_translations.py': 'ur'
        }
        
    def load_python_translations(self, file_path: str) -> dict:
        """Load translations from a Python file"""
        try:
            spec = importlib.util.spec_from_file_location("translations", file_path)
            module = importlib.util.module_from_spec(spec)
            spec.loader.exec_module(module)
            
            # Look for different possible variable names
            for var_name in ['spanish_translations', 'french_translations', 'german_translations', 
                           'hausa_translations', 'hindi_translations', 'persian_translations',
                           'traditional_chinese_translations', 'urdu_translations', 'translations']:
                if hasattr(module, var_name):
                    return getattr(module, var_name)
                    
            # If no specific name found, look for any dict variable
            for attr_name in dir(module):
                if not attr_name.startswith('_'):
                    attr_value = getattr(module, attr_name)
                    if isinstance(attr_value, dict) and len(attr_value) > 10:  # Assume it's translations if it's a large dict
                        return attr_value
                        
        except Exception as e:
            print(f"Error loading {file_path}: {e}")
            
        return {}
    
    def load_arb_file(self, file_path: str) -> dict:
        """Load an ARB file"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                return json.load(f)
        except Exception as e:
            print(f"Error loading ARB file {file_path}: {e}")
            return {}
    
    def save_arb_file(self, file_path: str, content: dict):
        """Save content to ARB file"""
        try:
            with open(file_path, 'w', encoding='utf-8') as f:
                json.dump(content, f, indent=2, ensure_ascii=False)
        except Exception as e:
            print(f"Error saving ARB file {file_path}: {e}")
    
    def apply_translations_to_arb(self, translations: dict, arb_file: str, lang_code: str) -> int:
        """Apply translations to an ARB file"""
        # Load current ARB content
        arb_content = self.load_arb_file(arb_file)
        
        # Track changes
        applied_count = 0
        
        # Apply each translation
        for key, translation in translations.items():
            if key in arb_content:
                # Update existing key
                old_value = arb_content[key]
                arb_content[key] = translation
                if old_value != translation:
                    applied_count += 1
                    print(f"  Updated {key}: '{old_value}' -> '{translation}'")
            else:
                # Add new key
                arb_content[key] = translation
                applied_count += 1
                print(f"  Added {key}: '{translation}'")
        
        # Save the updated ARB file
        if applied_count > 0:
            self.save_arb_file(arb_file, arb_content)
            print(f"  ✅ Applied {applied_count} translations to {arb_file}")
        else:
            print(f"  ℹ️  No changes needed for {arb_file}")
            
        return applied_count
    
    def apply_all_translations(self):
        """Apply all uploaded translations to their corresponding ARB files"""
        total_applied = 0
        
        print("🚀 Applying uploaded translations to ARB files...")
        print("=" * 60)
        
        for python_file, lang_code in self.translation_files.items():
            if not os.path.exists(python_file):
                print(f"❌ {python_file} not found")
                continue
                
            print(f"\n📝 Processing {python_file} -> {lang_code}")
            
            # Load translations from Python file
            translations = self.load_python_translations(python_file)
            
            if not translations:
                print(f"  ⚠️  No translations found in {python_file}")
                continue
                
            print(f"  Found {len(translations)} translations")
            
            # Apply to ARB file
            arb_file = f"lib/l10n/app_{lang_code}.arb"
            
            if not os.path.exists(arb_file):
                print(f"  ⚠️  ARB file {arb_file} not found")
                continue
                
            applied = self.apply_translations_to_arb(translations, arb_file, lang_code)
            total_applied += applied
        
        print(f"\n🎉 TRANSLATION UPDATE COMPLETE!")
        print(f"Total translations applied: {total_applied}")
        print(f"Languages updated: {len([f for f in self.translation_files.keys() if os.path.exists(f)])}")
        
        return total_applied
    
    def generate_status_report(self):
        """Generate a status report after applying translations"""
        print("\n📊 Translation Status Report")
        print("=" * 40)
        
        # Check English reference
        en_file = "lib/l10n/app_en.arb"
        en_content = self.load_arb_file(en_file)
        
        # Count translatable keys (exclude admin and metadata)
        admin_keys = {'adminBroadcast', 'playtimeAdminPanelTitle', 'adminScreenTBD', 'adminMetrics', 
                     'adminFreeAccess', 'adminDashboard', 'adminSettings', 'adminLogadminemail', 
                     'admin', 'adminOverviewGoesHere'}
        
        translatable_keys = set()
        for key, value in en_content.items():
            if not key.startswith('@') and key not in admin_keys and isinstance(value, str):
                translatable_keys.add(key)
        
        print(f"Total translatable keys: {len(translatable_keys)}")
        print()
        
        # Check status of updated languages
        for python_file, lang_code in self.translation_files.items():
            if os.path.exists(python_file):
                arb_file = f"lib/l10n/app_{lang_code}.arb"
                if os.path.exists(arb_file):
                    arb_content = self.load_arb_file(arb_file)
                    
                    # Count actual translations
                    translated_count = 0
                    for key in translatable_keys:
                        if key in arb_content:
                            value = arb_content[key]
                            # Check if it's properly translated (not placeholder)
                            if value and not value.startswith(f'[{lang_code.upper()}]') and value != key:
                                translated_count += 1
                    
                    completion = (translated_count / len(translatable_keys)) * 100
                    status = "✅" if completion > 90 else "⚠️" if completion > 50 else "📝"
                    
                    print(f"{status} {lang_code}: {translated_count}/{len(translatable_keys)} ({completion:.1f}%)")

def main():
    applier = TranslationApplier()
    
    print("🌐 APP-OINT Translation Applier")
    print("=" * 50)
    
    # Apply all translations
    total_applied = applier.apply_all_translations()
    
    # Generate status report
    applier.generate_status_report()
    
    if total_applied > 0:
        print("\n✅ SUCCESS: Uploaded translations have been applied!")
        print("🔄 The translation files have been updated with the uploaded content.")
    else:
        print("\n⚠️  No translations were applied. Please check the files.")

if __name__ == "__main__":
    main()