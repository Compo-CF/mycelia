import SwiftUI

struct ForestView: View {
    @Environment(GameState.self) private var game

    @State private var selectedSubstrate: SubstrateType = .hardwoodLog
    @State private var moriOffset: CGSize = .zero
    @State private var moriLean: Double = 0
    @State private var visibleHint: String?
    @State private var hintTask: Task<Void, Never>?

    @AppStorage("seen.intro")        private var seenIntro: Bool = false
    @AppStorage("seen.firstPlace")   private var seenFirstPlace: Bool = false
    @AppStorage("seen.firstFruit")   private var seenFirstFruit: Bool = false
    @AppStorage("seen.firstRelease") private var seenFirstRelease: Bool = false
    @AppStorage("seen.firstHarvest") private var seenFirstHarvest: Bool = false

    private let pickerTypes: [SubstrateType] = [.leafLitter, .stump, .hardwoodLog]

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

                bottomBar
                    .padding(.horizontal, 16)
                    .padding(.bottom, 90)
            }

            // Mori — drifts around the lower-left zone
            VStack {
                Spacer()
                HStack {
                    MoriView(state: moriState, size: 64)
                        .rotationEffect(.degrees(moriLean * 8), anchor: .bottom)
                        .offset(moriOffset)
                        .padding(.leading, 18)
                        .padding(.bottom, 130)
                    Spacer()
                }
            }
            .allowsHitTesting(false)

            // Hint text — floats above Mori, fades in/out
            ZStack {
                if let hint = visibleHint {
                    VStack {
                        Spacer()
                        HStack {
                            Text(hint)
                                .font(.display(17))
                                .foregroundStyle(Color.sporeDust)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: 240, alignment: .leading)
                                .padding(.leading, 28)
                                .padding(.bottom, 215)
                                .transition(.opacity)
                            Spacer()
                        }
                    }
                }
            }
            .animation(.easeInOut(duration: 0.8), value: visibleHint)
            .allowsHitTesting(false)
        }
        .task { await moriDriftLoop() }
        .onAppear {
            if !seenIntro {
                showHint("Place something. The forest will do the rest.")
                seenIntro = true
            }
        }
        .onChange(of: firstNode?.currentFruit?.id) { _, newId in
            if newId != nil && !seenFirstFruit {
                showHint("There. You've started something.")
                seenFirstFruit = true
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
            Button(action: placeAction) {
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
                        Button(action: harvestAction) {
                            Text("HARVEST")
                                .font(.specimen(11))
                                .tracking(2.4)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                        }
                        .tint(.oldLeaf)
                        .buttonStyle(.bordered)

                        Button(action: releaseAction) {
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

    // MARK: - Bottom bar (substrate picker + bank)

    private var bottomBar: some View {
        VStack(spacing: 12) {
            HStack {
                Spacer()
                Text("BANK \(Int(game.nutrientsBank)) ƒ")
                    .font(.specimen(10))
                    .tracking(1.6)
                    .foregroundStyle(Color.oldLeaf)
                    .monospacedDigit()
            }
            HStack(spacing: 10) {
                ForEach(pickerTypes) { type in
                    pickerPill(type)
                }
            }
        }
    }

    private func pickerPill(_ type: SubstrateType) -> some View {
        let count = game.inventory[type, default: 0]
        let isSelected = selectedSubstrate == type
        let available = count > 0

        return Button {
            selectedSubstrate = type
        } label: {
            HStack(spacing: 6) {
                Text(pickerLabel(type))
                    .font(.specimen(11))
                    .tracking(2.0)
                Text("\(count)")
                    .font(.specimen(11))
                    .monospacedDigit()
            }
            .foregroundStyle(
                isSelected ? Color.hollowBlack
                : (available ? Color.sporeDust : Color.oldLeaf.opacity(0.5))
            )
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(
                Capsule().fill(isSelected ? Color.foxfireTeal : Color.mossShadow)
            )
            .overlay(
                Capsule().stroke(
                    isSelected ? Color.foxfireTeal : Color.lichen,
                    lineWidth: 0.5
                )
            )
        }
        .buttonStyle(.plain)
    }

    private func pickerLabel(_ type: SubstrateType) -> String {
        switch type {
        case .leafLitter:  return "LEAF"
        case .stump:       return "STUMP"
        case .hardwoodLog: return "LOG"
        default:           return type.rawValue.uppercased()
        }
    }

    // MARK: - Actions

    private func placeAction() {
        let placed = game.place(selectedSubstrate, in: .forestFloor, nodeIdx: 0)
        guard placed else { return }
        if !seenFirstPlace {
            showHint("It's making something now.")
            seenFirstPlace = true
        }
    }

    private func harvestAction() {
        game.harvest(biome: .forestFloor, nodeIdx: 0)
        if !seenFirstHarvest {
            showHint("Nutrients keep. You can put them back into the soil.")
            seenFirstHarvest = true
        }
    }

    private func releaseAction() {
        game.release(biome: .forestFloor, nodeIdx: 0)
        if !seenFirstRelease {
            showHint("Spores carry. Spend them when there's somewhere to go.")
            seenFirstRelease = true
        }
    }

    private func showHint(_ text: String) {
        hintTask?.cancel()
        withAnimation(.easeInOut(duration: 0.8)) {
            visibleHint = text
        }
        hintTask = Task { @MainActor in
            try? await Task.sleep(for: .seconds(7))
            guard !Task.isCancelled else { return }
            withAnimation(.easeInOut(duration: 0.8)) {
                visibleHint = nil
            }
        }
    }

    // MARK: - Mori drift

    @MainActor
    private func moriDriftLoop() async {
        // Initial pause so Mori doesn't move before the player sees him.
        try? await Task.sleep(for: .seconds(.random(in: 6...12)))
        while !Task.isCancelled {
            let nextX = Double.random(in: 0...90)
            let nextY = Double.random(in: -8...18)
            let leanDir: Double = nextX >= moriOffset.width ? 1 : -1
            let moveDuration = Double.random(in: 10...14)

            withAnimation(.easeInOut(duration: 1.2)) {
                moriLean = leanDir
            }
            withAnimation(.easeInOut(duration: moveDuration)) {
                moriOffset = CGSize(width: nextX, height: nextY)
            }
            try? await Task.sleep(for: .seconds(moveDuration))
            withAnimation(.easeInOut(duration: 0.9)) {
                moriLean = 0
            }
            try? await Task.sleep(for: .seconds(.random(in: 8...18)))
        }
    }
}

#Preview {
    ForestView()
        .environment(GameState(species: SpeciesLoader.loadAll()))
}
