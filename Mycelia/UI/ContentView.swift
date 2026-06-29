import SwiftUI

struct ContentView: View {
    @State private var species: [Species] = []

    var body: some View {
        TabView {
            ForestView()
                .tabItem {
                    Label("Forest", systemImage: "leaf")
                }

            JournalView(species: species)
                .tabItem {
                    Label("Journal", systemImage: "book.closed")
                }
        }
        .task {
            species = SpeciesLoader.loadAll()
        }
    }
}

#Preview {
    ContentView()
}
