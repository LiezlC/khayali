import subprocess
import os
from datetime import datetime

def animate_image_with_ffmpeg(image_path, duration=5, zoom=1.2, pan_direction="up"):
    """
    Animate a static image with panning/zoom using ffmpeg
    """
    print(f"🎞️ Animating '{image_path}' using local ffmpeg...")

    output_file = f"panzoom_{datetime.now().strftime('%Y%m%d_%H%M%S')}.mp4"

    # Determine panning direction
    if pan_direction == "up":
        pan_filter = "y='ih-(t*ih/{})'".format(duration)
    elif pan_direction == "down":
        pan_filter = "y='t*ih/{}'".format(duration)
    else:
        pan_filter = "y='ih/2'"  # static

    zoom_filter = f"zoom='if(lte(zoom,{zoom}),zoom+0.001,zoom)',{pan_filter}"

    cmd = [
        "ffmpeg",
        "-loop", "1",
        "-i", image_path,
        "-vf", f"zoompan=d={duration*25}:s=1280x720:fps=25",
        "-t", str(duration),
        "-c:v", "libx264",
        "-pix_fmt", "yuv420p",
        output_file
    ]

    try:
        subprocess.run(cmd, check=True)
        print(f"✅ Animation saved as: {output_file}")
        return {"status": "success", "filename": output_file}
    except subprocess.CalledProcessError as e:
        print(f"❌ ffmpeg failed: {e}")
        return {"status": "error", "message": str(e)}

# Test it!
if __name__ == "__main__":
    test_image = "generated_20250626_021712.png"
    animate_image_with_ffmpeg(test_image)
