# This is your first AI agent!
# It will generate images using a real AI service

import requests
import json
from datetime import datetime

def generate_image(prompt, style="realistic"):
    """
    This function talks to an AI image service
    """
    print(f"🎨 Generating image: {prompt}")
    
    # For now, we'll simulate the response
    # Later we'll connect to a real AI service
    response = {
        "id": f"img_{datetime.now().strftime('%Y%m%d_%H%M%S')}",
        "prompt": prompt,
        "style": style,
        "status": "completed",
        "message": "Image would be generated here!"
    }
    
    return response

# Test our agent
if __name__ == "__main__":
    result = generate_image("spaceship launching from futuristic city", "cyberpunk")
    print(f"✅ Result: {json.dumps(result, indent=2)}")