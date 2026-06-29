import Foundation

struct Substrate: Codable, Identifiable, Hashable {
    let id: UUID
    let type: SubstrateType
    var energyRemaining: Float
    let placedAt: Date

    init(type: SubstrateType, now: Date = Date()) {
        self.id = UUID()
        self.type = type
        self.energyRemaining = type.totalEnergy
        self.placedAt = now
    }

    var isSpent: Bool { energyRemaining <= 0 }
}
