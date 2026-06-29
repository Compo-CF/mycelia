import Foundation

enum SpeciesLoader {
    static func loadAll() -> [Species] {
        guard let url = Bundle.main.url(forResource: "SPECIES", withExtension: "json") else {
            assertionFailure("SPECIES.json missing from bundle")
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            let catalog = try JSONDecoder().decode(SpeciesCatalog.self, from: data)
            return catalog.species
        } catch {
            assertionFailure("SPECIES.json decode failed: \(error)")
            return []
        }
    }
}
