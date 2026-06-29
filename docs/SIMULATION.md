# Simulation — Core Math

The spec that becomes Swift code. Every number here is a starting tunable, not a final value — playtesting will move them. Every formula is fixed.

## 1. Time

### 1.1 Tick rate
The world ticks at **1 Hz** (one tick per real second). `Δt = 1.0` in all formulas below. When the app is active, a foreground timer drives the ticks; when backgrounded or closed, time is reconstructed on resume (see §10, Offline progress).

### 1.2 Day / night cycle
Game time follows the **player's local wall clock**. This is intentional: returning to the game at night is mechanically different from returning at noon. The forest exists in the player's real day.

| Phase | Local hour range |
|---|---|
| Dawn  | 04:00 – 06:00 |
| Day   | 06:00 – 18:00 |
| Dusk  | 18:00 – 20:00 |
| Night | 20:00 – 04:00 |

Species marked `night_only: true` can only fruit during **Night** (or, with leniency, Dusk if `nutrients` are already at threshold — see §5.3).

### 1.3 Rain events
Rain is a Poisson process across the whole game. Decay accelerates during rain.

```
RAIN_MEAN_INTERVAL_SEC = 21_600   // ~6 hours
RAIN_DURATION_SEC       =    900   // 15 minutes
RAIN_DECAY_MULT         =    2.0
```

Next rain time is sampled on app launch (and after each rain ends):
```
nextRainAt = now + exponentialSample(meanSeconds: RAIN_MEAN_INTERVAL_SEC)
```

During rain, the biome's `decay_mult` is multiplied by `RAIN_DECAY_MULT`. A "rewarded ad" (Lantern of Rain IAP path) can trigger a 5-minute rain on demand — implemented by setting `rainEndsAt = now + 300` and `rainActive = true`.


## 2. Network topology (v1)

The player does not draw a graph. The biome **owns** a fixed set of nodes and slots arranged in the scene. The player drops substrate onto slots.

| Biome | Nodes | Slots / node | Total slots |
|---|---|---|---|
| Forest Floor | 3 | 3 | 9 |
| Old Growth   | 4 | 4 | 16 |
| Swamp        | 4 | 3 | 12 |

Each node is independent. Energy from substrates in a node's slots flows to **that node's** nutrient pool. Nodes do not share.

This is intentionally constrained for v1. Post-v1 may unlock a "trade route" that bridges nodes for a buff.

## 3. Substrate

A substrate is placed in a slot and decays over time, releasing energy into the parent node.

### 3.1 Properties

```swift
struct Substrate {
    let type: SubstrateType
    let totalEnergy: Float    // E_total, set at placement
    var energyRemaining: Float
    let baseDecayPerSec: Float  // d_base
    let placedAt: Date
}
```

### 3.2 Starting tunables

| Type | E_total | d_base | Lifespan (no mults) |
|---|---:|---:|---:|
| `leaf_litter`   |   100 | 0.50 |  3 min  |
| `wet_twig`      |   150 | 0.45 |  5 min  |
| `stump`         |   300 | 0.30 | 16 min  |
| `wet_duff`      |   400 | 0.35 | 19 min  |
| `birch_log`     |   600 | 0.20 | 50 min  |
| `elder_log`     |   600 | 0.20 | 50 min  |
| `hardwood_log`  |   800 | 0.20 | 66 min  |
| `oak_log`       | 1,200 | 0.18 | 111 min |
| `oak_base`      | 1,200 | 0.18 | 111 min |
| `hemlock_log`   | 1,500 | 0.15 | 167 min |
| `wet_hardwood`  | 1,000 | 0.25 | 67 min  |
| `buried_log`    | 1,800 | 0.12 | 250 min |
| `buried_root`   | 1,400 | 0.13 | 180 min |
| `root_system`   | 2,000 | 0.10 | 333 min |
| `conifer_duff`  |   600 | 0.20 | 50 min  |

### 3.3 Decay per tick

```
delta = d_base × biome_decay_mult × rain_mult × tree_bond_mult × Δt
energyRemaining -= delta
node.nutrients += delta
```

When `energyRemaining ≤ 0`: substrate is removed from the slot, slot opens, node continues with remaining substrates.

### 3.4 Decay multipliers

```
biome_decay_mult:
  forest_floor = 1.0
  old_growth   = 0.4
  swamp        = 0.6   (raises to ×1.4 during rain — water-driven)
  
rain_mult        = 2.0 if rain, else 1.0
tree_bond_mult   = §7
```


## 4. Nodes

```swift
struct Node {
    let id: NodeID
    var nutrients: Float    // capped at NODE_CAP
    var slots: [Slot]       // exactly K, fixed
    var currentFruit: Fruit?  // nil if empty
    var fruitProgress: Float  // 0..1, gates fruiting rolls
}

NODE_CAP = 1000
```

Nutrients accumulate via §3.3. Excess past `NODE_CAP` is wasted (this is intentional — encourages the player to harvest and convert).


