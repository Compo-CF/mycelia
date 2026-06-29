import SwiftUI

struct JournalView: View {
    let species: [Species]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.hollowBlack.ignoresSafeArea()

                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(Biome.allCases) { biome in
                            let bucket = species.filter { $0.biome == biome }
                            if !bucket.isEmpty {
                                BiomeSectionHeader(biome: biome, count: bucket.count)
                                ForEach(bucket) { s in
                                    NavigationLink(value: s) {
                                        SpeciesRow(species: s)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Field Journal")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color.hollowBlack, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationDestination(for: Species.self) { s in
                SpeciesDetailView(species: s)
            }
        }
    }
}

private struct BiomeSectionHeader: View {
    let biome: Biome
    let count: Int

    var body: some View {
        HStack {
            Text(biome.displayName.uppercased())
                .font(.specimen(11))
                .tracking(2.4)
                .foregroundStyle(Color.oldLeaf)
            Rectangle().fill(Color.lichen).frame(height: 1)
            Text("\(count)")
                .font(.specimen(11))
                .tracking(2.4)
                .foregroundStyle(Color.oldLeaf)
        }
        .padding(.horizontal, 20)
        .padding(.top, 32)
        .padding(.bottom, 14)
    }
}

private struct SpeciesRow: View {
    let species: Species

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .firstTextBaseline) {
                Text(species.commonName)
                    .font(.display(22))
                    .foregroundStyle(Color.sporeDust)
                Spacer()
                if species.bioluminescent {
                    Circle()
                        .fill(Color.foxfireTeal)
                        .frame(width: 6, height: 6)
                        .shadow(color: Color.foxfireTeal.opacity(0.7), radius: 4)
                }
            }
            Text(species.scientificName)
                .font(.display(13))
                .foregroundStyle(Color.oldLeaf)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .overlay(
            Rectangle().fill(Color.lichen).frame(height: 1),
            alignment: .bottom
        )
    }
}

#Preview {
    JournalView(species: SpeciesLoader.loadAll())
}
