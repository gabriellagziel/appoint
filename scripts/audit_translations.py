#!/usr/bin/env python3
"""
Translation Audit Script
Identifies what text should and shouldn't be translated based on content type and usage.
This is a permanent maintenance tool for APP-OINT.
"""

import json
import re
import glob
import os
from typing import Dict, List, Set, Tuple

class TranslationAuditor:
    def __init__(self):
        self.admin_patterns = [
            r'admin',
            r'Admin',
            r'ADMIN',
            r'playtimeAdmin',
            r'adminBroadcast',
            r'adminDashboard',
            r'adminScreen',
            r'adminMetrics',
            r'adminSettings',
            r'adminOverview',
            r'adminLog',
            r'adminFreeAccess'
        ]
        
        self.technical_patterns = [
            r'firebase',
            r'Firebase',
            r'fcmToken',
            r'api',
            r'API',
            r'token',
            r'Token',
            r'key',
            r'Key',
            r'secret',
            r'Secret',
            r'url',
            r'URL',
            r'endpoint',
            r'Endpoint',
            r'config',
            r'Config',
            r'auth',
            r'Auth',
            r'oauth',
            r'OAuth',
            r'id',
            r'ID',
            r'uuid',
            r'UUID',
            r'hash',
            r'Hash',
            r'error',
            r'Error',
            r'debug',
            r'Debug',
            r'log',
            r'Log'
        ]
        
        self.user_facing_patterns = [
            r'welcome',
            r'Welcome',
            r'button',
            r'Button',
            r'message',
            r'Message',
            r'screen',
            r'Screen',
            r'title',
            r'Title',
            r'label',
            r'Label',
            r'text',
            r'Text',
            r'name',
            r'Name',
            r'email',
            r'Email',
            r'password',
            r'Password',
            r'login',
            r'Login',
            r'signup',
            r'signup',
            r'home',
            r'Home',
            r'profile',
            r'Profile',
            r'settings',
            r'Settings',
            r'calendar',
            r'Calendar',
            r'booking',
            r'Booking',
            r'appointment',
            r'Appointment',
            r'notification',
            r'Notification',
            r'family',
            r'Family',
            r'child',
            r'Child',
            r'rewards',
            r'Rewards',
            r'referral',
            r'Referral',
            r'studio',
            r'Studio',
            r'business',
            r'Business',
            r'provider',
            r'Provider',
            r'service',
            r'Service',
            r'payment',
            r'Payment',
            r'billing',
            r'Billing',
            r'subscription',
            r'Subscription'
        ]
        
    def load_arb_file(self, file_path: str) -> Dict:
        """Load an ARB file and return its content"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                return json.load(f)
        except Exception as e:
            print(f"Error loading {file_path}: {e}")
            return {}
    
    def is_admin_key(self, key: str, value: str) -> bool:
        """Check if a key is admin-related"""
        for pattern in self.admin_patterns:
            if re.search(pattern, key, re.IGNORECASE) or re.search(pattern, value, re.IGNORECASE):
                return True
        return False
    
    def is_technical_key(self, key: str, value: str) -> bool:
        """Check if a key is technical/internal"""
        for pattern in self.technical_patterns:
            if re.search(pattern, key, re.IGNORECASE):
                return True
        
        # Check if it's a technical error message
        if 'error' in key.lower() and any(tech in value.lower() for tech in ['firebase', 'api', 'token', 'auth']):
            return True
            
        return False
    
    def is_user_facing_key(self, key: str, value: str) -> bool:
        """Check if a key is user-facing"""
        for pattern in self.user_facing_patterns:
            if re.search(pattern, key, re.IGNORECASE):
                return True
        
        # Check if it's a simple UI text
        if len(value) < 50 and not any(char in value for char in ['$', '{', '}', '\\', 'firebase', 'api']):
            return True
            
        return False
    
    def categorize_key(self, key: str, value: str) -> str:
        """Categorize a translation key"""
        if key.startswith('@'):
            return 'metadata'
        
        if self.is_admin_key(key, value):
            return 'admin'
        
        if self.is_technical_key(key, value):
            return 'technical'
        
        if self.is_user_facing_key(key, value):
            return 'user_facing'
        
        return 'ambiguous'
    
    def audit_english_file(self, file_path: str) -> Dict[str, List[Tuple[str, str]]]:
        """Audit the English ARB file and categorize keys"""
        content = self.load_arb_file(file_path)
        categories = {
            'admin': [],
            'technical': [],
            'user_facing': [],
            'business_facing': [],
            'ambiguous': [],
            'metadata': []
        }
        
        for key, value in content.items():
            if isinstance(value, str):
                category = self.categorize_key(key, value)
                
                # Special handling for business-related keys
                if category == 'user_facing' and any(term in key.lower() for term in ['studio', 'business', 'provider', 'billing', 'subscription']):
                    category = 'business_facing'
                
                categories[category].append((key, value))
        
        return categories
    
    def check_translation_violations(self, categories: Dict[str, List[Tuple[str, str]]]) -> List[str]:
        """Check for translation rule violations"""
        violations = []
        
        # Check if admin keys are in non-English files
        admin_keys = [key for key, _ in categories['admin']]
        
        for lang_file in glob.glob('lib/l10n/app_*.arb'):
            if 'app_en.arb' in lang_file:
                continue
                
            lang_content = self.load_arb_file(lang_file)
            lang_code = os.path.basename(lang_file).replace('app_', '').replace('.arb', '')
            
            for admin_key in admin_keys:
                if admin_key in lang_content:
                    violations.append(f"Admin key '{admin_key}' found in {lang_code} - should be English only")
        
        return violations
    
    def generate_quick_report(self, categories: Dict[str, List[Tuple[str, str]]], violations: List[str]) -> str:
        """Generate a quick text report"""
        report = []
        report.append("🔍 Translation Audit Report")
        report.append("=" * 50)
        report.append(f"Admin keys: {len(categories['admin'])}")
        report.append(f"Technical keys: {len(categories['technical'])}")
        report.append(f"User-facing keys: {len(categories['user_facing'])}")
        report.append(f"Business-facing keys: {len(categories['business_facing'])}")
        report.append(f"Ambiguous keys: {len(categories['ambiguous'])}")
        report.append(f"Translation violations: {len(violations)}")
        report.append("")
        
        if violations:
            report.append("❌ Translation Rule Violations:")
            for violation in violations[:10]:  # Show first 10
                report.append(f"  - {violation}")
            if len(violations) > 10:
                report.append(f"  ... and {len(violations) - 10} more")
        else:
            report.append("✅ No translation rule violations found!")
        
        return "\n".join(report)

def main():
    auditor = TranslationAuditor()
    
    print("🔍 Auditing APP-OINT translations...")
    
    # Audit the English file
    categories = auditor.audit_english_file('lib/l10n/app_en.arb')
    
    # Check for violations
    violations = auditor.check_translation_violations(categories)
    
    # Generate and print report
    report = auditor.generate_quick_report(categories, violations)
    print("\n" + report)
    
    # Return appropriate exit code
    if violations:
        exit(1)
    else:
        exit(0)

if __name__ == "__main__":
    main()