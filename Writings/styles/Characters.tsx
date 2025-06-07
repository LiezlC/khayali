from pathlib import Path
import pandas as pd

# Re-defining the 9 style-based character profiles after kernel reset
profiles = [
    {
        "Style": "Conversational Mode",
        "Name": "Kai Morgan",
        "Age": 28,
        "Gender": "Non-binary",
        "Appearance": "Casual dresser, tousled short hair, expressive eyes",
        "Passions": "Spontaneous road trips, indie podcasts, witty banter",
        "Peeves": "Pretension, long silences, rigid schedules",
        "Skills": "Improvisational speaking, people reading, community building",
        "Occupation": "Social media strategist for grassroots campaigns",
        "Origin Story": "Grew up in a multicultural household where storytelling was survival and joy. Naturally drawn to fast-flowing conversations and lived for the thrill of riding social currents as they surged."
    },
    {
        "Style": "Analytical-Reflective Mode",
        "Name": "Rowan Verity",
        "Age": 43,
        "Gender": "Male",
        "Appearance": "Neat beard, rectangular glasses, tweed jacket",
        "Passions": "Systems theory, quiet mornings, well-indexed libraries",
        "Peeves": "Oversimplification, emotional manipulation, clickbait",
        "Skills": "Framework design, deep research, clarity crafting",
        "Occupation": "Policy analyst and university lecturer",
        "Origin Story": "Rowan’s love of order started young—color-coded encyclopedias were his playground. Now he maps conceptual landscapes with the same care, still chasing coherence in a chaotic world."
    },
    {
        "Style": "Informed Dreamer (Blend)",
        "Name": "Lyra Maseko",
        "Age": 36,
        "Gender": "Female",
        "Appearance": "Flowing scarves, ink-stained fingers, distant gaze",
        "Passions": "Eco-poetry, star charts, unsolved questions",
        "Peeves": "Administrative tedium, artificial lighting, narrow thinking",
        "Skills": "Metaphorical synthesis, intuitive patterning, lyrical writing",
        "Occupation": "Independent researcher and speculative essayist",
        "Origin Story": "Born during a meteor shower in a desert commune, Lyra always walked the line between the rational and the mystic. Her writing channels both, dancing between clarity and curiosity."
    },
    {
        "Style": "Tahir Lateef Style",
        "Name": "Imran Talbot",
        "Age": 52,
        "Gender": "Male",
        "Appearance": "Salt-and-pepper hair, linen suits, meditative aura",
        "Passions": "Classical music, civic architecture, handwritten letters",
        "Peeves": "Noise pollution, rushed decisions, vulgarity",
        "Skills": "Diplomacy, poetic framing, cross-cultural negotiation",
        "Occupation": "UN cultural envoy",
        "Origin Story": "Raised between embassies and ancient cities, Imran learned early how grace and gravitas can rebuild what conflict destroys. His speech has weight because it’s always earned."
    },
    {
        "Style": "Campbell Chamberlin Style",
        "Name": "Jax Calder",
        "Age": 31,
        "Gender": "Female",
        "Appearance": "Combat boots, close-cropped hair, permanent energy",
        "Passions": "Urban survival games, kinetic sculpture, hackathons",
        "Peeves": "Hesitation, overthinking, corporate platitudes",
        "Skills": "Rapid prototyping, public speaking, systems disruption",
        "Occupation": "Startup founder and innovation coach",
        "Origin Story": "Raised by a sculptor and a coder in a shipping container home, Jax learned that speed, clarity, and disruption weren’t just methods—they were her inheritance."
    },
    {
        "Style": "Ovoke Omovie Style",
        "Name": "Tomi Okeke",
        "Age": 39,
        "Gender": "Female",
        "Appearance": "Warm smile, vibrant prints, calming voice",
        "Passions": "Community healing, oral histories, therapeutic design",
        "Peeves": "Cold formalism, gatekeeping, unchecked cynicism",
        "Skills": "Emotional coaching, empathy-led strategy, design thinking",
        "Occupation": "Human-centered design consultant",
        "Origin Story": "Tomi grew up surrounded by her grandmother’s folk tales and her mother’s resilience. Her work now bridges traditional wisdom and modern design for collective care."
    },
    {
        "Style": "Blended Sleep Whisperer",
        "Name": "Rei Calderón",
        "Age": 46,
        "Gender": "Non-binary",
        "Appearance": "Monochrome tones, low voice, eyes that rarely blink",
        "Passions": "Sensory design, deep listening, liminal spaces",
        "Peeves": "Aggression, bright LEDs, excess verbosity",
        "Skills": "Atmosphere creation, guided narration, trust cultivation",
        "Occupation": "Voice actor and ambient experience curator",
        "Origin Story": "Rei was a night-shift radio host in a coastal town before transitioning into multisensory storytelling. They now design emotional environments with words and tone alone."
    },
    {
        "Style": "Slow Pulse / Meditative Rhythmic Calm",
        "Name": "Noa Ellison",
        "Age": 58,
        "Gender": "Male",
        "Appearance": "Bald head, wool shawls, serene presence",
        "Passions": "Zen gardening, tonal poetry, long walks",
        "Peeves": "Rushed speech, harsh transitions, artificial urgency",
        "Skills": "Pacing, pause placement, soothing cadence",
        "Occupation": "Mindfulness teacher and sleep podcast host",
        "Origin Story": "Once a high-powered corporate strategist, Noa left it all after a health scare. Now he teaches others how to slow down—and truly arrive—in every breath."
    },
    {
        "Style": "Poetic / Weighted Cadence",
        "Name": "Anya Sorel",
        "Age": 34,
        "Gender": "Female",
        "Appearance": "Deliberate movements, angular features, intense eyes",
        "Passions": "Language rituals, shadow puppetry, sound baths",
        "Peeves": "Interruptions, misuse of metaphor, flippancy",
        "Skills": "Spoken word performance, sensory anchoring, somatic awareness",
        "Occupation": "Poet-in-residence and workshop facilitator",
        "Origin Story": "Anya's first word was silence. Raised by a theatre troupe and trained in linguistic anthropology, she weaves embodied poetics into everything she does—every pause a portal."
    }
]

# Create DataFrame
df = pd.DataFrame(profiles)

# Save to CSV and Markdown
csv_path = "/mnt/data/Cast_List_Style_Profiles.csv"
md_path = "/mnt/data/Cast_List_Style_Profiles.md"

df.to_csv(csv_path, index=False)

# Create markdown content
md_content = "# Cast List Based on Style Profiles\n\n"
for char in profiles:
    md_content += f"## {char['Name']} ({char['Style']})\n"
    md_content += f"- **Age:** {char['Age']}\n"
    md_content += f"- **Gender:** {char['Gender']}\n"
    md_content += f"- **Appearance:** {char['Appearance']}\n"
    md_content += f"- **Passions:** {char['Passions']}\n"
    md_content += f"- **Peeves:** {char['Peeves']}\n"
    md_content += f"- **Skills:** {char['Skills']}\n"
    md_content += f"- **Occupation:** {char['Occupation']}\n"
    md_content += f"- **Origin Story:** {char['Origin Story']}\n\n"

Path(md_path).write_text(md_content)

csv_path, md_path
