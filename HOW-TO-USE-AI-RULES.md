# How to Use AI Agent Rules

## 🎯 Purpose
This system lets you set up rules for AI agents (like me) so you don't have to re-explain your preferences every time you start a new conversation.

## 🚀 Quick Setup

### Option 1: Automated Setup (Recommended)
```bash
python setup-agent-rules.py
```
This will ask you a few questions and configure everything automatically.

### Option 2: Manual Setup
Edit the `.ai-agent-rules.md` file directly and replace the placeholder text with your preferences.

## 💬 How to Use in Conversations

When starting a new conversation with any AI agent, simply say:

> **"Please read my .ai-agent-rules.md file first"**

The AI agent will then:
1. Read your rules file
2. Follow your specified preferences throughout the conversation
3. Remember your coding style, communication preferences, and restrictions

## 📝 Example Usage

**You:** "Please read my .ai-agent-rules.md file first, then help me fix the ARB file syntax errors."

**AI Agent:** *(reads rules)* "I see you prefer brief responses, always want backups before bulk changes, and use 2-space indentation. I'll backup the ARB files first, then fix the syntax errors following your JSON validation requirements..."

## 🔧 Updating Rules

- **Add new rules**: Edit `.ai-agent-rules.md` directly
- **Quick changes**: Run `python setup-agent-rules.py` again
- **Emergency override**: In conversation, say "Ignore my rules for this task and [specific instruction]"

## 📁 Files Created

- `.ai-agent-rules.md` - Your rules file (this is the important one)
- `setup-agent-rules.py` - Setup script for easy configuration
- `HOW-TO-USE-AI-RULES.md` - This instruction file

## ✅ That's It!

Now you'll never have to re-explain your preferences to AI agents again. Just tell them to read your rules file first!