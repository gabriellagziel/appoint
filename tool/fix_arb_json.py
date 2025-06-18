import os
import json

ARB_DIR = 'lib/l10n'

for filename in os.listdir(ARB_DIR):
    if filename.startswith('app_') and filename.endswith('.arb'):
        path = os.path.join(ARB_DIR, filename)
        with open(path, 'r', encoding='utf-8') as f:
            try:
                # Try to load as JSON first
                data = json.load(f)
                valid = True
            except Exception:
                valid = False
        if not valid:
            # Try to repair: remove trailing commas and reload
            with open(path, 'r', encoding='utf-8') as f:
                lines = f.readlines()
            # Remove trailing commas before closing brace
            for i in range(len(lines)-1, 0, -1):
                if lines[i].strip() == '}' and lines[i-1].strip().endswith(','):
                    lines[i-1] = lines[i-1].rstrip(',\n') + '\n'
            # Join and try to load as JSON
            joined = ''.join(lines)
            try:
                data = json.loads(joined)
                with open(path, 'w', encoding='utf-8') as f:
                    json.dump(data, f, ensure_ascii=False, indent=2)
                print(f"Fixed {filename}")
            except Exception as e:
                print(f"Failed to fix {filename}: {e}")
        else:
            # Already valid, reformat for consistency
            with open(path, 'w', encoding='utf-8') as f:
                json.dump(data, f, ensure_ascii=False, indent=2)
            print(f"Reformatted {filename}") 