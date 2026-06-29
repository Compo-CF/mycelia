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

## Status
Concept locked, scaffolding in progress. See [docs/DESIGN.md](docs/DESIGN.md).
