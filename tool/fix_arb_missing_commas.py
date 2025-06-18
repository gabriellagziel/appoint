import os

ARB_DIR = 'lib/l10n'

for filename in os.listdir(ARB_DIR):
    if filename.startswith('app_') and filename.endswith('.arb'):
        path = os.path.join(ARB_DIR, filename)
        with open(path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
        new_lines = []
        i = 0
        while i < len(lines):
            new_lines.append(lines[i])
            if '"@failedToUpdateConsent"' in lines[i]:
                # Look ahead for the closing brace
                j = i + 1
                while j < len(lines) and '}' not in lines[j]:
                    j += 1
                if j < len(lines):
                    # If the next non-empty line after } is not a comma, add one
                    if not lines[j].strip().endswith(','):
                        lines[j] = lines[j].rstrip('\n') + ',\n'
                i = j
            i += 1
        with open(path, 'w', encoding='utf-8') as f:
            f.writelines(new_lines)
        print(f"Checked/fixed {filename}") 