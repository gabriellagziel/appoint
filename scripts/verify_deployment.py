#!/usr/bin/env python3
"""
Perfect Repository Deployment Verification
==========================================
Verifies that the perfect repository has been successfully deployed to DigitalOcean
"""

import requests
import json
import time
from datetime import datetime

def check_endpoint(url, expected_status=200, timeout=10):
    """Check if an endpoint is responding correctly"""
    try:
        response = requests.get(url, timeout=timeout)
        return {
            'url': url,
            'status_code': response.status_code,
            'success': response.status_code == expected_status,
            'response_time': response.elapsed.total_seconds(),
            'error': None
        }
    except Exception as e:
        return {
            'url': url,
            'status_code': 0,
            'success': False,
            'response_time': 0,
            'error': str(e)
        }

def main():
    print("🔍 VERIFYING PERFECT REPOSITORY DEPLOYMENT")
    print("=" * 50)
    
    # Endpoints to check
    endpoints = [
        {'url': 'https://app-oint.com/', 'name': 'Main Application'},
        {'url': 'https://app-oint.com/admin', 'name': 'Admin Portal'},
        {'url': 'https://app-oint.com/business', 'name': 'Business Portal'},
        {'url': 'https://app-oint.com/api/status', 'name': 'API Health'},
        {'url': 'https://app-oint.com/robots.txt', 'name': 'SEO Robots'},
        {'url': 'https://app-oint.com/sitemap.xml', 'name': 'SEO Sitemap'},
        {'url': 'https://api.app-oint.com/status', 'name': 'API Subdomain'},
        {'url': 'https://admin.app-oint.com/', 'name': 'Admin Subdomain'},
    ]
    
    results = []
    
    for endpoint in endpoints:
        print(f"Checking {endpoint['name']}...")
        result = check_endpoint(endpoint['url'])
        result['name'] = endpoint['name']
        results.append(result)
        
        if result['success']:
            print(f"  ✅ {endpoint['name']}: {result['status_code']} ({result['response_time']:.3f}s)")
        else:
            print(f"  ❌ {endpoint['name']}: {result['status_code']} - {result['error']}")
    
    # Summary
    successful = sum(1 for r in results if r['success'])
    total = len(results)
    success_rate = (successful / total) * 100
    
    print("\n📊 DEPLOYMENT VERIFICATION SUMMARY:")
    print("=" * 40)
    print(f"Total endpoints: {total}")
    print(f"Successful: {successful}")
    print(f"Failed: {total - successful}")
    print(f"Success rate: {success_rate:.1f}%")
    
    if success_rate >= 80:
        print("\n🎉 DEPLOYMENT VERIFICATION PASSED!")
        print("Perfect repository successfully deployed to DigitalOcean!")
    else:
        print("\n⚠️ DEPLOYMENT VERIFICATION FAILED")
        print("Some endpoints are not responding correctly.")
    
    # Save results
    timestamp = datetime.now().isoformat()
    report = {
        'timestamp': timestamp,
        'success_rate': success_rate,
        'results': results
    }
    
    with open('deployment_verification_report.json', 'w') as f:
        json.dump(report, f, indent=2)
    
    print(f"\n📋 Detailed report saved to: deployment_verification_report.json")
    
    return 0 if success_rate >= 80 else 1

if __name__ == '__main__':
    exit(main())
