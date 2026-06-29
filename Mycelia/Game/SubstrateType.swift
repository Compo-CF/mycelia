import Foundation

enum SubstrateType: String, Codable, CaseIterable, Identifiable {
    case leafLitter    = "leaf_litter"
    case wetTwig       = "wet_twig"
    case stump         = "stump"
    case wetDuff       = "wet_duff"
    case birchLog      = "birch_log"
    case elderLog      = "elder_log"
    case hardwoodLog   = "hardwood_log"
    case oakLog        = "oak_log"
    case oakBase       = "oak_base"
    case hemlockLog    = "hemlock_log"
    case wetHardwood   = "wet_hardwood"
    case buriedLog     = "buried_log"
    case buriedRoot    = "buried_root"
    case rootSystem    = "root_system"
    case coniferDuff   = "conifer_duff"

    var id: String { rawValue }

    var displayName: String {
        rawValue.replacingOccurrences(of: "_", with: " ").capitalized
    }

    /// Tunable starting energy reservoir for this substrate type.
    var totalEnergy: Float {
        switch self {
        case .leafLitter:   return   100
        case .wetTwig:      return   150
        case .stump:        return   300
        case .wetDuff:      return   400
        case .birchLog:     return   600
        case .elderLog:     return   600
        case .hardwoodLog:  return   800
        case .oakLog:       return 1_200
        case .oakBase:      return 1_200
        case .hemlockLog:   return 1_500
        case .wetHardwood:  return 1_000
        case .buriedLog:    return 1_800
        case .buriedRoot:   return 1_400
        case .rootSystem:   return 2_000
        case .coniferDuff:  return   600
        }
    }

    /// Tunable base decay rate per second.
    var baseDecayPerSec: Float {
        switch self {
        case .leafLitter:   return 0.50
        case .wetTwig:      return 0.45
        case .stump:        return 0.30
        case .wetDuff:      return 0.35
        case .birchLog:     return 0.20
        case .elderLog:     return 0.20
        case .hardwoodLog:  return 0.20
        case .oakLog:       return 0.18
        case .oakBase:      return 0.18
        case .hemlockLog:   return 0.15
        case .wetHardwood:  return 0.25
        case .buriedLog:    return 0.12
        case .buriedRoot:   return 0.13
        case .rootSystem:   return 0.10
        case .coniferDuff:  return 0.20
        }
    }

    /// Tunable price in nutrients to buy one of this substrate from inventory.
    var priceNutrients: Int {
        switch self {
        case .leafLitter:   return   3
        case .wetTwig:      return   5
        case .stump:        return  10
        case .wetDuff:      return  12
        case .birchLog:     return  25
        case .elderLog:     return  25
        case .hardwoodLog:  return  40
        case .oakLog:       return  80
        case .oakBase:      return 100
        case .hemlockLog:   return 120
        case .wetHardwood:  return  60
        case .buriedLog:    return 180
        case .buriedRoot:   return 140
        case .rootSystem:   return 250
        case .coniferDuff:  return  35
        }
    }
}
