import SwiftUI

@main
struct MyceliaApp: App {
    @State private var gameState = GameState(species: SpeciesLoader.loadAll())
    @State private var clock = GameClock()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(gameState)
                .preferredColorScheme(.dark)
                .tint(.foxfireTeal)
                .onAppear { clock.start(driving: gameState) }
                .onDisappear { clock.stop() }
        }
    }
}
