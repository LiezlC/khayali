import requests

# Better way to read token
with open('.env', 'r') as f:
    content = f.read().strip()
    # Handle different formats
    if '=' in content:
        token = content.split('=')[1].strip()
    else:
        token = content.strip()

print(f"Token starts with: {token[:10]}...")
print(f"Token length: {len(token)}")
print(f"Full token: {token}")

# Test the token
headers = {"Authorization": f"Bearer {token}"}
response = requests.get("https://huggingface.co/api/whoami", headers=headers)

print(f"\nStatus: {response.status_code}")
if response.status_code == 200:
    print(f"✅ Token works! User: {response.json()['name']}")
else:
    print(f"❌ Token issue: {response.text}")