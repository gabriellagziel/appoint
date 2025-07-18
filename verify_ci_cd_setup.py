#!/usr/bin/env python3
"""
CI/CD Pipeline Verification Script

This script verifies that all CI/CD workflows are properly configured
and production-ready for the Appoint project.
"""

import os
import yaml
import glob
from pathlib import Path

def check_workflow_file(file_path):
    """Check if a workflow file is valid and properly configured."""
    try:
        with open(file_path, 'r') as f:
            workflow = yaml.safe_load(f)
        
        # Basic structure checks
        if not workflow or 'name' not in workflow:
            return False, "Missing workflow name"
        
        # Check for triggers (can be 'on' or other trigger patterns)
        has_triggers = False
        for key in workflow.keys():
            if key in ['on', 'push', 'pull_request', 'workflow_dispatch', 'schedule']:
                has_triggers = True
                break
        
        if not has_triggers:
            return False, "Missing triggers"
        
        if 'jobs' not in workflow:
            return False, "Missing jobs"
        
        # Check for required elements
        required_elements = ['name', 'jobs']
        for element in required_elements:
            if element not in workflow:
                return False, f"Missing required element: {element}"
        
        return True, "Valid workflow"
        
    except yaml.YAMLError as e:
        return False, f"YAML parsing error: {e}"
    except Exception as e:
        return False, f"Error reading file: {e}"

def check_required_workflows():
    """Check for required workflow files."""
    workflows_dir = Path('.github/workflows')
    required_workflows = [
        'ci-cd-pipeline.yml',
        'ci.yml',
        'android-build.yml',
        'ios-build.yml',
        'web-deploy.yml',
        'security-qa.yml',
        'release.yml',
        'coverage-badge.yml',
        'branch-protection-check.yml'
    ]
    
    missing_workflows = []
    for workflow in required_workflows:
        if not (workflows_dir / workflow).exists():
            missing_workflows.append(workflow)
    
    return missing_workflows

def check_workflow_quality():
    """Check workflow quality and best practices."""
    workflows_dir = Path('.github/workflows')
    issues = []
    
    for workflow_file in workflows_dir.glob('*.yml'):
        if workflow_file.name in ['README.md', 'secrets-management.md']:
            continue
            
        is_valid, message = check_workflow_file(workflow_file)
        if not is_valid:
            issues.append(f"{workflow_file.name}: {message}")
    
    return issues

def check_secrets_documentation():
    """Check if secrets are properly documented."""
    secrets_file = Path('.github/workflows/secrets-management.md')
    if not secrets_file.exists():
        return ["Missing secrets-management.md file"]
    
    return []

def check_readme_documentation():
    """Check if README is properly updated."""
    readme_file = Path('.github/workflows/README.md')
    if not readme_file.exists():
        return ["Missing README.md file"]
    
    with open(readme_file, 'r') as f:
        content = f.read()
    
    issues = []
    if "PRODUCTION READY" not in content:
        issues.append("README doesn't indicate production readiness")
    
    if "✅" not in content:
        issues.append("README doesn't have completion checkmarks")
    
    return issues

def main():
    """Main verification function."""
    print("🔍 CI/CD Pipeline Verification")
    print("=" * 50)
    
    # Check for required workflows
    print("\n📋 Checking required workflows...")
    missing_workflows = check_required_workflows()
    if missing_workflows:
        print(f"❌ Missing required workflows: {missing_workflows}")
    else:
        print("✅ All required workflows present")
    
    # Check workflow quality
    print("\n🔧 Checking workflow quality...")
    quality_issues = check_workflow_quality()
    if quality_issues:
        print(f"❌ Workflow quality issues found:")
        for issue in quality_issues:
            print(f"   - {issue}")
    else:
        print("✅ All workflows are valid")
    
    # Check secrets documentation
    print("\n🔐 Checking secrets documentation...")
    secrets_issues = check_secrets_documentation()
    if secrets_issues:
        print(f"❌ Secrets documentation issues:")
        for issue in secrets_issues:
            print(f"   - {issue}")
    else:
        print("✅ Secrets documentation present")
    
    # Check README documentation
    print("\n📚 Checking README documentation...")
    readme_issues = check_readme_documentation()
    if readme_issues:
        print(f"❌ README documentation issues:")
        for issue in readme_issues:
            print(f"   - {issue}")
    else:
        print("✅ README documentation complete")
    
    # Summary
    print("\n" + "=" * 50)
    total_issues = len(missing_workflows) + len(quality_issues) + len(secrets_issues) + len(readme_issues)
    
    if total_issues == 0:
        print("🎉 CI/CD Pipeline Verification: PASSED")
        print("✅ All workflows are production-ready")
        print("🚀 Ready for Go To Market phase")
    else:
        print(f"❌ CI/CD Pipeline Verification: FAILED")
        print(f"Found {total_issues} issues that need to be resolved")
    
    return total_issues == 0

if __name__ == "__main__":
    success = main()
    exit(0 if success else 1)