import SwiftUI

struct ForestView: View {
    @Environment(GameState.self) private var game

    var body: some View {
        ZStack {
            Color.hollowBlack.ignoresSafeArea()

            VStack(spacing: 0) {
                topHUD
                    .padding(.top, 8)
                    .padding(.horizontal, 20)

                Spacer()

                centerScene
                    .padding(.horizontal, 24)

                Spacer()

                bottomHUD
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
            }

            VStack {
                Spacer()
                HStack {
                    MoriView(state: moriState, size: 64)
                        .padding(.leading, 16)
                        .padding(.bottom, 110)
                    Spacer()
                }
            }
        }
    }

    private var firstNode: Node? {
        game.biomes[.forestFloor]?.nodes.first
    }

    private var moriState: MoriState {
        if game.rainActive { return .listening }
        if firstNode?.currentFruit != nil { return .pleased }
        return .watching
    }

    // MARK: - Top HUD

    private var topHUD: some View {
        HStack {
            Text(topLeftLabel)
                .font(.specimen(11))
                .tracking(2.2)
                .foregroundStyle(Color.oldLeaf)
            Spacer()
            Text("▲ \(game.totalSpores) SPORES")
                .font(.specimen(11))
                .tracking(2.2)
                .foregroundStyle(Color.sporeDust)
                .monospacedDigit()
        }
    }

    private var topLeftLabel: String {
        var s = "FOREST FLOOR · \(game.phase.displayName.uppercased())"
        if game.rainActive { s += " · RAIN" }
        return s
    }

    // MARK: - Center scene

    private var centerScene: some View {
        VStack(spacing: 22) {
            Button(action: { _ = game.place(.leafLitter, in: .forestFloor, nodeIdx: 0) }) {
                ZStack {
                    Capsule()
                        .fill(LinearGradient(
                            colors: [Color.dampBark,
                                     Color(red: 0x2A/255, green: 0x1F/255, blue: 0x18/255)],
                            startPoint: .top, endPoint: .bottom))
                        .frame(width: 260, height: 36)
                        .overlay(Capsule().stroke(Color.lichen, lineWidth: 0.5))

                    if let node = firstNode, node.currentFruit != nil {
                        Circle()
                            .fill(RadialGradient(
                                colors: [Color.foxfireTeal.opacity(0.45), .clear],
                                center: .center, startRadius: 0, endRadius: 60))
                            .frame(width: 120, height: 120)
                            .offset(y: -24)
                    }
                }
            }
            .buttonStyle(.plain)

            if let node = firstNode {
                nodeStats(node)
            }
        }
    }

    @ViewBuilder
    private func nodeStats(_ node: Node) -> some View {
        let count = node.substrates.count
        let cap = node.slots.count
        let nutrients = Int(node.nutrients)
        let fruitSpecies = node.currentFruit.flatMap { game.species(byId: $0.speciesId) }

        VStack(spacing: 10) {
            Text("\(count)/\(cap) SUBSTRATES · \(nutrients) NUTRIENTS")
                .font(.specimen(10))
                .tracking(1.8)
                .foregroundStyle(Color.oldLeaf)
                .monospacedDigit()

            if let s = fruitSpecies {
                VStack(spacing: 14) {
                    Text(s.commonName)
                        .font(.display(24))
                        .foregroundStyle(Color.sporeDust)
                    Text(s.scientificName)
                        .font(.display(13))
                        .foregroundStyle(Color.oldLeaf)
                    HStack(spacing: 14) {
                        Button { game.harvest(biome: .forestFloor, nodeIdx: 0) } label: {
                            Text("HARVEST")
                                .font(.specimen(11))
                                .tracking(2.4)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                        }
                        .tint(.oldLeaf)
                        .buttonStyle(.bordered)

                        Button { game.release(biome: .forestFloor, nodeIdx: 0) } label: {
                            Text("RELEASE")
                                .font(.specimen(11))
                                .tracking(2.4)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                        }
                        .tint(.foxfireTeal)
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.top, 4)
                }
                .padding(.top, 6)
            } else {
                Text("—")
                    .font(.display(20))
                    .foregroundStyle(Color.oldLeaf.opacity(0.5))
                    .padding(.top, 4)
            }
        }
    }

    // MARK: - Bottom HUD

    private var bottomHUD: some View {
        HStack {
            Text("BANK \(Int(game.nutrientsBank)) ƒ")
                .font(.specimen(10))
                .tracking(1.6)
                .foregroundStyle(Color.oldLeaf)
                .monospacedDigit()
            Spacer()
            Text("LEAF \(game.inventory[.leafLitter, default: 0]) · STUMP \(game.inventory[.stump, default: 0]) · LOG \(game.inventory[.hardwoodLog, default: 0])")
                .font(.specimen(10))
                .tracking(1.4)
                .foregroundStyle(Color.oldLeaf)
                .monospacedDigit()
        }
    }
}

#Preview {
    ForestView()
        .environment(GameState(species: SpeciesLoader.loadAll()))
}
