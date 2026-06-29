import Foundation

enum HostTree: String, Codable, CaseIterable, Identifiable {
    case oak, hemlock, birch, beech

    var id: String { rawValue }
    var displayName: String { rawValue.capitalized }

    /// Multiplier on the substrate's decay yield when this host is bonded.
    func bondMult(for substrate: SubstrateType) -> Float {
        switch self {
        case .oak:
            return (substrate == .oakLog || substrate == .oakBase) ? 1.20 : 1.0
        case .hemlock:
            return (substrate == .hemlockLog || substrate == .coniferDuff) ? 1.20 : 1.0
        case .birch:
            return (substrate == .birchLog) ? 1.20 : 1.0
        case .beech:
            return 1.10
        }
    }

    /// Rarity weight boost applied at fruit-roll time. Birch gambles on rare.
    func rarityWeightMult(for rarity: Rarity) -> Float {
        switch (self, rarity) {
        case (.birch, .rare): return 2.0
        default:              return 1.0
        }
    }
}
