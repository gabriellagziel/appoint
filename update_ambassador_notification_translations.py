#!/usr/bin/env python3
"""
Update all ARB files with Ambassador notification translations
Adds the new notification keys to all 56 supported languages
"""

import json
import os
import glob
from typing import Dict, Any

# New Ambassador notification keys to add
AMBASSADOR_NOTIFICATION_KEYS = {
    "ambassadorPromotionTitle": "Congratulations! You're now an Ambassador!",
    "@ambassadorPromotionTitle": {
        "description": "Title for ambassador promotion notification"
    },
    "ambassadorPromotionBody": "Welcome to the {tier} tier! Start sharing your referral link to earn rewards.",
    "@ambassadorPromotionBody": {
        "description": "Body text for ambassador promotion notification",
        "placeholders": {
            "tier": {
                "type": "String"
            }
        }
    },
    "tierUpgradeTitle": "Tier Upgrade! 🎉",
    "@tierUpgradeTitle": {
        "description": "Title for tier upgrade notification"
    },
    "tierUpgradeBody": "Amazing! You've been upgraded from {previousTier} to {newTier} with {totalReferrals} referrals!",
    "@tierUpgradeBody": {
        "description": "Body text for tier upgrade notification",
        "placeholders": {
            "previousTier": {
                "type": "String"
            },
            "newTier": {
                "type": "String"
            },
            "totalReferrals": {
                "type": "String"
            }
        }
    },
    "monthlyReminderTitle": "Monthly Goal Reminder",
    "@monthlyReminderTitle": {
        "description": "Title for monthly performance reminder notification"
    },
    "monthlyReminderBody": "You have {currentReferrals}/{targetReferrals} referrals this month. {daysRemaining} days left to reach your goal!",
    "@monthlyReminderBody": {
        "description": "Body text for monthly reminder notification",
        "placeholders": {
            "currentReferrals": {
                "type": "String"
            },
            "targetReferrals": {
                "type": "String"
            },
            "daysRemaining": {
                "type": "String"
            }
        }
    },
    "performanceWarningTitle": "Ambassador Performance Alert",
    "@performanceWarningTitle": {
        "description": "Title for performance warning notification"
    },
    "performanceWarningBody": "Your monthly referrals ({currentReferrals}) are below the minimum requirement ({minimumRequired}). Your ambassador status may be affected.",
    "@performanceWarningBody": {
        "description": "Body text for performance warning notification",
        "placeholders": {
            "currentReferrals": {
                "type": "String"
            },
            "minimumRequired": {
                "type": "String"
            }
        }
    },
    "ambassadorDemotionTitle": "Ambassador Status Update",
    "@ambassadorDemotionTitle": {
        "description": "Title for ambassador demotion notification"
    },
    "ambassadorDemotionBody": "Your ambassador status has been temporarily suspended due to: {reason}. You can regain your status by meeting the requirements again.",
    "@ambassadorDemotionBody": {
        "description": "Body text for ambassador demotion notification",
        "placeholders": {
            "reason": {
                "type": "String"
            }
        }
    },
    "referralSuccessTitle": "New Referral! 🎉",
    "@referralSuccessTitle": {
        "description": "Title for successful referral notification"
    },
    "referralSuccessBody": "{referredUserName} joined through your referral! You now have {totalReferrals} total referrals.",
    "@referralSuccessBody": {
        "description": "Body text for successful referral notification",
        "placeholders": {
            "referredUserName": {
                "type": "String"
            },
            "totalReferrals": {
                "type": "String"
            }
        }
    }
}

