#!/usr/bin/env python3
import glob
import re

for file in glob.glob('lib/l10n/*.arb'):
    with open(file, 'r', encoding='utf-8') as f:
        content = f.read()
    # Remove trailing commas before } or ]
    content = re.sub(r',([ \t\r\n]*[}\]])', r'\1', content)
    with open(file, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f'Fixed trailing commas in {file}') 