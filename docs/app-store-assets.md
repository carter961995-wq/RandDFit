# App Store Connect assets (RandDFit)

This repo includes an automated screenshot pipeline (fastlane + UI tests) and templates for App Store Connect.

## Screenshots (recommended workflow)

### 1) Run locally on a Mac with Xcode + iOS simulators

From the repo root:

```bash
bundle install
bundle exec fastlane ios screenshots
```

Screenshots will be created under `fastlane/screenshots/`.

### 2) Upload to App Store Connect

In App Store Connect, open your app → **App Store** tab → add screenshots for the required device families.

## App previews (video)

App previews **cannot be generated from this Linux environment**. You’ll need to record them on a Mac using:
- Xcode Simulator recording, or
- QuickTime screen recording from a device.

Apple’s current requirements (duration, resolution, codecs) can change — use App Store Connect’s upload UI as the source of truth.

## What this repo provides

- `RandDFitUITests/RandDFitUITests.swift`: `testAppStoreScreenshots()` captures named screenshots.
- `RandDFitUITests/SnapshotHelper.swift`: enables `snapshot("...")` names for fastlane.
- `fastlane/`: `Fastfile`, `Snapfile`, `Appfile` for screenshot generation.

