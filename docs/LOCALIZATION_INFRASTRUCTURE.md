# APP-OINT Localization Infrastructure

## Overview

This document describes the comprehensive localization infrastructure implemented for APP-OINT, supporting 32 languages with automated CI/CD, quality checks, and translation workflows.

## 🏗️ Infrastructure Components

### 1. **Continuous Localization CI** (.github/workflows/localization.yml)
- **Triggers**: Runs on every PR and push to main
- **Validations**:
  - ARB file structure validation
  - Key count consistency across all locales
  - Localization generation (`flutter gen-l10n`)
  - Spell checking (`cspell`)
  - Flutter analysis
  - TODO list generation

### 2. **Pre-commit Hooks** (.husky/pre-commit)
- **Spell checking** on staged ARB files
- **Flutter analysis** on staged Dart files
- **Automatic validation** before commits

### 3. **ARB Management Tools** (tool/)
- **`merge_arb.js`**: Merges new keys from `app_en.arb` to all locales
- **`generate_todo_list.sh`**: Creates comprehensive TODO lists for translators
- **`back_translation_check.py`**: Validates translation quality and structure

### 4. **Translation Dashboard** (LOCALIZATION_DASHBOARD.md)
- **Platform recommendations** (Phrase, Crowdin, Custom)
- **Setup guides** and integration instructions
- **Workflow documentation**

## 🚀 Quick Start

### Setup Development Environment
```bash
# Install Node.js dependencies
npm install

# Setup pre-commit hooks
npm run setup-hooks

# Verify installation
npm run localization-ci
```

### Daily Development Workflow
```bash
# 1. Add new keys to app_en.arb
# 2. Merge to all locales
npm run merge-arb

# 3. Generate TODO list for translators
npm run gen-todos

# 4. Check translation quality
npm run check-translations

# 5. Commit changes (hooks will run automatically)
git add .
git commit -m "Add new localization keys"
```

## 📋 Available Scripts

| Script | Description |
|--------|-------------|
| `npm run spell-check` | Check spelling in ARB files |
| `npm run analyze` | Run Flutter analysis |
| `npm run gen-todos` | Generate TODO list for translations |
| `npm run merge-arb` | Merge new keys to all locales |
| `npm run check-translations` | Validate translation quality |
| `npm run localization-ci` | Run full localization CI locally |
| `npm run setup-hooks` | Setup pre-commit hooks |

## 🔧 Tool Documentation

### ARB Merge Script (`tool/merge_arb.js`)
**Purpose**: Automatically adds new keys from `app_en.arb` to all other locale files with `TODO:` placeholders.

**Usage**:
```bash
npm run merge-arb
```

**Features**:
- Reads `app_en.arb` as master
- Adds missing keys to all 31 other locales
- Preserves existing translations
- Adds `TODO:` prefix for new keys
- Includes metadata (`@key` descriptions)

### TODO List Generator (`tool/generate_todo_list.sh`)
**Purpose**: Creates comprehensive lists of translation tasks for the translation team.

**Usage**:
```bash
npm run gen-todos
```

**Outputs**:
- `todo_list.txt`: Detailed TODO list by locale
- `translation_report.md`: Progress report with statistics

### Back Translation Check (`tool/back_translation_check.py`)
**Purpose**: Validates translation quality and identifies remaining TODO placeholders.

**Usage**:
```bash
npm run check-translations
```

**Features**:
- Detects TODO placeholders
- Validates ARB file structure
- Generates quality reports
- Exits with error if TODOs found

## 🌐 Supported Languages

| Code | Language | Code | Language |
|------|----------|------|----------|
| ar | Arabic | bg | Bulgarian |
| cs | Czech | da | Danish |
| de | German | en | English |
| es | Spanish | fi | Finnish |
| fr | French | he | Hebrew |
| hu | Hungarian | id | Indonesian |
| it | Italian | ja | Japanese |
| ko | Korean | lt | Lithuanian |
| ms | Malay | nl | Dutch |
| no | Norwegian | pl | Polish |
| pt | Portuguese | ro | Romanian |
| ru | Russian | sk | Slovak |
| sl | Slovenian | sr | Serbian |
| sv | Swedish | th | Thai |
| tr | Turkish | uk | Ukrainian |
| vi | Vietnamese | zh | Chinese |

