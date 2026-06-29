# TestFlight — first upload

## What's already done in code

- `project.yml` strips AdMob / CloudKit / Game Center for the first build (we'll add them back when we actually wire them up). Bundle ID `com.centricfiber.mycelia`, Team `7H5T5AR2X5`, deployment target iOS 17.
- 1024×1024 AppIcon committed at `Mycelia/Resources/Assets.xcassets/AppIcon.appiconset/icon-1024.png`.
- `ITSAppUsesNonExemptEncryption: false` — skips the export compliance prompt on every upload.
- `scripts/bump-build.sh` increments `CFBundleVersion` and regenerates the Xcode project.

## One-time Apple-side setup *(~10 minutes)*

1. **App Store Connect → My Apps → +** → New App
   - Platform: iOS
   - Name: **Mycelia**
   - Primary language: English (U.S.)
   - Bundle ID: **com.centricfiber.mycelia** *(dropdown — if it's not there yet, Xcode will create it on first archive)*
   - SKU: `mycelia` (any unique string)
   - User Access: Full Access
2. *(No need to fill out app metadata, screenshots, or pricing for internal TestFlight — leave it all blank.)*

## On MacInCloud — first upload

```bash
cd ~/Developer/mycelia          # or wherever you cloned it
git pull
./scripts/bootstrap.sh          # regenerates Xcode project
open Mycelia.xcodeproj
```

Then in Xcode:

1. **Toolbar device selector** → switch from a simulator to **"Any iOS Device (arm64)"**.
2. **Product → Archive** *(takes a few minutes — coffee)*.
3. Organizer window opens automatically when done. If it doesn't: **Window → Organizer**.
4. Select the new archive → **Distribute App** → **TestFlight & App Store** → **Distribute**.
5. Xcode signs, uploads, and validates. *(5–10 minutes)*
6. ASC sends an email when processing completes.

## On your phone

1. Install the **TestFlight** app from the App Store (if you don't already have it).
2. In App Store Connect: **My Apps → Mycelia → TestFlight → Internal Testing → +** → add yourself.
3. Open the TestFlight email or the TestFlight app — Mycelia will appear.
4. Tap **Install**.

## Every subsequent build

```bash
./scripts/bump-build.sh    # 1 → 2 → 3 …
# then Archive → Distribute again
```

TestFlight will reject any upload whose build number ≤ a previously uploaded build for the same version string, so the bump matters.

## When things break

| Error | Fix |
|---|---|
| *"No matching profile found"* | In Xcode → Project → Signing & Capabilities, confirm Team is "Centric Fiber" (Team ID 7H5T5AR2X5) and "Automatically manage signing" is checked. |
| *"Bundle ID com.centricfiber.mycelia is not available"* | Someone else has it or you already registered it but with a typo. Check Apple Developer Portal → Identifiers. |
| *"Missing compliance"* in TestFlight after upload | `ITSAppUsesNonExemptEncryption: false` should already prevent this. If it appears, set it in App Store Connect → Build → Manage Compliance. |
| *"Invalid Icon"* | The 1024 icon must be RGB (no alpha), not interlaced. `make_icon.py` produces a compliant icon — re-run it if you've replaced the file. |
| *Crash on launch with "fonts not found"* | We use system stacks (Cochin/Hoefler Text), not bundled fonts. On a real device they fall back to the next item in the stack. Cosmetic only, won't actually crash. |
