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
    for k in ref_keys:
        meta = f'@{k}'
        if meta not in data and meta in ref:
            data[meta] = ref[meta]
            changed = True
    if changed:
        with open(path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        print(f'Fixed metadata in {filename}') 