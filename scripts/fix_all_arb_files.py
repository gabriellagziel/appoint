#!/usr/bin/env python3
import os
import re
import glob
from pathlib import Path

def fix_arb_file(file_path):
    """Fix common ARB syntax errors."""
    print(f"Fixing: {file_path}")
    
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Fix 1: Replace invalid placeholder metadata
    content = re.sub(r'"@([^"]+)":\s*\{([^}]+)\},', r'"@\1": {"description": "Placeholder for \1"},', content)
    
    # Fix 2: Replace non-ASCII placeholders with ASCII equivalents
    # Find all placeholders and replace non-ASCII ones
    placeholder_pattern = r'\{([^}]+)\}'
    
    def replace_placeholder(match):
        placeholder = match.group(1)
        if not placeholder.isascii():
            # Create ASCII equivalent
            ascii_placeholder = re.sub(r'[^a-zA-Z0-9_]', '_', placeholder)
            return f"{{{ascii_placeholder}}}"
        return match.group(0)
    
    content = re.sub(placeholder_pattern, replace_placeholder, content)
    
    # Fix 3: Fix common ICU syntax errors
    content = content.replace('${', '{')
    content = content.replace('}', '}')
    
    # Fix 4: Remove any trailing commas before closing braces
    content = re.sub(r',(\s*[}\]])', r'\1', content)
    
    # Write back the fixed content
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print(f"  Fixed syntax errors")

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
            fix_arb_file(arb_file)
        except Exception as e:
            print(f"  Error fixing {arb_file}: {e}")
    
    print("ARB syntax fixes completed!")

if __name__ == "__main__":
    main() 