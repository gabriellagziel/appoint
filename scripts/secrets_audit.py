#!/usr/bin/env python3
"""
Secrets Audit Script
Scans repository for hardcoded API keys and secrets
"""

import os
import re
import json
from pathlib import Path

def scan_for_secrets():
    """Scan repository for hardcoded secrets"""
    
    # Patterns to search for
    patterns = {
        'firebase_api_key': r'AIza[0-9A-Za-z_-]{35}',
        'stripe_secret_key': r'sk_[0-9a-zA-Z]{24}',
        'stripe_publishable_key': r'pk_[0-9a-zA-Z]{24}',
        'google_oauth_client': r'[0-9]{12}:[a-zA-Z0-9_-]{35}',
        'firebase_config_file': r'firebase.*\.json',
        'google_services_file': r'google-services\.json'
    }
    
    findings = []
    
    # Directories to exclude
    exclude_dirs = {'.git', 'node_modules', 'build', '.dart_tool', 'dist'}
    
    for root, dirs, files in os.walk('.'):
        # Skip excluded directories
        dirs[:] = [d for d in dirs if d not in exclude_dirs]
        
        for file in files:
            if file.endswith(('.dart', '.js', '.ts', '.json', '.yaml', '.yml', '.plist')):
                file_path = Path(root) / file
                
                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        content = f.read()
                        
                    for secret_type, pattern in patterns.items():
                        matches = re.findall(pattern, content)
                        if matches:
                            findings.append({
                                'file': str(file_path),
                                'secret_type': secret_type,
                                'matches': matches,
                                'line_numbers': []
                            })
                            
                            # Get line numbers
                            for i, line in enumerate(content.split('\n'), 1):
                                if re.search(pattern, line):
                                    findings[-1]['line_numbers'].append(i)
                                    
                except Exception as e:
                    continue
    
    return findings

def generate_patches(findings):
    """Generate secure replacement patches"""
    
    patches = []
    
    for finding in findings:
        file_path = finding['file']
        secret_type = finding['secret_type']
        
        if secret_type == 'firebase_api_key':
            patch = {
                'file': file_path,
                'description': 'Replace hardcoded Firebase API key with environment variable',
                'changes': [
                    {
                        'type': 'replace',
                        'pattern': r'AIza[0-9A-Za-z_-]{35}',
                        'replacement': '${FIREBASE_API_KEY}',
                        'environment_variable': 'FIREBASE_API_KEY'
                    }
                ]
            }
        elif secret_type == 'stripe_secret_key':
            patch = {
                'file': file_path,
                'description': 'Replace hardcoded Stripe secret key with environment variable',
                'changes': [
                    {
                        'type': 'replace',
                        'pattern': r'sk_[0-9a-zA-Z]{24}',
                        'replacement': '${STRIPE_SECRET_KEY}',
                        'environment_variable': 'STRIPE_SECRET_KEY'
                    }
                ]
            }
        elif secret_type == 'stripe_publishable_key':
            patch = {
                'file': file_path,
                'description': 'Replace hardcoded Stripe publishable key with environment variable',
                'changes': [
                    {
                        'type': 'replace',
                        'pattern': r'pk_[0-9a-zA-Z]{24}',
                        'replacement': '${STRIPE_PUBLISHABLE_KEY}',
                        'environment_variable': 'STRIPE_PUBLISHABLE_KEY'
                    }
                ]
            }
        else:
            patch = {
                'file': file_path,
                'description': f'Review and secure {secret_type}',
                'changes': [
                    {
                        'type': 'review',
                        'message': 'Manual review required for this secret type'
                    }
                ]
            }
        
        patches.append(patch)
    
    return patches

def main():
    print("🔒 Scanning for hardcoded secrets...")
    
    findings = scan_for_secrets()
    patches = generate_patches(findings)
    
    # Generate report
    report = {
        'scan_date': '2025-01-26T00:00:00Z',
        'total_findings': len(findings),
        'findings': findings,
        'patches': patches,
        'recommendations': [
            'Move all API keys to environment variables',
            'Use Firebase project settings for Firebase keys',
            'Implement secret management (AWS Secrets Manager, GCP Secret Manager)',
            'Add .env files to .gitignore',
            'Rotate exposed keys immediately'
        ]
    }
    
    with open('secrets_audit_report.json', 'w') as f:
        json.dump(report, f, indent=2)
    
    print(f"✅ Found {len(findings)} potential secrets")
    print("📋 Report generated: secrets_audit_report.json")
    
    # Print summary
    for finding in findings:
        print(f"⚠️  {finding['file']}: {finding['secret_type']}")

if __name__ == '__main__':
    main() 