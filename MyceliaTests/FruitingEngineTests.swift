import XCTest
@testable import Mycelia

final class FruitingEngineTests: XCTestCase {

    private lazy var allSpecies = SpeciesLoader.loadAll()

    private func nodeWith(substrate: SubstrateType, nutrients: Float = 0) -> Node {
        var node = Node(id: "test", slotsCount: 3)
        node.slots[0].substrate = Substrate(type: substrate)
        node.nutrients = nutrients
        return node
    }

    func testEmptyNode_yieldsNothingEligible() {
        let node = Node(id: "test", slotsCount: 3)
        let eligible = FruitingEngine.eligible(
            for: node, biome: .forestFloor, species: allSpecies, phase: .day
        )
        XCTAssertTrue(eligible.isEmpty)
    }

    func testBelowThreshold_yieldsNothingEligible() {
        let node = nodeWith(substrate: .leafLitter, nutrients: 0)
        let eligible = FruitingEngine.eligible(
            for: node, biome: .forestFloor, species: allSpecies, phase: .day
        )
        XCTAssertTrue(eligible.isEmpty)
    }

    func testAboveThreshold_matchingSubstrateBecomesEligible() {
        let node = nodeWith(substrate: .leafLitter, nutrients: 999)
        let eligible = FruitingEngine.eligible(
            for: node, biome: .forestFloor, species: allSpecies, phase: .day
        )
        XCTAssertEqual(eligible.map { $0.id }, ["common_stinkhorn"])
    }

    func testNightOnly_excludedDuringDay() {
        let node = nodeWith(substrate: .wetHardwood, nutrients: 999)
        let eligible = FruitingEngine.eligible(
            for: node, biome: .swamp, species: allSpecies, phase: .day
        )
        XCTAssertFalse(eligible.contains { $0.id == "bitter_oyster" })
        XCTAssertTrue(eligible.contains { $0.id == "witches_butter" })
    }

    func testNightOnly_eligibleAtNight() {
        let node = nodeWith(substrate: .wetHardwood, nutrients: 999)
        let eligible = FruitingEngine.eligible(
            for: node, biome: .swamp, species: allSpecies, phase: .night
        )
        XCTAssertTrue(eligible.contains { $0.id == "bitter_oyster" })
    }

    func testDuskGrace_requiresDoubleThreshold() {
        // Bitter Oyster: yield 8 → threshold 80 → dusk needs 160
        let belowGrace = nodeWith(substrate: .wetHardwood, nutrients: 100)
        XCTAssertFalse(
            FruitingEngine.eligible(for: belowGrace, biome: .swamp, species: allSpecies, phase: .dusk)
                .contains { $0.id == "bitter_oyster" }
        )

        let atGrace = nodeWith(substrate: .wetHardwood, nutrients: 200)
        XCTAssertTrue(
            FruitingEngine.eligible(for: atGrace, biome: .swamp, species: allSpecies, phase: .dusk)
                .contains { $0.id == "bitter_oyster" }
        )
    }

    func testRoll_zeroRandom_alwaysFruits() {
        let node = nodeWith(substrate: .leafLitter, nutrients: 999)
        let roll = FruitingEngine.roll(
            node: node, biome: .forestFloor, species: allSpecies,
            phase: .day, hostTree: nil, dtSeconds: 1.0,
            random: { 0.0 }
        )
        XCTAssertEqual(roll?.fruit.speciesId, "common_stinkhorn")
    }

    func testRoll_oneRandom_neverFruits() {
        let node = nodeWith(substrate: .leafLitter, nutrients: 999)
        let roll = FruitingEngine.roll(
            node: node, biome: .forestFloor, species: allSpecies,
            phase: .day, hostTree: nil, dtSeconds: 1.0,
            random: { 0.999 }
        )
        XCTAssertNil(roll)
    }
}
