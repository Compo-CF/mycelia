# Mycelia

An atmospheric idle game about growing a fungal network beneath an ancient forest. Decompose, fruit, spread spores, partner with trees. Real-world fungi. Slow, quiet, a little eerie.

Guided by **Mori**, a small morel who knows more than they're letting on.

## Stack
- SwiftUI / iOS 17+
- CloudKit (cross-device save)
- AdMob (banner + rewarded)
- StoreKit 2 (IAPs)
- xcodegen (`project.yml`)

## Layout
```
Mycelia/
├── App/          # entry point, app delegate, lifecycle
├── Game/         # core simulation: substrate, mycelium, fruiting, spores, time
├── Resources/    # assets, species data (JSON), biome data
├── Services/     # CloudKit, AdMob, IAP, audio, haptics
└── UI/           # SwiftUI views, atmospheric components
```

## Build (MacInCloud or any macOS dev box)
```sh
./scripts/bootstrap.sh    # installs xcodegen, generates Mycelia.xcodeproj
open Mycelia.xcodeproj    # build & run on simulator
```

## Status
Concept locked. v0.1 ships:
- [docs/DESIGN.md](docs/DESIGN.md) — pitch, tone, core loop, monetization
- [docs/BIOMES.md](docs/BIOMES.md) — Forest Floor, Old Growth, Swamp
- [docs/MORI.md](docs/MORI.md) — mascot character bible
- [docs/SIMULATION.md](docs/SIMULATION.md) — substrate, mycelium, fruiting math
- [design/identity.html](design/identity.html) — visual identity
- SwiftUI shell: app boots, loads 20 real species from JSON, two-tab UI (Forest + Journal), Mori rendered in SwiftUI primitives