## 5. Fruiting

Fruiting is what makes the game tick emotionally. The math:

### 5.1 Eligibility

A species `s` is **eligible** at node `n` if **all** are true:
1. `s.biome == n.biome`
2. At least one substrate in `n.slots` matches `s.substrate`
3. If `s.night_only`: current phase is Night (or Dusk with grace, see §5.3)
4. `n.nutrients >= s.fruitThreshold`

Where:
```
s.fruitThreshold = s.yieldNutrients × FRUIT_THRESHOLD_MULT
FRUIT_THRESHOLD_MULT = 10
```

So a yield-4 common species needs 40 banked nutrients. A yield-25 legendary needs 250.

### 5.2 Fruit roll

Each tick, for each node with `currentFruit == nil`, build the eligible list `E`. If empty, skip.

For each `s` in `E` sorted by `fruitThreshold` ascending:
```
roll_prob = FRUIT_ROLL_BASE / s.fruitTimeMinutes
FRUIT_ROLL_BASE = 1.0 / 60.0     // per tick

if random() < roll_prob × rarityWeight(s):
    n.currentFruit = Fruit(species: s, fruitedAt: now)
    n.nutrients -= s.fruitThreshold
    break  // one fruit per tick per node
```

```
rarityWeight:
  common      → 1.00
  uncommon    → 0.55
  rare        → 0.20
  legendary   → 0.05
```

This is the **emotional math**: legendary species do appear, but rarely, and only when you've patiently let nutrients bank well past common threshold without harvesting.

### 5.3 Dusk grace
A species with `night_only: true` may also fruit during **Dusk** if `n.nutrients >= 2 × s.fruitThreshold` at any tick. This rewards a player who arrives just before nightfall with a deeply primed node.

### 5.4 Fruit lifetime
A fruit sits at the node until:
- Player taps "Harvest" → +nutrients to inventory (see §6)
- Player taps "Release" → +spores to total (see §6)
- 24 hours elapse since `fruitedAt` → auto-release


## 6. Currencies and conversion

Two currencies:
1. **Nutrients** — local to inventory, used to buy substrate.
2. **Spores** — global meta currency, used to unlock biomes and progression.

### 6.1 Harvest vs. release

When a fruit is resolved:
```
Harvest: inventory.nutrients += s.yieldNutrients × HARVEST_MULT
Release: player.spores       += s.yieldSpores
```

```
HARVEST_MULT = 2.0
```

This means harvesting a yield-4 species adds 8 nutrients to inventory — enough to buy ~one new substrate. Releasing it adds `s.yieldSpores` to permanent progression. The trade-off is the loop.

### 6.2 Substrate prices

Buying substrate from inventory:

| Type | Cost (nutrients) |
|---|---:|
| `leaf_litter`   |   3 |
| `wet_twig`      |   5 |
| `stump`         |  10 |
| `wet_duff`      |  12 |
| `birch_log`     |  25 |
| `elder_log`     |  25 |
| `hardwood_log`  |  40 |
| `oak_log`       |  80 |
| `oak_base`      | 100 |
| `hemlock_log`   | 120 |
| `wet_hardwood`  |  60 |
| `buried_log`    | 180 |
| `buried_root`   | 140 |
| `root_system`   | 250 |
| `conifer_duff`  |  35 |

### 6.3 Biome unlocks

```
OLD_GROWTH_SPORE_COST = 500
SWAMP_SPORE_COST      = 2_500
```


## 7. Tree partnership

When **Old Growth** unlocks, the player picks one host tree. The bond persists across all biomes and is permanent until prestige (post-v1).

| Host | Effect |
|---|---|
| Oak     | `tree_bond_mult = 1.20` on `oak_log` and `oak_base` substrates |
| Hemlock | `tree_bond_mult = 1.20` on `hemlock_log` and `conifer_duff` substrates |
| Birch   | `tree_bond_mult = 1.20` on `birch_log` substrates; `rarityWeight` doubled for `rare` species |
| Beech   | `tree_bond_mult = 1.10` on all substrates (no rare buff) |

Default `tree_bond_mult = 1.0` when no substrate match.

The four are intentionally not balanced for "max DPS" — Beech is the safe spread pick, Birch is the gamble, Oak/Hemlock are the focused builds.


## 8. Spore release events (post-v1, scaffolded)

A periodic global event (every ~7 real days) opens a 24-hour window where releasing fruit gives **2× spores**. This is a retention hook, not a v1.0 ship feature. Flag in code, disabled by default.


## 9. Catalog (Field Journal)

Whenever a species fruits for the first time in the player's save, it is added to the **catalog**. The catalog drives:
- Game Center achievements (cataloged N species)
- The Field Journal IAP unlock view
- Mori's "First {species}" dialogue triggers (see [MORI.md](MORI.md))

Catalog is a `Set<SpeciesID>` persisted to CloudKit.


## 10. Offline progress

