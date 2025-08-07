#!/usr/bin/env python3
import sys, json, glob, re
from pathlib import Path
from collections import defaultdict

ARB_DIR = Path('lib/l10n')
ENGLISH_ONLY = re.compile(r"^[A-Za-z0-9 ,.!?'\"-]+$")

def load_arb(path):
    data = json.loads(path.read_text(encoding='utf-8'))
    entries = []
    for key, val in data.items():
        if key.startswith('@'): continue
        meta = data.get(f'@{key}', {})
        entries.append((key, val, meta.get('priority','P2')))  # default P2
    return entries

def audit():
    report = defaultdict(lambda: defaultdict(list))
    exit_with_error = False

    for arb in sorted(ARB_DIR.glob('*.arb')):
        locale = arb.stem
        for key, val, prio in load_arb(arb):
            # 1) TODO placeholders
            if isinstance(val, str) and val.startswith('TODO:'): 
                report[prio][f"{locale} (TODO)"].append(key)
                exit_with_error = exit_with_error or prio in ('P1','P2')
            # 2) English text in non-English file
            if locale != 'app_en' and ENGLISH_ONLY.fullmatch(val or ''): 
                report[prio][f"{locale} (EN)"].append(key)
                exit_with_error = exit_with_error or prio in ('P1','P2')

    for prio in ['P1','P2','P3']:
        if prio in report: 
            print(f"=== PRIORITY {prio} ===")
            for cat, keys in report[prio].items():
                print(f"{cat}: {len(keys)} issues")
                for k in keys: 
                    print(f"  • {k}")

    if exit_with_error: 
        sys.exit(1)

if __name__ == '__main__': 
    audit() 