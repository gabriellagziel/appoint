#!/usr/bin/env python3
import asyncio
import aiohttp
import ssl
import socket
import json
import dns.resolver
import subprocess
from datetime import datetime
from urllib.parse import urlparse

async def get_dns_info(domain):
    """Get DNS information for a domain"""
    try:
        # Get A records
        a_records = dns.resolver.resolve(domain, 'A')
        a_targets = [str(r) for r in a_records]
        
        # Get CNAME records
        try:
            cname_records = dns.resolver.resolve(domain, 'CNAME')
            cname_targets = [str(r) for r in cname_records]
        except:
            cname_targets = []
        
        return {
            "a_records": a_targets,
            "cname_records": cname_targets,
            "configured": len(a_targets) > 0 or len(cname_targets) > 0
        }
    except Exception as e:
        return {
            "a_records": [],
            "cname_records": [],
            "configured": False,
            "error": str(e)
        }

async def get_ssl_info(hostname, port=443):
    """Get SSL certificate information"""
    try:
        context = ssl.create_default_context()
        context.check_hostname = False
        context.verify_mode = ssl.CERT_NONE
        with socket.create_connection((hostname, port)) as sock:
            with context.wrap_socket(sock, server_hostname=hostname) as ssock:
                cert = ssock.getpeercert()
                return {
                    "valid": True,
                    "issuer": dict(x[0] for x in cert['issuer']),
                    "valid_from": cert['notBefore'],
                    "valid_until": cert['notAfter'],
                    "subject": dict(x[0] for x in cert['subject'])
                }
    except Exception as e:
        return {
            "valid": False,
            "error": str(e)
        }

async def check_path(session, base_url, path):
    """Check a specific path and return detailed information"""
    url = f"{base_url}{path}"
    
    # Get DNS info
    parsed_url = urlparse(url)
    dns_info = await get_dns_info(parsed_url.netloc)
    
    # Get SSL info
    ssl_info = await get_ssl_info(parsed_url.netloc)
    
    # Perform HEAD request
    status_code = None
    try:
        async with session.head(url, allow_redirects=True, ssl=False) as response:
            status_code = response.status
    except Exception as e:
        status_code = 0
    
    return {
        "domain_configured": dns_info.get("configured", False),
        "current_target": dns_info.get("a_records", []) + dns_info.get("cname_records", []),
        "ssl_valid": ssl_info.get("valid", False),
        "ssl_issuer": ssl_info.get("issuer", {}),
        "ssl_valid_from": ssl_info.get("valid_from"),
        "ssl_valid_until": ssl_info.get("valid_until"),
        "status_code": status_code
    }

async def main():
    """Main function to check all paths"""
    base_url = "https://app-oint.com"
    paths = ["/", "/business", "/admin", "/enterprise"]
    
    # Get DigitalOcean App Platform endpoint
    try:
        result = subprocess.run(['doctl', 'apps', 'list'], capture_output=True, text=True)
        if result.returncode == 0:
            lines = result.stdout.strip().split('\n')
            for line in lines:
                if 'app-oint' in line and 'ondigitalocean.app' in line:
                    app_platform_endpoint = line.split()[-1]  # Last column should be the URL
                    break
            else:
                app_platform_endpoint = "Unknown"
        else:
            app_platform_endpoint = "Error getting DO app info"
    except Exception as e:
        app_platform_endpoint = f"Error: {str(e)}"
    
    # Configure session
    timeout = aiohttp.ClientTimeout(total=30, connect=10)
    connector = aiohttp.TCPConnector(limit=10, limit_per_host=5, ssl=False)
    
    async with aiohttp.ClientSession(timeout=timeout, connector=connector) as session:
        # Create tasks for all paths
        tasks = [check_path(session, base_url, path) for path in paths]
        
        # Execute all tasks concurrently
        results = await asyncio.gather(*tasks, return_exceptions=True)
        
        # Build the result dictionary
        result = {}
        for i, path in enumerate(paths):
            if isinstance(results[i], Exception):
                result[path] = {
                    "domain_configured": False,
                    "current_target": [],
                    "ssl_valid": False,
                    "ssl_issuer": {},
                    "ssl_valid_from": None,
                    "ssl_valid_until": None,
                    "status_code": 0,
                    "error": str(results[i])
                }
            else:
                result[path] = results[i]
            
            # Add the app platform endpoint to each result
            result[path]["app_platform_endpoint"] = app_platform_endpoint
    
    # Print the results as JSON
    print(json.dumps(result, indent=2, ensure_ascii=False))

if __name__ == "__main__":
    asyncio.run(main()) 