#!/usr/bin/env python3
"""
Agent Rules Manager

A simple utility to help manage and update your .agent-rules.md file.
Use this to quickly update preferences and rules without manually editing the markdown.
"""

import os
import sys
from datetime import datetime

RULES_FILE = ".agent-rules.md"

def add_rule(section, rule_text):
    """Add a new rule to the specified section."""
    if not os.path.exists(RULES_FILE):
        print(f"Error: {RULES_FILE} not found. Please create it first.")
        return False
    
    # Read current content
    with open(RULES_FILE, 'r') as f:
        content = f.read()
    
    # Add the rule (simple implementation - could be enhanced)
    section_marker = f"### {section}"
    if section_marker in content:
        # Find the section and add the rule
        lines = content.split('\n')
        for i, line in enumerate(lines):
            if line.strip() == section_marker:
                # Find the next section or end of file
                j = i + 1
                while j < len(lines) and not lines[j].startswith('###') and not lines[j].startswith('##'):
                    j += 1
                # Insert the new rule before the next section
                lines.insert(j - 1, f"- {rule_text}")
                break
        
        # Write back
        with open(RULES_FILE, 'w') as f:
            f.write('\n'.join(lines))
        
        print(f"Added rule to {section}: {rule_text}")
        update_timestamp()
        return True
    else:
        print(f"Section '{section}' not found in {RULES_FILE}")
        return False

def update_timestamp():
    """Update the 'Last Updated' section with current timestamp."""
    if not os.path.exists(RULES_FILE):
        return
    
    with open(RULES_FILE, 'r') as f:
        content = f.read()
    
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    # Replace the Last Updated section
    lines = content.split('\n')
    for i, line in enumerate(lines):
        if line.startswith('## Last Updated'):
            if i + 1 < len(lines):
                lines[i + 1] = f"{timestamp} - Updated via agent-rules-manager"
            break
    
    with open(RULES_FILE, 'w') as f:
        f.write('\n'.join(lines))

def show_current_rules():
    """Display current rules."""
    if not os.path.exists(RULES_FILE):
        print(f"Error: {RULES_FILE} not found.")
        return
    
    with open(RULES_FILE, 'r') as f:
        content = f.read()
    
    print("Current Agent Rules:")
    print("=" * 50)
    print(content)

def quick_setup():
    """Quick setup wizard for common preferences."""
    print("Agent Rules Quick Setup")
    print("=" * 30)
    
    preferences = {}
    
    # Ask for basic preferences
    preferences['language'] = input("Primary programming language (e.g., Dart, Python, JavaScript): ").strip()
    preferences['formatting'] = input("Code formatting preference (e.g., 2 spaces, 4 spaces, tabs): ").strip()
    preferences['detail_level'] = input("Response detail level (verbose/concise): ").strip()
    preferences['testing'] = input("Testing approach (always test/manual testing/test-driven): ").strip()
    
    # Update the rules file
    if os.path.exists(RULES_FILE):
        with open(RULES_FILE, 'r') as f:
            content = f.read()
        
        # Replace placeholders
        content = content.replace('[Specify your preferred languages - e.g., Dart/Flutter, Python, JavaScript]', preferences['language'])
        content = content.replace('[Your formatting preferences - e.g., 2 spaces, 4 spaces, tabs]', preferences['formatting'])
        content = content.replace('[Verbose explanations vs. concise responses]', preferences['detail_level'])
        content = content.replace('[Your testing preferences - e.g., always write tests, test-driven development]', preferences['testing'])
        
        with open(RULES_FILE, 'w') as f:
            f.write(content)
        
        update_timestamp()
        print("\nAgent rules updated successfully!")
        print(f"You can further customize by editing {RULES_FILE} directly.")
    else:
        print(f"Error: {RULES_FILE} not found.")

def main():
    if len(sys.argv) < 2:
        print("Agent Rules Manager")
        print("Usage:")
        print("  python agent-rules-manager.py setup       # Quick setup wizard")
        print("  python agent-rules-manager.py show        # Show current rules")
        print("  python agent-rules-manager.py add <section> <rule>  # Add a rule")
        print("  python agent-rules-manager.py update      # Update timestamp")
        return
    
    command = sys.argv[1].lower()
    
    if command == 'setup':
        quick_setup()
    elif command == 'show':
        show_current_rules()
    elif command == 'add' and len(sys.argv) >= 4:
        section = sys.argv[2]
        rule = ' '.join(sys.argv[3:])
        add_rule(section, rule)
    elif command == 'update':
        update_timestamp()
        print("Timestamp updated.")
    else:
        print("Unknown command or insufficient arguments.")

if __name__ == "__main__":
    main()