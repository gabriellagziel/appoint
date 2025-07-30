#!/usr/bin/env python3
"""
Simple CI/CD Setup Verification Script

This script verifies that all CI/CD workflows are properly configured
by checking basic file structure and content.
"""

import os
from pathlib import Path

def check_workflow_basic(file_path):
    """Check if a workflow file has basic required structure."""
    try:
        with open(file_path, 'r') as f:
            content = f.read()
        
        # Check for required keywords
        required_keywords = ['name:', 'on:']
        missing_keywords = []
        
        for keyword in required_keywords:
            if keyword not in content:
                missing_keywords.append(keyword)
        
        if missing_keywords:
            return False, f"Missing required keywords: {', '.join(missing_keywords)}"
        
        # Check if it's a deprecated file
        if str(file_path).endswith('.deprecated'):
            return True, "Deprecated file (expected)"
        
        return True, "Valid workflow file"
    except Exception as e:
        return False, f"Error reading file: {str(e)}"

def check_secrets_usage(file_path):
    """Check if workflow uses secrets properly."""
    try:
        with open(file_path, 'r') as f:
            content = f.read()
        
        # Check for hardcoded secrets (basic check)
        suspicious_patterns = [
            'password: "',
            'token: "',
            'key: "',
            'secret: "',
        ]
        
        for pattern in suspicious_patterns:
            if pattern in content:
                return False, f"Potential hardcoded secret found: {pattern}"
        
        return True, "No hardcoded secrets detected"
    except Exception as e:
        return False, f"Error reading file: {str(e)}"

def main():
    """Main verification function."""
    print("🔍 CI/CD Setup Verification (Simple)")
    print("=" * 50)
    
    workflows_dir = Path(".github/workflows")
    
    # Check if workflows directory exists
    if not workflows_dir.exists():
        print("❌ .github/workflows directory not found")
        return
    
    # Get all workflow files
    workflow_files = list(workflows_dir.glob("*.yml")) + list(workflows_dir.glob("*.yaml"))
    
    print(f"📁 Found {len(workflow_files)} workflow files")
    print()
    
    # Check each workflow file
    valid_workflows = []
    deprecated_workflows = []
    invalid_workflows = []
    
    for workflow_file in workflow_files:
        is_valid, message = check_workflow_basic(workflow_file)
        secrets_ok, secrets_message = check_secrets_usage(workflow_file)
        
        if str(workflow_file).endswith('.deprecated'):
            deprecated_workflows.append(workflow_file.name)
            print(f"📄 {workflow_file.name}: {message}")
        elif is_valid and secrets_ok:
            valid_workflows.append(workflow_file.name)
            print(f"✅ {workflow_file.name}: {message}")
        else:
            invalid_workflows.append(workflow_file.name)
            print(f"❌ {workflow_file.name}: {message}")
            if not secrets_ok:
                print(f"   ⚠️  {secrets_message}")
    
    print()
    print("📊 Summary:")
    print(f"   ✅ Valid workflows: {len(valid_workflows)}")
    print(f"   📄 Deprecated workflows: {len(deprecated_workflows)}")
    print(f"   ❌ Invalid workflows: {len(invalid_workflows)}")
    
    # Check for required workflows
    required_workflows = [
        'test.yml',
        'build.yml', 
        'deploy.yml',
        'android_release.yml',
        'ios_build.yml'
    ]
    
    print()
    print("🎯 Required Workflows Check:")
    for workflow in required_workflows:
        if workflow in valid_workflows:
            print(f"   ✅ {workflow}")
        else:
            print(f"   ❌ {workflow} (missing)")
    
    # Check for deprecated workflows that should be removed
    print()
    print("🧹 Cleanup Recommendations:")
    if deprecated_workflows:
        print("   The following deprecated workflows can be removed:")
        for workflow in deprecated_workflows:
            print(f"   - {workflow}")
    else:
        print("   ✅ No deprecated workflows found")
    
    # Final status
    print()
    if len(invalid_workflows) == 0 and all(w in valid_workflows for w in required_workflows):
        print("🎉 CI/CD Setup Verification: PASSED")
        print("   All workflows are properly configured and ready for production use.")
    else:
        print("⚠️  CI/CD Setup Verification: NEEDS ATTENTION")
        if invalid_workflows:
            print(f"   - {len(invalid_workflows)} invalid workflow(s) need fixing")
        missing = [w for w in required_workflows if w not in valid_workflows]
        if missing:
            print(f"   - {len(missing)} required workflow(s) missing: {', '.join(missing)}")

if __name__ == "__main__":
    main()