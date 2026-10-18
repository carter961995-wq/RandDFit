# RanDoFit handover

Prepared October 17, 2026. App Store ID: `6757726061`.

## Sale scope and performance

RanDoFit is a live free iPhone/iPad workout app. The seller reports very few downloads and no revenue. Exact download, active-user, retention and operating-cost figures have not been verified. This is a software asset sale; no earnings or growth guarantee is offered.

The proposed RanDoFit scope consists of the app listing (subject to Apple's transfer criteria), the RanDoFit-specific source project, app artwork and seller-owned branding, and support/privacy page files. No personal Apple Developer account, personal GitHub account, unrelated Gate2Go code, unrelated domains or customer list is included.

The repair baseline is `cursor/app-launch-setup-4188`, commit `d0ef338598c0980ce112417d1118a3539ee0b1e8`. It contains the workout application and icon bitmaps. The repository's original default branch contains a template. Record the final tested repair commit delivered to the buyer.

## Required production-source check

The inspected source targets iOS 16 and uses `auto.RandDFit` as its configured bundle identifier. The current public App Store listing requires iOS 26.2. The exact Xcode archive/source used for the live release has not been located or matched to this snapshot.

Open App Store Connect and the original Xcode project/archive to confirm the production bundle ID, current version/build, capabilities and source. Preserve the production bundle ID. Do not submit an update or represent this repaired branch as the exact shipped source until this check is complete.

## Technical contents

- SwiftUI app with local workout generation, exercise illustrations and optional local notifications.
- Local settings using the app's own UserDefaults keys.
- Bundled icon files and icon-generation script.
- Xcode project, test target and shared scheme.
- Privacy manifest and static support/privacy pages.
- No third-party package dependency, backend, login service, advertising SDK, payment flow or analytics SDK found in this source snapshot.

## Transfer sequence

1. Confirm ownership, latest source/archive and the exact asset schedule in the sale agreement.
2. Give the buyer the final source commit, build instructions and actual validation results. Have the buyer reproduce the build.
3. Confirm both Apple Developer accounts meet Apple's current criteria; review capabilities, app status and any in-app purchases.
4. Use the marketplace's agreed payment/escrow process and written milestones for transfer, inspection and release of funds.
5. The current Account Holder initiates the transfer in App Store Connect; the buyer accepts with their own account. Personal account credentials are not transferred.
6. Deliver only RanDoFit assets. A new repository containing this project is preferable to transferring this multi-project repository wholesale. Update developer contact and support hosting as agreed.
7. Re-create signing/provisioning for the receiving team, verify install/update behavior and support/privacy URLs, and document completion.

An Apple app transfer is separate from source delivery. Neither this checklist nor a simulator build establishes Apple transfer eligibility.

## SafeRestore option

The seller is open to a separately negotiated combined acquisition with SafeRestore. Its existing Flippa draft covers desktop recovery software, associated website/software, domains and business-profile assets at a separate asking price. RanDoFit's asking price does not include SafeRestore. A bundle must identify exact assets and an agreed total price before either product transfers.

## Evidence to collect

- App Store Connect downloads with date range and territory.
- Actual revenue/proceeds and expenses; zero revenue does not establish zero costs.
- Production bundle ID, latest version/build, capabilities and matched source/archive.
- Final macOS build/test result and an actual device walkthrough.
- Pages enabled and both public URLs responding successfully.
- Buyer/seller Apple transfer eligibility at closing.

## Primary references

- [Live listing](https://apps.apple.com/us/app/randofit/id6757726061)
- [Apple transfer overview](https://developer.apple.com/help/app-store-connect/transfer-an-app/overview-of-app-transfer)
- [Apple transfer criteria](https://developer.apple.com/help/app-store-connect/transfer-an-app/app-transfer-criteria)
- [Flippa eligible app rules](https://support.flippa.com/hc/en-us/articles/360000682816-What-apps-can-be-sold-on-Flippa)
- [Flippa transfer guide](https://support.flippa.com/hc/en-us/articles/8808234922511-Mobile-Application-Asset-Transfer-Guide)