On resume:
```
elapsed = now - lastSeenAt    // seconds
elapsed = min(elapsed, OFFLINE_CAP_SEC)

OFFLINE_CAP_SEC = 86_400      // 24 hours
```

If `elapsed < 30`: skip — just run live ticks.

Otherwise, simulate forward in **chunks of 60 seconds** to bound CPU:

```
chunkCount = elapsed / 60
remainder  = elapsed % 60

for chunkIdx in 0..<chunkCount:
    chunkStartTime = lastSeenAt + chunkIdx * 60
    simulateChunk(durationSec: 60, startTime: chunkStartTime)
simulateChunk(durationSec: remainder, startTime: lastSeenAt + chunkCount * 60)
```

`simulateChunk` collapses 60 seconds of substrate decay into a single delta and runs **one** fruit roll per node, with `roll_prob × 60` to compensate for not doing 60 micro-rolls. This is an acceptable fidelity loss for offline.

### 10.1 Night-only species offline
During each chunk, compute the phase from `chunkStartTime` in the player's local clock. Night-only species are eligible only in chunks whose phase is Night/Dusk. This means: a player gone overnight returns to a swamp full of glow; a player gone during the workday returns to common forest fruits.

### 10.2 Pending fruits
Fruits that "would have" appeared offline are not rendered live. They are queued as **pending fruits**, surfaced to the player on resume:

> *"While you were away: 4 Turkey Tail, 2 Witches' Butter, 1 Bitter Oyster, 1 Bleeding Tooth Fungus."*

The player can Harvest-All, Release-All, or step through individually for the dopamine.

### 10.3 Long-absence message
If `elapsed >= OFFLINE_CAP_SEC`, Mori delivers:
> *"Welcome back. The forest didn't notice."*

(see [MORI.md](MORI.md) §"When Mori speaks")


## 11. Persistence schema

State persisted to **CloudKit** (and `UserDefaults` as a write-ahead cache):

```swift
struct SaveState: Codable {
    var schemaVersion: Int            // bump on incompatible changes
    var lastSeenAt: Date
    var totalSpores: Int
    var totalReleased: Int            // lifetime, for achievements
    var cataloged: Set<SpeciesID>
    var unlockedBiomes: Set<BiomeID>
    var hostTree: HostTree?
    var nodes: [BiomeID: [NodeState]]
    var inventory: [SubstrateType: Int]
    var iapEntitlements: Set<IAPID>
    var settings: Settings
    var nextRainAt: Date
    var version: Int                  // optimistic-concurrency stamp
}
```

Save cadence:
- On any meaningful action (harvest, release, place, buy): immediately to UserDefaults; debounced (5 sec) push to CloudKit.
- On app background: full flush.
- On app launch: read CloudKit, fall back to UserDefaults if iCloud not yet available.

Conflict resolution: highest `version` wins. If CloudKit `version > local`, replace local. If equal, prefer local (it just wrote).


## 12. Master tunable table

All the numbers a designer touches, in one place. Mirror these as a single `Tunables` Swift struct so playtesting is one file edit.

```swift
struct Tunables {
    // Time
    static let tickHz: Double                = 1.0
    static let offlineCapSec: Int            = 86_400
    
    // Rain
    static let rainMeanIntervalSec: Int      = 21_600
    static let rainDurationSec: Int          =      900
    static let rainDecayMult: Float          = 2.0
    
    // Day/night (player local time)
    static let dawnStartHour: Int = 4
    static let dayStartHour:  Int = 6
    static let duskStartHour: Int = 18
    static let nightStartHour: Int = 20
    
    // Network
    static let nodeCap: Float                = 1000
    
    // Fruiting
    static let fruitThresholdMult: Float     = 10
    static let fruitRollBase: Float          = 1.0 / 60.0
    static let duskGraceMult: Float          = 2.0
    static let fruitAutoReleaseSec: Int      = 86_400
    
    // Currency
    static let harvestMult: Float            = 2.0
    
    // Biome decay
    static let decayMult: [BiomeID: Float]   = [
        .forestFloor: 1.0,
        .oldGrowth:   0.4,
        .swamp:       0.6,
    ]
    
    // Unlocks
    static let oldGrowthSporeCost: Int       = 500
    static let swampSporeCost: Int           = 2_500
    
    // Rarity weights
    static let rarityWeight: [Rarity: Float] = [
        .common:    1.00,
        .uncommon:  0.55,
        .rare:      0.20,
        .legendary: 0.05,
    ]
}
```


## 13. What this spec does NOT cover (intentionally)

- **Visual tween/animation timing** — that's UI work, not simulation.
- **Audio cues** — separate doc.
- **Tutorial / first-run experience** — separate doc.
- **Prestige system** — post-v1.
- **The Heartwood endgame** — post-v1.
- **Cave / Tundra biomes** — post-v1.

When in doubt, refer back to [DESIGN.md](DESIGN.md) for tone and intent.
