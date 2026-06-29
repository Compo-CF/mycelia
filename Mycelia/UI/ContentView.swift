import SwiftUI

struct ContentView: View {
    @Environment(GameState.self) private var game

    var body: some View {
        TabView {
            ForestView()
                .tabItem { Label("Forest", systemImage: "leaf") }

            JournalView(species: game.species)
                .tabItem { Label("Journal", systemImage: "book.closed") }
        }
    }
}

#Preview {
    ContentView()
        .environment(GameState(species: SpeciesLoader.loadAll()))
}
