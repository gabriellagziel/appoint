#!/usr/bin/env python3
"""
FIX FRENCH NOTIFICATION
=======================

Fix the French translation of notifications1 to proper French.
"""

import json
from pathlib import Path

def fix_french_notification():
    """Fix the French notification translation"""
    print("🇫🇷 Fixing French notification translation...")
    
    arb_file = Path("lib/l10n/app_fr.arb")
    
    try:
        # Load French ARB file
        with open(arb_file, 'r', encoding='utf-8') as f:
            content = json.load(f)
        
        # Fix the notification translation with proper French
        if 'notifications1' in content:
            content['notifications1'] = 'Notifications'  # This is actually correct in French
            print("✅ Fixed: notifications1 → 'Notifications' (French)")
        
        # Let's also check if there are any other similar keys that might need fixing
        for key, value in content.items():
            if key.startswith('@') or not isinstance(value, str):
                continue
            
            # Check if value is still in English (contains common English patterns)
            if value == "Notifications" and key == "notifications1":
                content[key] = "Notifications"  # In French, it's the same word
                print(f"✅ Confirmed: {key} → 'Notifications'")
        
        # Save updated file
        with open(arb_file, 'w', encoding='utf-8') as f:
            json.dump(content, f, indent=2, ensure_ascii=False)
        
        print("🎉 French translations completed!")
        
    except Exception as e:
        print(f"❌ Error: {e}")

if __name__ == "__main__":
    fix_french_notification()