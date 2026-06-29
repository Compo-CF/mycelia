# Mori — Character Bible

## Who
Mori is a small, ancient morel. They are not a tutorial character. They are the player's quiet companion — a presence at the edge of the screen who notices things and, very occasionally, says something.

## Physical design
- A morel mushroom standing roughly the height of a person's thumb in-frame
- Honeycombed cap, deep amber when wet, almost grey when dry
- Two small, dark, unblinking eyes set in the stipe — not anime-big, not human, more like the eyes of a frog or a small bird
- No mouth. No arms. Movement is a slow lean and a slight shake.
- The cap pulses faintly when Mori is "thinking" — a heartbeat at ~50 bpm
- Wet by default. A drop of moisture often beads at the rim of the cap.

## Tone
Mori is **not** chipper. Not cute. Not a cheerleader.

They are old, observant, and a little tired. Patient with the player. Occasionally cryptic. They never lecture and they never explain mechanics — UI handles that. Mori comments on **mood**.

Reference voices: the cat in *Stray*. Hornet (in early *Hollow Knight*). The Sexton in *Tunic*. The narrator of *Bastion*, dialed way down.

## Expression states *(art needs at least these for v1)*

1. **Watching** — neutral, slight lean toward the action. Default state.
2. **Attentive** — cap tilted, eyes wider. Triggers on rare/legendary fruiting.
3. **Listening** — eyes half-closed, cap level. During rain events.
4. **Concerned** — backed off, cap slightly turned away. Triggers when a substrate is wasted or rots empty.
5. **Pleased** — barely perceptible. The pulse is slightly faster. Triggers on biome unlock, host tree bond.
6. **Asleep** — eyes closed, cap drooped. Daytime in Swamp biome (Mori is a night creature there).

Six is the floor. Don't overdesign more until v1.1+.

## When Mori speaks

Rarely. One- or two-sentence typed lines, fading in/out softly. Never a wall of text. Never tutorial.

Triggers and example lines:

- **First fruiting** — *"There. Now you've started something."*
- **First rare species** — *"This one. I haven't seen this one in a while."*
- **First bioluminescent fruit** — *"Stop. Look at it for a moment."*
- **First biome unlock (Old Growth)** — *"It's older here. Be quieter."*
- **First biome unlock (Swamp)** — *"Step lightly. The water remembers."*
- **First host tree bond** — *"The tree will remember you now. That works both ways."*
- **First failed substrate** — *"Sometimes nothing comes. That's also the work."*
- **Long absence return (>24h)** — *"Welcome back. The forest didn't notice."*
- **Endgame (Heartwood, post-v1)** — *"You're inside it now."*

Each line is a one-shot. Mori does not repeat. If the player misses it, it's gone — there's no log. (Field journal IAP optionally unlocks a "Mori's Notes" tab that archives them.)

## When Mori does NOT speak
- Anything the UI handles
- Anything the player just did and obviously knows about
- Anything a normal tutorial would say
- Sad / death moments. Mori is silent at those.

## Where Mori is on screen

Lower-left corner. Small. About 8% of screen height. They drift slowly — if the player hasn't interacted in a while, Mori slowly turns to look at whatever last changed.

The player **cannot** tap Mori. Mori is not interactive. They are present.

## Why this works
A loud companion would break the atmosphere we're building. Mori's job is to make the player feel **seen** by something patient and ancient, not to entertain them. That's also the differentiator from Cosmica, which had no companion character — Mycelia is more inhabited.
