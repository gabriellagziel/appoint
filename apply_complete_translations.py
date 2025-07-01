#!/usr/bin/env python3
"""
Script to apply complete translations from a CSV into ARB files.

Expected CSV format (UTF-8, newline-delimited, with header):
key,en,bn,es_419,he,pt_BR,uk,...
where 'key' = localization key, and each locale column matches the ARB filename stem without 'app_' prefix (e.g. 'bn', 'es_419', 'he', 'pt_BR', 'uk').

Usage:
  python3 apply_complete_translations.py

This will update lib/l10n/app_<locale>.arb for every locale.
"""
import csv
import json
from pathlib import Path
import sys

# Configuration
CSV_FILE = Path('complete-translation-list.csv')
ARB_DIR = Path('lib/l10n')
BASE_PREFIX = 'app_'

# Load translations from CSV into a dict: { key: { locale_code: translation, ... } }
def load_translations(csv_path):
    if not csv_path.exists():
        print(f"ERROR: CSV file not found: {csv_path}")
        sys.exit(1)
    with csv_path.open(newline='', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        translations = {}
        headers = reader.fieldnames
        if 'key' not in headers:
            print("ERROR: CSV header must include 'key' column.")
            sys.exit(1)
        # Locale codes = all headers except 'key'
        locale_codes = [h for h in headers if h != 'key']
        for row in reader:
            key = row['key']
            translations[key] = { loc: row[loc].strip() for loc in locale_codes }
    return translations, locale_codes

# Update each ARB file with the corresponding translations
def apply_to_arbs(translations, locale_codes):
    if not ARB_DIR.exists():
        print(f"ERROR: ARB directory not found: {ARB_DIR}")
        sys.exit(1)

    for arb_path in sorted(ARB_DIR.glob(f"{BASE_PREFIX}*.arb")):
        stem = arb_path.stem           # e.g. 'app_bn'
        locale = stem.replace(BASE_PREFIX, '')  # e.g. 'bn'
        if locale not in locale_codes:
            print(f"Skipping {arb_path.name}: no column '{locale}' in CSV")
            continue

        print(f"Updating {arb_path.name}...")
        data = json.loads(arb_path.read_text(encoding='utf-8'))
        updated = False
        for key, lang_map in translations.items():
            if key not in data:
                print(f"  WARN: key '{key}' missing in {arb_path.name}")
                continue
            new_val = lang_map.get(locale)
            if new_val:
                if data[key] != new_val:
                    data[key] = new_val
                    updated = True
            else:
                # No translation provided: leave existing or log
                print(f"  * no translation for '{key}' in locale '{locale}'")

        if updated:
            # Preserve metadata entries (fields starting with '@')
            # Dump with sorted keys for consistency
            arb_path.write_text(json.dumps(data, ensure_ascii=False, indent=2, sort_keys=True), encoding='utf-8')
            print(f"  ✓ {arb_path.name} written.")
        else:
            print(f"  (no changes)")

if __name__ == '__main__':
    translations, locale_codes = load_translations(CSV_FILE)
    apply_to_arbs(translations, locale_codes)
    print("Done applying complete translations.") 