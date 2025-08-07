#!/usr/bin/env python3
"""
Feature Inventory Validation Script

This script helps validate that the FEATURE_INVENTORY.md file is up-to-date
by scanning the codebase for new features that might not be documented.
"""

import os
import re
import glob
from pathlib import Path

def scan_feature_screens():
    """Scan for screen/page classes that might represent features."""
    screens = []
    patterns = [
        'lib/features/**/*.dart',
        'admin/src/**/*.tsx',
        'business/src/**/*.tsx'
    ]
    
    for pattern in patterns:
        for file_path in glob.glob(pattern, recursive=True):
            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                    
                # Look for screen/page class definitions
                screen_matches = re.findall(
                    r'class\s+(\w+(?:Screen|Page|Dashboard))\s+extends',
                    content,
                    re.IGNORECASE
                )
                
                for match in screen_matches:
                    screens.append({
                        'name': match,
                        'file': file_path,
                        'type': 'screen'
                    })
                    
            except (UnicodeDecodeError, PermissionError):
                continue
    
    return screens

def scan_services():
    """Scan for service classes that provide functionality."""
    services = []
    patterns = [
        'lib/services/**/*.dart',
        'functions/src/**/*.js',
        'functions/src/**/*.ts'
    ]
    
    for pattern in patterns:
        for file_path in glob.glob(pattern, recursive=True):
            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                    
                # Look for service class definitions
                service_matches = re.findall(
                    r'class\s+(\w+Service)\s+',
                    content,
                    re.IGNORECASE
                )
                
                for match in service_matches:
                    services.append({
                        'name': match,
                        'file': file_path,
                        'type': 'service'
                    })
                    
            except (UnicodeDecodeError, PermissionError):
                continue
    
    return services

def read_feature_inventory():
    """Read the current feature inventory."""
    try:
        with open('FEATURE_INVENTORY.md', 'r', encoding='utf-8') as f:
            return f.read()
    except FileNotFoundError:
        print("❌ FEATURE_INVENTORY.md not found!")
        return ""

def validate_features():
    """Main validation function."""
    print("🔍 Validating App-Oint Feature Inventory...")
    print("=" * 50)
    
    # Read current inventory
    inventory_content = read_feature_inventory()
    if not inventory_content:
        return
    
    # Scan codebase
    print("📱 Scanning for screens/pages...")
    screens = scan_feature_screens()
    
    print("⚙️  Scanning for services...")
    services = scan_services()
    
    # Check for potentially missing features
    print("\n📋 Validation Results:")
    print("-" * 30)
    
    missing_screens = []
    for screen in screens:
        if screen['name'] not in inventory_content:
            missing_screens.append(screen)
    
    missing_services = []
    for service in services:
        if service['name'] not in inventory_content:
            missing_services.append(service)
    
    # Report results
    if missing_screens:
        print(f"\n⚠️  Potentially missing screens ({len(missing_screens)}):")
        for screen in missing_screens[:10]:  # Show first 10
            print(f"   • {screen['name']} ({screen['file']})")
        if len(missing_screens) > 10:
            print(f"   ... and {len(missing_screens) - 10} more")
    
    if missing_services:
        print(f"\n⚠️  Potentially missing services ({len(missing_services)}):")
        for service in missing_services[:10]:  # Show first 10
            print(f"   • {service['name']} ({service['file']})")
        if len(missing_services) > 10:
            print(f"   ... and {len(missing_services) - 10} more")
    
    # Summary statistics
    total_screens = len(screens)
    total_services = len(services)
    print(f"\n📊 Summary:")
    print(f"   • Total screens found: {total_screens}")
    print(f"   • Total services found: {total_services}")
    print(f"   • Potentially missing screens: {len(missing_screens)}")
    print(f"   • Potentially missing services: {len(missing_services)}")
    
    if not missing_screens and not missing_services:
        print("\n✅ Feature inventory appears to be comprehensive!")
    else:
        print("\n💡 Consider updating FEATURE_INVENTORY.md with missing items.")
        print("   Note: Some items may be test/internal classes and don't need documentation.")

if __name__ == "__main__":
    validate_features()