import os
import json
import re

ARB_DIR = 'lib/l10n'
REFERENCE_FILE = os.path.join(ARB_DIR, 'app_en.arb')

with open(REFERENCE_FILE, encoding='utf-8') as f:
    ref = json.load(f)

ref_keys = set(k for k in ref.keys() if k != '@@locale')

for filename in os.listdir(ARB_DIR):
    if not filename.endswith('.arb'):
        continue
    path = os.path.join(ARB_DIR, filename)
    with open(path, encoding='utf-8') as f:
        try:
            data = json.load(f)
        except Exception as e:
            print(f'Error reading {filename}: {e}')
            continue
    
    changed = False
    
    # Fix metadata structure
    for k in list(data.keys()):
        if k.startswith('@') and k != '@@locale':
            meta = data[k]
            if not isinstance(meta, dict):
                # Replace malformed metadata with reference
                if k in ref:
                    data[k] = ref[k]
                    changed = True
                else:
                    # Remove malformed metadata
                    del data[k]
                    changed = True
            elif 'placeholders' in meta:
                # Ensure placeholders are properly structured
                placeholders = meta['placeholders']
                if not isinstance(placeholders, dict):
                    # Remove malformed placeholders
                    del meta['placeholders']
                    changed = True
                else:
                    # Fix placeholder types
                    for ph_key, ph_value in list(placeholders.items()):
                        if not isinstance(ph_value, dict) or 'type' not in ph_value:
                            # Remove malformed placeholder
                            del placeholders[ph_key]
                            changed = True
                        elif ph_value['type'] not in ['String', 'int', 'double', 'num']:
                            # Fix invalid type
                            ph_value['type'] = 'String'
                            changed = True
    
    # Ensure all values are strings
    for k, v in list(data.items()):
        if k != '@@locale' and not k.startswith('@'):
            if not isinstance(v, str):
                data[k] = str(v)
                changed = True
    
    if changed:
        with open(path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        print(f'Fixed {filename}')

print("ARB placeholder fix completed") 