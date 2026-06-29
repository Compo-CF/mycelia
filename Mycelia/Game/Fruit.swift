import Foundation

struct Fruit: Codable, Identifiable, Hashable {
    let id: UUID
    let speciesId: String
    let fruitedAt: Date

    init(speciesId: String, now: Date = Date()) {
        self.id = UUID()
        self.speciesId = speciesId
        self.fruitedAt = now
    }

    func hasAutoReleased(now: Date) -> Bool {
        now.timeIntervalSince(fruitedAt) >= Double(Tunables.fruitAutoReleaseSec)
    }
}

/// A fruit that ripened while the player was away.
struct PendingFruit: Codable, Identifiable, Hashable {
    let id: UUID
    let speciesId: String
    let nodeId: String
    let ripenedAt: Date

    init(speciesId: String, nodeId: String, ripenedAt: Date) {
        self.id = UUID()
        self.speciesId = speciesId
        self.nodeId = nodeId
        self.ripenedAt = ripenedAt
    }
}
