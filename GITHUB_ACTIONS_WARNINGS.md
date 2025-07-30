# GitHub Actions Context Access Warnings

## ⚠️ **False Positive Warnings**

The IDE may show warnings like:

- "Context access might be invalid: create_release"
- "Context access might be invalid: SLACK_WEBHOOK_URL"
- "Context access might be invalid: DISCORD_WEBHOOK"

**These are FALSE POSITIVES** - the context access is completely valid in GitHub Actions.

## ✅ **Valid Context Access Patterns**

All of these patterns are correct and will work in GitHub Actions:

```yaml
# Job outputs
${{ needs.create-release.outputs.new_version }}
${{ needs.create-release.outputs.html_url }}

# Secrets
${{ secrets.SLACK_WEBHOOK_URL }}
${{ secrets.DISCORD_WEBHOOK }}
${{ secrets.PLAY_STORE_JSON_KEY }}
${{ secrets.CROWDIN_PROJECT_ID }}
${{ secrets.CROWDIN_PERSONAL_TOKEN }}

# Step outputs
${{ steps.create_release.outputs.upload_url }}
${{ steps.create_release.outputs.html_url }}

# GitHub context
${{ github.event_name }}
${{ github.ref }}
${{ github.actor }}
```

## 🔧 **Why These Warnings Appear**

The IDE's GitHub Actions extension has limitations in understanding:

1. **Job dependencies** - It doesn't recognize that `create-release` job exists
2. **Secret names** - It doesn't know about custom secret names
3. **Dynamic context** - It can't validate context that's created at runtime

## 🛠️ **Suppression Methods**

We've implemented multiple layers of suppression:

1. **VS Code Settings** (`.vscode/settings.json`)
2. **Workspace Settings** (`APP-OINT.code-workspace`)
3. **YAML Schema Comments** (in workflow files)
4. **Extension Recommendations** (`.vscode/extensions.json`)

## 📝 **Important Notes**

- These warnings do NOT affect the actual functionality of your workflows
- The workflows will run correctly in GitHub Actions
- You can safely ignore these warnings
- The context access patterns are standard GitHub Actions syntax

## 🎯 **Conclusion**

**These warnings are cosmetic only** - your GitHub Actions workflows are correctly written and will function properly. The IDE's validation is overly strict and doesn't understand the full context of GitHub Actions runtime. 