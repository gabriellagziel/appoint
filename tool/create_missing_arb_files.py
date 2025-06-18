import os
import json

ARB_DIR = 'lib/l10n'

# Read the English ARB file to get the complete structure
with open(os.path.join(ARB_DIR, 'app_en.arb'), 'r', encoding='utf-8') as f:
    english_data = json.load(f)

# List of missing locales that need ARB files
missing_locales = [
    'bg', 'cs', 'id', 'lt', 'ms', 'ro', 'sk', 'sl', 'sr', 'uk', 'th'
]

print(f"Creating ARB files for {len(missing_locales)} missing locales...")

for locale in missing_locales:
    filename = f'app_{locale}.arb'
    filepath = os.path.join(ARB_DIR, filename)
    
    print(f"Creating {filename}...")
    
    # Create new ARB data based on English
    new_data = {}
    new_data['@@locale'] = locale
    
    # Copy all keys from English, but replace values with TODO placeholders
    for key, value in english_data.items():
        if key == '@@locale':
            continue  # Already set above
        elif key.startswith('@'):
            # Metadata key - copy as is
            new_data[key] = value
        else:
            # Translation key - add with TODO placeholder
            new_data[key] = f"TODO: {value}"
    
    # Write the new ARB file
    with open(filepath, 'w', encoding='utf-8') as f:
        json.dump(new_data, f, ensure_ascii=False, indent=2)
    
    print(f"  ✓ Created {filename}")

print(f"\nCreated {len(missing_locales)} ARB files!")
print("Missing locales added:", ', '.join(missing_locales)) 