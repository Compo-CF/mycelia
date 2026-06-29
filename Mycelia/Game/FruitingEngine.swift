import Foundation

/// Pure functions that decide whether a node fruits this tick, and with what species.
enum FruitingEngine {

    struct Roll {
        let fruit: Fruit
        let nutrientCost: Float
    }

    /// Species that meet biome, substrate, phase, and nutrient threshold conditions.
    static func eligible(
        for node: Node,
        biome: Biome,
        species: [Species],
        phase: GamePhase
    ) -> [Species] {
        let occupied = node.occupiedSubstrateTypes
        return species.filter { s in
            guard s.biome == biome else { return false }
            guard occupied.contains(s.substrate) else { return false }
            if s.nightOnly {
                if phase == .night { /* normal threshold below */ }
                else if phase == .dusk {
                    // Dusk grace: only eligible if nutrients are deeply primed.
                    let needed = Float(s.yieldNutrients)
                        * Tunables.fruitThresholdMult
                        * Tunables.duskGraceMult
                    return node.nutrients >= needed
                } else {
                    return false
                }
            }
            let threshold = Float(s.yieldNutrients) * Tunables.fruitThresholdMult
            return node.nutrients >= threshold
        }
    }

    /// Returns a roll if a species fruits at the node this tick, else nil.
    /// Iterates eligible species in ascending threshold order (cheapest first).
    static func roll(
        node: Node,
        biome: Biome,
        species: [Species],
        phase: GamePhase,
        hostTree: HostTree?,
        dtSeconds: Float,
        random: () -> Float = { Float.random(in: 0..<1) }
    ) -> Roll? {
        let candidates = eligible(for: node, biome: biome, species: species, phase: phase)
            .sorted {
                Float($0.yieldNutrients) * Tunables.fruitThresholdMult
                <
                Float($1.yieldNutrients) * Tunables.fruitThresholdMult
            }

        for s in candidates {
            // fruit_time_minutes IS the expected wait once eligible.
            // Rarity intentionally not applied here — see Tunables note.
            let treeBoost = hostTree?.rarityWeightMult(for: s.rarity) ?? 1.0
            let perSecond = (Tunables.fruitRollBase / Float(s.fruitTimeMinutes))
                * treeBoost
            let prob = perSecond * dtSeconds
            if random() < prob {
                let cost = Float(s.yieldNutrients) * Tunables.fruitThresholdMult
                return Roll(fruit: Fruit(speciesId: s.id), nutrientCost: cost)
            }
        }
        return nil
    }
}
