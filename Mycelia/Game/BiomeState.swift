import Foundation

struct BiomeState: Codable, Hashable {
    let biome: Biome
    var nodes: [Node]

    init(biome: Biome) {
        self.biome = biome
        let topo = Tunables.topology[biome] ?? (3, 3)
        self.nodes = (0..<topo.nodes).map { i in
            Node(id: "\(biome.rawValue)-\(i)", slotsCount: topo.slots)
        }
    }
}
