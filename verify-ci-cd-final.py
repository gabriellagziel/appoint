#!/usr/bin/env python3
"""
Final CI/CD Pipeline Verification Script
Verifies that all workflows are properly configured and production-ready.
"""

import os
import yaml
import re
from pathlib import Path

def check_workflow_file(file_path):
    """Check a single workflow file for common issues."""
    issues = []
    
    try:
        with open(file_path, 'r') as f:
            content = f.read()
            workflow = yaml.safe_load(content)
    except Exception as e:
        return [f"Failed to parse {file_path}: {e}"]
    
    # Skip deployment-config.yml as it's not a workflow file
    if file_path.name == "deployment-config.yml":
        return []
    
    # Check for required fields
    if 'name' not in workflow:
        issues.append("Missing 'name' field")
    
    if 'on' not in workflow:
        issues.append("Missing 'on' field")
    
    if 'jobs' not in workflow:
        issues.append("Missing 'jobs' field")
    
    # Check Flutter version consistency (only for workflows that use Flutter)
    if file_path.name in ["ci-cd-pipeline.yml", "ci.yml", "android-build.yml", "ios-build.yml", "security-qa.yml", "coverage-badge.yml", "nightly.yml", "l10n-check.yml"]:
        flutter_version_pattern = r"flutter-version:\s*['\"]?3\.24\.5['\"]?"
        if not re.search(flutter_version_pattern, content):
            issues.append("Flutter version should be 3.24.5")
    
    # Check for security issues (but allow legitimate secret references)
    if "password" in content.lower() or "secret" in content.lower():
        # Check if it's a legitimate secret reference
        if not re.search(r'\${{.*secrets\.', content):
            issues.append("Potential hardcoded secrets found")
    
    return issues

def verify_secrets_documentation():
    """Verify that secrets are properly documented."""
    secrets_file = Path(".github/workflows/secrets-management.md")
    if not secrets_file.exists():
        return ["Missing secrets-management.md file"]
    
    with open(secrets_file, 'r') as f:
        content = f.read()
    
    required_secrets = [
        "FIREBASE_TOKEN",
        "ANDROID_KEYSTORE_BASE64", 
        "PLAY_STORE_JSON_KEY",
        "IOS_P12_CERTIFICATE",
        "DIGITALOCEAN_ACCESS_TOKEN"
    ]
    
    missing_secrets = []
    for secret in required_secrets:
        if secret not in content:
            missing_secrets.append(secret)
    
    if missing_secrets:
        return [f"Missing documentation for secrets: {', '.join(missing_secrets)}"]
    
    return []

def verify_workflow_structure():
    """Verify the overall workflow structure."""
    workflows_dir = Path(".github/workflows")
    
    if not workflows_dir.exists():
        return ["Workflows directory does not exist"]
    
    # Expected workflows after cleanup
    expected_workflows = [
        "ci-cd-pipeline.yml",
        "ci.yml", 
        "android-build.yml",
        "ios-build.yml",
        "security-qa.yml",
        "coverage-badge.yml",
        "branch-protection-check.yml",
        "l10n-check.yml",
        "sync-translations.yml",
        "nightly.yml",
        "README.md",
        "secrets-management.md",
        "deployment-config.yml"
    ]
    
    actual_workflows = [f.name for f in workflows_dir.iterdir() if f.is_file()]
    
    missing_workflows = set(expected_workflows) - set(actual_workflows)
    extra_workflows = set(actual_workflows) - set(expected_workflows)
    
    issues = []
    if missing_workflows:
        issues.append(f"Missing expected workflows: {', '.join(missing_workflows)}")
    if extra_workflows:
        issues.append(f"Unexpected workflows found: {', '.join(extra_workflows)}")
    
    return issues

def main():
    """Main verification function."""
    print("🔍 Verifying CI/CD Pipeline Configuration...")
    print("=" * 50)
    
    all_issues = []
    
    # Check workflow structure
    print("📁 Checking workflow structure...")
    structure_issues = verify_workflow_structure()
    if structure_issues:
        all_issues.extend(structure_issues)
        for issue in structure_issues:
            print(f"  ❌ {issue}")
    else:
        print("  ✅ Workflow structure is correct")
    
    # Check individual workflow files
    print("\n📄 Checking individual workflow files...")
    workflows_dir = Path(".github/workflows")
    
    for workflow_file in workflows_dir.glob("*.yml"):
        print(f"  🔍 Checking {workflow_file.name}...")
        issues = check_workflow_file(workflow_file)
        if issues:
            all_issues.extend([f"{workflow_file.name}: {issue}" for issue in issues])
            for issue in issues:
                print(f"    ❌ {issue}")
        else:
            print(f"    ✅ {workflow_file.name} is properly configured")
    
    # Check secrets documentation
    print("\n🔐 Checking secrets documentation...")
    secrets_issues = verify_secrets_documentation()
    if secrets_issues:
        all_issues.extend(secrets_issues)
        for issue in secrets_issues:
            print(f"  ❌ {issue}")
    else:
        print("  ✅ Secrets documentation is complete")
    
    # Summary
    print("\n" + "=" * 50)
    if all_issues:
        print("❌ CI/CD Pipeline Verification Failed")
        print(f"Found {len(all_issues)} issues:")
        for issue in all_issues:
            print(f"  - {issue}")
        return False
    else:
        print("✅ CI/CD Pipeline Verification Passed")
        print("All workflows are properly configured and production-ready!")
        return True

if __name__ == "__main__":
    success = main()
    exit(0 if success else 1)