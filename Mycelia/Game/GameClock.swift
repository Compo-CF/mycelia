import Foundation

@MainActor
final class GameClock {
    private var task: Task<Void, Never>?

    func start(driving state: GameState) {
        stop()
        let intervalNanos = UInt64(1_000_000_000.0 / Tunables.tickHz)
        task = Task { [weak state] in
            while !Task.isCancelled {
                state?.tick()
                try? await Task.sleep(nanoseconds: intervalNanos)
            }
        }
    }

    func stop() {
        task?.cancel()
        task = nil
    }

    deinit {
        task?.cancel()
    }
}
