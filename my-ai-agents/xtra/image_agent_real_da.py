# REAL AI Image Generator Agent
import requests
import json
import os
import time
from datetime import datetime

# Load your API token
with open('.env', 'r') as f:
    token = f.read().strip().split('=')[1]

def generate_image(prompt, style="realistic"):
    """
    Generate REAL images using Hugging Face AI
    """
    print(f"🎨 Generating REAL image: {prompt}")
    print("⏳ This might take 20-30 seconds...")
    
    # API endpoint for Stable Diffusion
    API_URL = "https://api-inference.huggingface.co/models/dreamlike-art/dreamlike-photoreal-2.0"
    headers = {"Authorization": f"Bearer {token}"}
    
    # Make the request
    response = requests.post(API_URL, headers=headers, json={
        "inputs": f"{prompt}, {style} style, high quality, detailed",
    })
    
    if response.status_code == 200:
        # Save the image
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        filename = f"generated_{timestamp}.png"
        
        with open(filename, 'wb') as f:
            f.write(response.content)
        
        print(f"✅ Image saved as: {filename}")
        return {
            "status": "success",
            "filename": filename,
            "prompt": prompt
        }
    else:
        print(f"❌ Error: {response.status_code}")
        return {"status": "error", "message": response.text}

# TEST IT!
if __name__ == "__main__":
    print("🚀 REAL AI IMAGE GENERATOR READY!")
    print("-" * 40)
    
    # Generate our spaceship!
    result = generate_image(
        "futuristic spaceship launching from cyberpunk city at night, neon lights, dramatic angle",
        "cinematic"
    )
    
    print(f"\n📊 Result: {json.dumps(result, indent=2)}")