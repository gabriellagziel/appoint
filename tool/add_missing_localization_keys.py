#!/usr/bin/env python3
"""
Script to identify hard-coded strings in Dart files and add them to localization files.
"""

import os
import re
import json
from pathlib import Path
from typing import Set, Dict, List, Tuple

class LocalizationKeyExtractor:
    def __init__(self, lib_dir: str = "lib", l10n_dir: str = "lib/l10n"):
        self.lib_dir = Path(lib_dir)
        self.l10n_dir = Path(l10n_dir)
        self.existing_keys = self._load_existing_keys()
        self.hard_coded_strings = set()
        
    def _load_existing_keys(self) -> Set[str]:
        """Load existing localization keys from ARB files."""
        keys = set()
        arb_files = list(self.l10n_dir.glob("*.arb"))
        
        if not arb_files:
            print("No ARB files found in l10n directory")
            return keys
            
        # Use the English ARB file as the source of truth
        en_arb_file = self.l10n_dir / "app_en.arb"
        if en_arb_file.exists():
            try:
                with open(en_arb_file, 'r', encoding='utf-8') as f:
                    data = json.load(f)
                    keys.update(data.keys())
            except json.JSONDecodeError as e:
                print(f"Error parsing {en_arb_file}: {e}")
                
        return keys
    
    def extract_hard_coded_strings(self) -> Set[str]:
        """Extract hard-coded strings from Dart files."""
        dart_files = list(self.lib_dir.rglob("*.dart"))
        
        # Patterns to match hard-coded strings
        patterns = [
            r"Text\('([^']+)'\)",  # Text('string')
            r'Text\("([^"]+)"\)',  # Text("string")
            r"const Text\('([^']+)'\)",  # const Text('string')
            r'const Text\("([^"]+)"\)',  # const Text("string")
            r"title: const Text\('([^']+)'\)",  # title: const Text('string')
            r'title: const Text\("([^"]+)"\)',  # title: const Text("string")
            r"content: Text\('([^']+)'\)",  # content: Text('string')
            r'content: Text\("([^"]+)"\)',  # content: Text("string")
            r"label: const Text\('([^']+)'\)",  # label: const Text('string')
            r'label: const Text\("([^"]+)"\)',  # label: const Text("string")
        ]
        
        strings = set()
        
        for dart_file in dart_files:
            try:
                with open(dart_file, 'r', encoding='utf-8') as f:
                    content = f.read()
                    
                for pattern in patterns:
                    matches = re.findall(pattern, content)
                    for match in matches:
                        # Clean up the string
                        cleaned = match.strip()
                        if cleaned and len(cleaned) > 1:  # Skip single characters
                            strings.add(cleaned)
                            
            except Exception as e:
                print(f"Error reading {dart_file}: {e}")
        
        self.hard_coded_strings = strings
        return strings
    
    def generate_key_name(self, text: str) -> str:
        """Generate a key name from text."""
        # Remove special characters and convert to camelCase
        cleaned = re.sub(r'[^\w\s]', '', text.lower())
        words = cleaned.split()
        
        if not words:
            return "key"
            
        # Convert to camelCase
        key = words[0]
        for word in words[1:]:
            key += word.capitalize()
            
        # Ensure it's a valid identifier
        if key[0].isdigit():
            key = "key" + key
            
        return key
    
    def find_missing_keys(self) -> Dict[str, str]:
        """Find strings that don't have localization keys."""
        missing = {}
        
        for text in self.hard_coded_strings:
            # Skip strings that are already localized
            if text in self.existing_keys:
                continue
                
            # Skip strings that look like they're already localized
            if text.startswith('AppLocalizations.of(context).'):
                continue
                
            # Skip very short strings or common words
            if len(text) <= 2 or text.lower() in ['ok', 'no', 'yes', 'id', 'ui']:
                continue
                
            key = self.generate_key_name(text)
            
            # Ensure key is unique
            counter = 1
            original_key = key
            while key in self.existing_keys or key in missing:
                key = f"{original_key}{counter}"
                counter += 1
                
            missing[key] = text
            
        return missing
    
    def add_keys_to_arb(self, new_keys: Dict[str, str]) -> None:
        """Add new keys to the English ARB file."""
        en_arb_file = self.l10n_dir / "app_en.arb"
        
        if not en_arb_file.exists():
            print(f"English ARB file not found: {en_arb_file}")
            return
            
        try:
            with open(en_arb_file, 'r', encoding='utf-8') as f:
                data = json.load(f)
                
            # Add new keys
            for key, value in new_keys.items():
                if key not in data:
                    data[key] = value
                    data[f"@{key}"] = {"description": f"Localization key for: {value}"}
                    
            # Write back to file
            with open(en_arb_file, 'w', encoding='utf-8') as f:
                json.dump(data, f, indent=2, ensure_ascii=False)
                
            print(f"Added {len(new_keys)} new keys to {en_arb_file}")
            
        except Exception as e:
            print(f"Error updating ARB file: {e}")
    
    def generate_replacement_suggestions(self, new_keys: Dict[str, str]) -> List[Tuple[str, str, str]]:
        """Generate suggestions for replacing hard-coded strings."""
        suggestions = []
        
        for key, text in new_keys.items():
            # Generate the replacement pattern
            replacement = f"AppLocalizations.of(context).{key}"
            
            # Find files that contain this text
            dart_files = list(self.lib_dir.rglob("*.dart"))
            for dart_file in dart_files:
                try:
                    with open(dart_file, 'r', encoding='utf-8') as f:
                        content = f.read()
                        
                    if text in content:
                        suggestions.append((str(dart_file), text, replacement))
                        
                except Exception as e:
                    print(f"Error reading {dart_file}: {e}")
                    
        return suggestions
    
    def run(self):
        """Run the complete extraction and analysis process."""
        print("Extracting hard-coded strings from Dart files...")
        self.extract_hard_coded_strings()
        
        print(f"Found {len(self.hard_coded_strings)} hard-coded strings")
        
        print("Finding missing localization keys...")
        missing_keys = self.find_missing_keys()
        
        print(f"Found {len(missing_keys)} strings that need localization keys")
        
        if missing_keys:
            print("\nMissing keys:")
            for key, text in missing_keys.items():
                print(f"  {key}: '{text}'")
                
            # Add keys to ARB file
            self.add_keys_to_arb(missing_keys)
            
            # Generate replacement suggestions
            suggestions = self.generate_replacement_suggestions(missing_keys)
            
            print(f"\nReplacement suggestions for {len(suggestions)} instances:")
            for file_path, old_text, new_text in suggestions:
                print(f"  {file_path}:")
                print(f"    Replace: '{old_text}'")
                print(f"    With: {new_text}")
                print()
        else:
            print("No missing keys found!")

def main():
    extractor = LocalizationKeyExtractor()
    extractor.run()

if __name__ == "__main__":
    main() 