#!/usr/bin/env python3

import dns.resolver
import dns.reversename
import requests
import socket
import ssl
import json
from datetime import datetime
from urllib.parse import urlparse
import concurrent.futures
import time

# Common subdomain wordlist
SUBDOMAINS = [
    "www", "api", "admin", "docs", "sandbox", "staging", "dev", "test", "prod", "app",
    "web", "mail", "ftp", "blog", "forum", "support", "help", "status", "monitor",
    "dashboard", "portal", "login", "auth", "sso", "enterprise", "business", "marketing",
    "cdn", "static", "assets", "images", "media", "files", "download", "upload",
    "backup", "db", "database", "redis", "cache", "queue", "worker", "job",
    "analytics", "metrics", "logs", "monitoring", "alerting", "health", "ping",
    "mobile", "m", "app", "ios", "android", "desktop", "webapp", "spa",
    "vpn", "remote", "ssh", "shell", "terminal", "console", "admin-panel",
    "cpanel", "whm", "plesk", "directadmin", "webmin", "phpmyadmin",
    "wordpress", "joomla", "drupal", "magento", "shop", "store", "cart",
    "payment", "billing", "invoice", "accounting", "crm", "erp", "hr",
    "calendar", "meeting", "video", "chat", "messaging", "notification",
    "email", "smtp", "pop", "imap", "exchange", "outlook", "gmail",
    "git", "svn", "repo", "code", "deploy", "ci", "cd", "jenkins",
    "docker", "k8s", "kubernetes", "swarm", "rancher", "helm",
    "aws", "azure", "gcp", "cloud", "ec2", "s3", "lambda", "api-gateway",
    "firebase", "heroku", "netlify", "vercel", "cloudflare", "fastly",
    "nginx", "apache", "iis", "tomcat", "jboss", "weblogic", "websphere",
    "node", "python", "php", "java", "ruby", "go", "rust", "dotnet",
    "mysql", "postgres", "mongodb", "redis", "elasticsearch", "kafka",
    "grafana", "prometheus", "kibana", "logstash", "filebeat", "fluentd",
    "jenkins", "gitlab", "github", "bitbucket", "jira", "confluence", "trello",
    "slack", "discord", "teams", "zoom", "webex", "gotomeeting", "skype",
    "salesforce", "hubspot", "zendesk", "intercom", "freshdesk", "helpscout",
    "stripe", "paypal", "square", "braintree", "adyen", "klarna", "affirm",
    "google", "facebook", "twitter", "linkedin", "instagram", "youtube", "tiktok",
    "amazon", "ebay", "etsy", "shopify", "woocommerce", "bigcommerce", "magento",
    "dropbox", "box", "onedrive", "gdrive", "mega", "pcloud", "sync",
    "vimeo", "dailymotion", "twitch", "netflix", "spotify", "apple", "microsoft"
]

def get_dns_records(domain, record_type):
    """Get DNS records for a domain"""
    try:
        answers = dns.resolver.resolve(domain, record_type)
        return [str(answer) for answer in answers]
    except Exception as e:
        return []

def check_ssl_certificate(hostname, port=443):
    """Check SSL certificate details"""
    try:
        context = ssl.create_default_context()
        with socket.create_connection((hostname, port), timeout=10) as sock:
            with context.wrap_socket(sock, server_hostname=hostname) as ssock:
                cert = ssock.getpeercert()
                return {
                    "ssl_valid": True,
                    "issuer": dict(x[0] for x in cert['issuer']),
                    "valid_from": cert['notBefore'],
                    "valid_until": cert['notAfter']
                }
    except Exception as e:
        return {
            "ssl_valid": False,
            "issuer": None,
            "valid_from": None,
            "valid_until": None
        }

def check_http_status(subdomain, domain):
    """Check HTTP status for a subdomain"""
    full_domain = f"{subdomain}.{domain}"
    
    # Try HTTPS first
    try:
        response = requests.head(f"https://{full_domain}", timeout=10, allow_redirects=True)
        protocol = "https"
        status = response.status_code
    except:
        # Try HTTP
        try:
            response = requests.head(f"http://{full_domain}", timeout=10, allow_redirects=True)
            protocol = "http"
            status = response.status_code
        except:
            return None
    
    # Get SSL certificate info
    ssl_info = check_ssl_certificate(full_domain)
    
    return {
        "subdomain": subdomain,
        "full_domain": full_domain,
        "protocol": protocol,
        "http_status": status,
        "ssl_valid": ssl_info["ssl_valid"],
        "issuer": ssl_info["issuer"],
        "valid_from": ssl_info["valid_from"],
        "valid_until": ssl_info["valid_until"]
    }

