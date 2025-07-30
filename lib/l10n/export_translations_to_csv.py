#!/usr/bin/env python3
"""
ARB to CSV Translation Export Script
====================================

This script exports all ARB translation files to a single CSV file.
Each row represents a translation key, each column represents a language.

Usage:
    python export_translations_to_csv.py

Output:
    - translations_export.csv (complete translation matrix)
    - translations_summary.txt (translation completion report)
"""

import json
import csv
import os
import glob
from collections import defaultdict
from datetime import datetime

def load_arb_file(file_path):
    """Load and parse an ARB file."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            # Remove comments and clean up
            lines = content.split('\n')
            cleaned_lines = []
            for line in lines:
                line = line.strip()
                if line and not line.startswith('//') and not line.startswith('/*'):
                    cleaned_lines.append(line)
            
            # Reconstruct JSON
            json_content = '\n'.join(cleaned_lines)
            return json.loads(json_content)
    except Exception as e:
        print(f"Error loading {file_path}: {e}")
        return {}

def get_language_code(filename):
    """Extract language code from ARB filename."""
    # Remove 'app_' prefix and '.arb' suffix
    return filename.replace('app_', '').replace('.arb', '')

def get_language_name(code):
    """Get human-readable language name from code."""
    language_names = {
        'am': 'Amharic',
        'ar': 'Arabic',
        'bg': 'Bulgarian',
        'bn': 'Bengali',
        'bn_BD': 'Bengali (Bangladesh)',
        'bs': 'Bosnian',
        'ca': 'Catalan',
        'cs': 'Czech',
        'cy': 'Welsh',
        'da': 'Danish',
        'de': 'German',
        'en': 'English',
        'es': 'Spanish',
        'es_419': 'Spanish (Latin America)',
        'et': 'Estonian',
        'eu': 'Basque',
        'fa': 'Persian',
        'fi': 'Finnish',
        'fo': 'Faroese',
        'fr': 'French',
        'ga': 'Irish',
        'gl': 'Galician',
        'ha': 'Hausa',
        'he': 'Hebrew',
        'hi': 'Hindi',
        'hr': 'Croatian',
        'hu': 'Hungarian',
        'id': 'Indonesian',
        'is': 'Icelandic',
        'it': 'Italian',
        'ja': 'Japanese',
        'ko': 'Korean',
        'lt': 'Lithuanian',
        'lv': 'Latvian',
        'mk': 'Macedonian',
        'ms': 'Malay',
        'mt': 'Maltese',
        'nl': 'Dutch',
        'no': 'Norwegian',
        'pl': 'Polish',
        'pt': 'Portuguese',
        'pt_BR': 'Portuguese (Brazil)',
        'ro': 'Romanian',
        'ru': 'Russian',
        'sk': 'Slovak',
        'sl': 'Slovenian',
        'sq': 'Albanian',
        'sr': 'Serbian',
        'sv': 'Swedish',
        'th': 'Thai',
        'tr': 'Turkish',
        'uk': 'Ukrainian',
        'ur': 'Urdu',
        'vi': 'Vietnamese',
        'zh': 'Chinese (Simplified)',
        'zh_Hant': 'Chinese (Traditional)'
    }
    return language_names.get(code, code)

def extract_translations(arb_data):
    """Extract translation key-value pairs from ARB data."""
    translations = {}
    for key, value in arb_data.items():
        if isinstance(value, str) and not key.startswith('@'):
            translations[key] = value
    return translations

def main():
    print("🔄 Starting ARB to CSV export...")
    
    # Find all ARB files
    arb_files = glob.glob('app_*.arb')
    arb_files.sort()
    
    if not arb_files:
        print("❌ No ARB files found!")
        return
    
    print(f"📁 Found {len(arb_files)} ARB files")
    
    # Load all translations
    all_translations = {}
    language_codes = []
    translation_stats = {}
    
    for arb_file in arb_files:
        lang_code = get_language_code(arb_file)
        language_codes.append(lang_code)
        
        print(f"📖 Loading {lang_code} ({get_language_name(lang_code)})...")
        
        arb_data = load_arb_file(arb_file)
        translations = extract_translations(arb_data)
        
        all_translations[lang_code] = translations
        translation_stats[lang_code] = len(translations)
    
    # Get all unique keys
    all_keys = set()
    for translations in all_translations.values():
        all_keys.update(translations.keys())
    
    all_keys = sorted(list(all_keys))
    print(f"🔑 Found {len(all_keys)} unique translation keys")
    
    # Create CSV file
    csv_filename = 'translations_export.csv'
    print(f"💾 Creating CSV file: {csv_filename}")
    
    with open(csv_filename, 'w', newline='', encoding='utf-8') as csvfile:
        # Create header row
        header = ['key', 'description'] + [f'{code} ({get_language_name(code)})' for code in language_codes]
        writer = csv.writer(csvfile)
        writer.writerow(header)
        
        # Write translation rows
        for key in all_keys:
            row = [key, f'Translation key: {key}']
            
            for lang_code in language_codes:
                translation = all_translations[lang_code].get(key, '')
                # Clean up translation for CSV
                if isinstance(translation, str):
                    # Escape quotes and handle newlines
                    translation = translation.replace('"', '""').replace('\n', '\\n')
                row.append(translation)
            
            writer.writerow(row)
    
    # Create summary report
    summary_filename = 'translations_summary.txt'
    print(f"📊 Creating summary report: {summary_filename}")
    
    with open(summary_filename, 'w', encoding='utf-8') as summary_file:
        summary_file.write("TRANSLATION EXPORT SUMMARY\n")
        summary_file.write("=" * 50 + "\n")
        summary_file.write(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
        summary_file.write(f"Total languages: {len(language_codes)}\n")
        summary_file.write(f"Total keys: {len(all_keys)}\n\n")
        
        summary_file.write("LANGUAGE COMPLETION STATS:\n")
        summary_file.write("-" * 30 + "\n")
        
        # Sort by completion percentage
        completion_stats = []
        for lang_code in language_codes:
            count = translation_stats[lang_code]
            percentage = (count / len(all_keys)) * 100
            completion_stats.append((lang_code, count, percentage))
        
        completion_stats.sort(key=lambda x: x[2], reverse=True)
        
        for lang_code, count, percentage in completion_stats:
            lang_name = get_language_name(lang_code)
            summary_file.write(f"{lang_code:8} ({lang_name:20}): {count:3d}/{len(all_keys)} ({percentage:5.1f}%)\n")
        
        summary_file.write(f"\nEXPORT FILES:\n")
        summary_file.write(f"- {csv_filename}: Complete translation matrix\n")
        summary_file.write(f"- {summary_filename}: This summary report\n")
        
        summary_file.write(f"\nUSAGE INSTRUCTIONS:\n")
        summary_file.write(f"1. Open {csv_filename} in Excel or Google Sheets\n")
        summary_file.write(f"2. Each row is a translation key\n")
        summary_file.write(f"3. Each column is a language\n")
        summary_file.write(f"4. Fill in missing translations\n")
        summary_file.write(f"5. Save and use import script to update ARB files\n")
    
    print(f"✅ Export completed successfully!")
    print(f"📄 CSV file: {csv_filename}")
    print(f"📊 Summary: {summary_filename}")
    print(f"\n📈 Translation completion:")
    
    # Show top 10 languages by completion
    for i, (lang_code, count, percentage) in enumerate(completion_stats[:10]):
        lang_name = get_language_name(lang_code)
        print(f"   {i+1:2d}. {lang_code:8} ({lang_name:20}): {percentage:5.1f}%")
    
    print(f"\n💡 Next steps:")
    print(f"   1. Open {csv_filename} in Excel/Google Sheets")
    print(f"   2. Fill in missing translations")
    print(f"   3. Use import script to update ARB files")

if __name__ == "__main__":
    main() 