## 🔄 CI/CD Pipeline

### GitHub Actions Workflow
The localization CI runs automatically on every PR and includes:

1. **Environment Setup**
   - Flutter 3.3.0
   - Node.js 18
   - cspell for spell checking

2. **Validation Steps**
   - ARB file structure validation
   - Key count consistency check
   - Localization generation
   - Generated file verification
   - Flutter analysis
   - Spell checking

3. **Artifacts**
   - TODO list uploaded as artifact
   - Build logs for debugging

### Pre-commit Hooks
Automatically run before each commit:
- Spell checking on ARB files
- Flutter analysis on Dart files
- Prevents commits with errors

## 📊 Quality Assurance

### Automated Checks
- **Spell checking**: Uses cspell with custom dictionaries
- **Structure validation**: Ensures all ARB files have same keys
- **Format validation**: JSON syntax and ARB format compliance
- **Placeholder validation**: Checks for TODO placeholders

### Manual Review Process
1. **Translation review** by native speakers
2. **Cultural appropriateness** validation
3. **Technical accuracy** verification
4. **User experience** testing

## 🛠️ Troubleshooting

### Common Issues

**ARB files have different key counts**
```bash
# Run merge script to sync all files
npm run merge-arb
```

**Spell check fails**
```bash
# Add words to cspell dictionary
echo "newword" >> .cspell.json
```

**Pre-commit hooks not working**
```bash
# Reinstall hooks
npm run setup-hooks
```

**Generated files missing**
```bash
# Regenerate localizations
flutter gen-l10n
```

### Debug Commands
```bash
# Check ARB file structure
grep -c '^  "' lib/l10n/app_*.arb

# Validate JSON syntax
for file in lib/l10n/app_*.arb; do
  echo "Checking $file..."
  python3 -m json.tool "$file" > /dev/null
done

# Count TODO items
grep -c "TODO:" lib/l10n/app_*.arb
```

## 📈 Monitoring and Metrics

### Key Metrics
- **Translation completion rate**: Percentage of non-TODO strings
- **Quality score**: Based on spell check and validation results
- **CI success rate**: Percentage of successful CI runs
- **Translation velocity**: New translations per week

### Reports Generated
- `todo_list.txt`: Current translation tasks
- `translation_report.md`: Progress overview
- `translation_quality_report.md`: Quality metrics

## 🔮 Future Enhancements

### Planned Features
1. **Translation memory** integration
2. **Automated quality scoring**
3. **Translation suggestion AI**
4. **Real-time collaboration tools**
5. **Advanced analytics dashboard**

### Integration Opportunities
- **Phrase/Crowdin** for translation management
- **Slack/Teams** notifications for CI failures
- **Jira/Linear** integration for translation tasks
- **Analytics** for translation usage patterns

## 📚 Resources

- [Flutter Localization Guide](https://flutter.dev/docs/development/accessibility-and-localization)
- [ARB Format Specification](https://github.com/google/app-resource-bundle)
- [Phrase Documentation](https://phrase.com/docs)
- [Crowdin Documentation](https://support.crowdin.com)

## 🤝 Contributing

### For Developers
1. Add new keys to `app_en.arb`
2. Run `npm run merge-arb`
3. Test with `npm run localization-ci`
4. Submit PR

### For Translators
1. Review `todo_list.txt`
2. Edit ARB files directly or use dashboard
3. Remove `TODO:` prefix when translating
4. Test with `npm run check-translations`

---

*This infrastructure ensures high-quality, consistent translations across all 32 supported languages while maintaining developer productivity and translation team efficiency.* 