#!/usr/bin/env python3
"""
App-Oint Domain Fix Script
Automates the process of fixing app-oint.com domain configuration on DigitalOcean App Platform.
"""
import os
import sys
import time
import requests
import subprocess
from typing import Dict, List, Optional

API_BASE = "https://api.digitalocean.com/v2"
TOKEN = os.getenv("DIGITALOCEAN_ACCESS_TOKEN")
HEADERS = {"Authorization": f"Bearer {TOKEN}", "Content-Type": "application/json"}
RETRY = 5
RETRY_DELAY = 30

TARGET_DOMAINS = ["app-oint.com", "www.app-oint.com"]
APP_NAME = "appoint-marketing"


def log(msg, level="INFO"):
    print(f"[{level}] {msg}")


def api_request(method, endpoint, data=None, params=None):
    url = f"{API_BASE}{endpoint}"
    for attempt in range(RETRY):
        try:
            resp = requests.request(method, url, headers=HEADERS, json=data, params=params)
            if resp.status_code in (200, 201):
                return resp.json()
            elif resp.status_code == 429:
                log(f"Rate limited, waiting {RETRY_DELAY}s...", "WARN")
                time.sleep(RETRY_DELAY)
            else:
                log(f"API error {resp.status_code}: {resp.text}", "ERROR")
                time.sleep(RETRY_DELAY)
        except Exception as e:
            log(f"Request error: {e}", "ERROR")
            time.sleep(RETRY_DELAY)
    return None


def get_app_id():
    log("Fetching App Platform apps...")
    resp = api_request("GET", "/apps")
    if not resp or "apps" not in resp:
        log("Could not fetch apps.", "ERROR")
        sys.exit(1)
    for app in resp["apps"]:
        if app.get("spec", {}).get("name") == APP_NAME:
            log(f"Found app: {APP_NAME} ({app['id']})")
            return app["id"]
    log(f"App {APP_NAME} not found.", "ERROR")
    sys.exit(1)


def get_app_domains(app_id):
    resp = api_request("GET", f"/apps/{app_id}/domains")
    if not resp or "domains" not in resp:
        return []
    return resp["domains"]


def add_domain(app_id, domain):
    log(f"Adding domain: {domain}")
    resp = api_request("POST", f"/apps/{app_id}/domains", {"domain": domain})
    if resp:
        log(f"Domain {domain} added or already exists.")
        return True
    log(f"Failed to add domain {domain}.", "ERROR")
    return False


def print_dns_instructions(app_id):
    resp = api_request("GET", f"/apps/{app_id}/domains")
    if not resp or "domains" not in resp:
        log("Could not fetch domain info.", "ERROR")
        return
    for d in resp["domains"]:
        print("-" * 40)
        print(f"Domain: {d.get('domain')}")
        print(f"Status: {d.get('status')}")
        print(f"SSL Status: {d.get('ssl_status')}")
        if d.get("validation", {}).get("dns"):
            print("Required DNS Records:")
            for rec in d["validation"]["dns"]:
                print(f"  Type: {rec['type']}")
                print(f"  Name: {rec['name']}")
                print(f"  Data: {rec['data']}")
                print(f"  TTL: {rec.get('ttl', 3600)}")
                print()


def check_dns(domain):
    try:
        result = subprocess.run(["nslookup", domain], capture_output=True, text=True, timeout=10)
        if result.returncode == 0 and "Address:" in result.stdout:
            log(f"DNS for {domain} is resolving.")
            return True
        else:
            log(f"DNS for {domain} not found.", "WARN")
            return False
    except Exception as e:
        log(f"DNS check error: {e}", "ERROR")
        return False


def wait_for_ssl(app_id, domain, timeout=600):
    log(f"Waiting for SSL for {domain}...")
    start = time.time()
    while time.time() - start < timeout:
        domains = get_app_domains(app_id)
        for d in domains:
            if d.get("domain") == domain:
                if d.get("ssl_status") == "verified":
                    log(f"SSL verified for {domain}.")
                    return True
                elif d.get("ssl_status") == "pending":
                    log(f"SSL pending for {domain}...")
        time.sleep(20)
    log(f"SSL not ready for {domain} after {timeout}s", "ERROR")
    return False


def check_https(domain):
    try:
        resp = requests.get(f"https://{domain}", timeout=10, allow_redirects=True)
        if resp.status_code == 200:
            log(f"HTTPS access OK for {domain}.")
            return True
        else:
            log(f"HTTPS failed for {domain}: {resp.status_code}", "WARN")
            return False
    except Exception as e:
        log(f"HTTPS error for {domain}: {e}", "ERROR")
        return False


def main():
    if not TOKEN:
        log("DIGITALOCEAN_ACCESS_TOKEN not set.", "ERROR")
        sys.exit(1)
    app_id = get_app_id()
    # Add domains
    for domain in TARGET_DOMAINS:
        add_domain(app_id, domain)
    # Print DNS instructions
    print_dns_instructions(app_id)
    # Wait for DNS propagation
    for domain in TARGET_DOMAINS:
        for attempt in range(RETRY):
            if check_dns(domain):
                break
            log(f"Waiting for DNS propagation for {domain} (attempt {attempt+1}/{RETRY})...")
            time.sleep(RETRY_DELAY)
    # Wait for SSL
    for domain in TARGET_DOMAINS:
        wait_for_ssl(app_id, domain)
    # Final check
    all_ok = True
    for domain in TARGET_DOMAINS:
        if not check_https(domain):
            all_ok = False
    if all_ok:
        print("\n🎉 SUCCESS: https://app-oint.com is live and SSL is enabled!")
    else:
        print("\n❌ ERROR: Some domains are not live. Check above logs.")
        sys.exit(1)

if __name__ == "__main__":
    main()