---
name: create-ref-sheet
description: >
  Use this skill when a user wants to generate a Design Concept Sheet prompt for AI video
  preproduction. Trigger when the user mentions: design sheet, reference sheet, concept sheet,
  character design, production design, GPT Image, AI film preproduction, campaign board,
  character turnaround, or asks for a prompt to generate a preproduction reference image.
  This skill covers Stage 1 of the AI video pipeline only — generating and modifying the
  Design Sheet prompt. For storyboard prompts, use the create-story-board skill.
---

# Create Reference Sheet

Generate a Design Concept Sheet prompt — a single image prompt that produces a professional
preproduction board with characters, environments, style references, color palette, and mood.
The output is pasted into GPT Image 2 (or similar) to generate the reference image used in Stage 2.

---

## What a Design Sheet Prompt Must Include

**1. Layout Section**
Always describe the layout explicitly. Standard structure:
- Left column: title/logo, logline or campaign slogan, hero poster image
- Top row: full-body character turnaround shots (front, 3/4, profile, back, key poses) OR influencer/model turnaround
- Top right: props, products, accessories, technical specs, or key objects
- Middle row: cinematic action or lifestyle scenes
- Bottom row: environments/locations, mood references, color palette swatches, typography references

**2. Characters / Subjects**
- Describe each character or subject with specific visual detail: ethnicity, build, hair, expression, wardrobe, and any special elements (armor, wings, props)
- For campaigns: describe the model/influencer and the product in detail
- Emphasize: **"must remain visually consistent across all panels"**

**3. Story Tone / Campaign Concept**
- 1–2 sentences describing the emotional or narrative core

**4. Style Block**
Always end with a comma-separated style list. Tailor to the project type:

*Cinematic Film:*
```
photorealistic, shot on 35mm film, cinematic lighting, slightly desaturated colors,
minimalist editorial layout, high-end Hollywood production photography, organized grid composition
```

*Luxury Commercial / Influencer:*
```
ultra photorealistic, shot on 35mm film, cinematic shallow depth of field, natural film grain,
soft cinematic lighting, clean luxury commercial photography, Kodak Portra color tones,
slightly desaturated modern color grade, editorial magazine aesthetic, organized grid composition
```

*Sci-Fi / Action:*
```
photorealistic, shot on 35mm film, cinematic lighting, slightly desaturated colors,
high contrast dramatic lighting, minimalist editorial layout, organized grid composition
```

---

## Modifications

If the user wants to change the Design Sheet prompt, identify what they want to adjust:
- **Color palette** → update the style block and add explicit palette instructions (e.g., "warm amber tones, deep navy shadows")
- **Style/aesthetic** → swap or add style descriptors
- **Character** → rewrite the character description section
- **Story/concept** → update logline and tone section
- **Layout** → revise the layout section

---

## Output Format

Present the prompt in a clean code block, ready to paste into GPT Image 2 or similar:

```
DESIGN SHEET PROMPT — [Project Title]
[full prompt text]
```

---

## Tips for Quality Prompts

- **Consistency language** is critical: always include "keep [character/subject] visually consistent across all panels"
- **More specific = better**: "a young male violinist with elegant black hair and expressive eyes" beats "a musician"
- **Name characters**: giving characters names (Maya Song, Director Zhane) helps image models maintain consistency
- **Style blocks are cumulative**: don't just say "cinematic" — layer multiple descriptors
- **For products**: always describe the packaging in detail (shape, color, material, branding style)
