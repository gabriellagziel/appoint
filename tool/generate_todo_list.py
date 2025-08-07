#!/usr/bin/env python3

import json
import os
import re
from datetime import datetime
from pathlib import Path

def generate_todo_list():
    """Generate a comprehensive TODO list for translations."""
    
    l10n_dir = Path("lib/l10n")
    output_file = "todo_list.txt"
    report_file = "translation_report.md"
    
    print("🔍 Generating translation TODO list...")
    
    # Get all ARB files
    arb_files = list(l10n_dir.glob("app_*.arb"))
    
    # Create the TODO list
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write("# Translation TODO List\n")
        f.write(f"Generated on: {datetime.now().strftime('%c')}\n\n")
        
        total_todos = 0
        locale_todos = {}
        
        # Process each ARB file
        for arb_file in arb_files:
            locale = arb_file.stem.replace('app_', '')
            
            if locale == 'en':
                continue  # Skip English as it's the source
            
            try:
                with open(arb_file, 'r', encoding='utf-8') as arb_f:
                    data = json.load(arb_f)
                
                todos = []
                for key, value in data.items():
                    if isinstance(value, str) and value.startswith('TODO:'):
                        english_text = value[5:].strip()  # Remove "TODO: " prefix
                        todos.append((key, english_text))
                
                locale_todos[locale] = todos
                total_todos += len(todos)
                
                f.write(f"## {locale}\n")
                for key, english_text in todos:
                    f.write(f"- **{key}**: {english_text}\n")
                f.write("\n")
                
            except Exception as e:
                print(f"⚠️  Error processing {arb_file}: {e}")
                continue
        
        f.write(f"Total TODO items found: {total_todos}\n")
    
    # Create a summary report
    with open(report_file, 'w', encoding='utf-8') as f:
        f.write("# Translation Progress Report\n")
        f.write(f"Generated on: {datetime.now().strftime('%c')}\n\n")
        
        f.write("## Summary\n")
        f.write(f"- Total locales: {len(arb_files)}\n")
        f.write(f"- Total TODO items: {total_todos}\n\n")
        
        f.write("## Progress by Locale\n")
        f.write("| Locale | TODO Count | Status |\n")
        f.write("|--------|------------|--------|\n")
        
        for arb_file in arb_files:
            locale = arb_file.stem.replace('app_', '')
            todo_count = len(locale_todos.get(locale, []))
            
            if locale == 'en':
                status = "✅ Source"
            elif todo_count == 0:
                status = "✅ Complete"
            elif todo_count < 50:
                status = "🟡 In Progress"
            else:
                status = "🔴 Needs Work"
            
            f.write(f"| {locale} | {todo_count} | {status} |\n")
        
        f.write("\n## Next Steps\n")
        f.write("1. Review the TODO list in `todo_list.txt`\n")
        f.write("2. Prioritize high-impact strings (UI labels, error messages)\n")
        f.write("3. Work on one locale at a time\n")
        f.write("4. Run `npm run gen-todos` to regenerate this list after updates\n")
    
    print(f"✅ Generated TODO list: {output_file}")
    print(f"✅ Generated progress report: {report_file}")
    print(f"📊 Total TODO items: {total_todos}")

if __name__ == "__main__":
    generate_todo_list() 