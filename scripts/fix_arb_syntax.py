#!/usr/bin/env python3
import os
import re
import json
from pathlib import Path

def fix_arb_file(file_path):
    """Fix ARB syntax errors in a single file."""
    print(f"Fixing: {file_path}")
    
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Find all non-ASCII placeholders
    placeholder_pattern = r'\{([^}]+)\}'
    placeholders = re.findall(placeholder_pattern, content)
    
    # Create mapping for non-ASCII placeholders
    placeholder_mapping = {}
    counter = 1
    
    for placeholder in placeholders:
        if not placeholder.isascii():
            # Create ASCII equivalent
            ascii_name = f"placeholder_{counter}"
            placeholder_mapping[placeholder] = ascii_name
            counter += 1
    
    # Replace placeholders in content
    for old_placeholder, new_placeholder in placeholder_mapping.items():
        content = content.replace(f"{{{old_placeholder}}}", f"{{{new_placeholder}}}")
    
    # Update metadata for each key that has placeholders
    try:
        data = json.loads(content)
        updated_data = {}
        
        for key, value in data.items():
            if key.startswith('@'):
                # Skip metadata keys for now
                updated_data[key] = value
                continue
                
            if isinstance(value, str):
                # Check if this value has any of our mapped placeholders
                has_placeholders = any(new_placeholder in value for new_placeholder in placeholder_mapping.values())
                
                if has_placeholders:
                    # Create or update metadata
                    metadata_key = f"@{key}"
                    if metadata_key not in data:
                        updated_data[metadata_key] = {
                            "description": f"Localization key for: {key}",
                            "placeholders": {}
                        }
                    else:
                        updated_data[metadata_key] = data[metadata_key]
                        if "placeholders" not in updated_data[metadata_key]:
                            updated_data[metadata_key]["placeholders"] = {}
                    
                    # Add placeholders to metadata
                    for new_placeholder in placeholder_mapping.values():
                        if new_placeholder in value:
                            updated_data[metadata_key]["placeholders"][new_placeholder] = {}
                
                updated_data[key] = value
            else:
                updated_data[key] = value
        
        # Write back the fixed content
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(updated_data, f, ensure_ascii=False, indent=2)
            
        print(f"  Fixed {len(placeholder_mapping)} placeholders")
        
    except json.JSONDecodeError as e:
        print(f"  JSON error in {file_path}: {e}")
        # Fallback: just replace placeholders without JSON parsing
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)

def main():
    """Fix all ARB files in the l10n directory."""
    l10n_dir = Path("lib/l10n")
    
    if not l10n_dir.exists():
        print("l10n directory not found!")
        return
    
    arb_files = list(l10n_dir.glob("*.arb"))
    print(f"Found {len(arb_files)} ARB files to fix")
    
    for arb_file in arb_files:
        fix_arb_file(arb_file)
    
    print("ARB syntax fixes completed!")

if __name__ == "__main__":
    main() 