# Language mappings for translation prefixes
LANGUAGE_MAPPINGS = {
    'app_en.arb': ('en', 'English'),
    'app_es.arb': ('es', 'Spanish'),
    'app_fr.arb': ('fr', 'French'),
    'app_de.arb': ('de', 'German'),
    'app_it.arb': ('it', 'Italian'),
    'app_pt.arb': ('pt', 'Portuguese'),
    'app_pt_BR.arb': ('pt_BR', 'Portuguese (Brazil)'),
    'app_ru.arb': ('ru', 'Russian'),
    'app_zh.arb': ('zh', 'Chinese'),
    'app_zh_Hant.arb': ('zh_Hant', 'Chinese Traditional'),
    'app_ja.arb': ('ja', 'Japanese'),
    'app_ko.arb': ('ko', 'Korean'),
    'app_ar.arb': ('ar', 'Arabic'),
    'app_hi.arb': ('hi', 'Hindi'),
    'app_bn.arb': ('bn', 'Bengali'),
    'app_ur.arb': ('ur', 'Urdu'),
    'app_fa.arb': ('fa', 'Persian'),
    'app_tr.arb': ('tr', 'Turkish'),
    'app_pl.arb': ('pl', 'Polish'),
    'app_nl.arb': ('nl', 'Dutch'),
    'app_sv.arb': ('sv', 'Swedish'),
    'app_da.arb': ('da', 'Danish'),
    'app_no.arb': ('no', 'Norwegian'),
    'app_fi.arb': ('fi', 'Finnish'),
    'app_cs.arb': ('cs', 'Czech'),
    'app_sk.arb': ('sk', 'Slovak'),
    'app_hu.arb': ('hu', 'Hungarian'),
    'app_ro.arb': ('ro', 'Romanian'),
    'app_bg.arb': ('bg', 'Bulgarian'),
    'app_hr.arb': ('hr', 'Croatian'),
    'app_sr.arb': ('sr', 'Serbian'),
    'app_sl.arb': ('sl', 'Slovenian'),
    'app_mk.arb': ('mk', 'Macedonian'),
    'app_sq.arb': ('sq', 'Albanian'),
    'app_et.arb': ('et', 'Estonian'),
    'app_lv.arb': ('lv', 'Latvian'),
    'app_lt.arb': ('lt', 'Lithuanian'),
    'app_uk.arb': ('uk', 'Ukrainian'),
    'app_be.arb': ('be', 'Belarusian'),
    'app_el.arb': ('el', 'Greek'),
    'app_he.arb': ('he', 'Hebrew'),
    'app_th.arb': ('th', 'Thai'),
    'app_vi.arb': ('vi', 'Vietnamese'),
    'app_id.arb': ('id', 'Indonesian'),
    'app_ms.arb': ('ms', 'Malay'),
    'app_tl.arb': ('tl', 'Filipino'),
    'app_sw.arb': ('sw', 'Swahili'),
    'app_am.arb': ('am', 'Amharic'),
    'app_ha.arb': ('ha', 'Hausa'),
    'app_ig.arb': ('ig', 'Igbo'),
    'app_yo.arb': ('yo', 'Yoruba'),
    'app_zu.arb': ('zu', 'Zulu'),
    'app_af.arb': ('af', 'Afrikaans'),
    'app_mt.arb': ('mt', 'Maltese'),
    'app_ga.arb': ('ga', 'Irish'),
    'app_cy.arb': ('cy', 'Welsh'),
    'app_is.arb': ('is', 'Icelandic'),
    'app_fo.arb': ('fo', 'Faroese'),
    'app_eu.arb': ('eu', 'Basque'),
    'app_ca.arb': ('ca', 'Catalan'),
    'app_gl.arb': ('gl', 'Galician'),
    'app_bn_BD.arb': ('bn_BD', 'Bengali (Bangladesh)'),
    'app_bs.arb': ('bs', 'Bosnian'),
}

def get_translated_text(english_text: str, lang_code: str, lang_name: str) -> str:
    """
    Generate a translated version of the text.
    For now, we'll use a placeholder format until proper translation.
    """
    if lang_code == 'en':
        return english_text
    
    # For demonstration, we'll prefix with language code
    # In production, this would call a translation service
    return f"[{lang_code.upper()}] {english_text} ({lang_name})"

def update_arb_file(file_path: str, lang_code: str, lang_name: str) -> bool:
    """Update a single ARB file with Ambassador notification translations."""
    try:
        # Read existing ARB file
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        # Check if keys already exist
        existing_keys = set(data.keys())
        new_keys = set(AMBASSADOR_NOTIFICATION_KEYS.keys())
        
        if new_keys.issubset(existing_keys):
            print(f"✓ {file_path} already has all Ambassador notification keys")
            return True
        
        # Add new keys with translations
        for key, value in AMBASSADOR_NOTIFICATION_KEYS.items():
            if key not in data:
                if key.startswith('@'):
                    # Metadata keys remain the same
                    data[key] = value
                else:
                    # Translate the text
                    data[key] = get_translated_text(value, lang_code, lang_name)
        
        # Write back to file
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2, ensure_ascii=False)
        
        print(f"✓ Updated {file_path} with Ambassador notification keys")
        return True
        
    except Exception as e:
        print(f"✗ Error updating {file_path}: {e}")
        return False

def main():
    """Main function to update all ARB files."""
    print("🚀 Starting Ambassador notification translation update...")
    
    # Find all ARB files in lib/l10n directory
    arb_pattern = "lib/l10n/app_*.arb"
    arb_files = glob.glob(arb_pattern)
    
    if not arb_files:
        print(f"❌ No ARB files found matching pattern: {arb_pattern}")
        return
    
    success_count = 0
    total_count = len(arb_files)
    
    for arb_file in sorted(arb_files):
        filename = os.path.basename(arb_file)
        
        if filename in LANGUAGE_MAPPINGS:
            lang_code, lang_name = LANGUAGE_MAPPINGS[filename]
            if update_arb_file(arb_file, lang_code, lang_name):
                success_count += 1
        else:
            print(f"⚠️  Unknown language file: {filename}")
    
    print(f"\n📊 Summary:")
    print(f"   Total files: {total_count}")
    print(f"   Updated successfully: {success_count}")
    print(f"   Failed: {total_count - success_count}")
    
    if success_count == total_count:
        print("🎉 All Ambassador notification translations updated successfully!")
    else:
        print("⚠️  Some files failed to update. Please review the errors above.")

if __name__ == "__main__":
    main()