def enumerate_subdomain(subdomain, domain):
    """Enumerate a single subdomain"""
    full_domain = f"{subdomain}.{domain}"
    results = []
    
    # Check A record
    a_records = get_dns_records(full_domain, 'A')
    if a_records:
        for record in a_records:
            results.append({
                "subdomain": subdomain,
                "type": "A",
                "record": record,
                "full_domain": full_domain
            })
    
    # Check CNAME record
    cname_records = get_dns_records(full_domain, 'CNAME')
    if cname_records:
        for record in cname_records:
            results.append({
                "subdomain": subdomain,
                "type": "CNAME",
                "record": record,
                "full_domain": full_domain
            })
    
    # Check MX record
    mx_records = get_dns_records(full_domain, 'MX')
    if mx_records:
        for record in mx_records:
            results.append({
                "subdomain": subdomain,
                "type": "MX",
                "record": record,
                "full_domain": full_domain
            })
    
    # Check TXT record
    txt_records = get_dns_records(full_domain, 'TXT')
    if txt_records:
        for record in txt_records:
            results.append({
                "subdomain": subdomain,
                "type": "TXT",
                "record": record,
                "full_domain": full_domain
            })
    
    # If we found any records, check HTTP status
    if results:
        http_info = check_http_status(subdomain, domain)
        if http_info:
            for result in results:
                result.update(http_info)
    
    return results

def main():
    domain = "app-oint.com"
    results = []
    
    print(f"Starting subdomain enumeration for {domain}")
    print(f"Scanning {len(SUBDOMAINS)} subdomains...")
    
    # Check base domain first
    print("\nChecking base domain records...")
    base_results = enumerate_subdomain("", domain)
    results.extend(base_results)
    
    # Brute force subdomains
    print("\nPerforming brute-force subdomain scan...")
    
    with concurrent.futures.ThreadPoolExecutor(max_workers=10) as executor:
        future_to_subdomain = {
            executor.submit(enumerate_subdomain, subdomain, domain): subdomain 
            for subdomain in SUBDOMAINS
        }
        
        completed = 0
        for future in concurrent.futures.as_completed(future_to_subdomain):
            subdomain = future_to_subdomain[future]
            try:
                subdomain_results = future.result()
                if subdomain_results:
                    results.extend(subdomain_results)
                    print(f"Found: {subdomain}.{domain}")
                completed += 1
                if completed % 10 == 0:
                    print(f"Progress: {completed}/{len(SUBDOMAINS)} subdomains checked")
            except Exception as e:
                print(f"Error checking {subdomain}: {e}")
    
    # Remove duplicates and format results
    unique_results = []
    seen = set()
    
    for result in results:
        key = f"{result['subdomain']}.{domain}-{result['type']}-{result['record']}"
        if key not in seen:
            seen.add(key)
            unique_results.append(result)
    
    # Format for JSON output
    formatted_results = []
    for result in unique_results:
        formatted_result = {
            "subdomain": result["subdomain"] if result["subdomain"] else "@",
            "type": result["type"],
            "record": result["record"],
            "http_status": result.get("http_status"),
            "ssl_valid": result.get("ssl_valid"),
            "issuer": result.get("issuer"),
            "valid_from": result.get("valid_from"),
            "valid_until": result.get("valid_until")
        }
        formatted_results.append(formatted_result)
    
    print(f"\nEnumeration complete! Found {len(formatted_results)} records.")
    
    # Save results to file
    with open("subdomain_enumeration_results.json", "w") as f:
        json.dump(formatted_results, f, indent=2)
    
    print("Results saved to subdomain_enumeration_results.json")
    
    return formatted_results

if __name__ == "__main__":
    results = main()
    print(json.dumps(results, indent=2)) 