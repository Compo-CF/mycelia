import Foundation

enum Tunables {
    // Time
    static let tickHz: Double           = 1.0
    static let offlineCapSec: Int       = 86_400

    // Rain
    static let rainMeanIntervalSec: Int = 21_600
    static let rainDurationSec: Int     =    900
    static let rainDecayMult: Float     = 2.0

    // Day / night (player local hours)
    static let dawnStartHour:  Int = 4
    static let dayStartHour:   Int = 6
    static let duskStartHour:  Int = 18
    static let nightStartHour: Int = 20

    // Network
    static let nodeCap: Float           = 1000

    // Fruiting
    // Threshold mult was 10; lowered to 4 so common species become eligible
    // within ~30-90 seconds of placing a single substrate. Tunable.
    static let fruitThresholdMult: Float = 4
    // fruit_time_minutes is the expected wait once eligible. Roll prob per
    // second is dt / (fruit_time_min * 60). rarityWeight is intentionally
    // NOT applied at roll time — it was double-counting with fruit_time and
    // making legendaries take 20+ days. Rarity influence emerges from
    // substrate/biome/threshold gating instead.
    static let fruitRollBase: Float      = 1.0 / 60.0
    static let duskGraceMult: Float      = 2.0
    static let fruitAutoReleaseSec: Int  = 86_400

    // Currency
    static let harvestMult: Float        = 2.0

    // Biome decay multipliers
    static let decayMult: [Biome: Float] = [
        .forestFloor: 1.0,
        .oldGrowth:   0.4,
        .swamp:       0.6,
    ]

    // Biome topology (nodes × slots per biome)
    static let topology: [Biome: (nodes: Int, slots: Int)] = [
        .forestFloor: (3, 3),
        .oldGrowth:   (4, 4),
        .swamp:       (4, 3),
    ]

    // Unlocks
    static let oldGrowthSporeCost: Int = 500
    static let swampSporeCost: Int     = 2_500

    // Rarity weights for fruit rolls (higher = more likely)
    static let rarityWeight: [Rarity: Float] = [
        .common:    1.00,
        .uncommon:  0.55,
        .rare:      0.20,
        .legendary: 0.05,
    ]
}
