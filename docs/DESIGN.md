# Mycelia — Design Bible

## Pitch
A slow, atmospheric idle game about growing a fungal network beneath an old forest. The player decomposes substrate, threads mycelium, fruits real-world mushroom species, releases spores to colonize new biomes, and partners with host trees. Quiet. Eerie. Reverent.

## Tone
- **Atmospheric, not cute.** Hollow Knight, Tunic, Stray, The Witness, Rain World.
- The forest is old. Something is watching. Nothing is hostile, but nothing is safe either.
- Mori is not a chipper companion. They are quiet, observant, occasionally cryptic.
- Soundscape: low wind, distant creaks, water dripping, the wet snap of fruiting. No music most of the time. A theme only at biome unlocks.

## Visual direction
- **Palette**
  - Deep moss (`#2C3A2A`)
  - Wet bark (`#3B2E26`)
  - Pale spore (`#E4D8C4`)
  - Bioluminescent teal (`#5BC9B0`) — accent only, used sparingly to highlight life
  - Amanita red (`#8C2A2A`) — rare, dangerous, beautiful
- **Lighting**: backlit, volumetric, soft fog. A constant sense of damp.
- **Type**: a humanist serif for chrome (Source Serif or similar). A small mono for numbers.
- **No UI chrome by default.** HUD fades in on interaction, fades back into the world.

## Core loop

1. **Place substrate** — logs, leaves, animal remains, fallen fruit. Each has a decomposition curve.
2. **Mycelium spreads** along substrate, consuming it for energy (nutrients).
3. **Nutrients accumulate** in nodes along the network.
4. **Fruiting** happens at nodes that hit threshold — a species appropriate to that substrate + biome + moisture + light emerges.
5. **Harvest or release** — harvest gives currency; release sends spores into the air to colonize.
6. **Spore events** — periodic windows where you can spend spores to push into a new biome.
7. **Tree partnership** — each run, you bond with one host tree (oak / pine / birch / aspen / beech). Affects which species fruit best.

The whole thing runs in real time, slowly. Five minutes is meaningful. An hour is significant. A day is transformative.

## Time
- Real-time idle. Offline progress applies fully.
- Day/night cycle is real and matters: some species only fruit at night, some only after rain.
- A "rain event" passes through every ~6 hours, accelerating decomposition briefly.

## Progression spine
1. **Forest floor** (start) — leaf litter, fallen logs, common saprotrophs
2. **Old growth** — bigger logs, longer decay, larger fruiting bodies
3. **Swamp** — wet substrates, bioluminescent species (Panellus, Mycena)
4. **Cave** — no light, parasitic and rare species
5. **Tundra** — slow everything, lichens, rare alpine fungi
6. **The Heartwood** (endgame) — single ancient tree, the network becomes the tree

Each biome unlocks at a spore threshold. Biomes are not abandoned — they keep producing.

## Differentiators vs Cosmica
- **Inward growth** (network) vs outward expansion (sectors)
- **Patience-rewarding** vs click-engaging
- **Real species catalog** vs fictional cosmic objects
- **Time-of-day matters** vs always-on
- **One host tree per run** introduces meaningful build choice — Cosmica has no equivalent

## Monetization (mirror Cosmica)
- AdMob banner (toggleable; gone with any IAP)
- Rewarded ads: "speed the rain" (2x decomposition for 5 min)
- IAPs:
  1. Remove ads ($2.99)
  2. Field journal (cosmetic + lore + species pages) ($4.99)
  3. Lantern (small permanent night-light boost) ($1.99)
  4. Heartwood supporter ($9.99) — name in credits + cosmetic skins for Mori
  5. Mycologist bundle ($14.99) — everything above

## Game Center
- Leaderboards: total spores released, species cataloged, biomes reached, longest fruiting streak
- Achievements: First Fruit, Bioluminescence, Decomposer, Symbiosis, Heartwood

## What ships in v1.0
- 3 biomes (Forest, Old Growth, Swamp)
- 20 real species
- Mori with 6 expression states
- Day/night + rain
- CloudKit save
- All 5 IAPs + AdMob
- Game Center scaffolding (leaderboards post-launch)

## Open questions
- Touch model: tap-to-place substrate vs drag-to-thread mycelium? Lean drag — feels more physical.
- Do harvested mushrooms enter a "field journal" the player reads, or just a count?
  - Recommend: journal. It's atmospheric and supports the IAP.
- Should Mori speak? Or only emote?
  - Recommend: rare typed dialogue, no voice. One or two sentences per milestone.
