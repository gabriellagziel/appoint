import os

ARB_DIR = 'lib/l10n'

for filename in os.listdir(ARB_DIR):
    if filename.startswith('app_') and filename.endswith('.arb'):
        path = os.path.join(ARB_DIR, filename)
        with open(path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
        new_lines = []
        found_closing = False
        for line in lines:
            if not found_closing:
                new_lines.append(line)
                if line.strip() == '}':
                    found_closing = True
        # Only keep content up to and including the first closing brace
        with open(path, 'w', encoding='utf-8') as f:
            f.writelines(new_lines)
        print(f"Stripped after closing brace in {filename}") 