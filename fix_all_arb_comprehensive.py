#!/usr/bin/env python3
import os
import re
import json
import glob
from pathlib import Path

def fix_arb_file(file_path):
    """Comprehensive fix for ARB files."""
    print(f"Fixing: {file_path}")
    
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Fix 1: Remove invalid placeholder metadata like {placeholder_106}
    content = re.sub(r'\{placeholder_\d+\}', '{"description": "Placeholder"}', content)
    
    # Fix 2: Remove trailing commas before closing braces/brackets
    content = re.sub(r',(\s*[}\]])', r'\1', content)
    
    # Fix 3: Fix any unquoted property names
    content = re.sub(r'([{,])\s*([a-zA-Z_][a-zA-Z0-9_]*)\s*:', r'\1 "\2":', content)
    
    # Fix 4: Ensure file starts with {
    if not content.strip().startswith('{'):
        content = '{' + content
    
    # Fix 5: Remove any duplicate closing braces at the end
    content = re.sub(r'\}\s*\}\s*$', '}', content)
    
    # Fix 6: Fix any non-ASCII placeholders
    def replace_placeholder(match):
        placeholder = match.group(1)
        if not placeholder.isascii():
            ascii_placeholder = re.sub(r'[^a-zA-Z0-9_]', '_', placeholder)
            return f"{{{ascii_placeholder}}}"
        return match.group(0)
    
    content = re.sub(r'\{([^}]+)\}', replace_placeholder, content)
    
    # Fix 7: Ensure proper JSON structure by parsing and reformatting
    try:
        # Try to parse as JSON to validate
        data = json.loads(content)
        
        # Write back properly formatted JSON
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        
        print(f"  Successfully fixed and validated JSON")
        
    except json.JSONDecodeError as e:
        print(f"  JSON error: {e}")
        # If JSON parsing fails, try to fix common issues
        content = re.sub(r'([^"])\s*([a-zA-Z_][a-zA-Z0-9_]*)\s*:', r'\1 "\2":', content)
        content = re.sub(r':\s*([^"][^,}]*[^",\s])\s*([,}])', r': "\1"\2', content)
        
        # Try to add missing closing brace
        if content.count('{') > content.count('}'):
            content += '\n}'
        
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        
        print(f"  Applied basic fixes")

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
    
    print("Comprehensive ARB fixes completed!")

if __name__ == "__main__":
    main() 