import Foundation
import Observation

@MainActor
@Observable
final class GameState {
    // Persistent
    var totalSpores: Int = 0
    var totalReleased: Int = 0
    var cataloged: Set<String> = []
    var unlockedBiomes: Set<Biome> = [.forestFloor]
    var hostTree: HostTree? = nil
    var biomes: [Biome: BiomeState] = [:]
    var inventory: [SubstrateType: Int] = [:]
    var nutrientsBank: Float = 0
    var nextRainAt: Date
    var rainEndsAt: Date?
    var lastSeenAt: Date

    // Transient (recomputed each tick)
    var phase: GamePhase

    // Catalog of species, indexed for lookups
    let species: [Species]
    private let speciesById: [String: Species]

    init(species: [Species], now: Date = Date()) {
        self.species = species
        self.speciesById = Dictionary(uniqueKeysWithValues: species.map { ($0.id, $0) })
        self.lastSeenAt = now
        self.phase = GamePhase.forDate(now)
        self.nextRainAt = now.addingTimeInterval(.random(in: 0..<Double(Tunables.rainMeanIntervalSec * 2)))
        self.biomes[.forestFloor] = BiomeState(biome: .forestFloor)
        // Seed starting inventory so the player can place something on first run
        self.inventory[.leafLitter] = 20
        self.inventory[.stump] = 5
        self.inventory[.hardwoodLog] = 2
    }

    var rainActive: Bool { rainEndsAt != nil }

    // MARK: - Tick

    func tick(now: Date = Date()) {
        let dt = Float(now.timeIntervalSince(lastSeenAt))
        guard dt > 0 else { return }
        lastSeenAt = now
        phase = GamePhase.forDate(now)
        updateRain(now: now)
        // Cap dt for live ticks; offline catch-up is handled separately.
        let stepDt = min(dt, 5)
        for biome in unlockedBiomes {
            tickBiome(biome, dt: stepDt, now: now)
        }
    }

    private func updateRain(now: Date) {
        if let end = rainEndsAt {
            if now >= end {
                rainEndsAt = nil
                nextRainAt = now.addingTimeInterval(.random(in: 0..<Double(Tunables.rainMeanIntervalSec * 2)))
            }
        } else if now >= nextRainAt {
            rainEndsAt = now.addingTimeInterval(TimeInterval(Tunables.rainDurationSec))
        }
    }

    private func tickBiome(_ biome: Biome, dt: Float, now: Date) {
        guard var state = biomes[biome] else { return }
        let biomeMult = Tunables.decayMult[biome] ?? 1.0
        let rainMult: Float = rainActive ? Tunables.rainDecayMult : 1.0

        for i in state.nodes.indices {
            var node = state.nodes[i]

            // Decay substrates → accumulate nutrients
            for j in node.slots.indices {
                guard var s = node.slots[j].substrate else { continue }
                let treeMult = hostTree?.bondMult(for: s.type) ?? 1.0
                let delta = s.type.baseDecayPerSec * biomeMult * rainMult * treeMult * dt
                s.energyRemaining -= delta
                node.nutrients = min(Tunables.nodeCap, node.nutrients + delta)
                node.slots[j].substrate = s.isSpent ? nil : s
            }

            // Try to fruit if vacant
            if node.currentFruit == nil {
                if let r = FruitingEngine.roll(
                    node: node, biome: biome, species: species,
                    phase: phase, hostTree: hostTree, dtSeconds: dt
                ) {
                    node.currentFruit = r.fruit
                    node.nutrients = max(0, node.nutrients - r.nutrientCost)
                    cataloged.insert(r.fruit.speciesId)
                }
            } else if let fruit = node.currentFruit, fruit.hasAutoReleased(now: now) {
                // Auto-release: spores credited but no celebration.
                if let sp = speciesById[fruit.speciesId] {
                    totalSpores += sp.yieldSpores
                    totalReleased += 1
                }
                node.currentFruit = nil
            }

            state.nodes[i] = node
        }

        biomes[biome] = state
    }

    // MARK: - Player actions

    func place(_ type: SubstrateType, in biome: Biome, nodeIdx: Int) -> Bool {
        guard inventory[type, default: 0] > 0,
              var state = biomes[biome],
              state.nodes.indices.contains(nodeIdx),
              let slotIdx = state.nodes[nodeIdx].slots.firstIndex(where: { $0.isEmpty })
        else { return false }
        state.nodes[nodeIdx].slots[slotIdx].substrate = Substrate(type: type)
        biomes[biome] = state
        inventory[type, default: 0] -= 1
        return true
    }

    func buy(_ type: SubstrateType) -> Bool {
        let price = Float(type.priceNutrients)
        guard nutrientsBank >= price else { return false }
        nutrientsBank -= price
        inventory[type, default: 0] += 1
        return true
    }

    @discardableResult
    func harvest(biome: Biome, nodeIdx: Int) -> Bool {
        guard var state = biomes[biome],
              state.nodes.indices.contains(nodeIdx),
              let fruit = state.nodes[nodeIdx].currentFruit,
              let sp = speciesById[fruit.speciesId]
        else { return false }
        nutrientsBank += Float(sp.yieldNutrients) * Tunables.harvestMult
        state.nodes[nodeIdx].currentFruit = nil
        biomes[biome] = state
        return true
    }

    @discardableResult
    func release(biome: Biome, nodeIdx: Int) -> Bool {
        guard var state = biomes[biome],
              state.nodes.indices.contains(nodeIdx),
              let fruit = state.nodes[nodeIdx].currentFruit,
              let sp = speciesById[fruit.speciesId]
        else { return false }
        totalSpores += sp.yieldSpores
        totalReleased += 1
        state.nodes[nodeIdx].currentFruit = nil
        biomes[biome] = state
        return true
    }

    func species(byId id: String) -> Species? {
        speciesById[id]
    }
}
