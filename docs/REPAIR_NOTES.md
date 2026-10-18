# Repair notes — October 17, 2026

## Starting point

Source: `cursor/app-launch-setup-4188` at `d0ef338598c0980ce112417d1118a3539ee0b1e8`. This complete snapshot includes the workout app, illustrations and actual icon bitmaps. It has not been tied to the current App Store archive.

## Problems identified

- Settings did not publish changes, risking an onboarding screen that failed to update.
- Removing the final difficulty silently restored all difficulties, including Hard.
- Reminder scheduling ignored errors and could attempt 168 notifications while reporting unconditional 14-day success.
- The home layout could clip on small screens or at larger text sizes.
- A conditional foreground style mixed incompatible types.
- UserDefaults was used without a required-reason privacy manifest.
- Onboarding claimed one-minute workouts although some generated holds last longer.
- The App Store privacy URL returned 404 because GitHub Pages was disabled.

## Repairs

Settings now publish changes while retaining existing storage keys. Empty or invalid difficulty choices stay conservative. The reminder planner validates settings, uses future-only unique times, caps its queue at 64, and reports actual count/date or errors. The app prevents overlapping reminder changes and provides a clear-reminders control. The home screen scrolls, conditional style types are corrected, and duration wording is accurate.

The Xcode project includes a required-reason privacy manifest and a shared RandDFit scheme. Ten focused unit tests cover settings persistence/publication, migration, difficulty safety, schedule bounds and the repeated hour at the autumn clock change. The planner emits at most one first-occurrence date for each local clock minute and skips nonexistent or already-past times. The existing icon generator now emits an opaque RGB default icon using its original gradient; dark/tinted icons are unchanged. Static privacy/support pages, App Store copy and handover instructions are included.

## Actual validation and publication status

- Source/project membership, XML/plist structure, scheme target references and asset references checked.
- Default icon verified as 1024×1024 RGB; its appearance was inspected and compared to the original artwork composited onto its native gradient.
- The build-and-test GitHub Actions workflow runs with read-only repository permissions on a standard macOS runner.
- **Initial validation passed:** commit `40147ee16ccc034ed4e721a46bdb7be7ed272b24` built successfully on Xcode 26.6 (17F113), and all eight initial unit tests passed with zero failures. [Push run](https://github.com/carter961995-wq/RandDFit/actions/runs/39089854810) and [PR run](https://github.com/carter961995-wq/RandDFit/actions/runs/39089856106).
- **Final repair validation passed:** commit `dda9cfb104dd535a871c96973ec54c5595ffcebc` built successfully on Xcode 26.6 (17F113), and all ten unit tests passed with zero failures, including both clock-change regressions. [Push run](https://github.com/carter961995-wq/RandDFit/actions/runs/39096178239) and [PR run](https://github.com/carter961995-wq/RandDFit/actions/runs/39096179851).
- **Repairs merged:** [PR #8](https://github.com/carter961995-wq/RandDFit/pull/8) is merged into the default `app-setup` branch at `6e7adf7dfbe189fd1c8248891222a664873d4371`.
- Repository access was restored on October 17, 2026 (America/Chicago). The earlier connection allowlist blocker is resolved.
- **GitHub Pages is disabled.** The prepared privacy/support files are not yet live, and the existing privacy URL remains broken.
- **No App Store release was submitted.** Public Apple metadata confirms the production bundle ID and version; the exact shipped archive remains unverified. App Store Connect and on-device upgrade checks remain before release.

The repairs use the exact GitHub baseline tree `c5aca32030344e62c26e0403473ea66c4bbd4be8`. Simulator build and unit-test validation are complete. Pages publication, Apple verification and signed-release checks remain pending.

## Remaining release checks

Confirm the current production build/capabilities and source/archive provenance where available; verify on-device behavior and upgrade compatibility; obtain App Store Connect metrics; publish the privacy/support site; prepare a signed release after these checks.
