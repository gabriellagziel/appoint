#!/usr/bin/env python3
import os
import glob
from pathlib import Path

def fix_arb_start(file_path):
    """Fix the beginning of ARB files."""
    print(f"Fixing start of: {file_path}")
    
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Fix files that don't start with {
    if not content.strip().startswith('{'):
        # Find the first { and remove everything before it
        start_pos = content.find('{')
        if start_pos > 0:
            content = content[start_pos:]
            print(f"  Fixed start of file")
    
    # Ensure the file starts with {
    if not content.strip().startswith('{'):
        content = '{\n' + content
    
    # Write back the fixed content
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

def main():
    """Fix all ARB files."""
    l10n_dir = Path("lib/l10n")
    
    if not l10n_dir.exists():
        print("l10n directory not found!")
        return
    
    arb_files = list(l10n_dir.glob("*.arb"))
    print(f"Found {len(arb_files)} ARB files to fix")
    
    for arb_file in arb_files:
        try:
            fix_arb_start(arb_file)
        except Exception as e:
            print(f"  Error fixing {arb_file}: {e}")
    
    print("ARB start fixes completed!")

if __name__ == "__main__":
    main() 