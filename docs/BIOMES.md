# Biomes — v1

Three biomes ship with v1.0. Each is a persistent layer; the player does not abandon earlier biomes when a new one unlocks. Spore output stacks.

## 1. Forest Floor *(starting biome)*

The shallow, sunlit world of the duff layer. Leaf litter, fallen branches, the broken backs of last year's logs. Everything here is in motion — fast decay, fast fruit, fast death.

| Property | Value |
|---|---|
| **Unlock** | Default. Starting biome. |
| **Light** | Dappled — moderate by day, dim at night |
| **Moisture** | Moderate. Rain events bring quick spikes. |
| **Decay rate** | Fast (×1.0 baseline) |
| **Fruit time band** | 6 – 90 minutes |
| **Substrates available** | leaf_litter, hardwood_log, stump, elder_log, birch_log, root_system |
| **Species** | Turkey Tail, Sulphur Tuft, Common Stinkhorn, Lemon Disco, Wood Ear, Stump Puffball, Honey Fungus, Birch Polypore |
| **Mood** | Domestic. Quiet. Crows in the distance. |

## 2. Old Growth *(unlocks at 500 spores)*

The deep forest. Trees four hundred years old. Substrate is bigger, denser, and takes longer to break — but a single fruiting can carry you for hours.

| Property | Value |
|---|---|
| **Unlock** | 500 spores released cumulatively |
| **Light** | Low. Sun barely reaches the floor. |
| **Moisture** | High. Damp year-round. |
| **Decay rate** | Slow (×0.4) |
| **Fruit time band** | 3 – 9 hours |
| **Substrates available** | hardwood_log, oak_log, oak_base, hemlock_log, conifer_duff |
| **Species** | Lion's Mane, Chicken of the Woods, Hen of the Woods, Hemlock Reishi, Beefsteak Polypore, Bleeding Tooth Fungus |
| **Mood** | Cathedral. Held breath. Something old is paying attention. |
| **Mechanic** | Tree partnership unlocks here — pick a host (oak / hemlock / birch / beech). |

## 3. Swamp *(unlocks at 2,500 spores)*

Standing water, half-sunk logs, mist that doesn't lift. The bioluminescent layer. Most night-only species live here.

| Property | Value |
|---|---|
| **Unlock** | 2,500 spores released cumulatively |
| **Light** | Very low. Bioluminescence is the primary night light source. |
| **Moisture** | Saturated. Substrate decays at variable rates depending on submersion. |
| **Decay rate** | Variable (×0.6 base, ×1.4 in rain) |
| **Fruit time band** | 20 minutes – 36 hours |
| **Substrates available** | wet_hardwood, wet_duff, wet_twig, buried_root, buried_log |
| **Species** | Bitter Oyster, Jack-O'-Lantern, Eternal Light Mycena, Witches' Butter, Black Trumpet, Ghost Fungus |
| **Mood** | Awe with an edge. Bog water. Frogs that go silent when you look. |
| **Mechanic** | Night/Day swing matters here. Bioluminescent species only fruit between dusk and dawn (game time). |

## Decay rate notes

Decay rate is a multiplier on substrate energy release per tick. A "log" placed in Forest Floor is consumed at the base rate; the same log in Swamp lasts more than twice as long but the species fruiting from it are rarer.

## Future biomes (post-v1)

- **Cave** — no light, parasitic species, lichen mats
- **Tundra** — slow everything, alpine fungi, lichens (real Cladonia species)
- **The Heartwood** — endgame, single ancient tree, network fuses with the tree

These are scaffolded in BIOMES_FUTURE.md (TBD) and intentionally left out of v1 to keep the build scope tight, mirroring how Cosmica shipped lean and expanded post-launch.
