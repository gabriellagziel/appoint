#!/usr/bin/env python3
"""
Analyze what's missing for perfect translations
"""

import json
import os
from pathlib import Path
from collections import defaultdict

ARB_DIR = Path('lib/l10n')
BASE_PREFIX = 'app_'

def analyze_missing_for_perfection():
    """Analyze what's missing to make translations perfect."""
    
    # Get all ARB files
    arb_files = list(ARB_DIR.glob(f"{BASE_PREFIX}*.arb"))
    
    # Load English as the reference
    en_file = ARB_DIR / 'app_en.arb'
    if not en_file.exists():
        print("❌ English file not found!")
        return
    
    with open(en_file, 'r', encoding='utf-8') as f:
        en_data = json.load(f)
    
    # Get all keys from English (excluding metadata and system admin)
    all_keys = []
    system_admin_keys = [
        'adminMetrics', 'adminFreeAccess', 'adminDashboard', 
        'adminSettings', 'admin', 'adminOverviewGoesHere'
    ]
    
    for key in en_data.keys():
        if not key.startswith('@') and key not in system_admin_keys:
            all_keys.append(key)
    
    total_keys = len(all_keys)
    print(f"📊 Translation Perfection Analysis")
    print(f"Total translatable keys: {total_keys}")
    print(f"System admin keys excluded: {len(system_admin_keys)}")
    print("=" * 60)
    
    # Analyze each language
    language_stats = {}
    missing_by_category = defaultdict(list)
    
    for arb_path in sorted(arb_files):
        if arb_path.name == 'app_en.arb':
            continue
            
        locale = arb_path.stem.replace(BASE_PREFIX, '')
        
        try:
            with open(arb_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
        except Exception as e:
            print(f"❌ Error loading {arb_path.name}: {e}")
            continue
        
        # Count translations
        translated = 0
        missing = 0
        empty = 0
        placeholder = 0
        
        missing_keys = []
        
        for key in all_keys:
            if key in data:
                value = data[key]
                if isinstance(value, str):
                    if value.strip() == "":
                        empty += 1
                        missing_keys.append(key)
                    elif value.startswith('[TODO') or value.startswith('TODO:') or value.startswith('[HI]') or value.startswith('[UR]') or value.startswith('[HA]') or value.startswith('[FA]') or value.startswith('[ES]') or value.startswith('[FR]') or value.startswith('[DE]'):
                        placeholder += 1
                        missing_keys.append(key)
                    else:
                        translated += 1
                else:
                    missing += 1
                    missing_keys.append(key)
            else:
                missing += 1
                missing_keys.append(key)
        
        total_missing = missing + empty + placeholder
        completion_rate = ((total_keys - total_missing) / total_keys) * 100
        
        language_stats[locale] = {
            'translated': translated,
            'missing': missing,
            'empty': empty,
            'placeholder': placeholder,
            'total_missing': total_missing,
            'completion_rate': completion_rate,
            'missing_keys': missing_keys
        }
        
        # Categorize missing keys
        for key in missing_keys:
            if 'auth' in key.lower():
                missing_by_category['Authentication'].append(key)
            elif 'error' in key.lower():
                missing_by_category['Error Messages'].append(key)
            elif 'playtime' in key.lower():
                missing_by_category['Playtime Features'].append(key)
            elif 'family' in key.lower():
                missing_by_category['Family Features'].append(key)
            elif 'notification' in key.lower():
                missing_by_category['Notifications'].append(key)
            elif 'meeting' in key.lower() or 'session' in key.lower():
                missing_by_category['Meetings/Sessions'].append(key)
            elif 'invite' in key.lower():
                missing_by_category['Invitations'].append(key)
            elif 'profile' in key.lower():
                missing_by_category['Profile/Settings'].append(key)
            else:
                missing_by_category['General UI'].append(key)
        
        status_icon = "✅" if completion_rate >= 90 else "🟡" if completion_rate >= 70 else "❌"
        print(f"{status_icon} {locale:6} | {translated:3} translated | {total_missing:3} missing | {completion_rate:5.1f}% complete")
    
    # Show what's missing by category
    print("\n" + "=" * 60)
    print("📋 MISSING TRANSLATIONS BY CATEGORY")
    print("=" * 60)
    
    for category, keys in missing_by_category.items():
        unique_keys = list(set(keys))
        print(f"\n🔍 {category} ({len(unique_keys)} unique keys)")
        print(f"   Missing in most languages: {', '.join(unique_keys[:10])}")
        if len(unique_keys) > 10:
            print(f"   ... and {len(unique_keys) - 10} more")
    
    # Show top missing keys across all languages
    print("\n" + "=" * 60)
    print("🎯 TOP MISSING KEYS (most frequently missing)")
    print("=" * 60)
    
    key_frequency = defaultdict(int)
    for stats in language_stats.values():
        for key in stats['missing_keys']:
            key_frequency[key] += 1
    
    top_missing = sorted(key_frequency.items(), key=lambda x: x[1], reverse=True)[:20]
    
    for key, count in top_missing:
        percentage = (count / len(language_stats)) * 100
        print(f"   {key}: {count}/{len(language_stats)} languages ({percentage:.1f}%)")
    
    # Recommendations
    print("\n" + "=" * 60)
    print("🚀 RECOMMENDATIONS FOR PERFECT TRANSLATIONS")
    print("=" * 60)
    
    print("\n1. 📝 **Priority Translation Categories:**")
    print("   - Authentication messages (login, signup, errors)")
    print("   - Error messages (most critical for user experience)")
    print("   - Core UI elements (buttons, labels, navigation)")
    
    print("\n2. 🌍 **Language Priority:**")
    print("   - Focus on languages with highest user base")
    print("   - Complete Spanish, French, German first (already started)")
    print("   - Then add Italian, Portuguese, Russian, Arabic")
    
    print("\n3. 🔧 **Technical Approach:**")
    print("   - Use translation APIs for bulk translation")
    print("   - Create translation modules for each language")
    print("   - Implement continuous translation workflow")
    
    print("\n4. 📊 **Current Status:**")
    print(f"   - {len(language_stats)} languages analyzed")
    print(f"   - {total_keys} translatable keys (excluding system admin)")
    print(f"   - Average completion: {sum(s['completion_rate'] for s in language_stats.values()) / len(language_stats):.1f}%")
    
    return language_stats, missing_by_category

if __name__ == '__main__':
    analyze_missing_for_perfection() 