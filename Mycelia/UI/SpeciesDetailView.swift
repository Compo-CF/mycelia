import SwiftUI

struct SpeciesDetailView: View {
    let species: Species

    var body: some View {
        ZStack {
            Color.hollowBlack.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text(species.commonName)
                        .font(.display(40))
                        .foregroundStyle(Color.sporeDust)
                        .padding(.top, 16)

                    Text("\(species.scientificName) · \(species.biome.displayName)")
                        .font(.display(15))
                        .foregroundStyle(Color.oldLeaf)
                        .padding(.top, 4)
                        .padding(.bottom, 28)

                    Text(species.lore)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(Color.sporeDust)
                        .lineSpacing(4)
                        .padding(.bottom, 32)

                    statsBlock
                }
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .toolbarBackground(Color.hollowBlack, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    private var statsBlock: some View {
        VStack(spacing: 0) {
            Rectangle().fill(Color.lichen).frame(height: 1)
            statsGrid
            Rectangle().fill(Color.lichen).frame(height: 1)
        }
    }

    private var statsGrid: some View {
        let cols = [GridItem(.flexible()), GridItem(.flexible())]
        return LazyVGrid(columns: cols, spacing: 18) {
            stat(label: "Substrate", value: species.substrate.replacingOccurrences(of: "_", with: " "))
            stat(label: "Rarity",    value: species.rarity.displayName)
            stat(label: "Fruit time", value: "\(species.fruitTimeMinutes) min")
            stat(label: "Spores",     value: "+\(species.yieldSpores)")
            stat(label: "Nutrients",  value: "+\(species.yieldNutrients)")
            stat(label: "Phase", value: species.nightOnly ? "Night only" : "Anytime")
        }
        .padding(.vertical, 22)
    }

    private func stat(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label.uppercased())
                .font(.specimen(10))
                .tracking(1.8)
                .foregroundStyle(Color.oldLeaf)
            Text(value)
                .font(.system(size: 14, weight: .regular, design: .monospaced))
                .foregroundStyle(species.bioluminescent && label == "Phase" ? Color.foxfireTeal : Color.sporeDust)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    NavigationStack {
        SpeciesDetailView(species: SpeciesLoader.loadAll().first { $0.id == "bitter_oyster" }!)
    }
}
