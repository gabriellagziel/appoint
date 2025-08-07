import os
import json
import re

ARB_DIR = 'lib/l10n'

def repair_arb_file(filepath):
    """Repair a single ARB file to valid JSON format."""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Remove any content after the first closing brace
        brace_count = 0
        end_pos = 0
        for i, char in enumerate(content):
            if char == '{':
                brace_count += 1
            elif char == '}':
                brace_count -= 1
                if brace_count == 0:
                    end_pos = i + 1
                    break
        
        content = content[:end_pos]
        
        # Fix common JSON issues
        # Remove trailing commas before closing braces
        content = re.sub(r',\s*}', '}', content)
        content = re.sub(r',\s*]', ']', content)
        
        # Add missing commas between entries
        lines = content.split('\n')
        fixed_lines = []
        
        for i, line in enumerate(lines):
            fixed_lines.append(line)
            if i < len(lines) - 1:
                current_line = line.strip()
                next_line = lines[i + 1].strip()
                
                # If current line ends with } or " and next line starts with " or {, add comma
                if (current_line.endswith('}') or current_line.endswith('"')) and \
                   (next_line.startswith('"') or next_line.startswith('{')) and \
                   not current_line.endswith(',') and \
                   not next_line.startswith('}') and \
                   not next_line.startswith(']'):
                    fixed_lines[-1] = line.rstrip() + ','
        
        content = '\n'.join(fixed_lines)
        
        # Try to parse as JSON
        data = json.loads(content)
        
        # Write back with proper formatting
        with open(filepath, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        
        return True
    except Exception as e:
        print(f"Failed to repair {os.path.basename(filepath)}: {e}")
        return False

# Repair all ARB files
success_count = 0
total_count = 0

for filename in os.listdir(ARB_DIR):
    if filename.startswith('app_') and filename.endswith('.arb'):
        total_count += 1
        filepath = os.path.join(ARB_DIR, filename)
        if repair_arb_file(filepath):
            success_count += 1
            print(f"✓ Repaired {filename}")
        else:
            print(f"✗ Failed to repair {filename}")

print(f"\nRepair summary: {success_count}/{total_count} files repaired successfully") 