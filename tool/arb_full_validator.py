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
    changed = False
    # Ensure all values are strings (except metadata, which must be dicts)
    for k, v in list(data.items()):
        if k == '@@locale':
            continue
        if k.startswith('@'):
            if not isinstance(v, dict):
                data[k] = ref.get(k, {})
                changed = True
        else:
            if not isinstance(v, str):
                data[k] = str(v)
                changed = True
    # Ensure all keys from reference are present
    for k in ref_keys:
        if k not in data:
            data[k] = ref[k]
            changed = True
        meta = f'@{k}'
        if meta not in data and meta in ref:
            data[meta] = ref[meta]
            changed = True
    # Remove extra keys not in reference
    for k in list(data.keys()):
        if k != '@@locale' and not (k in ref_keys or (k.startswith('@') and k[1:] in ref_keys)):
            del data[k]
            changed = True
    if changed:
        with open(path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        print(f'Fixed {filename}') 