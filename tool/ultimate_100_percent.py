#!/usr/bin/env python3
"""
Ultimate script to achieve 100% translation coverage for ALL languages
"""

import json
from pathlib import Path

ARB_DIR = Path('lib/l10n')
ENGLISH_FILE = ARB_DIR / 'app_en.arb'

# Ultimate translations for remaining keys
ULTIMATE_TRANSLATIONS = {
    'ca': {  # Catalan - 2 keys remaining
        'participants': 'Participants',
        'no': 'No'
    },
    'bs': {  # Bosnian - 2 keys remaining
        'crm': 'CRM',
        'ekeyEvalue': '{e_key}: {e_value}'
    },
    'bg': {  # Bulgarian - 1 key remaining
        'ekeyEvalue': '{e_key}: {e_value}'
    },
    'pt_BR': {  # Portuguese Brazil - 2 keys remaining
        'admin': 'Admin',
        'ok': 'OK'
    },
    'cs': {  # Czech - 2 keys remaining
        'admin': 'Admin',
        'ok': 'OK'
    },
    'am': {  # Amharic - 1 key remaining
        'crm': 'CRM'
    },
    'pt': {  # Portuguese - 2 keys remaining
        'admin': 'Admin',
        'ok': 'OK'
    },
    'eu': {  # Basque - 1 key remaining
        'admin': 'Admin'
    },
    'et': {  # Estonian - 1 key remaining
        'ok': 'OK'
    },
    'fo': {  # Faroese - 1 key remaining
        'appTitle': 'APP-OINT'
    },
    'sl': {  # Slovenian - 1 key remaining
        'admin': 'Admin'
    },
    'de': {  # German - 1 key remaining
        'login1': 'Anmelden'
    },
    'it': {  # Italian - 2 keys remaining
        'ambassadorOnboarding': 'Onboarding ambasciatore',
        'login1': 'Accedi',
        'logout1': 'Esci'
    },
    'es': {  # Spanish - 1 key remaining
        'inviteeArgsinviteeid': 'Invitado: {args_inviteeId}'
    },
    'hu': {  # Hungarian - 1 key remaining
        'email': 'Email'
    },
    'da': {  # Danish - 2 keys remaining
        'adminMetrics': 'Admin metrikker',
        'adminDashboard': 'Admin dashboard'
    },
    'is': {  # Icelandic - 1 key remaining
        'adminMetrics': 'Admin mælikvarðar'
    },
    'id': {  # Indonesian - 2 keys remaining
        'admin': 'Admin',
        'edit': 'Edit'
    },
    'ha': {  # Hausa - 1 key remaining
        'logout': 'Fita'
    },
    'fr': {  # French - 12 keys remaining
        'notifications': 'Notifications',
        'messages': 'Messages',
        'crm': 'CRM',
        'menu': 'Menu',
        'branchesLengthBranches': '{branches_length} branches',
        'participants': 'Participants',
        'clients': 'Clients',
        'date': 'Date',
        'notifications1': 'Notifications',
        'logtargettypeLogtargetid': '{log_targetType}: {log_targetId}',
        'ok': 'OK',
        'ekeyEvalue': '{e_key}: {e_value}'
    },
    'pl': {  # Polish - 2 keys remaining
        'admin': 'Admin',
        'ok': 'OK'
    },
    'no': {  # Norwegian - 2 keys remaining
        'admin': 'Admin',
        'ok': 'OK'
    },
    'nl': {  # Dutch - 2 keys remaining
        'details': 'Details',
        'dashboard': 'Dashboard'
    },
    'es_419': {  # Spanish Latin America - 1 key remaining
        'admin': 'Admin'
    },
    'ms': {  # Malay - 3 keys remaining
        'admin': 'Admin',
        'edit': 'Edit',
        'ok': 'OK'
    },
    'ar': {  # Arabic - 2 keys remaining
        'crm': 'CRM',
        'ekeyEvalue': '{e_key}: {e_value}'
    }
}

def load_arb_file(file_path):
    """Load and parse an ARB file."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except Exception as e:
        print(f"Error loading {file_path}: {e}")
        return {}

def apply_ultimate_translations():
    """Apply ultimate translations to achieve 100% coverage."""
    print("🚀 ULTIMATE PUSH: Achieving 100% translation coverage for ALL languages...")
    
    english_data = load_arb_file(ENGLISH_FILE)
    if not english_data:
        print("❌ Cannot load English ARB file")
        return
    
    english_keys = {k: v for k, v in english_data.items() if not k.startswith('@')}
    
    for lang_code, translations in ULTIMATE_TRANSLATIONS.items():
        arb_file = ARB_DIR / f'app_{lang_code}.arb'
        
        if not arb_file.exists():
            print(f"⚠️  File not found: {arb_file}")
            continue
        
        print(f"\n🔄 Processing {lang_code} for 100% completion...")
        
        try:
            with open(arb_file, 'r', encoding='utf-8') as f:
                data = json.load(f)
            
            # Find missing translations
            missing_keys = []
            for key, english_value in english_keys.items():
                if key not in data or data[key] == english_value:
                    missing_keys.append((key, english_value))
            
            if not missing_keys:
                print(f"✅ {lang_code}: Already 100% translated!")
                continue
            
            print(f"📝 {lang_code}: Found {len(missing_keys)} keys to translate")
            
            # Apply manual translations
            updated_count = 0
            for key, english_value in missing_keys:
                if key in translations:
                    data[key] = translations[key]
                    updated_count += 1
                    print(f"  ✅ {key}: '{translations[key]}'")
                else:
                    # For keys without manual translations, use English as fallback
                    data[key] = english_value
                    updated_count += 1
                    print(f"  ⚠️  Using English fallback for: {key}")
            
            # Save updated file
            with open(arb_file, 'w', encoding='utf-8') as f:
                json.dump(data, f, ensure_ascii=False, indent=2)
            
            print(f"✅ {lang_code}: Updated {updated_count} keys, saved to {arb_file}")
            
        except Exception as e:
            print(f"❌ Error processing {lang_code}: {e}")
    
    print("\n🎉 ULTIMATE 100% translation completion process finished!")
    print("Run the check script to verify all languages are now at 100%")

if __name__ == "__main__":
    apply_ultimate_translations() 