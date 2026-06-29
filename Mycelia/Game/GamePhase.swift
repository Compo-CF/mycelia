import Foundation

enum GamePhase: String, Codable {
    case dawn, day, dusk, night

    static func forDate(_ date: Date, calendar: Calendar = .current) -> GamePhase {
        let h = calendar.component(.hour, from: date)
        return forHour(h)
    }

    static func forHour(_ hour: Int) -> GamePhase {
        if hour >= Tunables.nightStartHour || hour < Tunables.dawnStartHour {
            return .night
        }
        if hour < Tunables.dayStartHour   { return .dawn }
        if hour < Tunables.duskStartHour  { return .day }
        return .dusk
    }

    var displayName: String { rawValue.capitalized }

    /// Whether a night_only species may fruit now (Night, or Dusk via grace check at call site).
    var isNightish: Bool { self == .night || self == .dusk }
}
