import os
import json

ARB_DIR = 'lib/l10n'
REFERENCE_FILE = os.path.join(ARB_DIR, 'app_en.arb')

with open(REFERENCE_FILE, encoding='utf-8') as f:
    ref = json.load(f)

ref_keys = set(k for k in ref.keys() if k != '@@locale')
ref_placeholders = {}
for k in ref_keys:
    meta = ref.get(f'@{k}', {})
    if isinstance(meta, dict) and 'placeholders' in meta:
        ref_placeholders[k] = set(meta['placeholders'].keys())

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
    # Check for missing metadata
    for k in ref_keys:
        meta = f'@{k}'
        if meta not in data:
            print(f'{filename}: Missing metadata for {k}')
        # Check for placeholder mismatches
        ref_ph = ref_placeholders.get(k)
        if ref_ph:
            dmeta = data.get(meta, {})
            dph = set(dmeta.get('placeholders', {}).keys()) if isinstance(dmeta, dict) else set()
            if dph != ref_ph:
                print(f'{filename}: Placeholder mismatch for {k} (expected {ref_ph}, found {dph})') 