# Agent Rules System - Quick Reference

This system helps you maintain persistent preferences and instructions for AI agents, so you don't have to re-explain your requirements every time you start a new session.

## Files Created

1. **`.agent-rules.md`** - Main rules file containing all your preferences
2. **`agent-rules-manager.py`** - Python utility to manage the rules file
3. **`README-agent-rules.md`** - This guide

## Quick Start

### Option 1: Interactive Setup
```bash
python agent-rules-manager.py setup
```
This will walk you through setting up your basic preferences.

### Option 2: Manual Editing
Open `.agent-rules.md` and fill in your preferences by replacing the placeholder text in brackets `[like this]`.

## Usage Examples

### Tell the Agent to Check Your Rules
When starting a new conversation, simply say:
> "Please check my `.agent-rules.md` file to understand my preferences before we begin."

### Update Rules via Script
```bash
# Add a new rule to the Do's section
python agent-rules-manager.py add "Do's" "Always validate JSON syntax in ARB files"

# Show current rules
python agent-rules-manager.py show

# Update timestamp
python agent-rules-manager.py update
```

### Common Use Cases

**For Code Style:**
```markdown
- **Language**: Dart/Flutter primary, Python for scripts
- **Formatting**: 2 spaces for indentation, no trailing commas in Dart
- **Naming Convention**: camelCase for Dart variables, snake_case for Python
```

**For Workflow:**
```markdown
- Always run `flutter analyze` before committing
- Backup ARB files before bulk operations
- Include progress indicators in long-running scripts
```

**For Communication:**
```markdown
- **Detail Level**: Concise explanations with code examples
- **Planning**: Show brief plan before implementation
- **Validation**: Always test critical changes
```

## Key Sections to Fill Out

### High Priority
1. **General Coding Preferences** - Your coding style and standards
2. **Project-Specific Rules** - Rules specific to this translation system
3. **Communication Preferences** - How you want the agent to respond
4. **Custom Instructions Do's/Don'ts** - Specific requirements

### Medium Priority
5. **Workflow Preferences** - Testing, documentation, error handling
6. **Context & Background** - Project goals and current challenges

## Tips for Effective Rules

### Be Specific
❌ "Good code quality"
✅ "Always include error handling, validate inputs, add logging for debugging"

### Include Examples
❌ "Follow naming conventions"
✅ "Use camelCase for variables (userName), PascalCase for classes (UserManager)"

### Update Regularly
- Review and update rules monthly
- Add new rules as patterns emerge
- Remove outdated preferences

### Reference in Conversations
- "As per my agent rules, please use 2-space indentation"
- "Following the translation system rules, backup the ARB files first"
- "Check the Do's section in my rules before proceeding"

## Agent Instructions

When an AI agent first encounters this system, it should:

1. **Read the rules file** using the `read_file` tool
2. **Acknowledge the preferences** by summarizing key points
3. **Apply the rules** throughout the conversation
4. **Ask for clarification** if rules conflict with requests

## Maintenance

### Regular Updates
- Add new preferences as you discover them
- Update project context as goals change
- Refine rules based on agent interactions

### Version Control
- Keep the rules file in your git repository
- Track changes to see how preferences evolve
- Share with team members for consistency

### Backup
The rules file is just markdown, so it's easy to backup and restore.

## Advanced Usage

### Multiple Projects
Create project-specific rules files:
- `.agent-rules-flutter.md`
- `.agent-rules-python.md`
- `.agent-rules-web.md`

### Team Rules
Combine personal preferences with team standards:
```markdown
## Personal Preferences
[Your individual preferences]

## Team Standards
[Shared team rules]
```

### Integration with IDEs
Add rules file to your IDE favorites for quick access and editing.

---

## Troubleshooting

**Q: Agent isn't following my rules**
A: Explicitly mention "Please refer to my .agent-rules.md file" at the start of conversations.

**Q: Rules conflict with a specific request**
A: Be explicit about which rule to override: "Ignore the 2-space rule for this CSS file, use 4 spaces."

**Q: Too many rules to manage**
A: Start with the most important 5-10 rules. Add more gradually.

---

*Save time and improve consistency by maintaining your agent rules!*