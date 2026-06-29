import XCTest
@testable import Mycelia

final class SpeciesLoaderTests: XCTestCase {
    func testLoadsAllSpecies() {
        let all = SpeciesLoader.loadAll()
        XCTAssertEqual(all.count, 20, "v1 ships with 20 species")
    }

    func testBiomeDistribution() {
        let all = SpeciesLoader.loadAll()
        XCTAssertEqual(all.filter { $0.biome == .forestFloor }.count, 8)
        XCTAssertEqual(all.filter { $0.biome == .oldGrowth   }.count, 6)
        XCTAssertEqual(all.filter { $0.biome == .swamp       }.count, 6)
    }

    func testBioluminescentAreNightOnly() {
        for s in SpeciesLoader.loadAll() where s.bioluminescent {
            XCTAssertTrue(s.nightOnly, "\(s.commonName) glows but is not night_only")
        }
    }
}
