# RanDoFit

RanDoFit is a SwiftUI fitness app that generates short bodyweight workout prompts and schedules optional local reminders. The Xcode project and repository retain the original `RandDFit` spelling.

[App Store listing](https://apps.apple.com/us/app/randofit/id6757726061)

## Build and run

1. Open `RandDFit.xcodeproj` in a current Xcode release with an iOS simulator installed.
2. Select the shared **RandDFit** scheme and an iPhone or iPad simulator.
3. Build and run. Simulator builds do not need a signing identity.
4. For a physical device, choose your own development team. For an App Store update, first confirm the existing production bundle ID and signing configuration.

This snapshot targets iOS 16 and later. The live listing currently requires iOS 26.2 and later. The repository snapshot has **not yet been matched to the archive used for the live release**.

## Features in this source

- Easy, Moderate and/or Hard workouts with an optional beginner-friendly setting.
- Workout prompts with a repetition count or duration and exercise illustration.
- Optional local reminders with a daily frequency and time window.
- Preferences in the app's own UserDefaults storage.
- No account server, advertising SDK, analytics SDK or payment integration found in this source.

## Validation

The `iOS validation` GitHub Actions workflow builds the shared scheme and runs focused unit tests on a standard macOS runner. It does not sign, upload or submit an App Store release. Read the actual run result; the workflow file alone is not evidence of a successful build.

```sh
xcodebuild -project RandDFit.xcodeproj -scheme RandDFit -configuration Debug -sdk iphonesimulator -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build
```

## Release and handover

See [the handover checklist](docs/HANDOVER.md), [repair notes](docs/REPAIR_NOTES.md) and [proposed App Store copy](docs/APP_STORE_COPY.md).

GitHub Pages must be enabled before `privacy-policy.html` and `support.html` are reachable at their public URLs. Source edits do not update the installed App Store app; a separately signed, tested and approved release is required.

## Ownership

Copyright Logan Matthew Carter. No open-source license is granted by this repository. A sale must document the specific rights and assets transferred. Unrelated Gate2Go branches and the seller's personal Apple/GitHub accounts are outside the RanDoFit handover.
