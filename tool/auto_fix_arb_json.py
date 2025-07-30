import os
import re

ARB_DIR = 'lib/l10n'

for filename in os.listdir(ARB_DIR):
    if filename.startswith('app_') and filename.endswith('.arb'):
        path = os.path.join(ARB_DIR, filename)
        with open(path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
        # Remove any lines after the first closing brace
        new_lines = []
        found_closing = False
        for line in lines:
            if not found_closing:
                new_lines.append(line)
                if line.strip() == '}':
                    found_closing = True
        # Remove trailing commas before closing brace
        for i in range(len(new_lines)-2, 0, -1):
            if new_lines[i].strip() == '}' and new_lines[i-1].strip().endswith(','):
                new_lines[i-1] = new_lines[i-1].rstrip(',\n') + '\n'
        # Add missing commas between entries
        for i in range(1, len(new_lines)-2):
            line = new_lines[i].rstrip('\n')
            next_line = new_lines[i+1].strip()
            if (line.endswith('}') or line.endswith(']') or re.match(r'"[^"]+":', line)) and not line.endswith(',') and next_line and not next_line == '}':
                new_lines[i] = line + ',\n'
        # Write back
        with open(path, 'w', encoding='utf-8') as f:
            f.writelines(new_lines)
        print(f"Auto-fixed commas in {filename}") 