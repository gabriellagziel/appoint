import os
import json
import shutil

ARB_DIR = 'lib/l10n'

# Read the English ARB file to get the complete structure
with open(os.path.join(ARB_DIR, 'app_en.arb'), 'r', encoding='utf-8') as f:
    english_data = json.load(f)

# List of all supported locales
locales = [
    'ar', 'da', 'de', 'es', 'fi', 'fr', 'hu', 'it', 'ja', 'ko', 
    'nl', 'no', 'pl', 'pt', 'ru', 'sv', 'tr', 'vi', 'zh'
]

# Existing files
existing_files = [f for f in os.listdir(ARB_DIR) if f.startswith('app_') and f.endswith('.arb')]
existing_locales = [f.replace('app_', '').replace('.arb', '') for f in existing_files]

print(f"Existing ARB files: {existing_locales}")

for locale in locales:
    if locale in existing_locales:
        print(f"Skipping {locale} (already exists)")
        continue
    
    filename = f'app_{locale}.arb'
    filepath = os.path.join(ARB_DIR, filename)
    
    print(f"Creating {filename}...")
    
    # Create new ARB data based on English
    new_data = {}
    new_data['@@locale'] = locale
    
    # Copy all keys from English, but replace values with placeholders
    for key, value in english_data.items():
        if key == '@@locale':
            continue  # Already set above
        elif key.startswith('@'):
            # Metadata key - copy as is
            new_data[key] = value
        else:
            # Translation key - add with placeholder
            new_data[key] = f"{key} (TRANSLATE)"
    
    # Write the new ARB file
    with open(filepath, 'w', encoding='utf-8') as f:
        json.dump(new_data, f, ensure_ascii=False, indent=2)
    
    print(f"  ✓ Created {filename}")

print(f"\nGenerated {len(locales)} ARB files!") 