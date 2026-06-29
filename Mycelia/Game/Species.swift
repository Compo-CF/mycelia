import Foundation

enum Biome: String, Codable, CaseIterable, Identifiable {
    case forestFloor = "forest_floor"
    case oldGrowth   = "old_growth"
    case swamp       = "swamp"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .forestFloor: return "Forest Floor"
        case .oldGrowth:   return "Old Growth"
        case .swamp:       return "Swamp"
        }
    }
}

enum Rarity: String, Codable, CaseIterable {
    case common, uncommon, rare, legendary

    var displayName: String { rawValue.capitalized }
}

struct Species: Codable, Identifiable, Hashable {
    let id: String
    let commonName: String
    let scientificName: String
    let biome: Biome
    let substrate: String
    let rarity: Rarity
    let fruitTimeMinutes: Int
    let bioluminescent: Bool
    let nightOnly: Bool
    let yieldNutrients: Int
    let yieldSpores: Int
    let lore: String

    enum CodingKeys: String, CodingKey {
        case id
        case commonName       = "common_name"
        case scientificName   = "scientific_name"
        case biome
        case substrate
        case rarity
        case fruitTimeMinutes = "fruit_time_minutes"
        case bioluminescent
        case nightOnly        = "night_only"
        case yieldNutrients   = "yield_nutrients"
        case yieldSpores      = "yield_spores"
        case lore
    }
}

struct SpeciesCatalog: Codable {
    let species: [Species]
}
