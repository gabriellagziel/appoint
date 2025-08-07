#!/usr/bin/env python3
"""
Manual translation for final keys to achieve 100% coverage
"""

import json
from pathlib import Path

ARB_DIR = Path('lib/l10n')

# Manual translations for keys that API couldn't handle
MANUAL_TRANSLATIONS = {
    'fo': {  # Faroese - 8 keys remaining
        'playtimeParentDashboardTitle': 'Spælitíð yvirlit',
        'login': 'Rita inn',
        'admin': 'Stjóri',
        'adminBroadcast': 'Stjóri útvarp',
        'download': 'Niðurhal',
        'adminMetrics': 'Stjóri mát',
        'adminDashboard': 'Stjóri yvirlit',
        'appTitle': 'APP-OINT'
    },
    'ca': {  # Catalan - 2 keys remaining
        'participants': 'Participants',
        'no': 'No'
    },
    'bs': {  # Bosnian - 6 keys remaining
        'upload1': 'Učitaj',
        'crm': 'CRM',
        'timestamp_formatdatelogtimestamp': 'Vremenska oznaka: {formatDate_log_timestamp}',
        'dashboard1': 'Kontrolna tabla',
        'adminMetrics': 'Admin metrike',
        'ekeyEvalue': '{e_key}: {e_value}'
    },
    'bg': {  # Bulgarian - 1 key remaining
        'ekeyEvalue': '{e_key}: {e_value}'
    },
    'zh_Hant': {  # Traditional Chinese - 2 keys remaining
        'playtimeHub': '遊戲時間中心',
        'ok': '確定'
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
    'sl': {  # Slovenian - 1 key remaining
        'admin': 'Admin'
    },
    'de': {  # German - 12 keys remaining
        'shareLink': 'Link teilen',
        'nameProfilename': 'Name: {profile_name}',
        'crm': 'CRM',
        'login1': 'Anmelden',
        'details': 'Details',
        'text': 'Text',
        'multipleChoice': 'Multiple Choice',
        'studioDashboard': 'Studio Dashboard',
        'logtargettypeLogtargetid': '{log_targetType}: {log_targetId}',
        'businessDashboard': 'Business Dashboard',
        'ok': 'OK',
        'ekeyEvalue': '{e_key}: {e_value}'
    },
    'it': {  # Italian - 10 keys remaining
        'emailProfileemail': 'Email: {profile_email}',
        'ambassadorOnboarding': 'Onboarding ambasciatore',
        'crm': 'CRM',
        'menu': 'Menu',
        'login1': 'Accedi',
        'logout1': 'Esci',
        'ok': 'OK',
        'no': 'No',
        'ekeyEvalue': '{e_key}: {e_value}',
        'googleCalendar': 'Google Calendar'
    },
    'es': {  # Spanish - 7 keys remaining
        'error': 'Error',
        'crm': 'CRM',
        'inviteeArgsinviteeid': 'Invitado: {args_inviteeId}',
        'errorSnapshoterror': 'Error: {snapshot_error}',
        'ok': 'OK',
        'no': 'No',
        'ekeyEvalue': '{e_key}: {e_value}'
    },
    'hu': {  # Hungarian - 1 key remaining
        'email': 'Email'
    },
    'da': {  # Danish - 5 keys remaining
        'admin': 'Admin',
        'adminMetrics': 'Admin metrikker',
        'adminDashboard': 'Admin dashboard',
        'upload': 'Upload',
        'ok': 'OK'
    },
    'fi': {  # Finnish - 1 key remaining
        'ok': 'OK'
    },
    'is': {  # Icelandic - 2 keys remaining
        'admin': 'Admin',
        'adminMetrics': 'Admin mælikvarðar'
    },
    'id': {  # Indonesian - 2 keys remaining
        'admin': 'Admin',
        'edit': 'Edit'
    },
    'ha': {  # Hausa - 3 keys remaining
        'dashboard': 'Dashboard',
        'logout': 'Fita',
        'ok': 'OK'
    },
    'sk': {  # Slovak - 1 key remaining
        'ok': 'OK'
    },
    'ro': {  # Romanian - 1 key remaining
        'ok': 'OK'
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
    'sv': {  # Swedish - 1 key remaining
        'ok': 'OK'
    },
    'ja': {  # Japanese - 1 key remaining
        'ok': 'OK'
    },
    'ur': {  # Urdu - 1 key remaining
        'ok': 'OK'
    },
    'vi': {  # Vietnamese - 1 key remaining
        'ok': 'OK'
    },
    'mt': {  # Maltese - 1 key remaining
        'adminDashboard': 'Admin Dashboard'
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

def apply_manual_translations():
    """Apply manual translations to achieve 100% coverage."""
    print("🔧 Applying manual translations for 100% coverage...")
    
    for lang_code, translations in MANUAL_TRANSLATIONS.items():
        arb_file = ARB_DIR / f'app_{lang_code}.arb'
        
        if not arb_file.exists():
            print(f"⚠️  File not found: {arb_file}")
            continue
        
        print(f"\n🔄 Processing {lang_code}...")
        
        try:
            with open(arb_file, 'r', encoding='utf-8') as f:
                data = json.load(f)
            
            updated_count = 0
            for key, translation in translations.items():
                if key in data:
                    data[key] = translation
                    updated_count += 1
                    print(f"  ✅ {key}: '{translation}'")
            
            with open(arb_file, 'w', encoding='utf-8') as f:
                json.dump(data, f, ensure_ascii=False, indent=2)
            
            print(f"✅ {lang_code}: Updated {updated_count} keys")
            
        except Exception as e:
            print(f"❌ Error processing {lang_code}: {e}")
    
    print("\n🎉 Manual translations applied!")
    print("Run the check script to verify 100% coverage")

if __name__ == "__main__":
    apply_manual_translations() 