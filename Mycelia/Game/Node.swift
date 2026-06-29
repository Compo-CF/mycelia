import Foundation

struct Slot: Codable, Identifiable, Hashable {
    let id: UUID
    var substrate: Substrate?

    init() {
        self.id = UUID()
        self.substrate = nil
    }

    var isEmpty: Bool { substrate == nil }
}

struct Node: Codable, Identifiable, Hashable {
    let id: String
    var slots: [Slot]
    var nutrients: Float
    var currentFruit: Fruit?

    init(id: String, slotsCount: Int) {
        self.id = id
        self.slots = (0..<slotsCount).map { _ in Slot() }
        self.nutrients = 0
        self.currentFruit = nil
    }

    var substrates: [Substrate] {
        slots.compactMap { $0.substrate }
    }

    var occupiedSubstrateTypes: Set<SubstrateType> {
        Set(substrates.map { $0.type })
    }

    var hasFreeSlot: Bool {
        slots.contains(where: { $0.isEmpty })
    }
}
