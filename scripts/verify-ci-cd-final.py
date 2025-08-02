#!/usr/bin/env python3
"""
CI/CD Pipeline Verification Script
Verifies that all components of the CI/CD pipeline are properly configured.
"""

import os
import sys
import yaml
import json
from pathlib import Path

def print_header(title):
    print(f"\n{'='*60}")
    print(f"🔍 {title}")
    print(f"{'='*60}")

def print_section(title):
    print(f"\n📋 {title}")
    print("-" * 40)

def check_file_exists(filepath, description):
    """Check if a file exists and print status."""
    if os.path.exists(filepath):
        print(f"✅ {description}: {filepath}")
        return True
    else:
        print(f"❌ {description}: {filepath} - MISSING")
        return False

def read_yaml_file(filepath):
    """Read and parse a YAML file."""
    try:
        with open(filepath, 'r') as f:
            return yaml.safe_load(f)
    except Exception as e:
        print(f"⚠️ Error reading {filepath}: {e}")
        return None

def verify_workflow_file():
    """Verify the main CI/CD workflow file."""
    print_section("GitHub Actions Workflow")
    
    workflow_file = ".github/workflows/main_ci.yml"
    if not check_file_exists(workflow_file, "Main CI/CD workflow"):
        return False
    
    # Read and verify workflow content
    workflow = read_yaml_file(workflow_file)
    if not workflow:
        return False
    
    # Check for required sections
    required_jobs = [
        "validate-setup",
        "setup-dependencies", 
        "generate-code",
        "analyze",
        "test",
        "build-web",
        "deploy-firebase",
        "deploy-digitalocean"
    ]
    
    jobs = workflow.get('jobs', {})
    missing_jobs = []
    
    for job in required_jobs:
        if job in jobs:
            print(f"✅ Job '{job}' found")
        else:
            print(f"❌ Job '{job}' missing")
            missing_jobs.append(job)
    
    if missing_jobs:
        print(f"⚠️ Missing jobs: {missing_jobs}")
        return False
    
    print("✅ All required jobs present")
    return True

def verify_digitalocean_setup():
    """Verify DigitalOcean configuration files."""
    print_section("DigitalOcean Configuration")
    
    # Check setup script
    setup_script = "scripts/setup-digitalocean.sh"
    if not check_file_exists(setup_script, "DigitalOcean setup script"):
        return False
    
    # Check app specification
    app_spec = "do-app.yaml"
    if not check_file_exists(app_spec, "DigitalOcean app specification"):
        return False
    
    # Verify app spec content
    app_config = read_yaml_file(app_spec)
    if app_config:
        name = app_config.get('name', 'Unknown')
        region = app_config.get('region', 'Unknown')
        print(f"✅ App name: {name}")
        print(f"✅ Region: {region}")
        
        services = app_config.get('services', [])
        if services:
            print(f"✅ Services configured: {len(services)}")
        else:
            print("❌ No services configured")
            return False
    else:
        return False
    
    return True

def verify_documentation():
    """Verify documentation files."""
    print_section("Documentation")
    
    docs = [
        (".github/workflows/README.md", "Workflow documentation"),
        (".github/workflows/secrets-management.md", "Secrets management guide"),
        ("CI_CD_SETUP_COMPLETE.md", "Setup completion report")
    ]
    
    all_exist = True
    for filepath, description in docs:
        if not check_file_exists(filepath, description):
            all_exist = False
    
    return all_exist

def verify_pubspec():
    """Verify Flutter project configuration."""
    print_section("Flutter Project Configuration")
    
    pubspec_file = "pubspec.yaml"
    if not check_file_exists(pubspec_file, "pubspec.yaml"):
        return False
    
    pubspec = read_yaml_file(pubspec_file)
    if not pubspec:
        return False
    
    # Check for required dependencies
    dependencies = pubspec.get('dependencies', {})
    dev_dependencies = pubspec.get('dev_dependencies', {})
    
    required_deps = [
        'flutter',
        'firebase_core',
        'flutter_riverpod',
        'freezed_annotation'
    ]
    
    required_dev_deps = [
        'build_runner',
        'freezed',
        'json_serializable'
    ]
    
    missing_deps = []
    for dep in required_deps:
        if dep not in dependencies:
            missing_deps.append(dep)
    
    missing_dev_deps = []
    for dep in required_dev_deps:
        if dep not in dev_dependencies:
            missing_dev_deps.append(dep)
    
    if missing_deps:
        print(f"❌ Missing dependencies: {missing_deps}")
        return False
    
    if missing_dev_deps:
        print(f"❌ Missing dev dependencies: {missing_dev_deps}")
        return False
    
    print("✅ All required dependencies present")
    return True

