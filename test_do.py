import requests
import json

token =REDACTED_TOKEN = "https://api.digitalocean.com/v2account"
headers = {
    Authorization: fBearer {token}",
   Content-Type":application/json"
}

print("Testing DigitalOcean token...")
print(fToken: {token[:20}...")
print(f"URL: {url}")
print()

try:
    response = requests.get(url, headers=headers)
    
    print(f"HTTP Status: {response.status_code}")
    print("Response Headers:")
    for key, value in response.headers.items():
        print(f"  {key}: {value}")
    
    print("\nResponse Body:)if response.status_code ==20   data = response.json()
        print(json.dumps(data, indent=2))
        print("\n✅ Token is VALID")
    elif response.status_code == 401:
        print("❌ Token is INVALID - Unauthorized")
        print(response.text)
    else:
        print(f"❌ Unexpected status code: {response.status_code}")
        print(response.text)
        
except Exception as e:
    print(f"❌ Error making request: {e}")