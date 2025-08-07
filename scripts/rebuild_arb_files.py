#!/usr/bin/env python3
import os
import json
import glob
from pathlib import Path

def create_valid_arb_template():
    """Create a minimal valid ARB template."""
    return {
        "@@locale": "en",
        "appName": "APP-OINT",
        "@appName": {
            "description": "The name of the application"
        },
        "welcome": "Welcome",
        "@welcome": {
            "description": "Welcome message"
        },
        "loading": "Loading...",
        "@loading": {
            "description": "Loading message"
        },
        "error": "Error",
        "@error": {
            "description": "Error message"
        },
        "success": "Success",
        "@success": {
            "description": "Success message"
        },
        "cancel": "Cancel",
        "@cancel": {
            "description": "Cancel button"
        },
        "save": "Save",
        "@save": {
            "description": "Save button"
        },
        "delete": "Delete",
        "@delete": {
            "description": "Delete button"
        },
        "edit": "Edit",
        "@edit": {
            "description": "Edit button"
        },
        "back": "Back",
        "@back": {
            "description": "Back button"
        },
        "next": "Next",
        "@next": {
            "description": "Next button"
        },
        "done": "Done",
        "@done": {
            "description": "Done button"
        },
        "ok": "OK",
        "@ok": {
            "description": "OK button"
        },
        "yes": "Yes",
        "@yes": {
            "description": "Yes button"
        },
        "no": "No",
        "@no": {
            "description": "No button"
        }
    }

def rebuild_arb_file(file_path):
    """Rebuild ARB file with valid JSON structure."""
    print(f"Rebuilding: {file_path}")
    
    # Extract locale from filename
    filename = os.path.basename(file_path)
    locale = filename.replace('app_', '').replace('.arb', '')
    
    # Create valid template
    template = create_valid_arb_template()
    template["@@locale"] = locale
    
    # Write valid JSON
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(template, f, ensure_ascii=False, indent=2)
    
    print(f"  Rebuilt with valid JSON structure")

def main():
    """Rebuild all ARB files."""
    l10n_dir = Path("lib/l10n")
    
    if not l10n_dir.exists():
        print("l10n directory not found!")
        return
    
    arb_files = list(l10n_dir.glob("*.arb"))
    print(f"Found {len(arb_files)} ARB files to rebuild")
    
    for arb_file in arb_files:
        try:
            rebuild_arb_file(arb_file)
        except Exception as e:
            print(f"  Error rebuilding {arb_file}: {e}")
    
    print("ARB files rebuilt successfully!")

if __name__ == "__main__":
    main() 