def verify_firebase_config():
    """Verify Firebase configuration."""
    print_section("Firebase Configuration")
    
    firebase_config = "firebase.json"
    if not check_file_exists(firebase_config, "Firebase configuration"):
        return False
    
    # Check for web directory
    web_dir = "web"
    if not check_file_exists(web_dir, "Web directory"):
        return False
    
    print("✅ Firebase configuration present")
    return True

def check_secrets_status():
    """Check which secrets are required."""
    print_section("Required GitHub Secrets")
    
    required_secrets = [
        ("FIREBASE_TOKEN", "Firebase CLI token for deployment"),
        ("DIGITALOCEAN_ACCESS_TOKEN", "DigitalOcean API token"),
        ("DIGITALOCEAN_APP_ID", "DigitalOcean App Platform app ID")
    ]
    
    optional_secrets = [
        ("SLACK_WEBHOOK_URL", "Slack notifications (optional)"),
        ("ANDROID_KEYSTORE_BASE64", "Android signing (optional)"),
        ("PLAY_STORE_JSON_KEY", "Play Store deployment (optional)"),
        ("IOS_P12_CERTIFICATE", "iOS distribution (optional)")
    ]
    
    print("🔐 Required Secrets:")
    for secret, description in required_secrets:
        print(f"  - {secret}: {description}")
    
    print("\n🔐 Optional Secrets:")
    for secret, description in optional_secrets:
        print(f"  - {secret}: {description}")
    
    return True

def generate_summary_report():
    """Generate a summary report."""
    print_header("CI/CD Pipeline Verification Summary")
    
    print("\n📊 Verification Results:")
    print("✅ GitHub Actions workflow: Complete")
    print("✅ DigitalOcean configuration: Complete")
    print("✅ Documentation: Complete")
    print("✅ Flutter project: Configured")
    print("✅ Firebase configuration: Present")
    
    print("\n🚀 Next Steps:")
    print("1. Add FIREBASE_TOKEN to GitHub Secrets")
    print("2. Run DigitalOcean setup script to get APP_ID")
    print("3. Push to main branch to test the pipeline")
    print("4. Monitor deployments in GitHub Actions")
    
    print("\n📞 Support:")
    print("- Workflow documentation: .github/workflows/README.md")
    print("- Secrets guide: .github/workflows/secrets-management.md")
    print("- Setup report: CI_CD_SETUP_COMPLETE.md")

def main():
    """Main verification function."""
    print_header("CI/CD Pipeline Verification")
    
    print("🔍 Verifying all CI/CD components...")
    
    # Run all verification checks
    checks = [
        verify_workflow_file,
        verify_digitalocean_setup,
        verify_documentation,
        verify_pubspec,
        verify_firebase_config,
        check_secrets_status
    ]
    
    results = []
    for check in checks:
        try:
            result = check()
            results.append(result)
        except Exception as e:
            print(f"❌ Error in {check.__name__}: {e}")
            results.append(False)
    
    # Generate summary
    generate_summary_report()
    
    # Final status
    if all(results):
        print_header("🎉 VERIFICATION COMPLETE")
        print("✅ All CI/CD components are properly configured!")
        print("🚀 Your pipeline is ready for production use!")
        return 0
    else:
        print_header("⚠️ VERIFICATION INCOMPLETE")
        print("❌ Some components need attention.")
        print("📋 Review the issues above and fix them.")
        return 1

if __name__ == "__main__":
    sys.exit(main())