import os
import json

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
    cleaned = {}
    # Always keep @@locale if present
    if '@@locale' in data:
        cleaned['@@locale'] = data['@@locale']
    # Add all reference keys and their metadata
    for k in ref_keys:
        if k in data:
            cleaned[k] = data[k]
        elif k in ref:
            cleaned[k] = ref[k]  # fallback to English
        meta = f'@{k}'
        if meta in data:
            cleaned[meta] = data[meta]
        elif meta in ref:
            cleaned[meta] = ref[meta]
    # Write cleaned file
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(cleaned, f, ensure_ascii=False, indent=2)
    print(f'Cleaned {filename}') 