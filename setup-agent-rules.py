#!/usr/bin/env python3
"""
Quick setup for AI Agent Rules

Run this to quickly configure your .ai-agent-rules.md file
"""

import os
from datetime import datetime

RULES_FILE = ".ai-agent-rules.md"

def quick_setup():
    print("🤖 AI Agent Rules Quick Setup")
    print("=" * 40)
    print("This will help you set up rules for AI agents to follow.")
    print("You can always edit the .ai-agent-rules.md file manually later.\n")
    
    # Communication preferences
    print("📝 Communication Style:")
    response_length = input("Response length (brief/balanced/detailed): ").strip().lower()
    tech_level = input("Technical level (beginner/intermediate/advanced): ").strip().lower()
    confirmation = input("Confirmation style (always-ask/confident/destructive-only): ").strip().lower()
    
    # Code preferences
    print("\n💻 Code & Development:")
    languages = input("Primary languages (e.g., 'Dart/Flutter, Python'): ").strip()
    code_style = input("Code style (e.g., '2 spaces, camelCase'): ").strip()
    testing = input("Testing approach (always/manual/tdd): ").strip()
    
    # Workflow
    print("\n⚙️ Workflow:")
    show_plans = input("Show plans before implementing? (always/never/ask): ").strip().lower()
    parallel_ops = input("Use parallel operations when possible? (yes/no/ask): ").strip().lower()
    
    # Do's and Don'ts
    print("\n✅ Rules:")
    always_do = input("Something you ALWAYS want me to do (e.g., 'Backup files before changes'): ").strip()
    never_do = input("Something you NEVER want me to do (e.g., 'Delete files without asking'): ").strip()
    ask_first = input("Something I should ASK before doing (e.g., 'Installing dependencies'): ").strip()
    
    # Apply to file
    if os.path.exists(RULES_FILE):
        with open(RULES_FILE, 'r') as f:
            content = f.read()
        
        # Replace placeholders
        replacements = {
            '[Choose: Brief and concise / Detailed explanations / Balanced]': response_length,
            '[Choose: Beginner-friendly / Intermediate / Advanced technical depth]': tech_level,
            '[Choose: Always ask before major changes / Proceed with confidence / Ask only for destructive operations]': confirmation,
            '[e.g., Dart/Flutter, Python, JavaScript]': languages,
            '[e.g., 2 spaces, camelCase for Dart, snake_case for Python]': code_style,
            '[e.g., Always include tests / Manual testing only / Test-driven development]': testing,
            '[Choose: Always show plan before implementing / Jump straight to implementation / Ask if plan needed]': show_plans,
            '[Choose: Use parallel tools when possible / Sequential operations preferred / Ask before parallel execution]': parallel_ops,
            '[Date and brief description of changes]': f"{datetime.now().strftime('%Y-%m-%d %H:%M:%S')} - Initial setup"
        }
        
        for placeholder, replacement in replacements.items():
            content = content.replace(placeholder, replacement)
        
        # Add specific rules
        if always_do:
            content = content.replace('- [Add more as needed]', f'- {always_do}\n- [Add more as needed]', 1)
        if never_do:
            lines = content.split('\n')
            for i, line in enumerate(lines):
                if '- [Add more as needed]' in line and 'NEVER Do:' in '\n'.join(lines[max(0, i-5):i]):
                    lines[i] = f'- {never_do}\n- [Add more as needed]'
                    break
            content = '\n'.join(lines)
        if ask_first:
            lines = content.split('\n')
            for i, line in enumerate(lines):
                if '- [Add more as needed]' in line and 'ASK FIRST Before:' in '\n'.join(lines[max(0, i-5):i]):
                    lines[i] = f'- {ask_first}\n- [Add more as needed]'
                    break
            content = '\n'.join(lines)
        
        with open(RULES_FILE, 'w') as f:
            f.write(content)
        
        print(f"\n✅ Agent rules configured successfully!")
        print(f"📁 File: {RULES_FILE}")
        print("\n📋 How to use:")
        print("   1. In future conversations, say: 'Please read my .ai-agent-rules.md file first'")
        print("   2. The AI agent will follow your specified preferences")
        print("   3. Edit the file anytime to update your rules")
        print("\n🔧 You can further customize by editing the file manually.")
        
    else:
        print(f"❌ Error: {RULES_FILE} not found. Please create it first.")

if __name__ == "__main__":
    quick_setup()