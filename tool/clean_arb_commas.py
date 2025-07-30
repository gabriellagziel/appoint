import os
import re

ARB_DIR = 'lib/l10n'

for filename in os.listdir(ARB_DIR):
    if filename.startswith('app_') and filename.endswith('.arb'):
        path = os.path.join(ARB_DIR, filename)
        with open(path, 'r', encoding='utf-8') as f:
            content = f.read()
        # Remove any trailing commas before a closing brace
        content = re.sub(r',\s*}', '\n}', content)
        # Remove duplicate closing braces if any
        content = re.sub(r'}\s*}+\s*$', '}', content)
        # Try to load as JSON to verify
        import json
        try:
            data = json.loads(content)
            with open(path, 'w', encoding='utf-8') as f:
                json.dump(data, f, ensure_ascii=False, indent=2)
            print(f"Cleaned and validated {filename}")
        except Exception as e:
            print(f"Failed to clean {filename}: {e}") 