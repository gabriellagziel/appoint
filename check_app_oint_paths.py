#!/usr/bin/env python3
import asyncio
import aiohttp
import ssl
import socket
import json
from datetime import datetime
from urllib.parse import urljoin, urlparse
import re
from bs4 import BeautifulSoup

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
                    "issuer": dict(x[0] for x in cert['issuer']),
                    "valid_from": cert['notBefore'],
                    "valid_until": cert['notAfter']
                }
    except Exception as e:
        return {"error": str(e)}

async def check_path(session, base_url, path):
    """Check a specific path and return detailed information"""
    url = urljoin(base_url, path)
    
    # Get SSL info first
    parsed_url = urlparse(url)
    ssl_info = await get_ssl_info(parsed_url.netloc)
    
    # Perform HEAD request with redirect following
    final_url = url
    status_code = None
    redirects = []
    
    try:
        async with session.head(url, allow_redirects=True, max_redirects=5, ssl=False) as response:
            status_code = response.status
            final_url = str(response.url)
            redirects = [str(r.url) for r in response.history]
    except Exception as e:
        status_code = 0
        final_url = url
    
    # Perform GET request to get content
    title = None
    heading = None
    
    try:
        async with session.get(url, allow_redirects=True, max_redirects=5, ssl=False) as response:
            content = await response.text()
            
            # Parse HTML
            soup = BeautifulSoup(content, 'html.parser')
            
            # Get title
            title_tag = soup.find('title')
            if title_tag:
                title = title_tag.get_text().strip()
            
            # Get first prominent heading (h1, h2, h3)
            for tag in ['h1', 'h2', 'h3']:
                heading_tag = soup.find(tag)
                if heading_tag:
                    heading = heading_tag.get_text().strip()
                    break
                    
    except Exception as e:
        title = f"Error: {str(e)}"
        heading = f"Error: {str(e)}"
    
    return {
        "url": final_url,
        "http_status": status_code,
        "redirects_to": final_url if final_url != url else None,
        "title": title,
        "heading": heading,
        "ssl": ssl_info
    }

async def main():
    """Main function to check all paths concurrently"""
    base_url = "https://app-oint.com"
    paths = ["/", "/business", "/admin", "/enterprise"]
    
    # Configure session with reasonable timeouts and SSL disabled
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
                    "url": f"{base_url}{path}",
                    "http_status": 0,
                    "redirects_to": None,
                    "title": f"Error: {str(results[i])}",
                    "heading": f"Error: {str(results[i])}",
                    "ssl": {"error": str(results[i])}
                }
            else:
                result[path] = results[i]
    
    # Print the results as JSON
    print(json.dumps(result, indent=2, ensure_ascii=False))

if __name__ == "__main__":
    asyncio.run(main()) 