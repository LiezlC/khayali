import requests
import os

# Read token
with open('.env', 'r') as f:
    token = f.read().strip().split('=')[1].strip()

print(f"Testing with token: {token[:20]}...")

# Try a simple model that should definitely work
API_URL = "https://api-inference.huggingface.co/models/black-forest-labs/FLUX.1-dev"
headers = {"Authorization": f"Bearer {token}"}

response = requests.post(
    API_URL,
    headers=headers,
    json={"inputs": "a cat"}
)

print(f"Status: {response.status_code}")
print(f"Response: {response.text[:200]}")

if response.status_code == 200:
    with open("test_image.jpg", "wb") as f:
        f.write(response.content)
    print("✅ Success! Check test_image.jpg")