---
name: create-story-board
description: >
  Use this skill when a user wants to generate storyboard prompts for AI video production.
  Trigger when the user mentions: storyboard, story board, Seedance, AI video prompts,
  shot list, cinematic panels, animating a design sheet, or uploads a design sheet image
  and wants video prompts written. This skill covers Stage 2 of the AI video pipeline —
  generating and modifying the Storyboard image prompt and the 12 individual video prompts.
  For generating the initial Design Concept Sheet, use the create-ref-sheet skill.
---

# Create Storyboard

Generate a storyboard image prompt plus 12 individual video prompts from an uploaded Design
Concept Sheet. The storyboard prompt produces a 12-panel (4×3) cinematic grid; the video
prompts animate each panel in Seedance or another AI video model.

Always reference the uploaded Design Sheet image when writing the storyboard prompt.

---

## What the Storyboard Prompt Must Include

**1. Image Reference Instruction**
Always open with:
> "Use the uploaded image(s) as a reference for the [characters / influencer / model / product], [wardrobe / packaging], lighting, environments, color grading, mood, and overall cinematic style. Keep [them / him / her / the character] visually consistent across all panels."

**2. World & Environment**
Describe the setting, atmosphere, and tone in 2–3 sentences. Be specific about lighting, weather, time of day, and emotional register.

**3. Characters / Subject + Costume Lock**
Name each character and give a 1-line description. Then define a strict costume lock — a complete head-to-toe description of exactly what they are wearing for the entire storyboard. Be specific: every garment, accessory, helmet state, footwear, and any worn equipment.

Always include this line:
> "Every character's costume and appearance must remain exactly identical across all panels. Do not add, remove, or alter any clothing item, accessory, helmet, or equipment between panels unless a wardrobe change is explicitly listed below."

If the story requires a wardrobe change, list it explicitly:
> "WARDROBE CHANGE: [Character name] — from panel [N] onward: [full new outfit description]."

Every panel description must explicitly state what the character is wearing if there is any chance of ambiguity (e.g. helmet on vs off, jacket open vs closed). Leave nothing to the image model to decide.

**Face covering rule — applies to any wearable that covers the face (respirators, helmets, visors, masks, gas masks):**
- Every panel description AND every corresponding video prompt must explicitly state whether the face covering is ON or OFF
- Never assume the image model will carry this detail forward — restate it every time a character appears
- EXTERIOR panels: write "wearing [respirator/mask/helmet] over nose and mouth"
- INTERIOR panels: write "respirator/mask pulled down around neck, face fully visible"

**4. Scene Context**
1–3 sentences describing what the scene is about at a high level.

**5. Style Block**
Match the style from the Design Sheet, adapted for motion storyboards:
```
photorealistic, shot on 35mm film, cinematic lighting, [add atmosphere details],
realistic [action / lifestyle / commercial] cinematography
```

**6. Storyboard Structure**
Always specify: *"Build a single cinematic 4×3 storyboard grid, panels clearly separated by thin borders with the following frames:"*

Then list 12 panels. Each panel must include:
- Panel number
- Shot name (e.g., "Wide Establishing Shot", "Tight Close-Up — Hands")
- 1–2 sentence description of the specific action, framing, and emotional beat

**Panel Caption Instruction — always include this line:**
> "Below each panel, print the panel number and location header in the format: '01. EXT. LOCATION — DAY/NIGHT' followed on the next line by a single short caption of no more than 6 words describing the action. Example: '05. INT. CORRIDOR — NIGHT / She sees it for the first time.' Use monospace or typewriter-style font for all captions."

---

## Panel Writing Guidelines

- **Vary shot sizes**: mix wides, mediums, close-ups, inserts, and over-the-shoulder shots
- **Build narrative arc**: establish → develop tension → peak action → resolution
- **Use cinematic language**: "medium-wide cinematic shot", "side-angle action shot", "extreme close-up insert"
- **Ground each panel**: specific action + specific emotion or detail

**STILL IMAGE RULE — critical for image generators:**
Every panel description must only contain actions and states that can be captured in a single frozen photograph. Ask: "could a photographer take one photo that shows this?" If yes, it's valid. If no, rewrite it.

Valid (visible in a still image): walking, running, crouching, pointing, holding, pushing, looking, reaching, standing, sitting, embracing, falling, fighting, crying, laughing, staring, carrying, climbing

Invalid (require motion or time to understand): nodding, shaking head, agreeing, deciding, realizing, turning around, beginning to do something, finishing something, reacting to something, noticing something off-screen

When an "invalid" action is needed, translate it into its visible physical equivalent:
- "she nods" → "she looks at him with a small relieved expression, chin slightly lowered"
- "he realizes the door is locked" → "he stands at the door, both hands flat against it, head bowed"
- "she reacts to the gas" → "she staggers backward, one hand pressed over her respirator, eyes wide"
- "they decide to take the side road" → "both characters lean over the open map on the car hood, the father's finger pressed to a route, the daughter looking where he points"

---

## Scene Types & Panel Templates

**Action / Confrontation:**
Wide establishing → character entrances → reaction close-ups → action buildup → dynamic collision → combat sequence → insert damage detail → final blow → defeat shot → hero ending shot

**Emotional / Drama:**
Establishing location → character entrance → preparation close-up → performance begins → emotional escalation → psychological moment → wide performance → surreal/hallucination beat → introspective close-up → breakdown → confrontation → quiet resolution

**Day-in-Life / Commercial:**
Morning wake-up → routine → product close-up → product use → departure → activity (gym/work/errands) → social moment → mid-day energy → afternoon walk → evening return → night routine → final peaceful shot with product visible

**Fashion / Red Carpet:**
Getting ready wide → mirror preparation → outfit/accessories detail → dressed reveal → departure close-up → arrival exterior → entrance walk → crowd/event wide → interaction shot → photographer moment → close-up portrait → final brand shot

---

## Modifications

- **Change scene type** → rewrite Scene Context and swap panel template
- **Add/remove panels** → adjust grid (e.g., 3×4 or 2×4)
- **Shift tone** → update World & Environment and style block
- **Feature product/character more** → add insert shots or rewrite specific panels

---

## Output Format

### Block 1 — Storyboard Image Prompt

```
STORYBOARD PROMPT — [Project Title]
[full prompt text]
```

Each panel in the prompt must include its caption in the format:
`01. EXT./INT. LOCATION — DAY/NIGHT / [6-word max action caption]`

### Block 2 — AI Video Prompts

Generate 12 individual video prompts — one per panel — for Seedance or any AI video model.

Rules:
- Each prompt is 1–3 sentences maximum
- Write in plain present tense: describe exactly what is happening visually
- Include: subject, action, shot framing, environment, and any key visual detail (lighting, weather, movement)
- Do NOT use cinematic jargon like "medium shot" or "cut to"
- Do NOT reference other panels or use narrative language like "meanwhile" or "suddenly"
- **Dialogue is optional** — add only when the user requests it or when it meaningfully adds to the scene. Format: `[Character] says: "[line]"` after the visual description
- Every prompt must end with: **No Music, No Subtitles**

Format:
```
Shot [N]: [description]. No Music, No Subtitles
```

Example:
```
Shot 1: A damaged yellow robot powers on in a dense misty forest, slowly turning its
square head left and right to scan the dark trees around it. No Music, No Subtitles

Shot 2: A scientist in a full yellow hazmat suit and gas mask stands motionless among
tall ancient trees, watching the robot carefully from a distance. No Music, No Subtitles
```
