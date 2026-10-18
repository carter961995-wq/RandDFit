# RanDoFit handover

Prepared October 17, 2026. App Store ID: `6757726061`.

## Sale scope and performance

RanDoFit is a live free iPhone/iPad workout app. The seller reports very few downloads and no revenue. Exact download, active-user, retention and operating-cost figures have not been verified. This is a software asset sale; no earnings or growth guarantee is offered.

The proposed RanDoFit scope consists of the app listing (subject to Apple's transfer criteria), the RanDoFit-specific source project, app artwork and seller-owned branding, and support/privacy page files. No personal Apple Developer account, personal GitHub account, unrelated Gate2Go code, unrelated domains or customer list is included.

The repair baseline is `cursor/app-launch-setup-4188`, commit `d0ef338598c0980ce112417d1118a3539ee0b1e8`. It contains the workout application and icon bitmaps. The default branch previously contained a template; [PR #8](https://github.com/carter961995-wq/RandDFit/pull/8) merged the repairs into `app-setup` at `6e7adf7dfbe189fd1c8248891222a664873d4371`. The tested repair head is `dda9cfb104dd535a871c96973ec54c5595ffcebc`: both the [push run](https://github.com/carter961995-wq/RandDFit/actions/runs/39096178239) and [PR run](https://github.com/carter961995-wq/RandDFit/actions/runs/39096179851) passed the simulator build and all ten unit tests on Xcode 26.6 (17F113), with zero failures.

## App identity and release checks

Apple's public lookup metadata, retrieved October 18, 2026 UTC, confirms app ID `6757726061`, bundle ID `auto.RandDFit`, version `1.0`, minimum iOS `26.2`, seller Logan Matthew Carter and initial release on January 15, 2026. The bundle ID matches this project. The original default project also targeted iOS 26.2; the complete launch-source baseline selected for repairs targets iOS 16.

The exact archive used for the live release has not been matched to this source snapshot. The repaired source is a separately validated development snapshot, not a claim about which commit Apple shipped. Before a signed update, confirm the current build number and capabilities in App Store Connect, preserve the production bundle ID, and test upgrading the installed App Store app. Test the proposed iOS 16 compatibility separately or retain the live release's higher minimum.

No App Store release was submitted. The Flippa listing remains a draft; Apple ownership verification, the $29 listing checkout and GitHub Pages activation are pending.

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
- Latest build number and capabilities from App Store Connect, plus source/archive provenance where available. The public bundle ID and version are already confirmed.
- Actual device walkthrough and installed-app upgrade checks; the simulator build and ten-test results are recorded above.
- Pages enabled and both public URLs responding successfully.
- Buyer/seller Apple transfer eligibility at closing.

## Primary references

- [Live listing](https://apps.apple.com/us/app/randofit/id6757726061)
- [Apple public app metadata](https://itunes.apple.com/lookup?id=6757726061&country=us)
- [Apple transfer overview](https://developer.apple.com/help/app-store-connect/transfer-an-app/overview-of-app-transfer)
- [Apple transfer criteria](https://developer.apple.com/help/app-store-connect/transfer-an-app/app-transfer-criteria)
- [Flippa eligible app rules](https://support.flippa.com/hc/en-us/articles/360000682816-What-apps-can-be-sold-on-Flippa)
- [Flippa transfer guide](https://support.flippa.com/hc/en-us/articles/8808234922511-Mobile-Application-Asset-Transfer-Guide)
