{
  "metadata": {
    "title": "[PLACEHOLDER_TITLE]",
    "genre": "[GENRE_TAGS]", 
    "tone": "[TONE_DESCRIPTORS]",
    "setting": "[SETTING_DETAILS]", 
    "central_conflict": "[PRIMARY_CONFLICT_DESCRIPTION]"
  },
  "references": {
    "plot": "[PLOT_REFERENCE_FILE]", 
    "characters": {
      "character_A": "[CHARACTER_A_REFERENCE_FILE]",
      "character_B": "[CHARACTER_B_REFERENCE_FILE]" 
    }
  },
  "process": {
    "recursion_1": {
      "step_1": {
        "instruction": "Write the first chapter of the story, titled '[PLACEHOLDER_TITLE].' Introduce the main characters, their relationship, and the central conflict or theme. Set the tone and genre. The chapter should be approximately 350 words. Refer to '[PLOT_REFERENCE_FILE]' for plot elements, and '[CHARACTER_A_REFERENCE_FILE]' and '[CHARACTER_B_REFERENCE_FILE]' for character details.",
        "output": "chapter_1_raw",
        "user_prompt": "I completed Recursion 1 Step 1. The next step is Recursion 2 Step 1."
      }
    },
    "recursion_2": {
      "step_1": {
        "instruction": "Edit Chapter 1 for redundancy and style. Aim for [TONE_DESCRIPTOR] prose, ensuring the narrative flows smoothly and the characters' personalities and backstory are conveyed effectively. Refer to '[PLOT_REFERENCE_FILE]' for plot details. Refer to '[CHARACTER_A_REFERENCE_FILE]' and '[CHARACTER_B_REFERENCE_FILE]' for character details.",
        "input": "chapter_1_raw",
        "output": "chapter_1_edited",
        "user_prompt": "I completed Recursion 2 Step 1. The next step is Recursion 3 Step 1. Type CONTINUE to proceed."
      }
    },
    "recursion_3": {
      "step_1": {
        "instruction": "Write Chapter 2. Build on the foundation laid in Chapter 1, deepening the characters' relationship and advancing the plot. Introduce new elements that complicate the central conflict or reveal more about the characters' backstories. Refer to '[PLOT_REFERENCE_FILE]' for plot elements, and '[CHARACTER_A_REFERENCE_FILE]' and '[CHARACTER_B_REFERENCE_FILE]' for character details.",
        "input": "chapter_1_edited",
        "output": "chapter_2_raw",
        "user_prompt": "I completed Recursion 3 Step 1. The next step is Recursion 3 Step 2. Type CONTINUE to proceed."
      },
      "step_2": {
        "instruction": "Edit Chapters 1 and 2 for narrative and stylistic cohesion. Ensure the tone, pacing, and character development are consistent across both chapters. Refer to '[PLOT_REFERENCE_FILE]' for plot details. Refer to '[CHARACTER_A_REFERENCE_FILE]' and '[CHARACTER_B_REFERENCE_FILE]' for character details.",
        "input": ["chapter_1_edited", "chapter_2_raw"],
        "output": ["chapter_1_final", "chapter_2_edited"],
        "user_prompt": "I completed Recursion 3 Step 2. The next step is Recursion 4 Step 1. Type CONTINUE to proceed."
      }
    },
    "recursion_4": {
      "step_1": {
        "instruction": "Reread Chapters 1 and 2 to refresh understanding of the story's direction. Refer to '[PLOT_REFERENCE_FILE]' for plot elements, and '[CHARACTER_A_REFERENCE_FILE]' and '[CHARACTER_B_REFERENCE_FILE]' for character details.",
        "input": ["chapter_1_final", "chapter_2_edited"],
        "user_prompt": "I completed Recursion 4 Step 1. The next step is Recursion 4 Step 2. Type CONTINUE to proceed."
      },
      "step_2": {
        "instruction": "Write Chapter 3. Deepen the central conflict, reveal more about the characters' motivations, and move the plot forward. Introduce a turning point or moment of heightened tension. Refer to '[PLOT_REFERENCE_FILE]' for plot elements, and '[CHARACTER_A_REFERENCE_FILE]' and '[CHARACTER_B_REFERENCE_FILE]' for character details.",
        "input": ["chapter_1_final", "chapter_2_edited"],
        "output": "chapter_3_raw",
        "user_prompt": "I completed Recursion 4 Step 2. The next step is Recursion 4 Step 3. Type CONTINUE to proceed."
      },
      "step_3": {
        "instruction": "Edit Chapters 1, 2, and 3 for narrative and stylistic cohesion. Ensure the tone, pacing, and character development are consistent across all three chapters. Refer to '[PLOT_REFERENCE_FILE]' for plot details. Refer to '[CHARACTER_A_REFERENCE_FILE]' and '[CHARACTER_B_REFERENCE_FILE]' for character details.",
        "input": ["chapter_1_final", "chapter_2_edited", "chapter_3_raw"],
        "output": ["chapter_1_final", "chapter_2_final", "chapter_3_edited"],
        "user_prompt": "I completed Recursion 4 Step 3. The next step is Recursion 5 Step 1. Type CONTINUE to proceed."
      }
    },
    "recursion_5": {
      "step_1": {
        "instruction": "Reread Chapters 1, 2, and 3 to ensure a clear understanding of the story's direction and themes. Refer to '[PLOT_REFERENCE_FILE]' for plot elements, and '[CHARACTER_A_REFERENCE_FILE]' and '[CHARACTER_B_REFERENCE_FILE]' for character details.",
        "input": ["chapter_1_final", "chapter_2_final", "chapter_3_edited"],
        "user_prompt": "I completed Recursion 5 Step 1. The next step is Recursion 5 Step 2. Type CONTINUE to proceed."
      },
      "step_2": {
        "instruction": "Write Chapter 4. Build toward the climax, raising the stakes and deepening the emotional resonance of the narrative. Refer to '[PLOT_REFERENCE_FILE]' for plot elements, and '[CHARACTER_A_REFERENCE_FILE]' and '[CHARACTER_B_REFERENCE_FILE]' for character details.",
        "input": ["chapter_1_final", "chapter_2_final", "chapter_3_edited"],
        "output": "chapter_4_raw",
        "user_prompt": "I completed Recursion 5 Step 2. The next step is Recursion 5 Step 3. Type CONTINUE to proceed."
      },
      "step_3": {
        "instruction": "Write Chapter 5, the final chapter. Resolve the central conflict in a way that feels satisfying and true to the characters' journeys. Tie up loose ends while leaving room for reflection or ambiguity. Refer to '[PLOT_REFERENCE_FILE]' for plot elements, and '[CHARACTER_A_REFERENCE_FILE]' and '[CHARACTER_B_REFERENCE_FILE]' for character details.",
        "input": ["chapter_1_final", "chapter_2_final", "chapter_3_edited", "chapter_4_raw"],
        "output": "chapter_5_raw",
        "user_prompt": "I completed Recursion 5 Step 3. The next step is Recursion 5 Step 4. Type CONTINUE to proceed."
      },
      "step_4": {
        "instruction": "Reread Chapters 1, 2, 3, 4, and 5 to ensure the story flows smoothly and the narrative arc is complete. Refer to '[PLOT_REFERENCE_FILE]' for plot elements, and '[CHARACTER_A_REFERENCE_FILE]' and '[CHARACTER_B_REFERENCE_FILE]' for character details.",
        "input": ["chapter_1_final", "chapter_2_final", "chapter_3_edited", "chapter_4_raw", "chapter_5_raw"],
        "user_prompt": "I completed Recursion 5 Step 4. The next step is Recursion 5 Step 5. Type CONTINUE to proceed."
      },
      "step_5": {
        "instruction": "Make final edits to all chapters for consistency, pacing, and emotional impact. Then, suggest a fitting title for the story based on its themes, tone, and central conflict. Refer to '[PLOT_REFERENCE_FILE]' for plot elements, and '[CHARACTER_A_REFERENCE_FILE]' and '[CHARACTER_B_REFERENCE_FILE]' for character details.",
        "input": ["chapter_1_final", "chapter_2_final", "chapter_3_final", "chapter_4_raw", "chapter_5_raw"],
        "output": ["chapter_1_final", "chapter_2_final", "chapter_3_final", "chapter_4_final", "chapter_5_final", "new_story_title"],
        "user_prompt": "I completed Recursion 5 Step 5. This is the final step. Type CONTINUE to complete."
      }
    }
  },
  "completion": {
    "summary": "After completing all steps, summarize the story in a few compelling sentences. Then, wait for user input to evaluate the story together.",
    "user_prompt": "[Insert new title and summary]. Let me know how you'd like to proceed with evaluation or further edits. [Insert your thoughts]."
  }
}
