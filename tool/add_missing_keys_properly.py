import os
import json

ARB_DIR = 'lib/l10n'

# Read the English ARB file to get the complete structure
with open(os.path.join(ARB_DIR, 'app_en.arb'), 'r', encoding='utf-8') as f:
    english_data = json.load(f)

# List of all ARB files
arb_files = [f for f in os.listdir(ARB_DIR) if f.startswith('app_') and f.endswith('.arb')]

for filename in arb_files:
    if filename == 'app_en.arb':
        continue  # Skip English as it's our template
    
    filepath = os.path.join(ARB_DIR, filename)
    locale = filename.replace('app_', '').replace('.arb', '')
    
    print(f"Processing {filename}...")
    
    try:
        # Read existing ARB file
        with open(filepath, 'r', encoding='utf-8') as f:
            existing_data = json.load(f)
        
        # Add missing keys from English
        added_keys = 0
        for key, value in english_data.items():
            if key not in existing_data:
                if key.startswith('@'):
                    # Metadata key - copy as is
                    existing_data[key] = value
                else:
                    # Translation key - add with placeholder
                    existing_data[key] = f"{key} (TRANSLATE)"
                added_keys += 1
        
        # Write back with proper formatting
        with open(filepath, 'w', encoding='utf-8') as f:
            json.dump(existing_data, f, ensure_ascii=False, indent=2)
        
        print(f"  ✓ Added {added_keys} missing keys to {filename}")
        
    except Exception as e:
        print(f"  ✗ Failed to process {filename}: {e}")

print("\nAll ARB files processed!") 